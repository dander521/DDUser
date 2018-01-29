//
//  DTBannerModel.h
//  DotCustomer
//
//  Created by 程荣刚 on 2017/11/23.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTBannerModel : NSObject

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * img;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSString * url;

@end

@interface DTBannerCollectionModel : NSObject

@property (nonatomic, strong) NSArray *data;

@end
