//
//  DTRestaurantViewController.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/30.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTRestaurantViewController : UIViewController

/** <#description#> */
@property (nonatomic, strong) NSString *shopId;

/** <#description#> */
@property (nonatomic, strong) NSMutableArray *cartObjectArray;
@property (nonatomic, strong) NSMutableDictionary *cartObjectDictionary;

@end
