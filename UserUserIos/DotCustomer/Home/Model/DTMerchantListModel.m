//
//  DTMerchantListModel.m
//  DotCustomer
//
//  Created by 程荣刚 on 2017/11/23.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTMerchantListModel.h"

@implementation DTMerchantListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

@end

@implementation DTMerchantListCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : [DTMerchantListModel class]};
}


@end
