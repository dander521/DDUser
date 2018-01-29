//
//  DTSubCategoryViewController.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/30.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTSubCategoryViewController.h"
#import "DTSearchResultViewController.h"
#import "DTRestaurantViewController.h"
#import "DTSubCategoryStoreViewController.h"
#import "DTHomeTableViewCell.h"
#import "DTSubCategoryHeader.h"
#import "DTCategorySectionView.h"
#import "DTBannerModel.h"
#import "DTMerchantListModel.h"
#import "DTFirstCategoryModel.h"
#import "TXShowWebViewController.h"
#import "DTAutoModel.h"

@interface DTSubCategoryViewController () <UITableViewDelegate, UITableViewDataSource, DTSubCategoryHeaderDelegate, DTCategorySectionViewDelegate, RCTableViewDelegate, NetErrorViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerBgView;

/** <#description#> */
@property (nonatomic, strong) DTCategorySectionView *sectionHeader;
@property (strong, nonatomic) DTSubCategoryHeader *headerView;
/** 分页数 */
@property (nonatomic, assign) NSInteger page;
/** 分页请求条数 */
@property (nonatomic, assign) NSInteger pageSize;
/** 返回数据条数 */
@property (nonatomic, assign) NSInteger dataCount;
/** 数据源集合 */
@property (nonatomic, strong) NSMutableArray *sourceArray;

@property (nonatomic, strong) NSMutableArray *bannersArray;
@property (nonatomic, strong) NSMutableArray *secondCategoryArray;

@property (nonatomic, strong) NSString *areaName;
@property (nonatomic, strong) NSString *coutyName;
@property (nonatomic, strong) NSString *searchType;
@property (nonatomic, strong) NSString *nearDistance;
@property (nonatomic, strong) DTAutoModel *autoModel;
@property (nonatomic, strong) DTFirstCategoryModel *firstCategoryModel;

@property (nonatomic, strong) NSString *categoryTitle;
@property (nonatomic, strong) NSString *locationTitle;
@property (nonatomic, strong) NSString *autoTitle;

@property (nonatomic, assign) BOOL isCategoryRed;
@property (nonatomic, assign) BOOL isLocationRed;
@property (nonatomic, assign) BOOL isAutoRed;
@property (nonatomic, assign) BOOL isLoadNew;

@end

@implementation DTSubCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoadNew = false;
    self.tableView.estimatedSectionHeaderHeight = 44;
    self.headerBgView.hidden = false;
    self.tableView.tableHeaderView = self.headerView;
    adjustsScrollViewInsets_NO(self.tableView, self);
    self.sourceArray = [NSMutableArray new];
    self.bannersArray = [NSMutableArray new];
    self.secondCategoryArray = [NSMutableArray new];
    
    self.firstCategoryModel = [DTFirstCategoryModel new];
    self.firstCategoryModel.idField = self.firstCategoryId;
    self.autoModel = [DTAutoModel new];
    self.autoModel.autoId = @"3";
    self.searchType = @"3";
    self.nearDistance = @"0";
    self.coutyName = @"";
    self.areaName = @"";
    
    self.categoryTitle = @"全部分类";
    self.locationTitle = @"全城";
    self.autoTitle = @"红包排序";
    self.isCategoryRed = false;
    self.isLocationRed = false;
    self.isAutoRed = false;
    
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
    [self loadSecondCategoryData];
    [self loadData];
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

        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
    }];
}

- (void)loadSecondCategoryData {
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:secondCategory] headParams:nil bodyParams:@{@"typeId" : self.firstCategoryId} success:^(AFHTTPSessionManager *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            [ShowMessage showMessage:responseObject[@"msg"]];
            DTFirstCategoryCollectionModel *colloectionModel = [DTFirstCategoryCollectionModel mj_objectWithKeyValues:responseObject];
            self.secondCategoryArray = [NSMutableArray arrayWithArray:colloectionModel.data];
            self.headerView.collectionViewData = self.secondCategoryArray;
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
    [params setValue:self.firstCategoryModel.idField forKey:@"typeId"];
    [params setValue:[NSString stringWithFormat:@"%zd", self.page] forKey:@"page"];
    [params setValue:[NSString stringWithFormat:@"%zd", self.pageSize] forKey:@"pageSize"];
    [params setValue:@"0" forKey:@"twoTypeId"];
    [params setValue:self.autoModel.autoId forKey:@"seachType"];
    [params setValue:self.nearDistance forKey:@"nearDistance"];
    [params setValue:self.areaName forKey:@"city"];
    [params setValue:self.coutyName forKey:@"area"];
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:merchantList] headParams:nil bodyParams:params success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"status"] integerValue] == 1) {
            _page += 1;
            if (self.isLoadNew) {
                [self.sourceArray removeAllObjects];
                self.isLoadNew = false;
            }
            [ShowMessage showMessage:responseObject[@"msg"]];
            DTMerchantListCollectionModel *colloectionModel = [DTMerchantListCollectionModel mj_objectWithKeyValues:responseObject[@"data"]];
            _dataCount = colloectionModel.list.count;
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


#pragma mark - UITableViewDataSource

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

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 64.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.sectionHeader = [DTCategorySectionView instanceView];
    self.sectionHeader.delegate = self;
    self.sectionHeader.allCategoryLabel.text = self.categoryTitle;
    self.sectionHeader.locationLabel.text = self.locationTitle;
    self.sectionHeader.autoLabel.text = self.autoTitle;
    
    self.sectionHeader.allCategoryLabel.textColor = self.isCategoryRed ? RGB(246, 30, 46) : RGB(46, 46, 46);
    self.sectionHeader.locationLabel.textColor = self.isLocationRed ? RGB(246, 30, 46) : RGB(46, 46, 46);
    self.sectionHeader.autoLabel.textColor = self.isAutoRed ? RGB(246, 30, 46) : RGB(46, 46, 46);
    
    return self.sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DTMerchantListModel *model =self.sourceArray[indexPath.row];
    DTRestaurantViewController *vwcSearch = [[DTRestaurantViewController alloc] initWithNibName:NSStringFromClass([DTRestaurantViewController class]) bundle:[NSBundle mainBundle]];
    vwcSearch.shopId = model.idField;
    [self.navigationController pushViewController:vwcSearch animated:true];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > (SCREEN_WIDTH - 40)/5 * 2 + 200) {
        self.headerBgView.hidden = true;
    } else {
        self.headerBgView.hidden = false;
    }
}

#pragma mark - Lazy

- (DTSubCategoryHeader *)headerView {
    if (!_headerView) {
        _headerView = [[DTSubCategoryHeader alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH - 40)/5.1 * 2 + 220)];
        _headerView.delegate = self;
    }
    
    return _headerView;
}


#pragma mark - Touch Method

- (IBAction)touchBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)touchSearchBtn:(id)sender {
    DTSearchResultViewController *vwcSearch = [[DTSearchResultViewController alloc] initWithNibName:NSStringFromClass([DTSearchResultViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vwcSearch animated:true];
}


#pragma mark - DTSubCategoryHeaderDelegate

- (void)selectPhotoScrollViewWithIndex:(NSInteger)index {
    DTBannerModel *model = self.bannersArray[index];
    TXShowWebViewController *vwcWeb = [TXShowWebViewController new];
    vwcWeb.webViewUrl = model.url;
    vwcWeb.naviTitle = model.name;
    [self.navigationController pushViewController:vwcWeb animated:true];
}

- (void)selectCollectionItemWithIndex:(NSInteger)index {
    DTFirstCategoryModel *model = self.secondCategoryArray[index];
    DTSubCategoryStoreViewController *vwcSearch = [[DTSubCategoryStoreViewController alloc] initWithNibName:NSStringFromClass([DTSubCategoryStoreViewController class]) bundle:[NSBundle mainBundle]];
    vwcSearch.firstTypeId = self.firstCategoryModel.idField;
    vwcSearch.secondTypeId = model.idField;
    vwcSearch.titleName = model.name;
    [self.navigationController pushViewController:vwcSearch animated:true];
}

#pragma mark - DTCategorySectionViewDelegate

- (void)touchAllCategoryButton {
    RCTableView *instanceView = [RCTableView shareInstanceManagerWithType:0];
    instanceView.delegate = self;
    [instanceView show];
}

- (void)touchLocationButton {
    RCTableView *instanceView = [RCTableView shareInstanceManagerWithType:1];
    instanceView.delegate = self;
    [instanceView show];
}

- (void)touchRedPacketButton {
    NSLog(@"touchRedPacketButton");
    RCTableView *instanceView = [RCTableView shareInstanceManagerWithType:2];
    instanceView.delegate = self;
    [instanceView show];
}

#pragma mark - RCTableViewDelegate

- (void)touchTableWithType:(RCTableViewType)tableType content:(NSArray *)content {
    
    if (tableType == RCTableViewTypeAllCategory) {
        self.firstCategoryModel = content.firstObject;
        self.categoryTitle = self.firstCategoryModel.name;
        self.isCategoryRed = true;
    } else if (tableType == RCTableViewTypeAllLocation && content.count == 2) {
        CDZPickerComponentObject *object = content.firstObject;
        CDZPickerComponentObject *objectLast = content.lastObject;
        if ([object.text isEqualToString:@"全城"]) {
            self.areaName = @"";
            self.coutyName = @"";
            self.locationTitle = @"全城";
        } else if ([object.text isEqualToString:@"附近"]) {
            self.searchType = @"3";
            if ([objectLast.text isEqualToString:@"1km"]) {
                self.nearDistance = @"1";
            } else if ([objectLast.text isEqualToString:@"3km"]) {
                self.nearDistance = @"3";
            } else {
                self.nearDistance = @"5";
            }
            self.locationTitle = @"附近";
        } else {
            self.areaName = object.text;
            self.coutyName = objectLast.text;
            self.locationTitle = object.text;
        }
        self.isLocationRed = true;
    } else if (tableType == RCTableViewTypeAuto) {
        self.autoModel = content.firstObject;
        self.autoTitle = self.autoModel.autoName;
        self.isAutoRed = true;
    }
    
    [self loadNewData];
}


@end
