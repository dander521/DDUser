//
//  DTCategorySectionView.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/30.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTCategorySectionViewDelegate <NSObject>

- (void)touchAllCategoryButton;

- (void)touchLocationButton;

- (void)touchRedPacketButton;

@end

@interface DTCategorySectionView : UIView

@property (assign, nonatomic) id <DTCategorySectionViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *allCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *autoLabel;

+ (instancetype)instanceView;

@end
