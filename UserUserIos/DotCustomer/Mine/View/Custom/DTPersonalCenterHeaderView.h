//
//  DTPersonalCenterHeaderView.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/14.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 头部显示方式
 */
typedef NS_ENUM(NSUInteger, DTPersonalHeaderShowType) {
    DTPersonalHeaderShowTypeIsLogin, /**< 已登录 */
    DTPersonalHeaderShowTypeNotLogin /**< 未登录 */
};

@protocol DTPersonalCenterHeaderViewDelegate <NSObject>

- (void)touchLoginButton;

- (void)touchRegisterButton;

- (void)touchUserAvatar;

- (void)touchNameInfoButton;

@end

@interface DTPersonalCenterHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (nonatomic, assign) id<DTPersonalCenterHeaderViewDelegate>delegate;
@property (nonatomic, assign) DTPersonalHeaderShowType showType;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;
/**
 *  实例方法
 */
+ (instancetype)instanceView;

@end
