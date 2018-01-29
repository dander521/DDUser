//
//  BaseHeaderView.m
//  RCController
//
//  Created by 程荣刚 on 2017/9/22.
//  Copyright © 2017年 程荣刚. All rights reserved.
//

#import "BaseHeaderView.h"
#import "BaseCollectionViewCell.h"
#import "DTFirstCategoryModel.h"
#import "SMPageControl.h"

static NSString *cellID = @"BaseCollectionViewCell";

@interface BaseHeaderView ()

@property (nonatomic, strong) UIImageView *trumpetImageView;
@property (nonatomic, strong) UILabel *separateLabel;
/** <#description#> */
@property (nonatomic, strong) SMPageControl *pageControl;

@end

@implementation BaseHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.photoView];
        [self addSubview:self.midTitleView];
        [self addSubview:self.trumpetImageView];
        [self addSubview:self.separateLabel];
        
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
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.midTitleView.frame)+ 15.5, SCREEN_WIDTH-20, (SCREEN_WIDTH - 40 )*2/5.1) collectionViewLayout:flowLayout];
        
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.delegate = self;
        self.collectionView.bounces = NO;
        self.collectionView.pagingEnabled = true;
        self.collectionView.dataSource = self;
        [self addSubview:self.collectionView];
        
        // pagecontrol
        self.pageControl = [[SMPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), SCREEN_WIDTH, 20)];
        self.pageControl.numberOfPages = 3;
        self.pageControl.currentPage = 0;
        self.pageControl.backgroundColor = [UIColor whiteColor];
        self.pageControl.pageIndicatorTintColor = RGB(153, 153, 153);
        self.pageControl.currentPageIndicatorTintColor = RGB(246, 30, 46);
        
        [self addSubview:self.pageControl];
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
            _photoView.backgroundColor = [UIColor colorNamed:@"whiteColor"];
        } else {
            // Fallback on earlier versions
            _photoView.backgroundColor = [UIColor whiteColor];
        }
        _photoView.showPageControl = YES;
        _photoView.infiniteLoop = YES;
    }
    return _photoView;
}

- (SDCycleScrollView *)midTitleView {
    if (!_midTitleView) {
        _midTitleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(28, CGRectGetMaxY(self.photoView.frame), SCREEN_WIDTH, 50) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        _midTitleView.autoScrollTimeInterval = 3;
        _midTitleView.tag = 2;
        _midTitleView.onlyDisplayText = true;
        _midTitleView.scrollDirection = UICollectionViewScrollDirectionVertical;
        _midTitleView.titleLabelBackgroundColor = [UIColor whiteColor];
        _midTitleView.titleLabelTextColor = [UIColor blackColor];
    }
    
    return _midTitleView;
}

- (UIImageView *)trumpetImageView {
    if (!_trumpetImageView) {
        _trumpetImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(self.photoView.frame) + 17, 16, 16)];
        _trumpetImageView.image = [UIImage imageNamed:@"gonggao"];
    }
    
    return _trumpetImageView;
}

- (UILabel *)separateLabel {
    if (!_separateLabel) {
        _separateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.midTitleView.frame), SCREEN_WIDTH, 0.5)];
        _separateLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    }
    return _separateLabel;
}

#pragma mark - SDCycleScrollViewDelegate

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"cycleScrollView.tag = %zd", cycleScrollView.tag);
    NSLog(@"index = %zd", index);
    // photo
    if (cycleScrollView.tag == 1) {
        if ([self.delegate respondsToSelector:@selector(selectPhotoScrollViewWithIndex:)]) {
            [self.delegate selectPhotoScrollViewWithIndex:index];
        }
    } else { // title
        if ([self.delegate respondsToSelector:@selector(selectTitleScrollViewWithIndex:)]) {
            [self.delegate selectTitleScrollViewWithIndex:index];
        }
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
    if (collectionViewData.count % 10 == 0) {
        self.pageControl.numberOfPages = collectionViewData.count/10;
    } else {
        self.pageControl.numberOfPages = (NSInteger)collectionViewData.count/10 + 1;
    }
    [self.collectionView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {


}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        NSLog(@"%f", scrollView.contentOffset.x);
        NSLog(@"%f", scrollView.contentSize.width);
        NSLog(@"%f", SCREEN_WIDTH);
        if (scrollView.contentOffset.x == 0) {
            _pageControl.currentPage = 0;
        }
        if (scrollView.contentOffset.x <= SCREEN_WIDTH && scrollView.contentOffset.x > 0) {
            _pageControl.currentPage = 1;
        }
        
        if (scrollView.contentOffset.x <= 2*SCREEN_WIDTH && scrollView.contentOffset.x > SCREEN_WIDTH) {
            _pageControl.currentPage = 2;
        }
    }
}

@end
