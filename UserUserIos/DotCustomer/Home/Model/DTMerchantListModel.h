//
//  DTMerchantListModel.h
//  DotCustomer
//
//  Created by 程荣刚 on 2017/11/23.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTMerchantListModel : NSObject

@property (nonatomic, strong) NSString * dispatchFlag; // 是否支持配送,0否1是
@property (nonatomic, strong) NSString * distance; // 距离（米）
@property (nonatomic, strong) NSString * idField; // 商家ID
@property (nonatomic, strong) NSString * maxRate; // 最大红包（随机模式）
@property (nonatomic, strong) NSString * minIcon; // 图片
@property (nonatomic, strong) NSString * minRate; // 最小红包（随机模式）
@property (nonatomic, strong) NSString * name; // 店铺名称
@property (nonatomic, strong) NSString * paperStatus; // 是否配纸巾0否，非0为是
@property (nonatomic, strong) NSString * rate; // 红包（固定模式）
@property (nonatomic, strong) NSString * salerNum; // 月销量
@property (nonatomic, strong) NSString * score; // 评分
@property (nonatomic, strong) NSString * type; // 红包模式（1：固定，2：随机）

@end

@interface DTMerchantListCollectionModel : NSObject

/** <#description#> */
@property (nonatomic, strong) NSArray *list;

@end
