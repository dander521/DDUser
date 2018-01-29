//
//  DTOrderFooterView.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/11.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTOrderFooterView.h"

@implementation DTOrderFooterView

+ (instancetype)instanceView {
    DTOrderFooterView *customView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    return customView;
}

@end
