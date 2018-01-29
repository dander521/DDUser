//
//  DTPaySelectTableViewCell.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/11.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTPaySelectTableViewCellDelegate <NSObject>

- (void)selectPayMethodWithString:(NSString *)payStr;

@end

@interface DTPaySelectTableViewCell : TXSeperateLineCell

@property (nonatomic, weak) id <DTPaySelectTableViewCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** <#description#> */
@property (nonatomic, strong) NSString *selectStr;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@end
