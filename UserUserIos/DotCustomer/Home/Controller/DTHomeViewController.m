//
//  DTHomeViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/12.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTHomeViewController.h"
#import "BaseHeaderView.h"
#import "SGQRCodeScanningVC.h"
#import <AVFoundation/AVFoundation.h>
#import "TXSelectCityController.h"
#import "DTHomeTableViewCell.h"
#import "DTHomeHeaderView.h"
#import "DTSubCategoryViewController.h"
#import "DTRestaurantViewController.h"
#import "DTSearchResultViewController.h"
#import "DTMerchantListModel.h"
#import "DTBannerModel.h"
#import "DTFirstCategoryModel.h"
#import "DTScrollTitleModel.h"
#import "TXShowWebViewController.h"

@interface DTHomeViewController () <UITableViewDelegate, UITableViewDataSource, BaseHeaderViewDelegate,MAMapViewDelegate, AMapSearchDelegate, NetErrorViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerBgView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (nonatomic, strong) BaseHeaderView *headerView;

/** 定位*/
@property (nonatomic, strong) TXLocationManager *locationManager;

@property (nonatomic, strong) AMapSearchAPI *searchAPI;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSMutableDictionary *cityDictionary;

@property (nonatomic, strong) NSMutableArray *showArray;

/** 分页数 */
@property (nonatomic, assign) NSInteger page;
/** 分页请求条数 */
@property (nonatomic, assign) NSInteger pageSize;
/** 返回数据条数 */
@property (nonatomic, assign) NSInteger dataCount;
/** 数据源集合 */
@property (nonatomic, strong) NSMutableArray *sourceArray;

@property (nonatomic, strong) NSMutableArray *bannersArray;
@property (nonatomic, strong) NSMutableArray *titlesArray;
@property (nonatomic, strong) NSMutableArray *firstCategoryArray;
/** <#description#> */
@property (nonatomic, assign) BOOL isLoadNew;

@end

@implementation DTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = self.headerView;
    adjustsScrollViewInsets_NO(self.tableView, self);
    self.isLoadNew = false;
    self.cityArray = [NSMutableArray new];
    self.cityDictionary = [NSMutableDictionary new];
    self.showArray = [NSMutableArray new];
    self.bannersArray = [NSMutableArray new];
    self.titlesArray = [NSMutableArray new];
    self.firstCategoryArray = [NSMutableArray new];
    
    self.searchAPI = [[AMapSearchAPI alloc] init];
    self.searchAPI.delegate = self;
    
    self.locationManager = [[TXLocationManager alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.locationManager locationManagerWithsuccess:^(NSString *cityName, NSString *areaName) {
        weakSelf.cityName = cityName;
        weakSelf.cityLabel.text = cityName;
        [TXModelAchivar updateUserModelWithKey:@"cityName" value:cityName];
        [TXModelAchivar updateUserModelWithKey:@"areaName" value:areaName];
        
        AMapDistrictSearchRequest *dist = [[AMapDistrictSearchRequest alloc] init];
        dist.keywords = cityName;
        [weakSelf.searchAPI AMapDistrictSearch:dist];
        [weakSelf loadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    // tableView 设置
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.automaticallyHidden = true;
    
    // 初始化数据
    _page = 1;
    _pageSize = 10;
    _dataCount = 0;
    self.sourceArray = [NSMutableArray new];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadBannersData];
    [self loadScrollTitlesData];
    [self loadFirstCategoryData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request

- (void)loadBannersData {
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:bannerInfo] headParams:nil bodyParams:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            [ShowMessage showMessage:responseObject[@"msg"]];
            DTBannerCollectionModel *colloectionModel = [DTBannerCollectionModel mj_objectWithKeyValues:responseObject];
            self.bannersArray = [NSMutableArray arrayWithArray:colloectionModel.data];
            
            NSMutableArray *urlsArray = [NSMutableArray new];
            for (DTBannerModel *bannerModel in colloectionModel.data) {
                [urlsArray addObject:[imageHost stringByAppendingPathComponent:bannerModel.img]];
            }
            self.headerView.photoView.imageURLStringsGroup = urlsArray;
            
            NSMutableArray *titlesArray = [NSMutableArray new];
            for (DTBannerModel *bannerModel in colloectionModel.data) {
                [titlesArray addObject:bannerModel.name];
            }
            
            self.headerView.midTitleView.titlesGroup = titlesArray;
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
    }];
}

- (void)loadScrollTitlesData {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:bannerInfo] headParams:params bodyParams:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            [ShowMessage showMessage:responseObject[@"msg"]];
            DTScrollTitleCollectionModel *colloectionModel = [DTScrollTitleCollectionModel mj_objectWithKeyValues:responseObject];
            self.titlesArray = [NSMutableArray arrayWithArray:colloectionModel.data];
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
    }];
}

- (void)loadFirstCategoryData {
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:firstCategory] headParams:nil bodyParams:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            [ShowMessage showMessage:responseObject[@"msg"]];
            DTFirstCategoryCollectionModel *colloectionModel = [DTFirstCategoryCollectionModel mj_objectWithKeyValues:responseObject];
            self.firstCategoryArray = [NSMutableArray arrayWithArray:colloectionModel.data];
            self.headerView.collectionViewData = self.firstCategoryArray;
            [AppDelegate sharedAppDelegate].firstCategoryArray = [NSMutableArray arrayWithArray:colloectionModel.data];
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
    }];
}

- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:[TXModelAchivar getUserModel].longitude forKey:@"lon"];
    [params setValue:[TXModelAchivar getUserModel].latitude forKey:@"lat"];
    [params setValue:@"0" forKey:@"typeId"];
    [params setValue:[NSString stringWithFormat:@"%zd", self.page] forKey:@"page"];
    [params setValue:[NSString stringWithFormat:@"%zd", self.pageSize] forKey:@"pageSize"];
    [params setValue:@"0" forKey:@"twoTypeId"];
    [params setValue:@"3" forKey:@"seachType"];
    [params setValue:@"0" forKey:@"nearDistance"];
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:merchantList] headParams:nil bodyParams:params success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"status"] integerValue] == 1) {
            _page += 1;
            [ShowMessage showMessage:responseObject[@"msg"]];
            DTMerchantListCollectionModel *colloectionModel = [DTMerchantListCollectionModel mj_objectWithKeyValues:responseObject[@"data"]];
            _dataCount = colloectionModel.list.count;
            
            if (self.isLoadNew) {
                [self.sourceArray removeAllObjects];
                self.isLoadNew = false;
            }
            if (_dataCount > 0) {
                [self.sourceArray addObjectsFromArray:colloectionModel.list];
            }
            if (self.sourceArray.count == 0) {

            } else {
                if (_dataCount < _pageSize) {
                    [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                }
            }
            [self.tableView reloadData];
        } else {
            [MBProgressHUD hideHUDForView:self.view];
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

- (void)loadMoreData {
    if (_dataCount < _pageSize) {
        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
    } else {
        [self loadData];
    }
}

- (void)loadNewData {
    self.isLoadNew = true;
    _page = 1;
    [self loadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - Custom



#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DTHomeTableViewCell *cell = [DTHomeTableViewCell cellWithTableView:tableView];
    cell.cellLineType = TXCellSeperateLinePositionType_Single;
    cell.cellLineRightMargin = TXCellRightMarginType0;
    cell.cellType = DTHomeTableViewCellTypeHome;
    if (self.sourceArray.count - 1 >= indexPath.row) {
        cell.merchantListModel = self.sourceArray[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DTHomeHeaderView *header = [DTHomeHeaderView instanceView];
    header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50.0);
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DTMerchantListModel *model = self.sourceArray[indexPath.row];
    DTRestaurantViewController *vwcSearch = [[DTRestaurantViewController alloc] initWithNibName:NSStringFromClass([DTRestaurantViewController class]) bundle:[NSBundle mainBundle]];
    vwcSearch.shopId = model.idField;
    [self.navigationController pushViewController:vwcSearch animated:true];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 300) {
        self.headerBgView.alpha = 1.0;
    } else if (scrollView.contentOffset.y < 300 && scrollView.contentOffset.y >= 0) {
        self.headerBgView.alpha = scrollView.contentOffset.y/300.0;
    } else {
        self.headerBgView.alpha = 0.0;
    }
}

#pragma mark - Lazy

- (BaseHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[BaseHeaderView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, (SCREEN_WIDTH - 40)/5.1 * 2 + 285)];
        _headerView.delegate = self;
    }
    
    return _headerView;
}

#pragma mark - Touch Method

- (IBAction)touchLocationMethod:(UIButton *)sender {
    TXSelectCityController *vwcCity = [TXSelectCityController new];
    weakSelf(self);
    vwcCity.block = ^(NSString *cityName) {
        weakSelf.cityLabel.text = cityName;
        [weakSelf.locationManager geocodeAddressToLocation:cityName];
        AMapDistrictSearchRequest *dist = [[AMapDistrictSearchRequest alloc] init];
        dist.keywords = cityName;
        [weakSelf.searchAPI AMapDistrictSearch:dist];
    };
    [self.navigationController pushViewController:vwcCity animated:true];
}

- (IBAction)touchQRCodeMethod:(id)sender {
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        SGQRCodeScanningVC *vc = [[SGQRCodeScanningVC alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                    // 用户第一次同意了访问相机权限
                    NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    
                } else {
                    // 用户第一次拒绝了访问相机权限
                    NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            SGQRCodeScanningVC *vc = [[SGQRCodeScanningVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
            
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
        }
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

- (IBAction)touchSearchMethod:(id)sender {
    DTSearchResultViewController *vwcSearch = [[DTSearchResultViewController alloc] initWithNibName:NSStringFromClass([DTSearchResultViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vwcSearch animated:true];
}

#pragma mark - BaseHeaderViewDelegate

- (void)selectPhotoScrollViewWithIndex:(NSInteger)index {
    DTBannerModel *model = self.bannersArray[index];
    TXShowWebViewController *vwcWeb = [TXShowWebViewController new];
    vwcWeb.webViewUrl = model.url;
    vwcWeb.naviTitle = model.name;
    [self.navigationController pushViewController:vwcWeb animated:true];
}

- (void)selectTitleScrollViewWithIndex:(NSInteger)index {
    // TODO: selectTitleScrollViewWithIndex
    DTScrollTitleModel *model = self.titlesArray[index];
}

- (void)selectCollectionItemWithIndex:(NSInteger)index {
    DTFirstCategoryModel *model = self.firstCategoryArray[index];
    DTSubCategoryViewController *vwcSearch = [[DTSubCategoryViewController alloc] initWithNibName:NSStringFromClass([DTSubCategoryViewController class]) bundle:[NSBundle mainBundle]];
    vwcSearch.firstCategoryId = model.idField;
    [self.navigationController pushViewController:vwcSearch animated:true];
}

#pragma mark - Location


#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
//    NSLog(@"Error: %@ ", error);
}

- (void)onDistrictSearchDone:(AMapDistrictSearchRequest *)request response:(AMapDistrictSearchResponse *)response
{
//    NSLog(@"response: %@", response.formattedDescription);
    for (AMapDistrict *dictrict in response.districts) {
//        NSLog(@"...%@", dictrict.name);
        if ([self.cityName isEqualToString:dictrict.name]) {
            for (AMapDistrict *obj in dictrict.districts) {
//                NSLog(@"+++%@", obj.name);
                [self.cityArray addObject:obj.name];
            }
            for (int i = 0; i < self.cityArray.count; i++) {
                AMapDistrictSearchRequest *dist = [[AMapDistrictSearchRequest alloc] init];
                dist.keywords = self.cityArray[i];
                [self.searchAPI AMapDistrictSearch:dist];
            }
        } else {
            NSMutableArray *subArray = [NSMutableArray new];
            for (AMapDistrict *obj in dictrict.districts) {
//                NSLog(@"+++%@", obj.name);
                [subArray addObject:obj.name];
            }
            [self.cityDictionary setValue:subArray forKey:dictrict.name];
        }
    }
//    NSLog(@"self.cityDictionary = %@", self.cityDictionary);
    [self configCityDistrict];
}

- (void)configCityDistrict {
    NSArray *allKeys = self.cityDictionary.allKeys;
    
    NSMutableArray *allArea = [NSMutableArray new];
    
    for (NSString *key in allKeys) {
        CDZPickerComponentObject *area = [[CDZPickerComponentObject alloc] initWithText:key];
        
        NSArray *subArea = [self.cityDictionary objectForKey:key];
        
        NSMutableArray *subArray = [NSMutableArray new];
        for (NSString *subName in subArea) {
            CDZPickerComponentObject *subObj = [[CDZPickerComponentObject alloc] initWithText:subName];
            [subArray addObject:subObj];
        }
        
        area.subArray = [NSMutableArray arrayWithArray:[self orderArrayWithArray:subArray]];
        [allArea addObject:area];
    }
    [AppDelegate sharedAppDelegate].cityDistrictArray = [self orderArrayWithArray:allArea];
    
    // 添加附近
    CDZPickerComponentObject *areaNear = [[CDZPickerComponentObject alloc] initWithText:@"附近"];
    NSMutableArray *areaNearArray = [NSMutableArray new];
    for (NSString *subName in @[@"1km", @"3km", @"5km"]) {
        CDZPickerComponentObject *subObj = [[CDZPickerComponentObject alloc] initWithText:subName];
        [areaNearArray addObject:subObj];
    }
    areaNear.subArray = areaNearArray;
    [[AppDelegate sharedAppDelegate].cityDistrictArray insertObject:areaNear atIndex:0];
    
    // 添加全城
    CDZPickerComponentObject *area = [[CDZPickerComponentObject alloc] initWithText:@"全城"];
    CDZPickerComponentObject *subObj = [[CDZPickerComponentObject alloc] initWithText:@"全城"];
    area.subArray = [NSMutableArray arrayWithArray:@[subObj]];
    [[AppDelegate sharedAppDelegate].cityDistrictArray insertObject:area atIndex:0];
}

- (NSMutableArray *)orderArrayWithArray:(NSMutableArray *)array {
    NSArray *result = [array sortedArrayUsingComparator:^NSComparisonResult(CDZPickerComponentObject *obj1, CDZPickerComponentObject *obj2) {
        return [obj2.text compare:obj1.text]; //升序
    }];
    
    return [NSMutableArray arrayWithArray:result];
}


@end
