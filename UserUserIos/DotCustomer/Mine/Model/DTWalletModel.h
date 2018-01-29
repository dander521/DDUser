//
//  DTWalletModel.h
//  DotCustomer
//
//  Created by 程荣刚 on 2017/11/22.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTWalletModel : NSObject

@property (nonatomic, strong) NSString * changeType; //(1 支付  2 收入)
@property (nonatomic, strong) NSString * idField; //明细ID
@property (nonatomic, strong) NSString * money; //金额
@property (nonatomic, strong) NSString * time; //时间
@property (nonatomic, strong) NSString * type; //1支付2收入

@end

@interface DTWalletCollectionModel : NSObject

@property (nonatomic, strong) NSArray *list;

@end
