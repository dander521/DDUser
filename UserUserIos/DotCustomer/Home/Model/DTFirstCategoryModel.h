//
//  DTFirstCategoryModel.h
//  DotCustomer
//
//  Created by 程荣刚 on 2017/11/23.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTFirstCategoryModel : NSObject

@property (nonatomic, strong) NSString * icon;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * name;

@end

@interface DTFirstCategoryCollectionModel : NSObject

/** description */
@property (nonatomic, strong) NSArray *data;

@end
