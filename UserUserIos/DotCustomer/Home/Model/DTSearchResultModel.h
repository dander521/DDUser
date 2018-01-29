//
//  DTSearchResultModel.h
//  DotCustomer
//
//  Created by 程荣刚 on 2017/11/29.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTRestaurantModel.h"

@interface DTSearchResultModel : NSObject

@property (nonatomic, strong) NSString * dispatchFlag; //是否支持配送,0否1是
@property (nonatomic, strong) NSString * distance; //距离（米）
@property (nonatomic, strong) NSString * idField; //
@property (nonatomic, strong) NSString * lookNum; //浏览数
@property (nonatomic, strong) NSString * maxRate; //最大红包（随机模式）
@property (nonatomic, strong) NSString * minIcon; //图片
@property (nonatomic, strong) NSString * minRate; //最小红包（随机模式）
@property (nonatomic, strong) NSString * name; //店铺名称
@property (nonatomic, strong) NSString * paperStatus; //是否配纸巾0否，非0为是
@property (nonatomic, strong) NSArray * products; //
@property (nonatomic, strong) NSString * rate; //红包（固定模式）
@property (nonatomic, strong) NSString * salerNum; //月销量
@property (nonatomic, strong) NSString * score; //评分
@property (nonatomic, strong) NSString * type; //红包模式（1：固定，2：随机）

@end

@interface DTSearchResultCollectionModel : NSObject

@property (nonatomic, strong) NSArray * list; //

@end

@interface DTSearchResultProductsModel : NSObject

@property (nonatomic, strong) NSString * curPrice; //团购价格
@property (nonatomic, strong) NSString * idField; //
@property (nonatomic, strong) NSString * img; //
@property (nonatomic, strong) NSString * name; //商品名称
@property (nonatomic, strong) NSString * saleNum; //月销量
@property (nonatomic, strong) NSString * title; //商品简介

- (DTTypeModel *)transformToTypeModel;

@end
