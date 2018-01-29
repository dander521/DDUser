//
//  DTTicketVerifyViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/13.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTTicketVerifyViewController.h"
#import "DTPaySuccessViewController.h"
#import "WXApi.h"
#import "DTPayCustomView.h"

@interface DTTicketVerifyViewController ()<DTPayCustomViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *verifyTF;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, strong) DTPayCustomView *payView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@end

@implementation DTTicketVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addAddressNotification];
    self.navigationItem.title = @"付款金额";
    
    self.bottomView.layer.shadowOffset = CGSizeMake(2, 2);
    self.bottomView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    self.bottomView.layer.shadowOpacity = 0.5;
    self.bottomView.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldDidChange:(NSNotification *)noti {
    if (self.verifyTF.text.length != 0) {
        self.commitButton.enabled = true;
        [self.commitButton setBackgroundColor:RGB(246, 30, 46)];
    } else {
        self.commitButton.enabled = false;
        [self.commitButton setBackgroundColor:RGB(153, 153, 153)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchVerifyBtn:(id)sender {
    if (![NSString isTextEmpty:self.shopId] && (![NSString isNumText:self.verifyTF.text] || [self.verifyTF.text floatValue] <= 0)) {
        [ShowMessage showMessage:@"请输入正确的价格"];
        return;
    }
    
    [self.view endEditing:true];
    self.payView = [DTPayCustomView shareInstanceManager];
    self.payView.delegate = self;
    self.payView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.payView show];
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

- (void)touchPayBtnWithPayType:(DTPayCustomViewPayType)type model:(DTOrderListModel *)model {
    [self.payView hide];
    
    NSString *payWay = [NSString stringWithFormat:@"%zd", type];
    NSMutableDictionary *paramHeader = [NSMutableDictionary new];
    [paramHeader setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    
    NSMutableDictionary *paramBody = [NSMutableDictionary new];
    [paramBody setValue:self.shopId forKey:@"shopId"];
    [paramBody setValue:payWay forKey:@"payWay"];
    [paramBody setValue:self.verifyTF.text forKey:@"money"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:payToMerchant]
                              headParams:paramHeader
                              bodyParams:paramBody
                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
                                     [MBProgressHUD hideHUDForView:self.view];
                                     
                                     if ([responseObject[@"status"] integerValue] == 1) {
                                         if (type == DTPayCustomViewPayTypeBalance) {
                                             [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationOrderPaySuccess object:nil userInfo:nil];
                                             [ShowMessage showMessage:responseObject[@"msg"]];
                                             DTPaySuccessViewController *vwcSearch = [[DTPaySuccessViewController alloc] initWithNibName:NSStringFromClass([DTPaySuccessViewController class]) bundle:[NSBundle mainBundle]];
                                             [self.navigationController pushViewController:vwcSearch animated:true];
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


@end
