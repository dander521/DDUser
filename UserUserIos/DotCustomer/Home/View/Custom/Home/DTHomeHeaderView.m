//
//  DTHomeHeaderView.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/28.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTHomeHeaderView.h"

@implementation DTHomeHeaderView

+ (instancetype)instanceView {
    DTHomeHeaderView *customView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    
    return customView;
}

@end
