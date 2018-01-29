//
//  DTHomeTableViewCell.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/28.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTFavoriteModel.h"
#import "DTMerchantListModel.h"

typedef NS_ENUM(NSInteger, DTHomeTableViewCellType) {
    DTHomeTableViewCellTypeHome = 0,
    DTHomeTableViewCellTypeFavorite
};

@interface DTHomeTableViewCell : TXSeperateLineCell

/** <#description#> */
@property (nonatomic, strong) DTFavoriteModel *favoriteModel;
/** <#description#> */
@property (nonatomic, strong) DTMerchantListModel *merchantListModel;

@property (assign, nonatomic) DTHomeTableViewCellType cellType;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
