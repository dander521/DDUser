//
//  DTBannerModel.m
//  DotCustomer
//
//  Created by 程荣刚 on 2017/11/23.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTBannerModel.h"

@implementation DTBannerModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

@end

@implementation DTBannerCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : [DTBannerModel class]};
}

@end
