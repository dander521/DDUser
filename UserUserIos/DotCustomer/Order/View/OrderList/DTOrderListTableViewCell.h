//
//  DTOrderListTableViewCell.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/16.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTOrderListModel.h"
// (不传：全部，0:待付款，1：待使用，2：已完成，3：申诉)
typedef NS_ENUM(NSInteger, DTOrderListTableViewCellType) {
    DTOrderListTableViewCellTypeAll = 0, /**< 全部 */
    DTOrderListTableViewCellTypeForPay, /**< 待付款 */
    DTOrderListTableViewCellTypeForUse, /**< 待使用 */
    DTOrderListTableViewCellTypeDone, /**< 已完成 */
    DTOrderListTableViewCellTypeCommented, /**< 已评价 */
    DTOrderListTableViewCellTypeAppeal, /**< 申诉 */
    DTOrderListTableViewCellTypeRefund, /**< 已退款 */
    DTOrderListTableViewCellTypeAppealSuccess, /**< 申诉成功 */
    DTOrderListTableViewCellTypeBuyOrder /**< 买单成功 */
};

@protocol DTOrderListTableViewCellDelegate <NSObject>

- (void)touchTicketVerifyButtonWithType:(DTOrderListTableViewCellType)type model:(DTOrderListModel *)model;

- (void)touchActionButtonWithType:(DTOrderListTableViewCellType)type model:(DTOrderListModel *)model;

@end

@interface DTOrderListTableViewCell : TXSeperateLineCell

/**  */
@property (nonatomic, strong) DTOrderListModel *model;

@property (assign, nonatomic) DTOrderListTableViewCellType cellType;
@property (assign, nonatomic) id<DTOrderListTableViewCellDelegate>delegate;

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
