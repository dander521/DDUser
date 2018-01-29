//
//  DTHomeTableViewCell.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/28.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTHomeTableViewCell.h"
#import "XHStarRateView.h"

@interface DTHomeTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;

@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UIView *starBgView;

@property (weak, nonatomic) IBOutlet UILabel *deliveryLabel;
@property (weak, nonatomic) IBOutlet UILabel *paperLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;

@property (strong, nonatomic) XHStarRateView *starView;

@end

@implementation DTHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.starView = [[XHStarRateView alloc]initWithFrame:CGRectMake(0, 0, 80, 15) numberOfStars:5 rateStyle:WholeStar isAnination:NO finish:nil];
    self.starView.currentScore = 5;
    self.starView.userInteractionEnabled = NO;
    [self.starBgView addSubview:self.starView];
    
    self.deliveryLabel.layer.cornerRadius = 3.0;
    self.deliveryLabel.layer.masksToBounds = true;
    self.paperLabel.layer.cornerRadius = 3.0;
    self.paperLabel.layer.masksToBounds = true;
    self.rewardLabel.layer.cornerRadius = 3.0;
    self.rewardLabel.layer.masksToBounds = true;
    self.rewardLabel.layer.borderWidth = 1;
    self.rewardLabel.layer.borderColor = RGB(255, 146, 19).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellType:(DTHomeTableViewCellType)cellType {
    _cellType = cellType;
    
    if (cellType == DTHomeTableViewCellTypeFavorite) {
        self.distanceLabel.hidden = true;
        self.saleLabel.hidden = true;
    } else {
        self.distanceLabel.hidden = false;
        self.saleLabel.hidden = false;
    }
}

- (void)setFavoriteModel:(DTFavoriteModel *)favoriteModel {
    _favoriteModel = favoriteModel;
    
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:favoriteModel.minIcon]] placeholderImage:[UIImage imageNamed:@"goods"]];
    self.storeNameLabel.text = favoriteModel.name;
    self.distanceLabel.text = [NSString stringWithFormat:@"%@km", favoriteModel.distance];
    self.starView.currentScore = [favoriteModel.score floatValue];
    
    if ([favoriteModel.dispatchFlag integerValue] == 0) {
        [self.deliveryLabel removeFromSuperview];
    }
    
    if ([favoriteModel.paperStatus integerValue] == 0) {
        [self.paperLabel removeFromSuperview];
    }
    
    if ([favoriteModel.type integerValue] == 1) {
        self.rewardLabel.text = [NSString stringWithFormat:@" 红包奖励%@%% ", favoriteModel.rate];
    } else {
        self.rewardLabel.text = [NSString stringWithFormat:@" 最高红包奖励%@%% ", favoriteModel.maxRate];
    }
    
    self.saleLabel.text = [NSString stringWithFormat:@"月售%@", favoriteModel.salerNum];
}

- (void)setMerchantListModel:(DTMerchantListModel *)merchantListModel {
    _merchantListModel = merchantListModel;
    
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:merchantListModel.minIcon]] placeholderImage:[UIImage imageNamed:@"goods"]];
    self.storeNameLabel.text = merchantListModel.name;
    self.distanceLabel.text = [NSString stringWithFormat:@"%@km", merchantListModel.distance];
    self.starView.currentScore = [merchantListModel.score floatValue];
    
    if ([merchantListModel.dispatchFlag integerValue] == 0) {
        [self.deliveryLabel removeFromSuperview];
    }
    
    if ([merchantListModel.paperStatus integerValue] == 0) {
        [self.paperLabel removeFromSuperview];
    }
    
    if ([merchantListModel.type integerValue] == 1) {
        self.rewardLabel.text = [NSString stringWithFormat:@" 红包奖励%@%% ", merchantListModel.rate];
    } else {
        self.rewardLabel.text = [NSString stringWithFormat:@" 最高红包奖励%@%% ", merchantListModel.maxRate];
    }
    
    self.saleLabel.text = [NSString stringWithFormat:@"月售%@", merchantListModel.salerNum];
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTHomeTableViewCell";
    DTHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

@end
