//
//  DTGoodsModel.h
//  DotCustomer
//
//  Created by 程荣刚 on 2017/11/23.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTGoodsModel : NSObject

@property (nonatomic, strong) NSString * curPrice;// 团购价格
@property (nonatomic, strong) NSString * idField;//商品ID
@property (nonatomic, strong) NSString * img;//
@property (nonatomic, strong) NSString * name;//商品名称
@property (nonatomic, strong) NSString * price;//店铺价格
@property (nonatomic, strong) NSString * saleNum;//月销量
@property (nonatomic, strong) NSString * score;//评分
@property (nonatomic, strong) NSString * title;//标题
@property (nonatomic, strong) NSString * details;//描述
@property (nonatomic, strong) NSArray *descs;

@end

@interface DTDescsModel : NSObject

@property (nonatomic, strong) NSString *firstParam;
@property (nonatomic, strong) NSString *twoParam;
@property (nonatomic, strong) NSString *threeParam;

@end
