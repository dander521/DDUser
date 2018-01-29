//
//  DTRestaurantModel.h
//  DotCustomer
//
//  Created by 程荣刚 on 2017/11/23.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTRestaurantModel : NSObject

@property (nonatomic, strong) NSString * collection; //（是否收藏，0未收藏，非0：收藏）
@property (nonatomic, strong) NSArray * couponList; //代金券
@property (nonatomic, strong) NSString * dispatchFlag; //是否支持配送（0否1是）
@property (nonatomic, strong) NSString * idField; //商家ID
@property (nonatomic, strong) NSString * location; //地址信息
@property (nonatomic, strong) NSString * maxIcon; //
@property (nonatomic, strong) NSString * maxRate; //最大红包
@property (nonatomic, strong) NSString * minRate; //最小红包
@property (nonatomic, strong) NSString * name; //店铺名称
@property (nonatomic, strong) NSString * paperStatus; //是否配纸巾0否，非0为是
@property (nonatomic, strong) NSString * phone; //联系电话
@property (nonatomic, strong) NSString * rate; //红包
@property (nonatomic, strong) NSString * salerNum; //销量
@property (nonatomic, strong) NSString * score; //评分
@property (nonatomic, strong) NSString * type; //红包模式（1：固定，2：随机）
@property (nonatomic, strong) NSArray * typeList; //
@property (nonatomic, strong) NSString * lon;
@property (nonatomic, strong) NSString * lat;
@property (nonatomic, strong) NSString * noticeStr; // 店铺公告

@end

@interface DTCouponModel : NSObject

@property (nonatomic, strong) NSString * idField; // 代金券ID
@property (nonatomic, strong) NSString * price; //售卖价格
@property (nonatomic, strong) NSString * remark; //备注
@property (nonatomic, strong) NSString * usePrice; //抵用价格

@end

@interface DTTypeListModel : NSObject

@property (nonatomic, strong) NSString * idField; //分类ID
@property (nonatomic, strong) NSArray * list; //
@property (nonatomic, strong) NSString * name; //分类名称

@end

@interface DTTypeModel : NSObject

@property (nonatomic, strong) NSString * curPrice; //商品价格
@property (nonatomic, strong) NSString * idField; //商品ID
@property (nonatomic, strong) NSString * img; //
@property (nonatomic, strong) NSString * name; //商品名称
@property (nonatomic, strong) NSString * saleNum; //销量
@property (nonatomic, strong) NSString * title; //子标题

@end
