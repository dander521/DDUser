//
//  DTInputCommentViewController.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/29.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTOrderListModel.h"

@interface DTInputCommentViewController : UIViewController

/** <#description#> */
@property (nonatomic, strong) NSString *orderId;
/** <#description#> */
@property (nonatomic, strong) DTOrderListModel *listModel;

@end
