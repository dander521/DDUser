//
//  DTRestaurantSectionView.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/10.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHStarRateView.h"

@protocol DTRestaurantSectionViewDelegate <NSObject>

- (void)touchAllCommentsButton;

@end

@interface DTRestaurantSectionView : UIView

@property (assign, nonatomic) id<DTRestaurantSectionViewDelegate>delegate;
@property (strong, nonatomic) XHStarRateView *starView;
@property (weak, nonatomic) IBOutlet UIView *starBgView;
@property (assign, nonatomic) float score;

+ (instancetype)instanceView;

@end
