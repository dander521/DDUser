//
//  DTSingleCartView.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/11.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTSingleCartView.h"
#import "DTRestaurantModel.h"

@interface DTSingleCartView ()

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;

@end

@implementation DTSingleCartView

+ (instancetype)shareInstanceManager {
    DTSingleCartView *instance = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    instance.countLabel.layer.cornerRadius = 10;
    instance.countLabel.layer.masksToBounds = true;
    return instance;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        //代码
        self.frame = CGRectMake(0, SCREEN_HEIGHT+70, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    
    return self;
}

- (void)show {
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

// 添加弹出移除的动画效果
- (void)showInView:(UIView *)view {
    // 浮现
    [UIView animateWithDuration:0.25 animations:^{
        CGPoint point = self.center;
        point.y -= 70;
        self.center = point;
    } completion:^(BOOL finished) {
        
    }];
    [view addSubview:self];
}

- (void)hide {
    [UIView animateWithDuration:0.25 animations:^{
        CGPoint point = self.center;
        point.y += 70;
        self.center = point;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (IBAction)touchCartBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchSingleCartButton)]) {
        [self.delegate touchSingleCartButton];
    }
}
- (IBAction)touchPayBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchSingleCartPayButton)]) {
        [self.delegate touchSingleCartPayButton];
    }
}

- (void)setCartObjectDictionary:(NSMutableDictionary *)cartObjectDictionary {
    _cartObjectDictionary = cartObjectDictionary;
    
    [self setCountLabelText];
}

- (void)setCartObjectArray:(NSMutableArray *)cartObjectArray {
    _cartObjectArray = cartObjectArray;
    
    [self setTotalMoney];
}

- (void)setCountLabelText {
    NSArray *totalCount = self.cartObjectDictionary.allValues;
    NSInteger total = 0;
    for (NSString *count in totalCount) {
        total += [count integerValue];
    }
    
    self.countLabel.text = [NSString stringWithFormat:@"%zd", total];
}

- (void)setTotalMoney {
    CGFloat totalMoney = 0.0;
    for (DTTypeModel *model in self.cartObjectArray) {
        CGFloat singleMoney = [model.curPrice floatValue];
        NSInteger count = [[self.cartObjectDictionary objectForKey:model.idField] integerValue];
        CGFloat singleTotalMoney = singleMoney * count;
        totalMoney += singleTotalMoney;
    }
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f", totalMoney];
}

@end
