//
//  DTShoppingCartView.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/11.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTShoppingCartViewDelegate <NSObject>

- (void)touchShoppingCartPayButton;

@end

@interface DTShoppingCartView : UIView <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>


@property (assign, nonatomic) id<DTShoppingCartViewDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *cartObjectArray;
@property (nonatomic, strong) NSMutableDictionary *cartObjectDictionary;

+ (instancetype)shareInstanceManager;

- (void)show;

- (void)hide;

- (void)showInView:(UIView *)view;

@end
