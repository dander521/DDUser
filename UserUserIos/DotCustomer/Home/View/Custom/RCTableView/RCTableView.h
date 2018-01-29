//
//  RCTableView.h
//  TableViewDemo
//
//  Created by 程荣刚 on 2017/11/7.
//  Copyright © 2017年 程荣刚. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RCTableViewType) {
    RCTableViewTypeAllCategory,
    RCTableViewTypeAllLocation,
    RCTableViewTypeAuto
};

@protocol RCTableViewDelegate <NSObject>

- (void)touchTableWithType:(RCTableViewType)tableType content:(NSArray *)content;

@end

@interface RCTableView : UIView

/** <#description#> */
@property (nonatomic, assign) RCTableViewType tableType;

/** <#description#> */
@property (nonatomic, assign) id <RCTableViewDelegate> delegate;

+ (instancetype)shareInstanceManagerWithType:(RCTableViewType)type;

- (void)show;

- (void)hide;

@end
