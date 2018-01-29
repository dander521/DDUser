//
//  DTPersonalCenterViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/12.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTPersonalCenterViewController.h"
#import "DTPersonalCenterTableViewCell.h"
#import "DTPersonalCenterHeaderView.h"
#import "RCExpandHeader.h"
#import "DTNewLoginViewController.h"
#import "DTRegisterViewController.h"
#import "DTVerifyNameViewController.h"
#import "DTPersonalInfoViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface DTPersonalCenterViewController ()<UITableViewDelegate, UITableViewDataSource, DTPersonalCenterHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *centerTableView;
@property (nonatomic, strong) DTPersonalCenterHeaderView *headerView;

@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) NSArray *titlesArray;

@end

@implementation DTPersonalCenterViewController {
    RCExpandHeader *_header;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    adjustsScrollViewInsets_NO(self.centerTableView, self);
    self.imagesArray = @[@[@"icon_qianbao", @"icon_shoucang", @"icon_xiaoxi"], @[@"icon_lianxiwomen", @"icon_guanggao", @"icon_fenxiang"], @[@"icon_shezhi"]];
    self.titlesArray = @[@[@"我的钱包", @"我的收藏", @"消息中心"], @[@"联系我们", @"合作交流", @"分享"], @[@"设置"]];
    
//    _header = [RCExpandHeader expandWithScrollView:self.centerTableView expandView:[self tableHeaderView]];
    if ([[TXUserModel defaultUser] userLoginStatus]) {
        self.centerTableView.tableHeaderView = [self tableHeaderViewWithType:DTPersonalHeaderShowTypeIsLogin];
        self.headerView.infoLabel.text = [TXModelAchivar getUserModel].nickName;
        [self.headerView.userAvatarImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:[TXModelAchivar getUserModel].face]] placeholderImage:[UIImage imageNamed:@"user"]];
    } else {
        self.centerTableView.tableHeaderView = [self tableHeaderViewWithType:DTPersonalHeaderShowTypeNotLogin];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kNotificationLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOutSuccess) name:kNotificationLoginOutSuccess object:nil];
    
    self.headerView.infoLabel.text = [TXModelAchivar getUserModel].nickName;
    [self.headerView.userAvatarImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:[TXModelAchivar getUserModel].face]] placeholderImage:[UIImage imageNamed:@"user"]];
}

- (void)loginSuccess {
    self.centerTableView.tableHeaderView = [self tableHeaderViewWithType:DTPersonalHeaderShowTypeIsLogin];
    self.headerView.infoLabel.text = [TXModelAchivar getUserModel].nickName;
    [self.headerView.userAvatarImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:[TXModelAchivar getUserModel].face]] placeholderImage:[UIImage imageNamed:@"user"]];
}

- (void)loginOutSuccess {
    self.centerTableView.tableHeaderView = [self tableHeaderViewWithType:DTPersonalHeaderShowTypeNotLogin];
    self.headerView.infoLabel.text = [TXModelAchivar getUserModel].nickName;
    
    [self.headerView.userAvatarImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:[TXModelAchivar getUserModel].face]] placeholderImage:[UIImage imageNamed:@"user"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 3;
    if (section == 1) return 3;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DTPersonalCenterTableViewCell *cell = [DTPersonalCenterTableViewCell cellWithTableView:tableView];
    cell.iconImageView.image = [UIImage imageNamed:self.imagesArray[indexPath.section][indexPath.row]];
    cell.titleLabel.text = self.titlesArray[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (![[TXUserModel defaultUser] userLoginStatus] && indexPath.section == 0) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self contactWithUs];
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        // 分享
        [self shareContent];
    } else {
        NSArray *subControllers = @[@[@"DTWalletViewController", @"DTFavoriteViewController", @"DTNotificationViewController"], @[@"DTContactUsViewController", @"DTContactUsViewController", @"DTContactUsViewController"], @[@"DTSettingViewController"]];
        [self customPushActionWithControllerName:subControllers[indexPath.section][indexPath.row]];
    }
}

#pragma mark - DTPersonalCenterHeaderViewDelegate

- (void)touchLoginButton {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    DTNewLoginViewController *vwcLogin = [[DTNewLoginViewController alloc] initWithNibName:NSStringFromClass([DTNewLoginViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vwcLogin animated:NO];
}

- (void)touchRegisterButton {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    DTRegisterViewController *vwcRegister = [[DTRegisterViewController alloc] initWithNibName:NSStringFromClass([DTRegisterViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vwcRegister animated:NO];
}

- (void)touchUserAvatar {
    NSLog(@"touchUserAvatar");
    [self customPushActionWithControllerName:@"DTPersonalInfoViewController"];
}

- (void)touchNameInfoButton {
    [self customPushActionWithControllerName:@"DTPersonalInfoViewController"];
}

#pragma mark - Custom Method

- (void)customPushActionWithControllerName:(NSString *)controllerName {
    UIViewController *vwc = [NSClassFromString(controllerName) new];
    vwc.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:vwc animated:true];
}

- (UIView *)tableHeaderViewWithType:(DTPersonalHeaderShowType)type {
    _headerView = [DTPersonalCenterHeaderView instanceView];
    _headerView.delegate = self;
    _headerView.showType = type;
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    return _headerView;
}

- (void)contactWithUs {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:contactUs]
                             headParams:nil
                             bodyParams:nil
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                    [ShowMessage showMessage:responseObject[@"msg"]];
                                    if ([responseObject[@"status"] integerValue] == 1) {
                                        NSString *phoneNum = [NSString isTextEmpty:responseObject[@"data"]] ? @"暂未设置联系方式" : responseObject[@"data"];
                                        [TXCustomTools callStoreWithPhoneNo:phoneNum target:self];
                                    }
                                }
                                failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                    [ShowMessage showMessage:error.description];
                                    [MBProgressHUD hideHUDForView:self.view];
                                }];
}

- (void)shareContent {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:shareContent]
                             headParams:nil
                             bodyParams:nil
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                    [ShowMessage showMessage:responseObject[@"msg"]];
                                    if ([responseObject[@"status"] integerValue] == 1) {
                                        
                                        NSArray* imageArray = [NSArray new];
                                        if ([NSString isTextEmpty:responseObject[@"data"][@"icon"]]) {
                                            imageArray = @[[UIImage imageNamed:@"logo.png"]];
                                        } else {
                                            NSURL *imageUrl = [NSURL URLWithString:[imageHost stringByAppendingPathComponent:responseObject[@"data"][@"icon"]]];
                                            imageArray = @[imageUrl];
                                        }
                                        
                                        if (imageArray) {
                                            
                                            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                                            [shareParams SSDKSetupShareParamsByText:responseObject[@"data"][@"content"]
                                                                             images:imageArray
                                                                                url:[NSURL URLWithString:responseObject[@"data"][@"url"]]
                                                                              title:responseObject[@"data"][@"title"]
                                                                               type:SSDKContentTypeAuto];
                                            //有的平台要客户端分享需要加此方法，例如微博
                                            [shareParams SSDKEnableUseClientShare];
                                            //2、分享（可以弹出我们的分享菜单和编辑界面）
                                            [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                                                     items:nil
                                                               shareParams:shareParams
                                                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                           
                                                           switch (state) {
                                                               case SSDKResponseStateSuccess:
                                                               {
                                                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                                                       message:nil
                                                                                                                      delegate:nil
                                                                                                             cancelButtonTitle:@"确定"
                                                                                                             otherButtonTitles:nil];
                                                                   [alertView show];
                                                                   break;
                                                               }
                                                               case SSDKResponseStateFail:
                                                               {
                                                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                                                   message:[NSString stringWithFormat:@"%@",error]
                                                                                                                  delegate:nil
                                                                                                         cancelButtonTitle:@"OK"
                                                                                                         otherButtonTitles:nil, nil];
                                                                   [alert show];
                                                                   break;
                                                               }
                                                               default:
                                                                   break;
                                                           }
                                                       }
                                             ];}
                                    }
                                }
                                failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                    [ShowMessage showMessage:error.description];
                                    [MBProgressHUD hideHUDForView:self.view];
                                }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
