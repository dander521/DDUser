//
//  DTReceiptQRViewController.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/13.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTOrderListModel.h"

@interface DTReceiptQRViewController : UIViewController

/** <#description#> */
@property (nonatomic, strong) NSString *orderNo;
/** <#description#> */
@property (nonatomic, strong) DTOrderListModel *model;

@end
