//
//  DTPaySuccessViewController.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/13.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTPaySuccessViewController.h"
#import "DTRedPacketViewController.h"

@interface DTPaySuccessViewController ()

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@end

@implementation DTPaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"付款成功";
    self.doneBtn.layer.cornerRadius = 24.5;
    self.doneBtn.layer.masksToBounds = true;
    self.doneBtn.layer.borderWidth = 1;
    self.doneBtn.layer.borderColor = RGB(246, 30, 46).CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchDoneBtn:(id)sender {
//    DTRedPacketViewController *vwcSearch = [[DTRedPacketViewController alloc] initWithNibName:NSStringFromClass([DTRedPacketViewController class]) bundle:[NSBundle mainBundle]];
//    [self.navigationController pushViewController:vwcSearch animated:true];
    [self.navigationController popToRootViewControllerAnimated:true];
}


@end
