//
//  DTCommentModel.m
//  DotCustomer
//
//  Created by 程荣刚 on 2017/11/23.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTCommentModel.h"

@implementation DTCommentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"replyList" : [DTReplyModel class]};
}

@end

@implementation DTReplyModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id"};
}

@end

@implementation DTCommentCollectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : [DTCommentModel class]};
}

@end
