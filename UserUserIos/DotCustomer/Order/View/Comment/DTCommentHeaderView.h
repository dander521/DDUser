//
//  DTCommentHeaderView.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/29.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTOrderListModel.h"

@interface DTCommentHeaderView : UIView

/** <#description#> */
@property (nonatomic, strong) DTOrderListModel *model;
+ (instancetype)instanceView;

@end
