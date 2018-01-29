//
//  DTInputCommentTableViewCell.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/29.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHStarRateView.h"

@protocol DTInputCommentTableViewCellDelegate <NSObject>

- (void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore;

@end


@interface DTInputCommentTableViewCell : UITableViewCell <XHStarRateViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *starBgView;
@property (strong, nonatomic) XHStarRateView *starView;
@property (weak, nonatomic) IBOutlet UITextView *contentTX;
/** <#description#> */
@property (nonatomic, weak) id <DTInputCommentTableViewCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

