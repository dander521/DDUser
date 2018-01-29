//
//  DTDiscountCouponViewController.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/10.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTDiscountCouponViewController.h"
#import "DTPayTicketViewController.h"

@interface DTDiscountCouponViewController ()
@property (weak, nonatomic) IBOutlet UIButton *fiftyBtn;
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@end

@implementation DTDiscountCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"优惠券";
    
    self.fiftyBtn.layer.cornerRadius = 25.0;
    self.fiftyBtn.layer.masksToBounds = true;
    self.fiftyBtn.layer.borderWidth = 1.0;
    self.fiftyBtn.layer.borderColor = RGB(246, 30, 46).CGColor;
    
    self.oneBtn.layer.cornerRadius = 25.0;
    self.oneBtn.layer.masksToBounds = true;
    self.oneBtn.layer.borderWidth = 1.0;
    self.oneBtn.layer.borderColor = RGB(246, 30, 46).CGColor;
    
    self.twoBtn.layer.cornerRadius = 25.0;
    self.twoBtn.layer.masksToBounds = true;
    self.twoBtn.layer.borderWidth = 1.0;
    self.twoBtn.layer.borderColor = RGB(246, 30, 46).CGColor;
    
    self.threeBtn.layer.cornerRadius = 25.0;
    self.threeBtn.layer.masksToBounds = true;
    self.threeBtn.layer.borderWidth = 1.0;
    self.threeBtn.layer.borderColor = RGB(246, 30, 46).CGColor;
    
    self.buyBtn.layer.cornerRadius = 25.0;
    self.buyBtn.layer.masksToBounds = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchBtns:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            self.fiftyBtn.backgroundColor = RGB(246, 30, 46);
            [self.fiftyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.oneBtn.backgroundColor = [UIColor whiteColor];
            [self.oneBtn setTitleColor:RGB(246, 30, 46) forState:UIControlStateNormal];
            self.twoBtn.backgroundColor = [UIColor whiteColor];
            [self.twoBtn setTitleColor:RGB(246, 30, 46) forState:UIControlStateNormal];
            self.threeBtn.backgroundColor = [UIColor whiteColor];
            [self.threeBtn setTitleColor:RGB(246, 30, 46) forState:UIControlStateNormal];
            
        }
            break;
            
        case 2:
        {
            self.oneBtn.backgroundColor = RGB(246, 30, 46);
            [self.oneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.fiftyBtn.backgroundColor = [UIColor whiteColor];
            [self.fiftyBtn setTitleColor:RGB(246, 30, 46) forState:UIControlStateNormal];
            self.twoBtn.backgroundColor = [UIColor whiteColor];
            [self.twoBtn setTitleColor:RGB(246, 30, 46) forState:UIControlStateNormal];
            self.threeBtn.backgroundColor = [UIColor whiteColor];
            [self.threeBtn setTitleColor:RGB(246, 30, 46) forState:UIControlStateNormal];
        }
            break;
            
        case 3:
        {
            self.twoBtn.backgroundColor = RGB(246, 30, 46);
            [self.twoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.oneBtn.backgroundColor = [UIColor whiteColor];
            [self.oneBtn setTitleColor:RGB(246, 30, 46) forState:UIControlStateNormal];
            self.fiftyBtn.backgroundColor = [UIColor whiteColor];
            [self.fiftyBtn setTitleColor:RGB(246, 30, 46) forState:UIControlStateNormal];
            self.threeBtn.backgroundColor = [UIColor whiteColor];
            [self.threeBtn setTitleColor:RGB(246, 30, 46) forState:UIControlStateNormal];
        }
            break;
            
        case 4:
        {
            self.threeBtn.backgroundColor = RGB(246, 30, 46);
            [self.threeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.oneBtn.backgroundColor = [UIColor whiteColor];
            [self.oneBtn setTitleColor:RGB(246, 30, 46) forState:UIControlStateNormal];
            self.twoBtn.backgroundColor = [UIColor whiteColor];
            [self.twoBtn setTitleColor:RGB(246, 30, 46) forState:UIControlStateNormal];
            self.fiftyBtn.backgroundColor = [UIColor whiteColor];
            [self.fiftyBtn setTitleColor:RGB(246, 30, 46) forState:UIControlStateNormal];
        }
            break;
            
        case 5:
        {
            DTPayTicketViewController *vwcSearch = [[DTPayTicketViewController alloc] initWithNibName:NSStringFromClass([DTPayTicketViewController class]) bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:vwcSearch animated:true];
        }
            break;
            
        default:
            break;
    }
}


@end
