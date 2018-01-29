//
//  DTSearchResultViewController.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/30.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTSearchResultViewController.h"
#import "DTSearchTableViewCell.h"
#import "DTSearchHeaderView.h"
#import "DTRestaurantViewController.h"
#import "DTRestaurantGoodsDetailViewController.h"
#import "DTSearchResultModel.h"
#import "DTRestaurantModel.h"

@interface DTSearchResultViewController () <UITableViewDataSource, UITableViewDelegate, DTSearchHeaderViewDelegate, NetErrorViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
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
@property (nonatomic, strong) NSMutableArray <DTSearchResultModel *>*sourceArray;

/** <#description#> */
@property (nonatomic, strong) NSString *name;

@end

@implementation DTSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedSectionFooterHeight = 10.0;
    self.tableView.estimatedSectionHeaderHeight = 120.0;
    
    UIImage *image = [UIImage imageNamed:@"search"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(20, 14, 12, 12);
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    leftView.backgroundColor = [UIColor clearColor];
    [leftView addSubview:imageView];
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
    self.searchTF.leftView = leftView;
    self.searchTF.delegate = self;
    
    self.searchTF.layer.cornerRadius = 8;
    self.searchTF.layer.masksToBounds = true;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    // tableView 设置
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.automaticallyHidden = true;
    
    // 初始化数据
    _page = 1;
    _pageSize = 10;
    _dataCount = 0;
    self.sourceArray = [NSMutableArray new];
    
    [self showBlankView];
}

- (void)textFieldDidChange:(NSNotification *)noti {
    self.name = self.searchTF.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}

#pragma mark - Data Request

- (void)loadDataWithName:(NSString *)name {
    if ([NSString isTextEmpty:name]) {
        [ShowMessage showMessage:@"请输入搜索内容"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:[NSString stringWithFormat:@"%zd", self.page] forKey:@"page"];
    [params setValue:[NSString stringWithFormat:@"%zd", self.pageSize] forKey:@"pageSize"];
    [params setValue:[TXModelAchivar getUserModel].longitude forKey:@"lon"];
    [params setValue:[TXModelAchivar getUserModel].latitude forKey:@"lat"];
    [params setValue:name forKey:@"name"];
    
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:searchMerchant] headParams:nil bodyParams:params success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"status"] integerValue] == 1) {
            _page += 1;
            [ShowMessage showMessage:responseObject[@"msg"]];
            [self.netView stopNetViewLoadingFail:false error:false];
            DTSearchResultCollectionModel *colloectionModel = [DTSearchResultCollectionModel mj_objectWithKeyValues:responseObject[@"data"]];
            _dataCount = colloectionModel.list.count;
            if (_dataCount > 0) {
                [self.sourceArray addObjectsFromArray:colloectionModel.list];
            }
            if (self.sourceArray.count == 0) {

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
        [MBProgressHUD hideHUDForView:self.view];
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
        [self loadDataWithName:self.name];
    }
}

- (void)loadNewData {
    [self.sourceArray removeAllObjects];
    _page = 1;
    [self loadDataWithName:self.name];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - Custom

- (void)showBlankView {
    [self.view addSubview:self.blankView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArray[section].products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DTSearchResultModel *searchModel = self.sourceArray[indexPath.section];
    DTSearchResultProductsModel *model = searchModel.products[indexPath.row];
    DTSearchTableViewCell *cell = [DTSearchTableViewCell cellWithTableView:tableView];
    cell.cellLineType = TXCellSeperateLinePositionType_Single;
    cell.cellLineRightMargin = TXCellRightMarginType30;
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DTSearchResultModel *searchModel = self.sourceArray[indexPath.section];
    DTSearchResultProductsModel *model = searchModel.products[indexPath.row];
    DTRestaurantGoodsDetailViewController *vwcSearch = [[DTRestaurantGoodsDetailViewController alloc] initWithNibName:NSStringFromClass([DTRestaurantGoodsDetailViewController class]) bundle:[NSBundle mainBundle]];
    DTTypeModel *typeModel = [model transformToTypeModel];
    vwcSearch.typeModel = typeModel;
    vwcSearch.shopId = searchModel.idField;
    [self.navigationController pushViewController:vwcSearch animated:true];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 120.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DTSearchResultModel *model = self.sourceArray[section];
    DTSearchHeaderView *headerView = [DTSearchHeaderView instanceView];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120);
    headerView.delegate = self;
    headerView.model = model;
    return headerView;
}

- (IBAction)touchBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - DTSearchHeaderViewDelegate

- (void)touchHeaderViewButtonWithModel:(DTSearchResultModel *)model {

    DTRestaurantViewController *vwcSearch = [[DTRestaurantViewController alloc] initWithNibName:NSStringFromClass([DTRestaurantViewController class]) bundle:[NSBundle mainBundle]];
    vwcSearch.shopId = model.idField;
    [self.navigationController pushViewController:vwcSearch animated:true];

}

#pragma mark - NetErrorViewDelegate

- (void)reloadDataNetErrorView:(NetErrorView *)errorView {
    [self loadNewData];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    _page = 1;
    [self.searchTF resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadDataWithName:self.name];
    return true;
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
