//
//  DTOrderListModel.h
//  DotCustomer
//
//  Created by 程荣刚 on 2017/11/22.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTOrderListModel : NSObject

@property (nonatomic, strong) NSString * idField;//订单ID
@property (nonatomic, strong) NSArray * list;//
@property (nonatomic, strong) NSString * orderNo;//订单号
@property (nonatomic, strong) NSString * orderPrice;//订单价格
@property (nonatomic, strong) NSString * orderType;//订单类型（1商品2券 3 买单）
@property (nonatomic, strong) NSString * remark;//备注
@property (nonatomic, strong) NSString * sendPrice;//红包
@property (nonatomic, strong) NSString * shopName;//店铺名称
@property (nonatomic, strong) NSString * shopId;//店铺名称
@property (nonatomic, strong) NSString * status;//状态 (不传：全部，0:待付款，1：待使用，2：已完成，3：申诉)
@property (nonatomic, strong) NSString * time;//下单时间
@property (nonatomic, strong) NSString * shopIcon;
@property (nonatomic, strong) NSString * assessFlag;//是否评价（0否1是）

@end

@interface DTOrderListCollectionModel : NSObject

@property (nonatomic, strong) NSArray *data;//

@end

@interface DTOrderModel : NSObject

@property (nonatomic, strong) NSString * dataId;//数据ID（商品ID或券ID）
@property (nonatomic, strong) NSString * idField;//订单详情ID
@property (nonatomic, strong) NSString * img;//
@property (nonatomic, strong) NSString * name;//商品名称
@property (nonatomic, strong) NSString * num;//数量
@property (nonatomic, strong) NSString * price;//商品单价
@property (nonatomic, strong) NSString * title;//标题

@end
