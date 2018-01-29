//
//  DTRestaurantModel.m
//  DotCustomer
//
//  Created by 程荣刚 on 2017/11/23.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTRestaurantModel.h"

@implementation DTRestaurantModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"couponList" : [DTCouponModel class],
             @"typeList" : [DTTypeListModel class]
             };
}

@end

@implementation DTCouponModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

@end

@implementation DTTypeListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : [DTTypeModel class]};
}

@end

@implementation DTTypeModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

@end
