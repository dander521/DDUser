//
//  AppDelegate.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/12.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/** <#description#> */
@property (nonatomic, strong) NSMutableArray *cityDistrictArray;
/** <#description#> */
@property (nonatomic, strong) NSMutableArray *firstCategoryArray;

/**
 *  实例对象
 */
+ (instancetype)sharedAppDelegate;

@end

