//
//  DTGoodsDetailViewController.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/10.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTRestaurantGoodsDetailViewController.h"
#import "DTAllCommentsViewController.h"
#import "DTPayOrderViewController.h"
#import "SDCycleScrollView.h"
#import "DTGoodsDetailCartTableViewCell.h"
#import "DTGoodsDetailsTableViewCell.h"
#import "DTGoodsDescTableViewCell.h"
#import "DTGoodsCommentTableViewCell.h"
#import "DTRestaurantSectionView.h"
#import "DTShoppingCartView.h"
#import "DTSingleCartView.h"
#import "DTGoodsModel.h"
#import "DTCommentModel.h"

@interface DTRestaurantGoodsDetailViewController () <SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, DTRestaurantSectionViewDelegate, DTGoodsDetailCartTableViewCellDelegate, DTSingleCartViewDelegate, DTShoppingCartViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SDCycleScrollView *headerView;
@property (strong, nonatomic) DTShoppingCartView *shoppingView;
@property (strong, nonatomic) DTSingleCartView *singleShoppingView;

/** <#description#> */
@property (nonatomic, strong) DTGoodsModel *model;

/** <#description#> */
@property (nonatomic, strong) NSMutableArray *sourceArray;

@end

@implementation DTRestaurantGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.estimatedRowHeight = 80.0;
    self.tableView.estimatedSectionFooterHeight = 10.0;
    self.tableView.estimatedSectionHeaderHeight = 46.0;
    adjustsScrollViewInsets_NO(self.tableView, self);
    
    self.sourceArray = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodsDataChange) name:kNotificationGoodsDataChange object:nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadData];
    [self loadCommentData];
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
    [self.tableView reloadData];
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
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:goodsDetail] headParams:nil bodyParams:@{@"productId" : self.typeModel.idField} success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"status"] integerValue] == 1) {
            [ShowMessage showMessage:responseObject[@"msg"]];
            self.model = [DTGoodsModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            [self.tableView reloadData];
            
            if (![NSString isTextEmpty:self.model.img]) {
                NSArray *imageArray = [self.model.img componentsSeparatedByString:@","];
                NSMutableArray *urlsArray = [NSMutableArray new];
                for (NSString *str in imageArray) {
                    [urlsArray addObject:[imageHost stringByAppendingPathComponent:str]];
                }
                self.headerView.imageURLStringsGroup = urlsArray;
            } else {
                self.headerView.imageURLStringsGroup = @[[imageHost stringByAppendingPathComponent:self.model.img]];
            }
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [ShowMessage showMessage:error.description];
    }];
}

- (void)loadCommentData {
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:goodsCommentInfo] headParams:nil bodyParams:@{@"page": @"1", @"pageSize": @"10", @"shopId" : self.shopId} success:^(AFHTTPSessionManager *operation, id responseObject) {
        // TODO: 排查评论返回
        if ([responseObject[@"status"] integerValue] == 1) {
            [ShowMessage showMessage:responseObject[@"msg"]];
            DTCommentCollectionModel *colloectionModel = [DTCommentCollectionModel mj_objectWithKeyValues:responseObject[@"data"]];
            [self.sourceArray addObjectsFromArray:colloectionModel.list];
            [self.tableView reloadData];
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return self.model.descs.count;
    } else {
        return self.sourceArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXSeperateLineCell *defaultCell = nil;
    if (indexPath.section == 0) {
        DTGoodsDetailCartTableViewCell *cell = [DTGoodsDetailCartTableViewCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.goodsModel = self.model;
        cell.typeModel = self.typeModel;
        
        cell.isHiddenBuyLabel = [self.cartObjectArray containsObject:self.typeModel] ? true : false;
        NSInteger modelCount = [[self.cartObjectDictionary objectForKey:self.typeModel.idField] integerValue];
        cell.countLabel.text = [NSString stringWithFormat:@"%zd", modelCount];
        defaultCell = cell;
    } else if (indexPath.section == 1) {
        DTGoodsDetailsTableViewCell *cell = [DTGoodsDetailsTableViewCell cellWithTableView:tableView];
        cell.detailsLabel.text = self.model.details;
        return cell;
    } else if (indexPath.section == 2) {
        DTGoodsDescTableViewCell *cell = [DTGoodsDescTableViewCell cellWithTableView:tableView];
        if (self.model.descs.count >= indexPath.row) {
            cell.model = self.model.descs[indexPath.row];
        }
        return cell;
    } else {
        DTGoodsCommentTableViewCell *cell = [DTGoodsCommentTableViewCell cellWithTableView:tableView];
        cell.cellLineType = TXCellSeperateLinePositionType_Single;
        cell.cellLineRightMargin = TXCellRightMarginType12;
        cell.model = self.sourceArray[indexPath.row];
        defaultCell = cell;
    }
    
    return defaultCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 2) {
        return 10.0;
    } else {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 46.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 46)];
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 10, 46)];
        descLabel.text = @"商品描述";
        descLabel.textColor = RGB(46, 46, 46);
        descLabel.font = FONT(16);
        [header addSubview:descLabel];
        return header;
    } else if (section == 2) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 46)];
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 10, 46)];
        descLabel.text = @"商品规格";
        descLabel.textColor = RGB(46, 46, 46);
        descLabel.font = FONT(16);
        [header addSubview:descLabel];
        return header;
    } else if (section == 3) {
        DTRestaurantSectionView *headerView = [DTRestaurantSectionView instanceView];
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 46);
        headerView.delegate = self;
        return headerView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return 46;
    } else {
        return UITableViewAutomaticDimension;
    }
}

#pragma mark - DTGoodsDetailCartTableViewCellDelegate

- (void)touchAddToCartButtonWithModel:(DTTypeModel *)model {
    if (!self.singleShoppingView) {
        self.singleShoppingView = [DTSingleCartView shareInstanceManager];
        self.singleShoppingView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 70);
        self.singleShoppingView.delegate = self;
        [self.singleShoppingView showInView:self.view];
    }
    
    [self.cartObjectDictionary setValue:@"1" forKey:model.idField];
    [self.cartObjectArray addObject:model];
    
    DTGoodsDetailCartTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.isHiddenBuyLabel = true;
    [self.tableView reloadData];
    
    self.singleShoppingView.cartObjectDictionary = self.cartObjectDictionary;
    self.singleShoppingView.cartObjectArray = self.cartObjectArray;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGoodsDataChange object:nil userInfo:nil];
}

- (void)touchPlusToCartButtonWithModel:(DTTypeModel *)model {
    if (!self.singleShoppingView) {
        self.singleShoppingView = [DTSingleCartView shareInstanceManager];
        self.singleShoppingView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 70);
        self.singleShoppingView.delegate = self;
        [self.singleShoppingView showInView:self.view];
    }
    
    NSInteger modelCount = [[self.cartObjectDictionary objectForKey:model.idField] integerValue];
    modelCount += 1;
    [self.cartObjectDictionary setValue:[NSString stringWithFormat:@"%zd", modelCount]  forKey:model.idField];
    
    [self.tableView reloadData];
    
    self.singleShoppingView.cartObjectDictionary = self.cartObjectDictionary;
    self.singleShoppingView.cartObjectArray = self.cartObjectArray;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGoodsDataChange object:nil userInfo:nil];
}

- (void)touchMinusToCartButtonWithModel:(DTTypeModel *)model {
    if (!self.singleShoppingView) {
        self.singleShoppingView = [DTSingleCartView shareInstanceManager];
        self.singleShoppingView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 70);
        self.singleShoppingView.delegate = self;
        [self.singleShoppingView showInView:self.view];
    }
    
    NSInteger modelCount = [[self.cartObjectDictionary objectForKey:model.idField] integerValue];
    modelCount -= 1;
    if (modelCount == 0) {
        [self.cartObjectDictionary removeObjectForKey:model.idField];
        if ([self.cartObjectArray containsObject:model]) {
            [self.cartObjectArray removeObject:model];
        }
        DTGoodsDetailCartTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.isHiddenBuyLabel = true;
    } else {
        [self.cartObjectDictionary setValue:[NSString stringWithFormat:@"%zd", modelCount]  forKey:model.idField];
    }
    
    [self.tableView reloadData];
    
    self.singleShoppingView.cartObjectDictionary = self.cartObjectDictionary;
    self.singleShoppingView.cartObjectArray = self.cartObjectArray;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGoodsDataChange object:nil userInfo:nil];
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

#pragma mark - SDCycleScrollViewDelegate

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"index = %zd", index);
    if ([NSString isTextEmpty:self.model.img]) {
        return;
    }
    NSArray *imageArray = [self.model.img componentsSeparatedByString:@","];
    NSMutableArray *urlsArray = [NSMutableArray new];
    for (NSString *str in imageArray) {
        [urlsArray addObject:[imageHost stringByAppendingPathComponent:str]];
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

#pragma mark - DTRestaurantSectionViewDelegate

- (void)touchAllCommentsButton {
    DTAllCommentsViewController *vwcSearch = [[DTAllCommentsViewController alloc] initWithNibName:NSStringFromClass([DTAllCommentsViewController class]) bundle:[NSBundle mainBundle]];
    vwcSearch.productId = self.shopId;
    [self.navigationController pushViewController:vwcSearch animated:true];
}

#pragma mark - Touch Method

- (IBAction)touchBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - NetErrorViewDelegate

- (void)reloadDataNetErrorView:(NetErrorView *)errorView {
    [self loadData];
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

@end
