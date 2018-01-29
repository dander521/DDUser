//
//  DTShoppingCartView.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/11.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTShoppingCartView.h"
#import "DTCartViewTableViewCell.h"
#import <Foundation/Foundation.h>
#import "DTRestaurantModel.h"

@interface DTShoppingCartView () <DTCartViewTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UITableView *cartTableView;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;

@end

@implementation DTShoppingCartView

+ (instancetype)shareInstanceManager {
    DTShoppingCartView *instance = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    instance.countLabel.layer.cornerRadius = 10;
    instance.countLabel.layer.masksToBounds = true;
    return instance;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        //代码
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestrueMethod:)];
        tapGesture.delegate = self;
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
    }
    
    return self;
}

// 点击背景
- (void)tapGestrueMethod:(UITapGestureRecognizer *)gesture {
    [self hide];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view.tag == 100 ||
        touch.view.tag == 101 ||
        touch.view.tag == 102) {
        return false;
    }
    return true;
}

- (void)show {
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

// 添加弹出移除的动画效果
- (void)showInView:(UIView *)view {
    self.cartTableView.delegate = self;
    self.cartTableView.dataSource = self;
    // 浮现
    self.backgroundColor = RGBA(0, 0, 0, 0.3);
    [UIView animateWithDuration:0.25 animations:^{
        
        CGPoint point = self.center;
        self.center = point;
    } completion:^(BOOL finished) {
        
    }];
    
    [view addSubview:self];
}

- (void)hide {
    self.backgroundColor = RGBA(0, 0, 0, 0.0);
    [UIView animateWithDuration:0.25 animations:^{
        CGPoint point = self.center;
        self.alpha = 0;
        self.center = point;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)touchPayBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchShoppingCartPayButton)]) {
        [self.delegate touchShoppingCartPayButton];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cartObjectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DTCartViewTableViewCell *cell = [DTCartViewTableViewCell cellWithTableView:tableView];
    cell.cellLineType = TXCellSeperateLinePositionType_Single;
    cell.cellLineRightMargin = TXCellRightMarginType12;
    DTTypeModel *model =self.cartObjectArray[indexPath.row];
    cell.model = model;
    cell.cartObjectDictionary = self.cartObjectDictionary;
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (void)setCartObjectDictionary:(NSMutableDictionary *)cartObjectDictionary {
    _cartObjectDictionary = cartObjectDictionary;
    
    [self setCountLabelText];
}

- (void)setCartObjectArray:(NSMutableArray *)cartObjectArray {
    _cartObjectArray = cartObjectArray;
    
    [self setTotalMoney];
    [self.cartTableView reloadData];
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

#pragma mark - DTCartViewTableViewCellDelegate

- (void)touchMinusButtonWithModel:(DTTypeModel *)model {
    NSInteger modelCount = [[self.cartObjectDictionary objectForKey:model.idField] integerValue];
    modelCount -= 1;
    if (modelCount == 0) {
        [self.cartObjectDictionary removeObjectForKey:model.idField];
        if ([self.cartObjectArray containsObject:model]) {
            [self.cartObjectArray removeObject:model];
        }
    } else {
        [self.cartObjectDictionary setValue:[NSString stringWithFormat:@"%zd", modelCount]  forKey:model.idField];
    }
    
    [self.cartTableView reloadData];
    [self setCountLabelText];
    [self setTotalMoney];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGoodsDataChange object:nil userInfo:nil];
}

- (void)touchPlusButtonWithModel:(DTTypeModel *)model {
    NSInteger modelCount = [[self.cartObjectDictionary objectForKey:model.idField] integerValue];
    modelCount += 1;
    [self.cartObjectDictionary setValue:[NSString stringWithFormat:@"%zd", modelCount]  forKey:model.idField];
    
    [self.cartTableView reloadData];
    [self setCountLabelText];
    [self setTotalMoney];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGoodsDataChange object:nil userInfo:nil];
}

- (IBAction)touchCleanBtn:(id)sender {
    [self.cartObjectDictionary removeAllObjects];
    [self.cartObjectArray removeAllObjects];
    [self.cartTableView reloadData];
    self.countLabel.text = @"0";
    self.totalMoneyLabel.text = @"￥0.0";
    [self hide];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGoodsDataChange object:nil userInfo:nil];
}

@end
