//
//  DTWalletModel.m
//  DotCustomer
//
//  Created by 程荣刚 on 2017/11/22.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTWalletModel.h"

@implementation DTWalletModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

@end

@implementation DTWalletCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : [DTWalletModel class]};
}

@end
