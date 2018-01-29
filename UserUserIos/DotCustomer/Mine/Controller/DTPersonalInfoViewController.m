//
//  DTPersonalInfoViewController.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/22.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTPersonalInfoViewController.h"
#import "DTPersonAvatarTableViewCell.h"

static NSString *cellId = @"cellId";

@interface DTPersonalInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DTPersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request

- (void)loadData {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:personalInfo]
                             headParams:param
                             bodyParams:nil
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                    [ShowMessage showMessage:responseObject[@"msg"]];
                                    if ([responseObject[@"status"] integerValue] == 1) {
                                        
                                        TXUserModel *model = [TXUserModel defaultUser];
                                        model = [model initWithDictionary:responseObject[@"data"]];
                                        [TXModelAchivar achiveUserModel];
                                        [self.tableView reloadData];
                                    }
                                }
                                failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                    [ShowMessage showMessage:error.description];
                                    [MBProgressHUD hideHUDForView:self.view];
                                }];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXSeperateLineCell *cellDefault = nil;
    
    if (indexPath.row == 0) {
        DTPersonAvatarTableViewCell *cell = [DTPersonAvatarTableViewCell cellWithTableView:tableView];
        NSLog(@"face = %@", [TXModelAchivar getUserModel].face)
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:[TXModelAchivar getUserModel].face]] placeholderImage:[UIImage imageNamed:@"user"]];
        cellDefault = cell;
    } else {
        TXSeperateLineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[TXSeperateLineCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        }
        
        if (indexPath.row == 1) {
            cell.textLabel.text = @"昵  称";
            cell.detailTextLabel.text = [TXModelAchivar getUserModel].nickName;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"手机号";
            cell.detailTextLabel.text = [TXModelAchivar getUserModel].account;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            cell.textLabel.text = @"性  别";
            cell.detailTextLabel.text = [[TXModelAchivar getUserModel].sex integerValue] == 1 ? @"男" : @"女";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cellDefault = cell;
    }
    
    cellDefault.cellLineType = TXCellSeperateLinePositionType_Single;
    cellDefault.cellLineRightMargin = TXCellRightMarginType0;
    
    return cellDefault;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 90;
    } else {
        return 58;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.row == 3) {
        [self touchChangeSexCell];
    }
    if (indexPath.row == 0) {
        [self showChangeAvatarActionSheet];
    }
    
    if (indexPath.row == 1) {
        [self touchChangeNicknameCell];
    }
}

- (void)touchChangeNicknameCell {
    UIAlertController *avatarAlert = [UIAlertController alertControllerWithTitle:@"修改昵称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    __weak __typeof(&*avatarAlert)weakAvatarAlert = avatarAlert;
    [avatarAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSLog(@"textField.text... = %@", textField.text);
    }];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"textField.text = %@", avatarAlert.textFields.firstObject.text);
        if ([NSString isTextEmpty:avatarAlert.textFields.firstObject.text]) {
            [ShowMessage showMessage:@"昵称不能为空"];
            return;
        }
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setValue:avatarAlert.textFields.firstObject.text forKey:@"nickName"];
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:setPersonalInfo]
                                  headParams:param
                                  bodyParams:dic
                                     success:^(AFHTTPSessionManager *operation, id responseObject) {
                                         [MBProgressHUD hideHUDForView:self.view];
                                         [ShowMessage showMessage:responseObject[@"msg"]];
                                         if ([responseObject[@"status"] integerValue] == 1) {
                                             
                                             [TXModelAchivar updateUserModelWithKey:@"nickName" value:avatarAlert.textFields.firstObject.text];
                                             [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginSuccess object:nil userInfo:nil];
                                             [self.tableView reloadData];
                                         }
                                     }
                                     failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                         [ShowMessage showMessage:error.description];
                                         [MBProgressHUD hideHUDForView:self.view];
                                     }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakAvatarAlert dismissViewControllerAnimated:true completion:nil];
    }];
    
    [TXCustomTools setActionTitleTextColor:RGB(46, 46, 46) action:sureAction];
    [TXCustomTools setActionTitleTextColor:RGB(0, 122, 255) action:cancelAction];
    
    [avatarAlert addAction:sureAction];
    [avatarAlert addAction:cancelAction];
    
    [self presentViewController:avatarAlert animated:true completion:nil];
}

- (void)touchChangeSexCell {
    UIAlertController *avatarAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak __typeof(&*avatarAlert)weakAvatarAlert = avatarAlert;
    UIAlertAction *maleAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setValue:@"1" forKey:@"sex"];
        
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:setPersonalInfo]
                                  headParams:param
                                  bodyParams:dic
                                     success:^(AFHTTPSessionManager *operation, id responseObject) {
                                         [MBProgressHUD hideHUDForView:self.view];
                                         [ShowMessage showMessage:responseObject[@"msg"]];
                                         if ([responseObject[@"status"] integerValue] == 1) {
                                             [TXModelAchivar updateUserModelWithKey:@"sex" value:@"1"];
                                             
                                             [self.tableView reloadData];
                                         }
                                     }
                                     failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                         [ShowMessage showMessage:error.description];
                                         [MBProgressHUD hideHUDForView:self.view];
                                     }];
    }];
    
    UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setValue:@"2" forKey:@"sex"];
        
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:setPersonalInfo]
                                  headParams:param
                                  bodyParams:dic
                                     success:^(AFHTTPSessionManager *operation, id responseObject) {
                                         [MBProgressHUD hideHUDForView:self.view];
                                         [ShowMessage showMessage:responseObject[@"msg"]];
                                         if ([responseObject[@"status"] integerValue] == 1) {
                                             [TXModelAchivar updateUserModelWithKey:@"sex" value:@"2"];
                                             [self.tableView reloadData];
                                         }
                                     }
                                     failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                         [ShowMessage showMessage:error.description];
                                         [MBProgressHUD hideHUDForView:self.view];
                                     }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakAvatarAlert dismissViewControllerAnimated:true completion:nil];
    }];
    
    [TXCustomTools setActionTitleTextColor:RGB(46, 46, 46) action:maleAction];
    [TXCustomTools setActionTitleTextColor:RGB(46, 46, 46) action:femaleAction];
    [TXCustomTools setActionTitleTextColor:RGB(0, 122, 255) action:cancelAction];
    
    [avatarAlert addAction:maleAction];
    [avatarAlert addAction:femaleAction];
    [avatarAlert addAction:cancelAction];
    
    [self presentViewController:avatarAlert animated:true completion:nil];
}

- (void)showChangeAvatarActionSheet {
    UIAlertController *avatarAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak __typeof(&*avatarAlert)weakAvatarAlert = avatarAlert;
    weakSelf(self);
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[CMImagePickerManager sharedCMImagePickerManager] showCameraWithViewController:weakSelf handler:^(UIImage *image) {
            // 上传图片
            NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
            if (imageData.length/1024/1024 > 0.9) {
                imageData = UIImageJPEGRepresentation(image, 0.4);
            }
            // 上传图片 完成后 拿到地址 上传其他参数
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[RCHttpHelper sharedHelper] uploadPicWithPostUrl:[httpHost stringByAppendingPathComponent:orderCommentPicUp] headParams:nil bodyParams:nil imageKeys:@[@"file"] images:@[imageData] progress:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
                [MBProgressHUD hideHUDForView:self.view];
                if ([responseObject[@"status"] integerValue] == 1) {
                    
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    [dic setValue:responseObject[@"data"] forKey:@"face"];
                    NSString *face = responseObject[@"data"];
                    NSMutableDictionary *param = [NSMutableDictionary new];
                    [param setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:setPersonalInfo]
                                              headParams:param
                                              bodyParams:dic
                                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
                                                     [MBProgressHUD hideHUDForView:self.view];
                                                     [ShowMessage showMessage:responseObject[@"msg"]];
                                                     if ([responseObject[@"status"] integerValue] == 1) {
                                                         [TXModelAchivar updateUserModelWithKey:@"face" value:face];
                                                         [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginSuccess object:nil userInfo:nil];
                                                         [self.tableView reloadData];
                                                     }
                                                 }
                                                 failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                                     [ShowMessage showMessage:error.description];
                                                     [MBProgressHUD hideHUDForView:self.view];
                                                 }];
                } else {
                    [MBProgressHUD hideHUDForView:self.view];
                    [ShowMessage showMessage:responseObject[@"msg"]];
                }
            } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                [ShowMessage showMessage:error.description];
                [MBProgressHUD hideHUDForView:self.view];
            }];
        }];
    }];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[CMImagePickerManager sharedCMImagePickerManager] showPhotoLibraryWithViewController:weakSelf handler:^(UIImage *image) {
            // 上传图片
            NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
            if (imageData.length/1024/1024 > 0.9) {
                imageData = UIImageJPEGRepresentation(image, 0.4);
            }
            // 上传图片 完成后 拿到地址 上传其他参数
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[RCHttpHelper sharedHelper] uploadPicWithPostUrl:[httpHost stringByAppendingPathComponent:orderCommentPicUp] headParams:nil bodyParams:nil imageKeys:@[@"file"] images:@[imageData] progress:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
                [MBProgressHUD hideHUDForView:self.view];
                if ([responseObject[@"status"] integerValue] == 1) {
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    [dic setValue:responseObject[@"data"] forKey:@"face"];
                    NSString *face = responseObject[@"data"];
                    NSMutableDictionary *param = [NSMutableDictionary new];
                    [param setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:setPersonalInfo]
                                              headParams:param
                                              bodyParams:dic
                                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
                                                     [MBProgressHUD hideHUDForView:self.view];
                                                     [ShowMessage showMessage:responseObject[@"msg"]];
                                                     if ([responseObject[@"status"] integerValue] == 1) {
                                                         
                                                         [TXModelAchivar updateUserModelWithKey:@"face" value:face];
                                                         [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginSuccess object:nil userInfo:nil];
                                                         [self.tableView reloadData];
                                                     }
                                                 }
                                                 failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                                     [ShowMessage showMessage:error.description];
                                                     [MBProgressHUD hideHUDForView:self.view];
                                                 }];
                } else {
                    [MBProgressHUD hideHUDForView:self.view];
                    [ShowMessage showMessage:responseObject[@"msg"]];
                }
            } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                [ShowMessage showMessage:error.description];
                [MBProgressHUD hideHUDForView:self.view];
            }];
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakAvatarAlert dismissViewControllerAnimated:true completion:nil];
    }];
    
    [TXCustomTools setActionTitleTextColor:RGB(46, 46, 46) action:cameraAction];
    [TXCustomTools setActionTitleTextColor:RGB(46, 46, 46) action:albumAction];
    [TXCustomTools setActionTitleTextColor:RGB(0, 122, 255) action:cancelAction];
    
    [avatarAlert addAction:cameraAction];
    [avatarAlert addAction:albumAction];
    [avatarAlert addAction:cancelAction];
    
    [self presentViewController:avatarAlert animated:true completion:nil];
}


@end
