//
//  DTSubCategoryHeader.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/30.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTSubCategoryHeader.h"
#import "BaseCollectionViewCell.h"
#import "DTFirstCategoryModel.h"

static NSString *cellID = @"BaseCollectionViewCell";

@implementation DTSubCategoryHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        self.photoView.localizationImageNamesGroup = @[@"pic1", @"pic2", @"pic3"];
        [self addSubview:self.photoView];
        
        //初始化一个布局对象
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //设置最小间距
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 7;
        //设置格子大小
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 40 )/5.1, (SCREEN_WIDTH - 40 )/5.1);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //初始化集合视图
        self.collectionView.collectionViewLayout = flowLayout;
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.photoView.frame) + 20, SCREEN_WIDTH-20, (SCREEN_WIDTH - 40 )*2/5.1) collectionViewLayout:flowLayout];
        
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.delegate = self;
        self.collectionView.bounces = NO;
        self.collectionView.pagingEnabled = true;
        self.collectionView.dataSource = self;
        [self addSubview:self.collectionView];
    }
    
    return self;
}

- (SDCycleScrollView *)photoView {
    if (!_photoView) {
        _photoView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,200) delegate:self placeholderImage:[UIImage imageNamed:@"banner"]];
        _photoView.autoScrollTimeInterval = 3;
        _photoView.tag = 1;
        _photoView.pageDotImage = [UIImage imageNamed:@"ic_shuffling"];
        _photoView.currentPageDotImage = [UIImage imageNamed:@"ic_shuffling_star"];
        _photoView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        if (@available(iOS 11.0, *)) {
            _photoView.backgroundColor = [UIColor colorNamed:@"lightGrayColor"];
        } else {
            // Fallback on earlier versions
            _photoView.backgroundColor = [UIColor lightGrayColor];
        }
        _photoView.showPageControl = YES;
        _photoView.infiniteLoop = YES;
    }
    return _photoView;
}

#pragma mark - SDCycleScrollViewDelegate

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"cycleScrollView.tag = %zd", cycleScrollView.tag);
    NSLog(@"index = %zd", index);
    // photo
    if ([self.delegate respondsToSelector:@selector(selectPhotoScrollViewWithIndex:)]) {
        [self.delegate selectPhotoScrollViewWithIndex:index];
    }
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionViewData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.desLabel.text = self.collectionViewData[indexPath.item].name;
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:self.collectionViewData[indexPath.item].icon]] placeholderImage:[UIImage imageNamed:@"goods"]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath.item = %zd", indexPath.item);
    if ([self.delegate respondsToSelector:@selector(selectCollectionItemWithIndex:)]) {
        [self.delegate selectCollectionItemWithIndex:indexPath.item];
    }
}

- (void)setCollectionViewData:(NSArray<DTFirstCategoryModel *> *)collectionViewData {
    _collectionViewData = collectionViewData;
    [self.collectionView reloadData];
}

@end
