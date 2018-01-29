//
//  DTFavoriteModel.m
//  DotCustomer
//
//  Created by 程荣刚 on 2017/11/22.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTFavoriteModel.h"

@implementation DTFavoriteModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

@end

@implementation DTFavoriteCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : [DTFavoriteModel class]};
}

@end
