//
//  DTPersonalCenterHeaderView.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/14.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTPersonalCenterHeaderView.h"

@interface DTPersonalCenterHeaderView ()



@property (weak, nonatomic) IBOutlet UIButton *nameButton;

@end

@implementation DTPersonalCenterHeaderView

/**
 *  实例方法
 */
+ (instancetype)instanceView {
    DTPersonalCenterHeaderView *customView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    
    customView.userAvatarImageView.layer.borderColor = [UIColor cyanColor].CGColor;
    customView.userAvatarImageView.layer.borderWidth = 3;
    customView.loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    customView.loginBtn.layer.borderWidth = 1;
    customView.registerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    customView.registerBtn.layer.borderWidth = 1;
    customView.userAvatarImageView.userInteractionEnabled = false;
    customView.userAvatarImageView.layer.cornerRadius = 30;
    customView.userAvatarImageView.layer.masksToBounds = true;
    
    return customView;
}

- (void)setShowType:(DTPersonalHeaderShowType)showType {
    _showType = showType;
    if (showType == DTPersonalHeaderShowTypeIsLogin) {
        self.storeNameLabel.hidden = true;
        self.loginBtn.hidden = true;
        self.registerBtn.hidden = true;
        self.avatarBtn.enabled = true;
        
        self.infoLabel.hidden = false;
        self.nameButton.hidden = false;
    } else {
        self.storeNameLabel.hidden = true;
        self.loginBtn.hidden = false;
        self.registerBtn.hidden = false;
        self.avatarBtn.enabled = false;
        
        self.infoLabel.hidden = true;
        self.nameButton.hidden = true;
    }
}

- (IBAction)touchUserAvatarBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchUserAvatar)]) {
        [self.delegate touchUserAvatar];
    }
}

- (IBAction)touchLoginBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchLoginButton)]) {
        [self.delegate touchLoginButton];
    }
}

- (IBAction)touchRegisterBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchRegisterButton)]) {
        [self.delegate touchRegisterButton];
    }
}

- (IBAction)touchNameButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchNameInfoButton)]) {
        [self.delegate touchNameInfoButton];
    }
}

@end
