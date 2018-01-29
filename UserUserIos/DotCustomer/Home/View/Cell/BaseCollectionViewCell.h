//
//  BaseCollectionViewCell.h
//  RCController
//
//  Created by 程荣刚 on 2017/9/22.
//  Copyright © 2017年 程荣刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end
