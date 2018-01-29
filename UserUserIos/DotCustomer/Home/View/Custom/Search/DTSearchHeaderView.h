//
//  DTSearchHeaderView.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/11.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSearchResultModel.h"

@protocol DTSearchHeaderViewDelegate <NSObject>

- (void)touchHeaderViewButtonWithModel:(DTSearchResultModel *)model;

@end

@interface DTSearchHeaderView : UIView

/** <#description#> */
@property (nonatomic, strong) DTSearchResultModel *model;

@property (assign, nonatomic) id <DTSearchHeaderViewDelegate> delegate;

+ (instancetype)instanceView;

@end
