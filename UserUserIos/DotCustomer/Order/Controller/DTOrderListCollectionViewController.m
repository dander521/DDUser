//
//  DTOrderListCollectionViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/16.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTOrderListCollectionViewController.h"

#import "DTOrderListViewController.h"

@interface DTOrderListCollectionViewController ()<ZJScrollPageViewDelegate>



@end

@implementation DTOrderListCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 定义全局leftBarButtonItem
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""]
                                                                                       style:UIBarButtonItemStylePlain
                                                                                      target:self
                                                                                      action:nil];
    
    [self setupscrollPageView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupscrollPageView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    style.titleBigScale = 1.f;;
    style.segmentHeight = 49;
    style.gradualChangeTitleColor = true;
    style.autoAdjustTitlesWidth = true;
    style.showLine = true;
    style.adjustCoverOrLineWidth = true;
    style.scrollLineColor = RGB(246, 30, 46);
    style.scrollTitle = false;
    style.titleFont = [UIFont fontWithName:@"Helvetica-Light" size:17];
    style.normalTitleColor = RGB(204, 204, 204);
    style.selectedTitleColor = RGB(246, 30, 46);
    
    // 初始化
    self.scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, SCREEN_HEIGHT - 64 - 60) segmentStyle:style titles:@[@"全部",@"待付款", @"待使用", @"已完成", @"申诉"] parentViewController:self delegate:self];

    [self.view addSubview:self.scrollPageView];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [self.scrollPageView setSelectedIndex:self.selectedIndex animated:false];
}

- (NSInteger)numberOfChildViewControllers {
    return 5;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    if (index == 0) {
        DTOrderListViewController *childVc = (DTOrderListViewController *)reuseViewController;
        if (childVc == nil) {
            childVc = [[DTOrderListViewController alloc] initWithNibName:NSStringFromClass([DTOrderListViewController class]) bundle:[NSBundle mainBundle]];
        }
        childVc.cellType = 0;
        return childVc;
    } else if (index == 1) {
        DTOrderListViewController *childVc = (DTOrderListViewController *)reuseViewController;
        if (childVc == nil) {
            childVc = [[DTOrderListViewController alloc] initWithNibName:NSStringFromClass([DTOrderListViewController class]) bundle:[NSBundle mainBundle]];
        }
        childVc.cellType = 1;
        return childVc;
    } else if (index == 2) {
        DTOrderListViewController *childVc = (DTOrderListViewController *)reuseViewController;
        if (childVc == nil) {
            childVc =[[DTOrderListViewController alloc] initWithNibName:NSStringFromClass([DTOrderListViewController class]) bundle:[NSBundle mainBundle]];
        }
        childVc.cellType = 2;
        return childVc;
    } else if (index == 3) {
        DTOrderListViewController *childVc = (DTOrderListViewController *)reuseViewController;
        if (childVc == nil) {
            childVc =[[DTOrderListViewController alloc] initWithNibName:NSStringFromClass([DTOrderListViewController class]) bundle:[NSBundle mainBundle]];
        }
        childVc.cellType = 3;
        return childVc;
    } else if (index == 4) {
        DTOrderListViewController *childVc = (DTOrderListViewController *)reuseViewController;
        if (childVc == nil) {
            childVc =[[DTOrderListViewController alloc] initWithNibName:NSStringFromClass([DTOrderListViewController class]) bundle:[NSBundle mainBundle]];
        }
        childVc.cellType = 4;
        return childVc;
    }
    return nil;
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}


@end
