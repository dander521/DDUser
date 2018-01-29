//
//  DTGoodsModel.m
//  DotCustomer
//
//  Created by 程荣刚 on 2017/11/23.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTGoodsModel.h"

@implementation DTGoodsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"descs" : [DTDescsModel class]};
}

@end

@implementation DTDescsModel



@end
