//
//  DTGoodsDetailViewController.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/10.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTRestaurantModel.h"

@interface DTRestaurantGoodsDetailViewController : UIViewController

/** <#description#> */
@property (nonatomic, strong) DTTypeModel *typeModel;
/** <#description#> */
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSMutableArray *cartObjectArray;
@property (nonatomic, strong) NSMutableDictionary *cartObjectDictionary;

@end
