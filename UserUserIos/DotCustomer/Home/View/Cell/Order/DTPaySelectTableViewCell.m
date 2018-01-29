//
//  DTPaySelectTableViewCell.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/11.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTPaySelectTableViewCell.h"

@interface DTPaySelectTableViewCell ()

@property (nonatomic, assign) BOOL isSelectBalance;
@property (nonatomic, assign) BOOL isSelectWechat;
@property (nonatomic, assign) BOOL isSelectAlipay;
@property (weak, nonatomic) IBOutlet UIButton *balanceButton;
@property (weak, nonatomic) IBOutlet UIButton *wechatButton;
@property (weak, nonatomic) IBOutlet UIButton *alipayButton;

/** <#description#> */
@property (nonatomic, strong) NSMutableArray *strArray;

@end

@implementation DTPaySelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.isSelectBalance = false;
    self.isSelectWechat = false;
    self.isSelectAlipay = false;
    self.strArray = [NSMutableArray new];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTPaySelectTableViewCell";
    DTPaySelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (void)setIsSelectBalance:(BOOL)isSelectBalance {
    _isSelectBalance = isSelectBalance;
    NSString *imageName = isSelectBalance ? @"xuanzhong" : @"ic_unselected";
    [self.balanceButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)setIsSelectWechat:(BOOL)isSelectWechat {
    _isSelectWechat = isSelectWechat;
    NSString *imageName = isSelectWechat ? @"xuanzhong" : @"ic_unselected";
    [self.wechatButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)setIsSelectAlipay:(BOOL)isSelectAlipay {
    _isSelectAlipay = isSelectAlipay;
    NSString *imageName = isSelectAlipay ? @"xuanzhong" : @"ic_unselected";
    [self.alipayButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (IBAction)touchBalanceBtn:(id)sender {
    self.isSelectBalance = !self.isSelectBalance;
    
    if (self.isSelectBalance) {
        [self.strArray addObject:@"0"];
    } else {
        [self.strArray removeObject:@"0"];
    }
    
    if ([self.delegate respondsToSelector:@selector(selectPayMethodWithString:)]) {
        [self.delegate selectPayMethodWithString:[self.strArray componentsJoinedByString:@","]];
    }
}

- (IBAction)touchWechatBtn:(id)sender {
    self.isSelectWechat = self.isSelectAlipay == false ? !self.isSelectAlipay : self.isSelectAlipay;
    self.isSelectAlipay = self.isSelectWechat == true ? false : true;
    
    if (self.isSelectAlipay) {
        if (![self.strArray containsObject:@"1"]) {
            [self.strArray addObject:@"1"];
        }
        [self.strArray removeObject:@"2"];
    } else {
        if (![self.strArray containsObject:@"2"]) {
            [self.strArray addObject:@"2"];
        }
        [self.strArray removeObject:@"1"];
    }
    
    if ([self.delegate respondsToSelector:@selector(selectPayMethodWithString:)]) {
        [self.delegate selectPayMethodWithString:[self.strArray componentsJoinedByString:@","]];
    }
}

- (IBAction)touchAlipayBtn:(id)sender {
    self.isSelectAlipay = self.isSelectWechat == false ? !self.isSelectWechat : self.isSelectWechat;
    self.isSelectWechat = self.isSelectAlipay == true ? false : true;
    
    if (self.isSelectAlipay) {
        if (![self.strArray containsObject:@"1"]) {
            [self.strArray addObject:@"1"];
        }
        [self.strArray removeObject:@"2"];
    } else {
        if (![self.strArray containsObject:@"2"]) {
            [self.strArray addObject:@"2"];
        }
        [self.strArray removeObject:@"1"];
    }
    
    if ([self.delegate respondsToSelector:@selector(selectPayMethodWithString:)]) {
        [self.delegate selectPayMethodWithString:[self.strArray componentsJoinedByString:@","]];
    }
}

- (void)setSelectStr:(NSString *)selectStr {
    if ([NSString isTextEmpty:selectStr]) {
        return;
    }
    
    NSArray *selectArray = [selectStr componentsSeparatedByString:@","];
    self.strArray = [NSMutableArray arrayWithArray:selectArray];
    self.isSelectBalance = [selectArray containsObject:@"0"] ? true : false;
    self.isSelectAlipay = [selectArray containsObject:@"1"] ? true : false;
    self.isSelectWechat = [selectArray containsObject:@"2"] ? true : false;
    
}

@end
