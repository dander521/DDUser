//
//  DTNotificationModel.m
//  DotCustomer
//
//  Created by 程荣刚 on 2017/11/22.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTNotificationModel.h"

@implementation DTNotificationModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"idField" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : [DTNotificationSubModel class]};
}

@end

@implementation DTNotificationCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : [DTNotificationModel class]};
}

@end

@implementation DTNotificationSubModel

@end
