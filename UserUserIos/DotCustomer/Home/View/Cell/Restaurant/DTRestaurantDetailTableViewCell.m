//
//  DTRestaurantDetailTableViewCell.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/10.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTRestaurantDetailTableViewCell.h"
#import "XHStarRateView.h"

@interface DTRestaurantDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *starBgView;
@property (strong, nonatomic) XHStarRateView *starView;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryLabel;
@property (weak, nonatomic) IBOutlet UILabel *paperLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *couponView;

@property (weak, nonatomic) IBOutlet UIView *subOneCouponView;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchOneLabel;
@property (weak, nonatomic) IBOutlet UIButton *matchOneBtn;


@property (weak, nonatomic) IBOutlet UIView *subTwoCouponView;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchTwoLabel;
@property (weak, nonatomic) IBOutlet UIButton *matchTwoBtn;

@property (weak, nonatomic) IBOutlet UIButton *addressButton;

@property (weak, nonatomic) IBOutlet UIView *subThreeCouponView;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchThreeLabel;
@property (weak, nonatomic) IBOutlet UIButton *matchThreeBtn;


@end

@implementation DTRestaurantDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.starView = [[XHStarRateView alloc]initWithFrame:CGRectMake(0, 0, 80, 15) numberOfStars:5 rateStyle:WholeStar isAnination:NO finish:nil];
    self.starView.currentScore = 5;
    self.starView.userInteractionEnabled = NO;
    [self.starBgView addSubview:self.starView];
    
    self.rewardLabel.layer.cornerRadius = 3.0;
    self.rewardLabel.layer.masksToBounds = true;
    self.rewardLabel.layer.borderColor = RGB(255, 146, 19).CGColor;
    self.rewardLabel.layer.borderWidth = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)touchPhoneNoBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchPhoneNoButton)]) {
        [self.delegate touchPhoneNoButton];
    }
}

- (IBAction)touchBuyTicketBtn:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(touchBuyTicketButtonWithModel:)]) {
        DTCouponModel *model = nil;
        if (sender.tag == 100) {
            model = self.model.couponList.firstObject;
        } else if (sender.tag == 101) {
            model = self.model.couponList[1];
        } else if (sender.tag == 102) {
            model = self.model.couponList[2];
        }
        [self.delegate touchBuyTicketButtonWithModel:model];
    }
}


/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTRestaurantDetailTableViewCell";
    DTRestaurantDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (IBAction)touchBuyOrderBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchBuyOrderButton)]) {
        [self.delegate touchBuyOrderButton];
    }
}

- (void)setModel:(DTRestaurantModel *)model {
    _model = model;
    
    self.desLabel.text = model.noticeStr;
    self.starView.currentScore = [model.score floatValue];
    self.storeNameLabel.text = model.name;
    self.saleLabel.text = [NSString stringWithFormat:@"月售%@", model.salerNum];
    self.addressLabel.text = [NSString stringWithFormat:@"地址：%@", model.location];
    
    if ([model.dispatchFlag integerValue] == 0) {
        self.deliveryLabel.hidden = true;
    }
    
    if ([model.paperStatus integerValue] == 0) {
        self.paperLabel.hidden = true;
    }
    
    if ([model.type integerValue] == 1) {
        self.rewardLabel.text = [NSString stringWithFormat:@" 红包奖励%@%% ", model.rate];
    } else {
        self.rewardLabel.text = [NSString stringWithFormat:@" 最高红包奖励%@%% ", model.maxRate];
    }
    
    if (!model.couponList || model.couponList.count == 0) {
        self.couponView.hidden = true;
    } else if (model.couponList.count == 1) {
        self.subOneCouponView.hidden = false;
        DTCouponModel *oneModel = model.couponList.firstObject;
        self.oneLabel.text = [NSString stringWithFormat:@"￥%@", oneModel.price];
        self.matchOneLabel.text = [NSString stringWithFormat:@"代%@", oneModel.usePrice];
        [self.matchOneBtn setTitle:oneModel.remark forState:UIControlStateNormal];
        [self.subTwoCouponView removeFromSuperview];
        [self.subThreeCouponView removeFromSuperview];
        
        
    } else if (model.couponList.count == 2) {
        self.subOneCouponView.hidden = false;
        DTCouponModel *oneModel = model.couponList.firstObject;
        self.oneLabel.text = [NSString stringWithFormat:@"￥%@", oneModel.price];
        self.matchOneLabel.text = [NSString stringWithFormat:@"代%@", oneModel.usePrice];
        [self.matchOneBtn setTitle:oneModel.remark forState:UIControlStateNormal];
        self.subTwoCouponView.hidden = false;
        DTCouponModel *twoModel = model.couponList[1];
        self.twoLabel.text = [NSString stringWithFormat:@"￥%@", twoModel.price];
        self.matchTwoLabel.text = [NSString stringWithFormat:@"代%@", twoModel.usePrice];
        [self.matchTwoBtn setTitle:twoModel.remark forState:UIControlStateNormal];
        [self.subThreeCouponView removeFromSuperview];
        
        
    } else if (model.couponList.count >= 3) {
        self.subOneCouponView.hidden = false;
        DTCouponModel *oneModel = model.couponList.firstObject;
        self.oneLabel.text = [NSString stringWithFormat:@"￥%@", oneModel.price];
        self.matchOneLabel.text = [NSString stringWithFormat:@"代%@", oneModel.usePrice];
        [self.matchOneBtn setTitle:oneModel.remark forState:UIControlStateNormal];
        self.subTwoCouponView.hidden = false;
        DTCouponModel *twoModel = model.couponList[1];
        self.twoLabel.text = [NSString stringWithFormat:@"￥%@", twoModel.price];
        self.matchTwoLabel.text = [NSString stringWithFormat:@"代%@", twoModel.usePrice];
        [self.matchTwoBtn setTitle:twoModel.remark forState:UIControlStateNormal];
        self.subThreeCouponView.hidden = false;
        DTCouponModel *threeModel = model.couponList[2];
        self.threeLabel.text = [NSString stringWithFormat:@"￥%@", threeModel.price];
        self.matchThreeLabel.text = [NSString stringWithFormat:@"代%@", threeModel.usePrice];
        [self.matchThreeBtn setTitle:threeModel.remark forState:UIControlStateNormal];
    }
}
- (IBAction)touchAddressBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchAddressButton)]) {
        [self.delegate touchAddressButton];
    }
}

@end
