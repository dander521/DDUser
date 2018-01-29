//
//  AppDelegate.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/12.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
/** 10.0注册通知*/
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//微信SDK头文件
#import "WXApi.h"

#import "UMessage.h"

#import "DTNotificationViewController.h"
#import "DTOrderListCollectionViewController.h"
#import "DTWalletViewController.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate, WXApiDelegate>
/** iOS10通知中心 */
@property (strong, nonatomic) UNUserNotificationCenter *notificationCenter;
@property (nonatomic, strong) DTTabBarViewController *tabBar;

@end

@implementation AppDelegate

#pragma mark - APP Circle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setupRootViewController];
    [self.window makeKeyAndVisible];
    
    [AMapServices sharedServices].apiKey = @"ca61d631b45543ac03fe3d82784c60cd";
    
    [self iqKeyboardShowOrHide];
    
    // 日志分析
    UMConfigInstance.appKey = @"5a1e5417f29d9815ea00040c";
    UMConfigInstance.channelId = @"App Store";
    [MobClick setCrashReportEnabled:true];
#if TX_Environment != 0
    [MobClick setLogEnabled:YES];
#endif
    
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    // 向微信注册wx5ce7259f60fc8895
    [WXApi registerApp:@"wx5ce7259f60fc8895"];
    
    self.cityDistrictArray = [NSMutableArray new];
    self.firstCategoryArray = [NSMutableArray new];
    
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ),
                                        ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {

         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx5ce7259f60fc8895"
                                       appSecret:@"95fbcd704034d8ea07ac8a5326dde61c"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1106414876"
                                      appKey:@"kUretY2RIw5p40O7"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
    
    [UMessage startWithAppkey:@"5a1e5417f29d9815ea00040c" launchOptions:launchOptions httpsEnable:YES ];
    [UMessage openDebugMode:YES];
    [UMessage registerForRemoteNotifications];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];

    return YES;
}

/**
 *  实例对象
 */
+ (instancetype)sharedAppDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


- (void)applicationWillResignActive:(UIApplication *)application {}


- (void)applicationDidEnterBackground:(UIApplication *)application {}


- (void)applicationWillEnterForeground:(UIApplication *)application {}


- (void)applicationDidBecomeActive:(UIApplication *)application {}


- (void)applicationWillTerminate:(UIApplication *)application {}

#pragma mark - Custom Method

/**
 设置根控制器
 */
- (void)setupRootViewController {
    self.tabBar = [[DTTabBarViewController alloc] init];
    
    // 获取版本号
    NSString *currenVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    // 获取上一次的版本号
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"CFBundleShortVersionString"];
    
    TailorxLeadingViewController *vwcScroll = [[TailorxLeadingViewController alloc] init];
    vwcScroll.tabBarController = self.tabBar;
    self.window.rootViewController = vwcScroll;
    
    if ([currenVersion isEqualToString:lastVersion]) {
        self.window.rootViewController = self.tabBar;
    } else {
        self.window.rootViewController = vwcScroll;
        // 保存版本信息  判断是不是新版本来展示欢迎界面
        [[NSUserDefaults standardUserDefaults] setObject:currenVersion forKey:@"CFBundleShortVersionString"];
    }
}

#pragma mark - IQKeyboard

- (void)iqKeyboardShowOrHide {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}

// NOTE: 4.2-9.0
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"url.scheme = %@",url.scheme);
    BOOL result = false;
    if ([url.scheme hasPrefix:@"wx5ce7259f60fc8895"]) {
        return [WXApi handleOpenURL:url delegate:self];
    } else{
        result = [[UMSocialManager defaultManager] handleOpenURL:url];
        if (result == FALSE) {
            if ([url.host isEqualToString:@"safepay"]) {
                // 支付跳转支付宝钱包进行支付，处理支付结果
                [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                    NSLog(@"result = %@",resultDic);
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationAliPaySuccess object:nil userInfo:resultDic];
                }];
            } else if ([url.host isEqualToString:@"we"]) {
                
            }
            return YES;
        }
    }
    
    return result;
}

// NOTE: 9.0以后使用新API接口
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    NSLog(@"url.scheme = %@",url.scheme);
    BOOL result = false;
    if ([url.scheme hasPrefix:@"wx5ce7259f60fc8895"]) {
        return [WXApi handleOpenURL:url delegate:self];
    } else {
        result = [[UMSocialManager defaultManager] handleOpenURL:url];
        
        if (result == FALSE) {
            if ([url.host isEqualToString:@"safepay"]) {
                // 支付跳转支付宝钱包进行支付，处理支付结果
                [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                    NSLog(@"result = %@",resultDic);
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationAliPaySuccess object:nil userInfo:resultDic];
                }];
            }
            
            return YES;
        }
    }
    return result;
}
#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"deviceToken = %@", deviceToken);
    [UMessage registerDeviceToken:deviceToken];
}

//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭U-Push自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    [self operatorUpushMessageWithDic:userInfo];
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

/**
 *  触发通知动作时回调，比如点击、删除通知和点击自定义action(iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        // 必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        [self operatorUpushMessageWithDic:userInfo];
    }else{
        //应用处于后台时的本地推送接受
    }
}

- (void)operatorUpushMessageWithDic:(NSDictionary *)userInfo {
    /*
     UMPMessage dict [{
     aps =     {
     alert = "\U652f\U4ed8\U6210\U529f,\U8bf7\U53ca\U65f6\U4f7f\U7528";
     badge = 1;
     sound = default;
     };
     d = uu59724151377788789501;
     p = 0;
     type = newOrder;
     }]
     */
    
    if ([userInfo[@"type"] isEqualToString:@"message"]) {
        DTNotificationViewController *vwcNoti = [[DTNotificationViewController alloc] initWithNibName:NSStringFromClass([DTNotificationViewController class]) bundle:[NSBundle mainBundle]];
        [self.tabBar.navigationController pushViewController:vwcNoti animated:false];
    } else if ([userInfo[@"type"] isEqualToString:@"newOrder"]) {
        self.tabBar.selectedIndex = 2;
        [self.tabBar.orderListVC.scrollPageView setSelectedIndex:2 animated:false];
    } else if ([userInfo[@"type"] isEqualToString:@"handleOrder"]) {
        self.tabBar.selectedIndex = 2;
        [self.tabBar.orderListVC.scrollPageView setSelectedIndex:3 animated:false];
    } else if ([userInfo[@"type"] isEqualToString:@"newReply"]) {
        self.tabBar.selectedIndex = 2;
        [self.tabBar.orderListVC.scrollPageView setSelectedIndex:3 animated:false];
    } else if ([userInfo[@"type"] isEqualToString:@"newRefund"]) {
        self.tabBar.selectedIndex = 2;
        [self.tabBar.orderListVC.scrollPageView setSelectedIndex:0 animated:false];
    } else if ([userInfo[@"type"] isEqualToString:@"newRefundOrder"]) {
        self.tabBar.selectedIndex = 2;
        [self.tabBar.orderListVC.scrollPageView setSelectedIndex:4 animated:false];
    } else if ([userInfo[@"type"] isEqualToString:@"newWithdrawals"]) {
        DTWalletViewController *vwcNoti = [[DTWalletViewController alloc] initWithNibName:NSStringFromClass([DTWalletViewController class]) bundle:[NSBundle mainBundle]];
        [self.tabBar.navigationController pushViewController:vwcNoti animated:false];
    } else if ([userInfo[@"type"] isEqualToString:@"newAdvertisement"]) {
        
    }
}

#pragma mark - WXApiDelegate

//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法,显示支付结果的
-(void)onResp:(BaseResp*)resp
{
    // 启动微信支付的response
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
                payResoult = @"支付结果：成功！";
                [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationWXPaySuccess object:nil userInfo:nil];
                break;
            case -1:
                payResoult = @"支付结果：失败！";
                [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationWXPayFail object:nil userInfo:nil];
                break;
            case -2:
                payResoult = @"用户已经退出支付！";
                [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationWXPayFail object:nil userInfo:nil];
                break;
            default:
                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationWXPayFail object:nil userInfo:nil];
                break;
        }
    }
    NSLog(@"payResoult = %@", payResoult);
}


@end
