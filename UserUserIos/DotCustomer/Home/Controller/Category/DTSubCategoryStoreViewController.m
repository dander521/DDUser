//
//  DTSubCategoryStoreViewController.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/16.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTSubCategoryStoreViewController.h"
#import "DTRestaurantViewController.h"
#import "DTHomeTableViewCell.h"
#import "DTCategorySectionView.h"
#import "DTMerchantListModel.h"
#import "DTFirstCategoryModel.h"
#import "DTAutoModel.h"

@interface DTSubCategoryStoreViewController () <UITableViewDelegate, UITableViewDataSource, DTCategorySectionViewDelegate, RCTableViewDelegate, NetErrorViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *headBgView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** <#description#> */
@property (nonatomic, strong) DTCategorySectionView *headerView;

/** 无数据提示页面 */
@property (nonatomic, strong) TXBlankView *blankView;
/** 分页数 */
@property (nonatomic, assign) NSInteger page;
/** 分页请求条数 */
@property (nonatomic, assign) NSInteger pageSize;
/** 返回数据条数 */
@property (nonatomic, assign) NSInteger dataCount;
/** 数据源集合 */
@property (nonatomic, strong) NSMutableArray *sourceArray;

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

@end

@implementation DTSubCategoryStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.titleName;
    adjustsScrollViewInsets_NO(self.tableView, self);
    [self.headBgView addSubview:self.headerView];
    
    self.firstCategoryModel = [DTFirstCategoryModel new];
    self.firstCategoryModel.idField = self.firstTypeId;
    self.autoModel = [DTAutoModel new];
    self.autoModel.autoId = @"0";
    self.searchType = @"1";
    self.nearDistance = @"0";
    
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
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request

- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:[TXModelAchivar getUserModel].longitude forKey:@"lon"];
    [params setValue:[TXModelAchivar getUserModel].latitude forKey:@"lat"];
    [params setValue:self.firstCategoryModel.idField forKey:@"typeId"];
    [params setValue:[NSString stringWithFormat:@"%zd", self.page] forKey:@"page"];
    [params setValue:[NSString stringWithFormat:@"%zd", self.pageSize] forKey:@"pageSize"];
    [params setValue:self.secondTypeId forKey:@"twoTypeId"];
    [params setValue:self.autoModel.autoId forKey:@"seachType"];
    [params setValue:self.nearDistance forKey:@"nearDistance"];
    [params setValue:self.areaName forKey:@"city"];
    [params setValue:self.coutyName forKey:@"area"];
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:merchantList] headParams:nil bodyParams:params success:^(AFHTTPSessionManager *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            _page += 1;
            [ShowMessage showMessage:responseObject[@"msg"]];
            DTMerchantListCollectionModel *colloectionModel = [DTMerchantListCollectionModel mj_objectWithKeyValues:responseObject[@"data"]];
            _dataCount = colloectionModel.list.count;
            if (_dataCount > 0) {
                [self.sourceArray addObjectsFromArray:colloectionModel.list];
            }
            if (self.sourceArray.count == 0) {
                [self showBlankView];
            } else {
                [self.blankView removeFromSuperview];
                if (_dataCount < _pageSize) {
                    [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                }
            }
            
            self.headerView.allCategoryLabel.text = self.categoryTitle;
            self.headerView.locationLabel.text = self.locationTitle;
            self.headerView.autoLabel.text = self.autoTitle;
            
            self.headerView.allCategoryLabel.textColor = self.isCategoryRed ? RGB(246, 30, 46) : RGB(46, 46, 46);
            self.headerView.locationLabel.textColor = self.isLocationRed ? RGB(246, 30, 46) : RGB(46, 46, 46);
            self.headerView.autoLabel.textColor = self.isAutoRed ? RGB(246, 30, 46) : RGB(46, 46, 46);
            
            [self.tableView reloadData];
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
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
    [self.sourceArray removeAllObjects];
    _page = 1;
    [self loadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - Custom

- (void)showBlankView {
    [self.view addSubview:self.blankView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DTHomeTableViewCell *cell = [DTHomeTableViewCell cellWithTableView:tableView];
    cell.cellLineType = TXCellSeperateLinePositionType_Single;
    cell.cellLineRightMargin = TXCellRightMarginType0;
    cell.cellType = DTHomeTableViewCellTypeHome;
    cell.merchantListModel = self.sourceArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DTMerchantListModel *model =self.sourceArray[indexPath.row];
    DTRestaurantViewController *vwcSearch = [[DTRestaurantViewController alloc] initWithNibName:NSStringFromClass([DTRestaurantViewController class]) bundle:[NSBundle mainBundle]];
    vwcSearch.shopId = model.idField;
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
            self.areaName = @"全城";
            self.coutyName = @"全城";
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

#pragma mark - Lazy

- (DTCategorySectionView *)headerView {
    if (!_headerView) {
        _headerView = [DTCategorySectionView instanceView];
        _headerView.delegate = self;
    }
    return _headerView;
}

/**
 空白页
 */
- (UIView *)blankView {
    if (nil == _blankView) {
        _blankView = [[TXBlankView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _blankView.backgroundColor = RGB(255, 255, 255);
        [_blankView createBlankViewWithImage:@"wudingdan"
                                       title:@"暂无"
                                    subTitle:nil];
    }
    
    return _blankView;
}


@end
