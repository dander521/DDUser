//
//  DTFavoriteViewController.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/29.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTFavoriteViewController.h"
#import "DTHomeTableViewCell.h"
#import "DTRestaurantViewController.h"
#import "DTFavoriteModel.h"

@interface DTFavoriteViewController () <UITableViewDelegate, UITableViewDataSource,NetErrorViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 加载页面 */
@property (strong, nonatomic) NetErrorView *netView;
/** 无数据提示页面 */
@property (nonatomic, strong) TXBlankView *blankView;
/** 分页数 */
@property (nonatomic, assign) NSInteger page;
/** 分页请求条数 */
@property (nonatomic, assign) NSInteger pageSize;
/** 返回数据条数 */
@property (nonatomic, assign) NSInteger dataCount;
/** 数据源集合 */
@property (nonatomic, strong) NSMutableArray *sourceArray;

@end

@implementation DTFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的收藏";
    
    // tableView 设置
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.automaticallyHidden = true;
    
    // 初始化数据
    _page = 1;
    _pageSize = 10;
    _dataCount = 0;
    self.sourceArray = [NSMutableArray new];
    
    [self.netView showAddedTo:self.view isClearBgc:false];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Request

- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    
    NSMutableDictionary *paramsBody = [NSMutableDictionary new];
    [paramsBody setValue:[TXModelAchivar getUserModel].longitude forKey:@"lon"];
    [paramsBody setValue:[TXModelAchivar getUserModel].latitude forKey:@"lat"];
    [paramsBody setValue:[NSString stringWithFormat:@"%zd", self.page] forKey:@"pageNo"];
    [paramsBody setValue:[NSString stringWithFormat:@"%zd", self.pageSize] forKey:@"pageSize"];

    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:mySaveInfo] headParams:params bodyParams:paramsBody success:^(AFHTTPSessionManager *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            _page += 1;
            [ShowMessage showMessage:responseObject[@"msg"]];
            [self.netView stopNetViewLoadingFail:false error:false];
            DTFavoriteCollectionModel *colloectionModel = [DTFavoriteCollectionModel mj_objectWithKeyValues:responseObject[@"data"]];
            _dataCount = colloectionModel.list.count;
            if (_dataCount > 0) {
                [self.sourceArray addObjectsFromArray:colloectionModel.list];
            }
            if (self.sourceArray.count == 0) {
                [self showBlankView];
            } else {
                [self.blankView removeFromSuperview];
                if (_dataCount < _pageSize) {
                    [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                }
            }
            [self.tableView reloadData];
        } else {
            [self.netView stopNetViewLoadingFail:false error:true];
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.netView stopNetViewLoadingFail:true error:false];
        [ShowMessage showMessage:error.description];
    }];
}

- (void)loadMoreData {
    if (_dataCount < _pageSize) {
        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
    } else {
        [self loadData];
    }
}

- (void)loadNewData {
    [self.sourceArray removeAllObjects];
    _page = 1;
    [self loadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - Custom

- (void)showBlankView {
    [self.view addSubview:self.blankView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DTHomeTableViewCell *cell = [DTHomeTableViewCell cellWithTableView:tableView];
    cell.cellType = DTHomeTableViewCellTypeFavorite;
    cell.cellLineType = TXCellSeperateLinePositionType_Single;
    cell.cellLineRightMargin = TXCellRightMarginType12;
    cell.favoriteModel = self.sourceArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    DTFavoriteModel *model = [self.sourceArray objectAtIndex:indexPath.row];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:saveShop]
                             headParams:param
                             bodyParams:@{@"shopId" : model.shopId}
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                    
                                    if ([responseObject[@"status"] integerValue] == 1) {
                                        // 删除模型
                                        [self.sourceArray removeObjectAtIndex:indexPath.row];
                                        [self.tableView reloadData];
                                        [ShowMessage showMessage:@"删除成功"];
                                    } else {
                                        [ShowMessage showMessage:responseObject[@"msg"]];
                                    }
                                }
                                failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                    [ShowMessage showMessage:error.description];
                                    [MBProgressHUD hideHUDForView:self.view];
                                }];
}

/**
 *  修改Delete按钮文字为“删除”
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DTFavoriteModel *model = self.sourceArray[indexPath.row];
    DTRestaurantViewController *vwcSearch = [[DTRestaurantViewController alloc] initWithNibName:NSStringFromClass([DTRestaurantViewController class]) bundle:[NSBundle mainBundle]];
    vwcSearch.shopId = model.shopId;
    [self.navigationController pushViewController:vwcSearch animated:true];
}

#pragma mark - NetErrorViewDelegate

- (void)reloadDataNetErrorView:(NetErrorView *)errorView {
    [self loadNewData];
}

#pragma mark - Lazy

/**
 空白页
 */
- (UIView *)blankView {
    if (nil == _blankView) {
        _blankView = [[TXBlankView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _blankView.backgroundColor = RGB(255, 255, 255);
        [_blankView createBlankViewWithImage:@"wudingdan"
                                       title:@"暂无"
                                    subTitle:nil];
    }
    
    return _blankView;
}

/**
 网络错误页
 */
- (NetErrorView *)netView {
    if (!_netView) {
        _netView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _netView.delegate = self;
    }
    return _netView;
}

@end
