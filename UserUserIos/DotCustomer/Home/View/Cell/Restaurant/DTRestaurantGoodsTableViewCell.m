//
//  DTRestaurantGoodsTableViewCell.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/10.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTRestaurantGoodsTableViewCell.h"
#import "DTRestaurantCategoryTableViewCell.h"
#import "DTRestaurantDetailGoodsTableViewCell.h"

@interface DTRestaurantGoodsTableViewCell () <UITableViewDataSource, UITableViewDelegate, DTRestaurantDetailGoodsTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UITableView *goodsTableView;
/** <#description#> */
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation DTRestaurantGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.categoryTableView.delegate = self;
    self.categoryTableView.dataSource = self;
    
    self.goodsTableView.delegate = self;
    self.goodsTableView.dataSource = self;
    
    self.selectedIndex = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(DTRestaurantModel *)model {
    _model = model;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.categoryTableView) {
        return self.model.typeList.count;
    } else {
        DTTypeListModel *listModel = self.model.typeList[self.selectedIndex];
        return listModel.list.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXSeperateLineCell *defaultCell = nil;
    
    if (self.categoryTableView == tableView) {
        DTRestaurantCategoryTableViewCell *cell = [DTRestaurantCategoryTableViewCell cellWithTableView:tableView];
        if (indexPath.row == self.selectedIndex) {
            cell.contentView.backgroundColor = [UIColor whiteColor];
        } else {
            cell.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        }
        cell.cellLineType = TXCellSeperateLinePositionType_None;
        
        DTTypeListModel *listModel = self.model.typeList[indexPath.row];
        cell.categoryLabel.text = listModel.name;
        defaultCell = cell;
    } else {
        DTRestaurantDetailGoodsTableViewCell *cell = [DTRestaurantDetailGoodsTableViewCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.cellLineType = TXCellSeperateLinePositionType_Single;
        cell.cellLineRightMargin = TXCellRightMarginType12;
        
        DTTypeListModel *listModel = self.model.typeList[self.selectedIndex];
        DTTypeModel *model = listModel.list[indexPath.row];
        cell.model = model;
        defaultCell = cell;
    }
    return defaultCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.categoryTableView) {
        return 48.0;
    } else {
        return 120.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.categoryTableView == tableView) {
        self.selectedIndex = indexPath.row;
        [self.categoryTableView reloadData];
        [self.goodsTableView reloadData];
    } else {
        DTTypeListModel *listModel = self.model.typeList[self.selectedIndex];
        DTTypeModel *model = listModel.list[indexPath.row];
        if ([self.delegate respondsToSelector:@selector(touchGoodsDetailCellWithModel:)]) {
            [self.delegate touchGoodsDetailCellWithModel:model];
        }
    }
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"DTRestaurantGoodsTableViewCell";
    DTRestaurantGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

#pragma mark - DTRestaurantDetailGoodsTableViewCellDelegate

- (void)touchAddGoodsButtonWithModel:(DTTypeModel *)model {
    if ([self.delegate respondsToSelector:@selector(touchGoodsDetailAddButtonWithModel:)]) {
        [self.delegate touchGoodsDetailAddButtonWithModel:model];
    }
}

@end
