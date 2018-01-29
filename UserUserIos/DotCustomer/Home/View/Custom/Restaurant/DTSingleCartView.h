//
//  DTSingleCartView.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/11.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTSingleCartViewDelegate <NSObject>

- (void)touchSingleCartButton;

- (void)touchSingleCartPayButton;

@end

@interface DTSingleCartView : UIView


@property (assign, nonatomic) id<DTSingleCartViewDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *cartObjectArray;
@property (nonatomic, strong) NSMutableDictionary *cartObjectDictionary;

+ (instancetype)shareInstanceManager;

- (void)show;

- (void)hide;
// 添加弹出移除的动画效果
- (void)showInView:(UIView *)view;

@end
