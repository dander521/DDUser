//
//  DTPaperViewController.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/12.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTPaperViewController.h"
#import "DTHomeTableViewCell.h"
#import "DTRestaurantViewController.h"
#import "DTSearchResultViewController.h"
#import "DTSearchResultViewController.h"
#import "TXSelectCityController.h"
#import "DTMerchantListModel.h"

@interface DTPaperViewController () <NetErrorViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *searchTF;

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

@implementation DTPaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = true;
    self.locationLabel.text = [NSString isTextEmpty:[TXModelAchivar getUserModel].areaName] ? @"暂无" : [TXModelAchivar getUserModel].areaName;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:[TXModelAchivar getUserModel].longitude forKey:@"lon"];
    [params setValue:[TXModelAchivar getUserModel].latitude forKey:@"lat"];
    [params setValue:@"0" forKey:@"typeId"];
    [params setValue:[NSString stringWithFormat:@"%zd", self.page] forKey:@"page"];
    [params setValue:[NSString stringWithFormat:@"%zd", self.pageSize] forKey:@"pageSize"];
    [params setValue:@"0" forKey:@"twoTypeId"];
    [params setValue:@"isPaper" forKey:@"isPaper"];
    [params setValue:@"3" forKey:@"seachType"];
    [params setValue:@"0" forKey:@"nearDistance"];
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:merchantList] headParams:nil bodyParams:params success:^(AFHTTPSessionManager *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            _page += 1;
            [ShowMessage showMessage:responseObject[@"msg"]];
            [self.netView stopNetViewLoadingFail:false error:false];
            DTMerchantListCollectionModel *colloectionModel = [DTMerchantListCollectionModel mj_objectWithKeyValues:responseObject[@"data"]];
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

- (void)showBlankView {
    [self.view addSubview:self.blankView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DTHomeTableViewCell *cell = [DTHomeTableViewCell cellWithTableView:tableView];
    cell.cellLineType = TXCellSeperateLinePositionType_Single;
    cell.cellLineRightMargin = TXCellRightMarginType0;
    cell.cellType = DTHomeTableViewCellTypeHome;
    cell.merchantListModel = self.sourceArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DTMerchantListModel *model = self.sourceArray[indexPath.row];
    DTRestaurantViewController *vwcSearch = [[DTRestaurantViewController alloc] initWithNibName:NSStringFromClass([DTRestaurantViewController class]) bundle:[NSBundle mainBundle]];
    vwcSearch.shopId = model.idField;
    [self.navigationController pushViewController:vwcSearch animated:true];
}

- (IBAction)touchSearchButton:(UIButton *)sender {
    DTSearchResultViewController *vwcSearch = [[DTSearchResultViewController alloc] initWithNibName:NSStringFromClass([DTSearchResultViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vwcSearch animated:true];
}

- (IBAction)touchLocationBtn:(id)sender {
    TXSelectCityController *vwcCity = [TXSelectCityController new];
    [self.navigationController pushViewController:vwcCity animated:true];
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
