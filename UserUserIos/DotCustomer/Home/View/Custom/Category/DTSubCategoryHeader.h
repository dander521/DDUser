//
//  DTSubCategoryHeader.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/30.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
@class DTFirstCategoryModel;

@protocol DTSubCategoryHeaderDelegate <NSObject>

- (void)selectPhotoScrollViewWithIndex:(NSInteger)index;

- (void)selectCollectionItemWithIndex:(NSInteger)index;

@end
@interface DTSubCategoryHeader : UIView <SDCycleScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) id <DTSubCategoryHeaderDelegate> delegate;
/** 头部视图*/
@property (nonatomic, strong) SDCycleScrollView *photoView;

@property (nonatomic, strong) NSArray <DTFirstCategoryModel *>*collectionViewData;
/** <#description#> */
@property (nonatomic, strong) UICollectionView *collectionView;

@end
