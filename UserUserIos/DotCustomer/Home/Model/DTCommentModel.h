//
//  DTCommentModel.h
//  DotCustomer
//
//  Created by 程荣刚 on 2017/11/23.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTCommentModel : NSObject

@property (nonatomic, strong) NSString * content; //内容
@property (nonatomic, strong) NSString * face; //头像
@property (nonatomic, strong) NSString * idField; //数据ID
@property (nonatomic, strong) NSString * img; //图片1,图片2
@property (nonatomic, strong) NSString * name; //评价人
@property (nonatomic, strong) NSString * score; //评分
@property (nonatomic, strong) NSString * time; //评价时间
@property (nonatomic, strong) NSArray *replyList;

@end

@interface DTReplyModel : NSObject
@property (nonatomic, strong) NSString * content; //内容
@property (nonatomic, strong) NSString * idField; //数据ID
@property (nonatomic, strong) NSString * userId; //数据ID
@property (nonatomic, strong) NSString * name;

@end

@interface DTCommentCollectionModel : NSObject

/** description */
@property (nonatomic, strong) NSArray *list;

@end
