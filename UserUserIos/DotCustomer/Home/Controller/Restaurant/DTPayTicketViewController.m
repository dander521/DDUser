//
//  DTPayTicketViewController.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/13.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTPayTicketViewController.h"
#import "DTTicketTableViewCell.h"
#import "DTTicketOperateTableViewCell.h"
#import "DTPaySelectTableViewCell.h"
#import "DTOrderFooterView.h"
#import "WXApi.h"
#import "DTPaySuccessViewController.h"

@interface DTPayTicketViewController () <UITableViewDelegate, UITableViewDataSource, DTTicketOperateTableViewCellDelegate, DTPaySelectTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
    
@property (nonatomic, assign) NSInteger ticketCount;
@property (nonatomic, strong) NSString *payWayStr;
@property (nonatomic, strong) NSString *balanceStr;
@property (nonatomic, assign) float totalPriceMoney;

@end

@implementation DTPayTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"提交订单";
    self.tableView.tableFooterView = [self tableFooterView];
    self.ticketCount = 1;
    self.totalPriceMoney = self.ticketCount * [self.model.price floatValue];
    [self addAddressNotification];
    [self getBalance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXSeperateLineCell *defaultCell = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            DTTicketTableViewCell *cell = [DTTicketTableViewCell cellWithTableView:tableView];
            cell.cellLineType = TXCellSeperateLinePositionType_Single;
            cell.cellLineRightMargin = TXCellRightMarginType12;
            cell.priceLabel.text = self.model.price;
            defaultCell = cell;
        } else {
            DTTicketOperateTableViewCell *cell = [DTTicketOperateTableViewCell cellWithTableView:tableView];
            cell.cellLineType = TXCellSeperateLinePositionType_Single;
            cell.cellLineRightMargin = TXCellRightMarginType12;
            cell.delegate = self;
            cell.countLabel.text = [NSString stringWithFormat:@"%zd", self.ticketCount];
            defaultCell = cell;
        }
    } else {
        DTPaySelectTableViewCell *cell = [DTPaySelectTableViewCell cellWithTableView:tableView];
        cell.cellLineType = TXCellSeperateLinePositionType_None;
        cell.balanceLabel.text = self.balanceStr;
        cell.selectStr = self.payWayStr;
        cell.delegate = self;
        defaultCell = cell;
    }
    return defaultCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 87.0;
        } else {
            return 55.0;
        }
    } else {
        return 210.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        DTOrderFooterView *footer = [DTOrderFooterView instanceView];
        footer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50.0);
        footer.priceLabel.text = [NSString stringWithFormat:@"%.2f", self.totalPriceMoney];
        return footer;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 57.0;
    }
    return 0.01;
}

- (UIView *)tableFooterView {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    footer.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(42, 32, SCREEN_WIDTH - 84, 49);
    commitButton.titleLabel.font = FONT(18);
    [commitButton setTitle:@"提交订单" forState:UIControlStateNormal];
    commitButton.backgroundColor = RGB(246, 30, 46);
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitButton.layer.cornerRadius = 24.5;
    commitButton.layer.masksToBounds = true;
    [commitButton addTarget:self action:@selector(touchCommitBtn) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:commitButton];
    return footer;
}

- (void)touchCommitBtn {
    if ([NSString isTextEmpty:self.payWayStr]) {
        [ShowMessage showMessage:@"请选择支付方式"];
        return;
    }
    
    NSMutableDictionary *paramHeader = [NSMutableDictionary new];
    [paramHeader setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    
    NSMutableDictionary *paramBody = [NSMutableDictionary new];
    [paramBody setValue:@"2" forKey:@"type"];
    [paramBody setValue:self.payWayStr forKey:@"payWay"];
    [paramBody setValue:self.model.idField forKey:@"dataId"];
    [paramBody setValue:[NSString stringWithFormat:@"%zd", self.ticketCount] forKey:@"num"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:commitOrder]
                              headParams:paramHeader
                              bodyParams:paramBody
                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
                                     [MBProgressHUD hideHUDForView:self.view];
                                     
                                     if ([responseObject[@"status"] integerValue] == 1) {
                                         NSArray *payArray = [self.payWayStr componentsSeparatedByString:@","];
                                         id dic = responseObject[@"data"][@"data"];
                                         if ([dic isKindOfClass:[NSString class]]) {
                                             
                                             if ([payArray containsObject:@"1"] && [self.balanceStr floatValue] < self.totalPriceMoney) {
                                                 [[AlipaySDK defaultService] payOrder:responseObject[@"data"][@"data"] fromScheme:alipayScheme callback:^(NSDictionary *resultDic) {
                                                 }];
                                             } else if ([self.payWayStr isEqualToString:@"1"]) {
                                                 [[AlipaySDK defaultService] payOrder:responseObject[@"data"][@"data"] fromScheme:alipayScheme callback:^(NSDictionary *resultDic) {
                                                 }];
                                             } else {
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationOrderPaySuccess object:nil userInfo:nil];
                                                 DTPaySuccessViewController *vwcSearch = [[DTPaySuccessViewController alloc] initWithNibName:NSStringFromClass([DTPaySuccessViewController class]) bundle:[NSBundle mainBundle]];
                                                 [self.navigationController pushViewController:vwcSearch animated:true];
                                                 [ShowMessage showMessage:responseObject[@"msg"]];
                                             }
                                         } else if ([dic isKindOfClass:[NSDictionary class]]) {
                                             if ([payArray containsObject:@"2"]) {
                                                 
                                                 
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

#pragma mark - DTTicketOperateTableViewCellDelegate
    
- (void)touchMinusButton {
    if (self.ticketCount == 1) {
        return;
    }
    self.ticketCount -= 1;
    self.totalPriceMoney = self.ticketCount * [self.model.price floatValue];
    [self.tableView reloadData];
}

- (void)touchPlusButton {
    self.ticketCount += 1;
    self.totalPriceMoney = self.ticketCount * [self.model.price floatValue];
    [self.tableView reloadData];
}
    
#pragma mark - DTPaySelectTableViewCellDelegate
    
- (void)selectPayMethodWithString:(NSString *)payStr {
    self.payWayStr = payStr;
}

#pragma mark - Net Request

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
                                        self.balanceStr = [NSString stringWithFormat:@"%.2f", [responseObject[@"data"][@"yue"] floatValue]];
                                        [self.tableView reloadData];
                                    }
                                }
                                failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                    [ShowMessage showMessage:error.description];
                                    [MBProgressHUD hideHUDForView:self.view];
                                }];
}


#pragma mark - Pay Order

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 添加通知
 */
- (void)addAddressNotification {
    // 阿里支付成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rechargeAlipayCallBack:) name:kNSNotificationAliPaySuccess object:nil];
    // 微信支付成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPaySuccess) name:kNSNotificationWXPaySuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(againReload) name:kNSNotificationWXPayFail object:nil];
    
}

- (void)rechargeAlipayCallBack:(NSNotification *)notification {
    
    NSDictionary *resultDic = notification.userInfo;
    NSString *message;
    
    if ([resultDic[ServerResponse_resultStatus] isEqualToString:ServerResponse_alipayCodeSuccess]) { // 充值成功后
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationOrderPaySuccess object:nil userInfo:nil];
            DTPaySuccessViewController *vwcSearch = [[DTPaySuccessViewController alloc] initWithNibName:NSStringFromClass([DTPaySuccessViewController class]) bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:vwcSearch animated:true];
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
        DTPaySuccessViewController *vwcSearch = [[DTPaySuccessViewController alloc] initWithNibName:NSStringFromClass([DTPaySuccessViewController class]) bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:vwcSearch animated:true];
    });
}

- (void)againReload {
    dispatch_async(dispatch_get_main_queue(), ^{
        [ShowMessage showMessage:@"支付未成功" withCenter:self.view.center];
    });
}


@end
