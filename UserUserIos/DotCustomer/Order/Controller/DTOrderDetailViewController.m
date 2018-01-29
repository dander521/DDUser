//
//  DTOrderDetailViewController.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/14.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTOrderDetailViewController.h"
#import "DTOrderDetailTableViewCell.h"
#import "DTOrderRemindTableViewCell.h"
#import "DTOrderFooterView.h"

@interface DTOrderDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** <#description#> */
@property (nonatomic, strong) UITextView *remarkTX;
@end

@implementation DTOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listModel.list.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.listModel.list.count == indexPath.row) {
        DTOrderRemindTableViewCell *cell = [DTOrderRemindTableViewCell cellWithTableView:tableView];
        cell.cellLineType = TXCellSeperateLinePositionType_Single;
        cell.cellLineRightMargin = TXCellRightMarginType12;
        cell.contentTX.text = self.listModel.remark;
        cell.contentTX.editable = false;
        return cell;
    } else {
        DTOrderDetailTableViewCell *cell = [DTOrderDetailTableViewCell cellWithTableView:tableView];
        cell.cellLineType = TXCellSeperateLinePositionType_Single;
        cell.cellLineRightMargin = TXCellRightMarginType12;
        cell.orderType = self.listModel.orderType;
        cell.model = self.listModel.list[indexPath.row];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    DTOrderFooterView *footer = [DTOrderFooterView instanceView];
    footer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50.0);
    footer.priceLabel.text = [NSString stringWithFormat:@"%.2f", [self.listModel.orderPrice floatValue]];
    return footer;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *shopName = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 30, 20)];
    shopName.text = self.listModel.shopName;
    shopName.textColor = RGB(246, 30, 46);
    shopName.font = FONT(16);
    [headerView addSubview:shopName];
    
    UILabel *subLine = [[UILabel alloc] initWithFrame:CGRectMake(15, 49.5, SCREEN_WIDTH - 15, 0.5)];
    subLine.backgroundColor = RGBA(0, 0, 0, 0.1);
    [headerView addSubview:subLine];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50.0;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listModel.list.count == indexPath.row) {
        return 100.0;
    }
    return 83.0;
}

@end
