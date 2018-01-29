//
//  DTOrderTableViewCell.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/11.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTRestaurantModel.h"

@protocol DTOrderTableViewCellDelegate <NSObject>

- (void)touchMinusButtonWithModel:(DTTypeModel *)model;

- (void)touchPlusButtonWithModel:(DTTypeModel *)model;

@end

@interface DTOrderTableViewCell : TXSeperateLineCell

@property (nonatomic, weak) id <DTOrderTableViewCellDelegate> delegate;
@property (nonatomic, strong) DTTypeModel *model;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
