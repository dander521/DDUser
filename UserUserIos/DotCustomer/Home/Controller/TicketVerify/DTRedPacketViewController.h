//
//  DTRedPacketViewController.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/13.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTOrderListModel.h"

@interface DTRedPacketViewController : UIViewController

@property (nonatomic, strong) DTOrderListModel *model;
/** <#description#> */
@property (nonatomic, strong) NSString *redpacketNum;

@end
