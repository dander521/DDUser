//
//  BaseHeaderView.h
//  RCController
//
//  Created by 程荣刚 on 2017/9/22.
//  Copyright © 2017年 程荣刚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@class DTFirstCategoryModel;

@protocol BaseHeaderViewDelegate <NSObject>

- (void)selectPhotoScrollViewWithIndex:(NSInteger)index;

- (void)selectTitleScrollViewWithIndex:(NSInteger)index;

- (void)selectCollectionItemWithIndex:(NSInteger)index;

@end

@interface BaseHeaderView : UIView <SDCycleScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) id <BaseHeaderViewDelegate> delegate;
/** 头部视图*/
@property (nonatomic, strong) SDCycleScrollView *photoView;
/** 文字视图*/
@property (nonatomic, strong) SDCycleScrollView *midTitleView;

/** <#description#> */
@property (nonatomic, strong) NSArray <DTFirstCategoryModel *>*collectionViewData;
/** <#description#> */
@property (nonatomic, strong) UICollectionView *collectionView;

@end
