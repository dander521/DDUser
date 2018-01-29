//
//  DTCategorySectionView.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/30.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTCategorySectionView.h"

@implementation DTCategorySectionView

- (IBAction)touchLocationBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchLocationButton)]) {
        [self.delegate touchLocationButton];
    }
}

- (IBAction)touchAllCategoryBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchAllCategoryButton)]) {
        [self.delegate touchAllCategoryButton];
    }
}

- (IBAction)touchRedPacketOrderBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchRedPacketButton)]) {
        [self.delegate touchRedPacketButton];
    }
}

+ (instancetype)instanceView {
    DTCategorySectionView *customView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    
    return customView;
}

@end
