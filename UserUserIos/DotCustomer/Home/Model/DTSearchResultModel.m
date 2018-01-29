//
//  DTSearchResultModel.m
//  DotCustomer
//
//  Created by 程荣刚 on 2017/11/29.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTSearchResultModel.h"

@implementation DTSearchResultModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"products" : [DTSearchResultProductsModel class]};
}

@end

@implementation DTSearchResultCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : [DTSearchResultModel class]};
}

@end

@implementation DTSearchResultProductsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

- (DTTypeModel *)transformToTypeModel {
    DTTypeModel *model = [DTTypeModel new];
    model.curPrice = self.curPrice;
    model.img = self.img;
    model.title = self.title;
    model.name = self.name;
    model.saleNum = self.saleNum;
    model.idField = self.idField;
    return model;
}

@end

