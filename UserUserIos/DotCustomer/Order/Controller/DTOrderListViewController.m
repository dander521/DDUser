//
//  DTOrderListViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/13.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTOrderListViewController.h"
#import "DTOrderListTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "DTInputCommentViewController.h"
#import "DTCommentedViewController.h"
#import "DTAppealViewController.h"
#import "DTReceiptQRViewController.h"
#import "DTOrderDetailViewController.h"
#import "DTOrderListModel.h"
#import "DTPayCustomView.h"
#import "WXApi.h"

@interface DTOrderListViewController () <UITableViewDelegate, UITableViewDataSource, DTOrderListTableViewCellDelegate, NetErrorViewDelegate, DTPayCustomViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** <#description#> */
@property (nonatomic, strong) DTPayCustomView *payView;
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

@implementation DTOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addAddressNotification];
    
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
    
    [self.netView showAddedTo:self.view isClearBgc:false];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Request

// 订单列表
- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    
    NSString *status = nil;
    switch (self.cellType) {
        case 0: {
            status = @"";
        }
            break;
        case 1: {
            status = @"0";
        }
            break;
        case 2: {
            status = @"1";
        }
            break;
        case 3: {
            status = @"2";
        }
            break;
        case 4: {
            status = @"3";
        }
            break;
            
        default:
            break;
    }
    
    NSMutableDictionary *bodyParams = [NSMutableDictionary new];
    [bodyParams setValue:[NSString stringWithFormat:@"%zd", self.page] forKey:@"page"];
    [bodyParams setValue:[NSString stringWithFormat:@"%zd", self.pageSize] forKey:@"pageSize"];
    [bodyParams setValue:status forKey:@"status"];
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:orderInfo] headParams:params bodyParams:bodyParams success:^(AFHTTPSessionManager *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            _page += 1;
            [ShowMessage showMessage:responseObject[@"msg"]];
            [self.netView stopNetViewLoadingFail:false error:false];
            DTOrderListCollectionModel *colloectionModel = [DTOrderListCollectionModel mj_objectWithKeyValues:responseObject];
            _dataCount = colloectionModel.data.count;
            if (_dataCount > 0) {
                [self.sourceArray addObjectsFromArray:colloectionModel.data];
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

// 退款
- (void)paybackMoneyWithId:(NSString *)orderId {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:orderRefund]
                              headParams:param
                              bodyParams:@{@"orderId" : orderId}
                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
                                     [MBProgressHUD hideHUDForView:self.view];
                                     
                                     if ([responseObject[@"status"] integerValue] == 1) {
                                         [ShowMessage showMessage:@"退款成功"];
                                         [self loadNewData];
                                     } else {
                                         [ShowMessage showMessage:responseObject[@"msg"]];
                                     }
                                 }
                                 failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                     [ShowMessage showMessage:error.description];
                                     [MBProgressHUD hideHUDForView:self.view];
                                 }];
}

// 退款
- (void)cancelWithId:(NSString *)orderId {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:cancelOrder]
                              headParams:param
                              bodyParams:@{@"orderId" : orderId}
                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
                                     [MBProgressHUD hideHUDForView:self.view];
                                     
                                     if ([responseObject[@"status"] integerValue] == 1) {
                                         [ShowMessage showMessage:@"取消成功"];
                                         [self loadNewData];
                                     } else {
                                         [ShowMessage showMessage:responseObject[@"msg"]];
                                     }
                                 }
                                 failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                     [ShowMessage showMessage:error.description];
                                     [MBProgressHUD hideHUDForView:self.view];
                                 }];
}

// 取消申诉
- (void)cancelAppealWithId:(NSString *)orderId {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:orderCancelComplaint]
                              headParams:param
                              bodyParams:@{@"orderId" : orderId}
                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
                                     [MBProgressHUD hideHUDForView:self.view];
                                     
                                     if ([responseObject[@"status"] integerValue] == 1) {
                                         [ShowMessage showMessage:@"取消申诉成功"];
                                         [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationAppealSuccess object:nil userInfo:nil];
                                     } else {
                                         [ShowMessage showMessage:responseObject[@"msg"]];
                                     }
                                 }
                                 failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                     [ShowMessage showMessage:error.description];
                                     [MBProgressHUD hideHUDForView:self.view];
                                 }];
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
    DTOrderListTableViewCell *cell = [DTOrderListTableViewCell cellWithTableView:tableView];
    cell.cellLineType = TXCellSeperateLinePositionType_Single;
    cell.cellLineRightMargin = TXCellRightMarginType0;
    cell.model = self.sourceArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 210.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DTOrderListModel *model = self.sourceArray[indexPath.row];
    DTOrderDetailViewController *vwcAppeal = [[DTOrderDetailViewController alloc] initWithNibName:NSStringFromClass([DTOrderDetailViewController class]) bundle:[NSBundle mainBundle]];
    vwcAppeal.listModel = model;
    [self.navigationController pushViewController:vwcAppeal animated:true];
}

#pragma mark - DTOrderListTableViewCellDelegate

- (void)touchTicketVerifyButtonWithType:(DTOrderListTableViewCellType)type model:(DTOrderListModel *)model {
    
    if (type == DTOrderListTableViewCellTypeDone ||
        type == DTOrderListTableViewCellTypeCommented) {
        DTAppealViewController *vwcAppeal = [[DTAppealViewController alloc] initWithNibName:NSStringFromClass([DTAppealViewController class]) bundle:[NSBundle mainBundle]];
        vwcAppeal.orderId = model.idField;
        [self.navigationController pushViewController:vwcAppeal animated:true];
    } else if (type == DTOrderListTableViewCellTypeForUse) {
        [self paybackMoneyWithId:model.idField];
    } else if (type ==  DTOrderListTableViewCellTypeForPay) {
        [self cancelWithId:model.idField];
    }
}

- (void)touchActionButtonWithType:(DTOrderListTableViewCellType)type model:(DTOrderListModel *)model {
    NSLog(@"touchActionButtonWithType");
    
    if (type == DTOrderListTableViewCellTypeForPay) {
        self.payView = [DTPayCustomView shareInstanceManager];
        self.payView.delegate = self;
        self.payView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.payView.listModel = model;
        [self.payView show];
    } else if (type == DTOrderListTableViewCellTypeForUse) {
        DTReceiptQRViewController *vwcInput = [[DTReceiptQRViewController alloc] initWithNibName:NSStringFromClass([DTReceiptQRViewController class]) bundle:[NSBundle mainBundle]];
        vwcInput.orderNo = model.orderNo;
        vwcInput.model = model;
        [self.navigationController pushViewController:vwcInput animated:true];
    } else if (type == DTOrderListTableViewCellTypeDone) {
        DTInputCommentViewController *vwcInput = [[DTInputCommentViewController alloc] initWithNibName:NSStringFromClass([DTInputCommentViewController class]) bundle:[NSBundle mainBundle]];
        vwcInput.orderId = model.idField;
        vwcInput.listModel = model;
        [self.navigationController pushViewController:vwcInput animated:true];
    } else if (type == DTOrderListTableViewCellTypeCommented) {
        DTCommentedViewController *vwcCommented = [[DTCommentedViewController alloc] initWithNibName:NSStringFromClass([DTCommentedViewController class]) bundle:[NSBundle mainBundle]];
        vwcCommented.orderNo = model.orderNo;
        [self.navigationController pushViewController:vwcCommented animated:true];
    } else if (type == DTOrderListTableViewCellTypeAppeal) {
        [self cancelAppealWithId:model.idField];
    } else if (type == DTOrderListTableViewCellTypeBuyOrder) {
        DTAppealViewController *vwcAppeal = [[DTAppealViewController alloc] initWithNibName:NSStringFromClass([DTAppealViewController class]) bundle:[NSBundle mainBundle]];
        vwcAppeal.orderId = model.idField;
        [self.navigationController pushViewController:vwcAppeal animated:true];
    }
}

#pragma mark - DTPayCustomViewDelegate

- (void)touchPayBtnWithPayType:(DTPayCustomViewPayType)type model:(DTOrderListModel *)model {
    [self.payView hide];
    
    NSString *payWay = [NSString stringWithFormat:@"%zd", type];
    NSMutableDictionary *paramHeader = [NSMutableDictionary new];
    [paramHeader setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    
    NSMutableDictionary *paramBody = [NSMutableDictionary new];
    [paramBody setValue:model.orderNo forKey:@"orderNo"];
    [paramBody setValue:payWay forKey:@"payWay"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:payOrder]
                              headParams:paramHeader
                              bodyParams:paramBody
                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
                                     [MBProgressHUD hideHUDForView:self.view];
                                     
                                     if ([responseObject[@"status"] integerValue] == 1) {
                                         if (type == DTPayCustomViewPayTypeBalance) {
                                             [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationOrderPaySuccess object:nil userInfo:nil];
                                             [ShowMessage showMessage:responseObject[@"msg"]];
                                         } else if (type == DTPayCustomViewPayTypeAli) {
                                             [[AlipaySDK defaultService] payOrder:responseObject[@"data"][@"data"] fromScheme:alipayScheme callback:^(NSDictionary *resultDic) {
                                             }];
                                         } else {
                                             NSDictionary *dic = responseObject[@"data"][@"data"];
                                             
                                             //需要创建这个支付对象
                                             PayReq *req   = [[PayReq alloc] init];
                                             //由用户微信号和AppID组成的唯一标识，用于校验微信用户
                                             req.openID = dic[@"appid"];
                                             // 商家id，在注册的时候给的
                                             req.partnerId = dic[@"partnerid"];
                                             // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
                                             req.prepayId  = dic[@"prepayid"];
                                             // 根据财付通文档填写的数据和签名
                                             //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
                                             req.package   = @"Sign=WXPay";
                                             // 随机编码，为了防止重复的，在后台生成
                                             req.nonceStr  = dic[@"noncestr"];
                                             // 这个是时间戳，也是在后台生成的，为了验证支付的
                                             NSString * stamp = dic[@"timestamp"];
                                             req.timeStamp = stamp.intValue;
                                             // 这个签名也是后台做的
                                             req.sign = dic[@"sign"];
                                             //发送请求到微信，等待微信返回onResp
                                             [WXApi sendReq:req];
                                         }
                                     } else {
                                         
                                         [ShowMessage showMessage:responseObject[@"msg"]];
                                     }
                                 }
                                 failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                     [ShowMessage showMessage:error.description];
                                     [MBProgressHUD hideHUDForView:self.view];
                                 }];
}

- (void)touchCloseViewButton {
    
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


#pragma mark - Pay Order

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 添加通知
 */
- (void)addAddressNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderPaySuccess) name:kNSNotificationOrderPaySuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderPaySuccess) name:kNSNotificationOrderUseSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderPaySuccess) name:kNSNotificationOrderCommentSuccess object:nil];
    // 阿里支付成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rechargeAlipayCallBack:) name:kNSNotificationAliPaySuccess object:nil];
    // 微信支付成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPaySuccess) name:kNSNotificationWXPaySuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(againReload) name:kNSNotificationWXPayFail object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appealSuccess) name:kNSNotificationAppealSuccess object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kNotificationLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOutSuccess) name:kNotificationLoginOutSuccess object:nil];
}

- (void)loginSuccess {
    [self loadNewData];
}

- (void)loginOutSuccess {
    [self.sourceArray removeAllObjects];
    [self.tableView reloadData];
}

- (void)appealSuccess {
    [self loadNewData];
}

- (void)rechargeAlipayCallBack:(NSNotification *)notification {
    
    NSDictionary *resultDic = notification.userInfo;
    NSString *message;
    
    if ([resultDic[ServerResponse_resultStatus] isEqualToString:ServerResponse_alipayCodeSuccess]) { // 充值成功后
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationOrderPaySuccess object:nil userInfo:nil];
        });
    } else {
        if ([resultDic[ServerResponse_resultStatus] isEqualToString:ServerResponse_alipayCodeDealing]) {
            message = @"正在处理中";
        }
        else if ([resultDic[ServerResponse_resultStatus] isEqualToString:ServerResponse_alipayCodeFail]) {
            message = @"订单支付失败";
        }
        else if ([resultDic[ServerResponse_resultStatus] isEqualToString:ServerResponse_alipayCodeCancel]) {
            message = @"用户中途取消";
        }
        else {
            message = @"订单支付失败";
        }
        [ShowMessage showMessage:@"支付未成功"];
    }
}

- (void)weChatPaySuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationOrderPaySuccess object:nil userInfo:nil];
    });
}

- (void)orderPaySuccess {
    [self loadNewData];
}

- (void)againReload {
    dispatch_async(dispatch_get_main_queue(), ^{
        [ShowMessage showMessage:@"支付未成功" withCenter:self.view.center];
    });
}

@end
