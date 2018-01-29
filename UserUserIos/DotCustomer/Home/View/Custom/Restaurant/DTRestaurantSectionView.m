//
//  DTRestaurantSectionView.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/10.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTRestaurantSectionView.h"

@implementation DTRestaurantSectionView

+ (instancetype)instanceView {
    DTRestaurantSectionView *customView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    [customView.starBgView addSubview:customView.starView];
    return customView;
}

- (XHStarRateView *)starView {
    if (!_starView) {
        _starView = [[XHStarRateView alloc]initWithFrame:CGRectMake(0, 0, 80, 15) numberOfStars:5 rateStyle:WholeStar isAnination:NO finish:nil];
        _starView.currentScore = 5;
        _starView.userInteractionEnabled = NO;
    }
    return _starView;
}

- (void)setScore:(float)score {
    _score = score;
    self.starView.currentScore = 5;
}
- (IBAction)touchAllCommentsBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchAllCommentsButton)]) {
        [self.delegate touchAllCommentsButton];
    }
}

@end
