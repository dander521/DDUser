//
//  TXSelectCityController.h
//  TailorX
//
//  Created by Qian Shen on 12/5/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXCityModel.h"

typedef void (^sureBlock)(NSString *cityName);

@interface TXSelectCityController : UIViewController

/** blcok变量*/
@property (nonatomic, copy) sureBlock block;

@end
