//
//  DTTabBarViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/12.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTTabBarViewController.h"
#import "DTNavigationViewController.h"
#import "DTHomeViewController.h"
#import "DTPaperViewController.h"

#import "DTPersonalCenterViewController.h"
#import "ScrollTabBarDelegate.h"

@interface DTTabBarViewController ()

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) NSInteger subViewControllerCount;
@property (nonatomic, strong) ScrollTabBarDelegate *tabBarDelegate;

@end

@implementation DTTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dictTitle = [NSDictionary dictionaryWithObject:RGB(246, 30, 46) forKey:NSForegroundColorAttributeName];
    
    // 首页
    DTHomeViewController *vwcHome = [[DTHomeViewController alloc] init];
    vwcHome.title = @"首页";
    DTNavigationViewController *vwcNavHome = [[DTNavigationViewController alloc] initWithRootViewController:vwcHome];
    vwcNavHome.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页"
                                                           image:[UIImage imageNamed:@"tabbar_home_n"]
                                                   selectedImage:[UIImage imageNamed:@"tabbar_home_s"]];
    [vwcNavHome.tabBarItem setTitleTextAttributes:dictTitle forState:UIControlStateSelected];
    
    // 附近纸巾
    DTPaperViewController *vwcPaper = [[DTPaperViewController alloc] init];
    vwcPaper.title = @"附近纸巾";
    DTNavigationViewController *vwcNavPaper = [[DTNavigationViewController alloc] initWithRootViewController:vwcPaper];
    vwcNavPaper.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"附近纸巾"
                                                             image:[UIImage imageNamed:@"tabbar_around_n"]
                                                     selectedImage:[UIImage imageNamed:@"tabbar_around_s"]];
    [vwcNavPaper.tabBarItem setTitleTextAttributes:dictTitle forState:UIControlStateSelected];
    
    // 订单
    self.orderListVC = [[DTOrderListCollectionViewController alloc] init];
    self.orderListVC.title = @"订单";
    DTNavigationViewController *vwcNavOrder = [[DTNavigationViewController alloc] initWithRootViewController:self.orderListVC];
    vwcNavOrder.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"订单"
                                                          image:[UIImage imageNamed:@"tabbar_order_n"]
                                                  selectedImage:[UIImage imageNamed:@"tabbar_order_s"]];
    [vwcNavOrder.tabBarItem setTitleTextAttributes:dictTitle forState:UIControlStateSelected];
    
    // 我的
    DTPersonalCenterViewController *vwcMine = [[DTPersonalCenterViewController alloc] init];
    vwcMine.title = @"我的";
    DTNavigationViewController *vwcNavMine = [[DTNavigationViewController alloc] initWithRootViewController:vwcMine];
    vwcNavMine.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的"
                                                          image:[UIImage imageNamed:@"tabbar_mine_n"]
                                                  selectedImage:[UIImage imageNamed:@"tabbar_mine_s"]];
   [vwcNavMine.tabBarItem setTitleTextAttributes:dictTitle forState:UIControlStateSelected];
    
    
    self.viewControllers = @[vwcNavHome, vwcNavPaper, vwcNavOrder, vwcNavMine];
//    [self addScrollTabBar];
}

/**
 添加滑动逻辑
 */
- (void)addScrollTabBar {
    // 正确的给予 count
    self.subViewControllerCount = self.viewControllers ? self.viewControllers.count : 0;
    // 代理
    self.tabBarDelegate = [[ScrollTabBarDelegate alloc] init];
    self.delegate = self.tabBarDelegate;
    // 增加滑动手势
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandle:)];
    [self.view addGestureRecognizer:self.panGesture];
}

- (void)panHandle:(UIPanGestureRecognizer *)panGesture {
    // 获取滑动点
    CGFloat translationX = [panGesture translationInView:self.view].x;
    CGFloat progress = fabs(translationX)/self.view.frame.size.width;
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.tabBarDelegate.interactive = YES;
            CGFloat velocityX = [panGesture velocityInView:self.view].x;
            if (velocityX < 0) {
                if (self.selectedIndex < self.subViewControllerCount - 1) {
                    self.selectedIndex += 1;
                }
            }
            else {
                if (self.selectedIndex > 0) {
                    self.selectedIndex -= 1;
                }
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self.tabBarDelegate.interactionController updateInteractiveTransition:progress];
        }
            
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        {
            if (progress > 0.3) {
                self.tabBarDelegate.interactionController.completionSpeed = 0.99;
                [self.tabBarDelegate.interactionController finishInteractiveTransition];
            }else{
                //转场取消后，UITabBarController 自动恢复了 selectedIndex 的值，不需要我们手动恢复。
                self.tabBarDelegate.interactionController.completionSpeed = 0.99;
                [self.tabBarDelegate.interactionController cancelInteractiveTransition];
            }
            self.tabBarDelegate.interactive = NO;
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
