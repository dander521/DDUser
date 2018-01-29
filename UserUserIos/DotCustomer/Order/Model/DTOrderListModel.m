//
//  DTOrderListModel.m
//  DotCustomer
//
//  Created by 程荣刚 on 2017/11/22.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTOrderListModel.h"

@implementation DTOrderListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : [DTOrderModel class]};
}

@end

@implementation DTOrderListCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : [DTOrderListModel class]};
}

@end

@implementation DTOrderModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

@end
