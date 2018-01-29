//
//  DTWalletViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/14.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTWalletViewController.h"
#import "DTWalletHeaderView.h"
#import "DTPersonalCenterTableViewCell.h"
#import "DTWithdrawViewController.h"
#import "DTBindAliViewController.h"
#import "DTWalletTableViewCell.h"
#import "DTWalletModel.h"

@interface DTWalletViewController () <UITableViewDataSource, UITableViewDelegate, DTWalletHeaderViewDelegate, NetErrorViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) DTWalletHeaderView *headerView;
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

@implementation DTWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(withdrawSuccess) name:kNSNotificationWithdrawSuccess object:nil];
    
    self.navigationItem.title = @"我的钱包";
    self.tableView.tableHeaderView = [self tableViewHeader];
    // tableView 设置
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.automaticallyHidden = true;
    
    // 初始化数据
    _page = 1;
    _pageSize = 10;
    _dataCount = 0;
    self.sourceArray = [NSMutableArray new];
    
    // 请求数据
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    
    // 添加右侧提现绑定按钮
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    [leftbutton setTitleColor:RGB(246, 30, 46) forState:UIControlStateNormal];
    [leftbutton setTitle:@"提现绑定" forState:UIControlStateNormal];
    leftbutton.titleLabel.font = FONT(14);
    [leftbutton addTarget:self action:@selector(touchRightBarItem) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightitem=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.rightBarButtonItem = rightitem;
//    [self.netView showAddedTo:self.view isClearBgc:false];
    [self getBalance];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)withdrawSuccess {
    [self getBalance];
    [self loadNewData];
}

#pragma mark - Data Request

- (void)getBalance {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getBalance]
                             headParams:param
                             bodyParams:nil
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                    [ShowMessage showMessage:responseObject[@"msg"]];
                                    if ([responseObject[@"status"] integerValue] == 1) {
                                        self.headerView.priceLabel.text = [NSString stringWithFormat:@"%.2f", [responseObject[@"data"][@"yue"] floatValue]];
                                    }
                                }
                                failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                    [ShowMessage showMessage:error.description];
                                    [MBProgressHUD hideHUDForView:self.view];
                                }];
}

- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:balanceDetail] headParams:params bodyParams:@{@"page": [NSString stringWithFormat:@"%zd", self.page], @"pageSize": [NSString stringWithFormat:@"%zd", self.pageSize]} success:^(AFHTTPSessionManager *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            _page += 1;
            [ShowMessage showMessage:responseObject[@"msg"]];
//            [self.netView stopNetViewLoadingFail:false error:false];
            DTWalletCollectionModel *colloectionModel = [DTWalletCollectionModel mj_objectWithKeyValues:responseObject[@"data"]];
            _dataCount = colloectionModel.list.count;
            if (_dataCount > 0) {
                [self.sourceArray addObjectsFromArray:colloectionModel.list];
            }
//            if (self.sourceArray.count == 0) {
//                [self showBlankView];
//            } else {
//                [self.blankView removeFromSuperview];
//                if (_dataCount < _pageSize) {
//                    [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
//                }
//            }
            [self.tableView reloadData];
        } else {
//            [self.netView stopNetViewLoadingFail:false error:true];
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
//        [self.netView stopNetViewLoadingFail:true error:false];
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
    
    DTWalletTableViewCell *cell = [DTWalletTableViewCell cellWithTableView:tableView];
    cell.cellLineType = TXCellSeperateLinePositionType_Single;
    cell.cellLineRightMargin = TXCellRightMarginType0;
    cell.model = self.sourceArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    headerView.backgroundColor = RGB(240, 240, 240);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 15, 150, 20)];
    label.text = @"余额明细";
    label.font = FONT(14);
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor lightGrayColor];
    [headerView addSubview:label];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0;
}

- (UIView *)tableViewHeader {
    self.headerView = [DTWalletHeaderView instanceView];
    self.headerView.delegate = self;
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 240);
    return self.headerView;
}

- (void)touchWithdrawButton {
    if ([NSString isTextEmpty:[TXModelAchivar getUserModel].aliAccount]) {
        DTBindAliViewController *vwcWith = [[DTBindAliViewController alloc] initWithNibName:NSStringFromClass([DTBindAliViewController class]) bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:vwcWith animated:true];
    } else {
        DTWithdrawViewController *vwcWith = [[DTWithdrawViewController alloc] initWithNibName:NSStringFromClass([DTWithdrawViewController class]) bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:vwcWith animated:true];
    }
}

- (void)touchRightBarItem {
    DTBindAliViewController *vwcWith = [[DTBindAliViewController alloc] initWithNibName:NSStringFromClass([DTBindAliViewController class]) bundle:[NSBundle mainBundle]];
    
    if ([NSString isTextEmpty:[TXModelAchivar getUserModel].aliAccount]) {
        vwcWith.isBind = false;
    } else {
        vwcWith.isBind = true;
    }
    [self.navigationController pushViewController:vwcWith animated:true];
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
