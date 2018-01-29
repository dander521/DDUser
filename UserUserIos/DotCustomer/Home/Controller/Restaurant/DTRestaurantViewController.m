//
//  DTRestaurantViewController.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/30.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTRestaurantViewController.h"
//#import "DTDiscountCouponViewController.h"
#import "DTRestaurantGoodsDetailViewController.h"
#import "DTPayOrderViewController.h"
#import "SDCycleScrollView.h"
#import "DTRestaurantDetailTableViewCell.h"
#import "DTRestaurantGoodsTableViewCell.h"
#import "DTShoppingCartView.h"
#import "DTSingleCartView.h"
#import "DTTicketVerifyViewController.h"
#import "DTPayTicketViewController.h"
#import "DTRestaurantModel.h"
#import <MapKit/MKMapItem.h>

@interface DTRestaurantViewController () <UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, DTRestaurantDetailTableViewCellDelegate, DTRestaurantGoodsTableViewCellDelegate, DTSingleCartViewDelegate, DTShoppingCartViewDelegate, NetErrorViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) SDCycleScrollView *headerView;
@property (strong, nonatomic) DTShoppingCartView *shoppingView;
@property (strong, nonatomic) DTSingleCartView *singleShoppingView;
@property (assign, nonatomic) BOOL isSelected;
@property (weak, nonatomic) IBOutlet UIImageView *saveImg;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
/**  */
@property (nonatomic, strong) DTRestaurantModel *model;

@end

@implementation DTRestaurantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [self tableViewFooterView];
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 10.0;
    adjustsScrollViewInsets_NO(self.tableView, self);
    self.cartObjectArray = [NSMutableArray new];
    self.cartObjectDictionary = [NSMutableDictionary new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodsDataChange) name:kNotificationGoodsDataChange object:nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadData];
}

- (void)goodsDataChange {
    if (self.singleShoppingView) {
        self.singleShoppingView.cartObjectDictionary = self.cartObjectDictionary;
        self.singleShoppingView.cartObjectArray = self.cartObjectArray;
    }
    
    if (self.shoppingView) {
        self.shoppingView.cartObjectDictionary = self.cartObjectDictionary;
        self.shoppingView.cartObjectArray = self.cartObjectArray;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}

#pragma mark - Request

- (void)loadData {
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:merchantDetail] headParams:nil bodyParams:@{@"id" : self.shopId} success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"status"] integerValue] == 1) {
            [ShowMessage showMessage:responseObject[@"msg"]];
            
            self.model = [DTRestaurantModel mj_objectWithKeyValues:responseObject[@"data"]];

            [self.tableView reloadData];
            
            NSMutableArray *urlsArray = [NSMutableArray new];
            NSArray *maxIconArray = [self.model.maxIcon componentsSeparatedByString:@","];
            for (NSString *imageUrl in maxIconArray) {
                [urlsArray addObject:[imageHost stringByAppendingPathComponent:imageUrl]];
            }
            self.headerView.imageURLStringsGroup = urlsArray;
            
            self.isSelected = [self.model.collection integerValue] == 0 ? false : true;
            self.saveImg.image = self.isSelected ? [UIImage imageNamed:@"btn_yishoucang"] : [UIImage imageNamed:@"btn_shoucang"];
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [ShowMessage showMessage:error.description];
    }];
}

- (void)setFavoriteShop {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:saveShop]
                             headParams:param
                             bodyParams:@{@"shopId" : self.shopId}
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                    
                                    if ([responseObject[@"status"] integerValue] == 1) {
                                        if (self.isSelected) {
                                            [ShowMessage showMessage:@"取消收藏"];
                                        } else {
                                            [ShowMessage showMessage:@"收藏成功"];
                                        }
                                        self.isSelected = !self.isSelected;
                                        self.saveImg.image = self.isSelected ? [UIImage imageNamed:@"btn_yishoucang"] : [UIImage imageNamed:@"btn_shoucang"];
                                    }
                                    [ShowMessage showMessage:responseObject[@"msg"]];
                                }
                                failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                    [ShowMessage showMessage:error.description];
                                    [MBProgressHUD hideHUDForView:self.view];
                                }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.model.typeList.count == 0) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXSeperateLineCell *defaultCell = nil;
    if (indexPath.section == 0) {
        DTRestaurantDetailTableViewCell *cell = [DTRestaurantDetailTableViewCell cellWithTableView:tableView];
        cell.model = self.model;
        cell.delegate = self;
        defaultCell = cell;
    } else {
        DTRestaurantGoodsTableViewCell *cell = [DTRestaurantGoodsTableViewCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.model = self.model;
        defaultCell = cell;
    }
    return defaultCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 10.0;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (!self.model.couponList || self.model.couponList.count == 0) {
            return 180.0;
        } else if (self.model.couponList.count == 1) {
            return 220.0;
        } else if (self.model.couponList.count == 2) {
            return 260.0;
        } else {
            return 300.0;
        }
    } else {
        return 480.0;
    }
}

#pragma mark - DTRestaurantDetailTableViewCellDelegate

- (void)touchPhoneNoButton {
    [TXCustomTools callStoreWithPhoneNo:self.model.phone target:self];
}

- (void)touchBuyTicketButtonWithModel:(DTCouponModel *)model {
    DTPayTicketViewController *vwcSearch = [[DTPayTicketViewController alloc] initWithNibName:NSStringFromClass([DTPayTicketViewController class]) bundle:[NSBundle mainBundle]];
    vwcSearch.model = model;
    [self.navigationController pushViewController:vwcSearch animated:true];
}

- (void)touchBuyOrderButton {
    DTTicketVerifyViewController *vwcSearch = [[DTTicketVerifyViewController alloc] initWithNibName:NSStringFromClass([DTTicketVerifyViewController class]) bundle:[NSBundle mainBundle]];
    vwcSearch.shopId = self.model.idField;
    [self.navigationController pushViewController:vwcSearch animated:true];
}

- (void)touchAddressButton {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak __typeof(&*actionSheet)weakActionSheet = actionSheet;
    CLLocationCoordinate2D coorUser = CLLocationCoordinate2DMake([[TXModelAchivar getUserModel].latitude floatValue], [[TXModelAchivar getUserModel].longitude floatValue]);
    CLLocationCoordinate2D coorDes = CLLocationCoordinate2DMake([self.model.lat floatValue], [self.model.lon floatValue]);
    
    CLLocationCoordinate2D coorUserTrans = [self gcj02CoordianteToBD09:coorUser];
    CLLocationCoordinate2D coorDesTrans = [self gcj02CoordianteToBD09:coorDes];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        UIAlertAction *baiduMapAction = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *baiduParameterFormat = @"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:终点&mode=driving";
            
            NSString *urlString = [[NSString stringWithFormat:
                                    baiduParameterFormat,
                                    coorUserTrans.latitude,
                                    coorUserTrans.longitude,
                                    coorDesTrans.latitude,
                                    coorDesTrans.longitude]
                                   stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }];
        [actionSheet addAction:baiduMapAction];
    }

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        UIAlertAction *gaodeMapAction = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CLLocationCoordinate2D desCorrdinate = CLLocationCoordinate2DMake([self.model.lat floatValue], [self.model.lon floatValue]);
            NSString *gaodeParameterFormat = @"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&lat=%f&lon=%f&dev=1&style=2";
            NSString *urlString = [[NSString stringWithFormat:
                                    gaodeParameterFormat,
                                    @"点点仓库",
                                    @"DotCustomer",
                                    @"终点",
                                    desCorrdinate.latitude,
                                    desCorrdinate.longitude]
                                   stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }];
        [actionSheet addAction:gaodeMapAction];
    }
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //起点
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        CLLocationCoordinate2D desCorrdinate = CLLocationCoordinate2DMake([self.model.lat floatValue], [self.model.lon floatValue]);
        //终点
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:desCorrdinate addressDictionary:nil]];
        //默认驾车
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                       MKLaunchOptionsMapTypeKey:[NSNumber numberWithInteger:0],
                                       MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
    }]];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakActionSheet dismissViewControllerAnimated:true completion:nil];
    }];

    [actionSheet addAction:cancelAction];
    [self presentViewController:actionSheet animated:true completion:nil];
}

/** *  将GCJ-02坐标转换为BD-09坐标 即将高德地图上获取的坐标转换成百度坐标 */
- (CLLocationCoordinate2D)gcj02CoordianteToBD09:(CLLocationCoordinate2D)gdCoordinate
{
    double x_PI = M_PI * 3000.0 /180.0;
    
    double gd_lat = gdCoordinate.latitude;
    
    double gd_lon = gdCoordinate.longitude;
    
    double z = sqrt(gd_lat * gd_lat + gd_lon * gd_lon) + 0.00002 * sin(gd_lat * x_PI);
    
    double theta = atan2(gd_lat, gd_lon) + 0.000003 * cos(gd_lon * x_PI);
    
    return CLLocationCoordinate2DMake(z * sin(theta) + 0.006, z * cos(theta) + 0.0065);
}

/** *  将BD-09坐标转换为GCJ-02坐标 即将百度地图上获取的坐标转换成高德地图的坐标 */
- (CLLocationCoordinate2D)bd09CoordinateToGCJ02:(CLLocationCoordinate2D)bdCoordinate
{
    double x_PI = M_PI * 3000.0 /180.0;
    
    double bd_lat = bdCoordinate.latitude - 0.006;
    
    double bd_lon = bdCoordinate.longitude - 0.0065;
    
    double z = sqrt(bd_lat * bd_lat + bd_lon * bd_lon) - 0.00002 * sin(bd_lat * x_PI);
    
    double theta = atan2(bd_lat, bd_lon) - 0.000003 * cos(bd_lon * x_PI);
    
    return CLLocationCoordinate2DMake(z * sin(theta), z * cos(theta));
}


#pragma mark - Touch Method

- (IBAction)touchBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)touchSaveBtn:(id)sender {
    [self setFavoriteShop];
}

#pragma mark - SDCycleScrollViewDelegate

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"index = %zd", index);
    if ([NSString isTextEmpty:self.model.maxIcon]) {
        return;
    }
    NSMutableArray *urlsArray = [NSMutableArray new];
    NSArray *maxIconArray = [self.model.maxIcon componentsSeparatedByString:@","];
    for (NSString *imageUrl in maxIconArray) {
        [urlsArray addObject:[imageHost stringByAppendingPathComponent:imageUrl]];
    }
    
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    for(int i = 0;i < [urlsArray count];i++) {
        NSString *imagePath = urlsArray[i];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImageUrl = imagePath;// 加载网络图片大图地址
        
        [browseItemArray addObject:browseItem];
    }
    MSSBrowseNetworkViewController *vwcBrowse = [[MSSBrowseNetworkViewController alloc] initWithBrowseItemArray:browseItemArray currentIndex:index];
    [vwcBrowse showBrowseViewController];
}

#pragma mark - DTRestaurantGoodsTableViewCellDelegate

- (void)touchGoodsDetailCellWithModel:(DTTypeModel *)model {
    DTRestaurantGoodsDetailViewController *vwcSearch = [[DTRestaurantGoodsDetailViewController alloc] initWithNibName:NSStringFromClass([DTRestaurantGoodsDetailViewController class]) bundle:[NSBundle mainBundle]];
    vwcSearch.typeModel = model;
    vwcSearch.shopId = self.model.idField;
    vwcSearch.cartObjectDictionary = self.cartObjectDictionary;
    vwcSearch.cartObjectArray = self.cartObjectArray;
    [self.navigationController pushViewController:vwcSearch animated:true];
}

- (void)touchGoodsDetailAddButtonWithModel:(DTTypeModel *)model {
    if (!self.singleShoppingView) {
        self.singleShoppingView = [DTSingleCartView shareInstanceManager];
        self.singleShoppingView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 70);
        self.singleShoppingView.delegate = self;
        [self.singleShoppingView showInView:self.view];
    }
    
    if (self.cartObjectDictionary.count == 0) {
        [self.cartObjectDictionary setValue:@"1" forKey:model.idField];
        [self.cartObjectArray addObject:model];
    } else {
        NSArray *modelArray = self.cartObjectDictionary.allKeys;
        if ([modelArray containsObject:model.idField]) {
            NSInteger modelCount = [[self.cartObjectDictionary objectForKey:model.idField] integerValue];
            modelCount += 1;
            [self.cartObjectDictionary setValue:[NSString stringWithFormat:@"%zd", modelCount]  forKey:model.idField];
        } else {
            [self.cartObjectDictionary setValue:@"1" forKey:model.idField];
            [self.cartObjectArray addObject:model];
        }
    }
    
    self.singleShoppingView.cartObjectDictionary = self.cartObjectDictionary;
    self.singleShoppingView.cartObjectArray = self.cartObjectArray;
}

#pragma mark - DTSingleCartViewDelegate

- (void)touchSingleCartButton {
    self.shoppingView = [DTShoppingCartView shareInstanceManager];
    self.shoppingView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.shoppingView.delegate = self;
    
    [self.shoppingView showInView:self.view];
    
    [self.singleShoppingView removeFromSuperview];
    self.singleShoppingView = nil;
    
    self.shoppingView.cartObjectDictionary = self.cartObjectDictionary;
    self.shoppingView.cartObjectArray = self.cartObjectArray;
}

- (void)touchSingleCartPayButton {
    DTPayOrderViewController *vwcSearch = [[DTPayOrderViewController alloc] initWithNibName:NSStringFromClass([DTPayOrderViewController class]) bundle:[NSBundle mainBundle]];
    vwcSearch.cartObjectArray = self.cartObjectArray;
    vwcSearch.cartObjectDictionary = self.cartObjectDictionary;
    [self.navigationController pushViewController:vwcSearch animated:true];
}

#pragma mark - DTShoppingCartViewDelegate

- (void)touchShoppingCartPayButton {
    DTPayOrderViewController *vwcSearch = [[DTPayOrderViewController alloc] initWithNibName:NSStringFromClass([DTPayOrderViewController class]) bundle:[NSBundle mainBundle]];
    vwcSearch.cartObjectArray = self.cartObjectArray;
    vwcSearch.cartObjectDictionary = self.cartObjectDictionary;
    [self.navigationController pushViewController:vwcSearch animated:true];
}

#pragma mark - Lazy

- (SDCycleScrollView *)headerView {
    if (!_headerView) {
        _headerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,200) delegate:self placeholderImage:[UIImage imageNamed:@"banner"]];
        _headerView.autoScrollTimeInterval = 3;
        _headerView.tag = 1;
        _headerView.pageDotImage = [UIImage imageNamed:@"ic_main_by_switching_circle"];
        _headerView.currentPageDotImage = [UIImage imageNamed:@"ic_main_by_switching"];
        _headerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        if (@available(iOS 11.0, *)) {
            _headerView.backgroundColor = [UIColor colorNamed:@"lightGrayColor"];
        } else {
            // Fallback on earlier versions
            _headerView.backgroundColor = [UIColor lightGrayColor];
        }
        _headerView.showPageControl = YES;
        _headerView.infiniteLoop = YES;
    }
    return _headerView;
}


#pragma mark - Custom Method

- (UIView *)tableViewFooterView {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    footer.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return footer;
}

@end
