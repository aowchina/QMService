//
//  LoginViewController.m
//  PerfectHospital
//
//  Created by minfo019 on 16/5/5.
//  Copyright © 2016年 Tracy. All rights reserved.
//

#import "LoginViewController.h"
#import "PerfectOrderListViewController.h"

#define kLogin_url @"public/Login.php"
@interface LoginViewController ()

/**
 *  我要作为载体View
 */
@property (strong,nonatomic) UIView *backgroundView;
/**
 *  显示两个小的图片
 */
@property (strong,nonatomic) UIImageView *phoneImageView;
@property (strong,nonatomic) UIImageView *lockImageView;
/**
 *  输入电话号码，密码的field
 */
@property (strong,nonatomic) UITextField *inputPhoneNumField;
@property (strong,nonatomic) UITextField *inputPasswordField;
/**
 *  我要做一条华丽丽的分割线
 */
@property (strong,nonatomic) UIView *cuttingLineView;

@property (strong,nonatomic) UIButton *loginButton;

@property (strong,nonatomic) UIButton *findPasswordButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildNav:@"登录"];
    self.view.backgroundColor = ZYColor(245, 245, 245);
    [self layoutControllerView];
    
}

- (void)loginC_netServer {

    [self.wait_hud show:YES];
    [self.net_work asy_netWithUrlString:[self.base_url stringByAppendingString:kLogin_url] ParamArray:@[self.inputPhoneNumField.text,self.inputPasswordField.text] Success:^(id source, NSError *analysis_error) {
        
        if (analysis_error) {
            
            [self.wait_hud hide:YES];
            if (analysis_error.code == 10) {
                
                self.alert_hud.detailsLabelText = @"用户名不存在";
                [self.alert_hud show:YES];
                [self.alert_hud hide:YES afterDelay:1.0f];

            } else if (analysis_error.code == 11) {
            
                self.alert_hud.detailsLabelText = @"密码错误";
                [self.alert_hud show:YES];
                [self.alert_hud hide:YES afterDelay:1.0f];
                
            } else {
            
                self.alert_hud.detailsLabelText = kServerError ;
                [self.alert_hud show:YES];
                [self.alert_hud hide:YES afterDelay:1.0f];
                
            }
            
        } else {
        
            [self.wait_hud hide:YES];
            
            [[NSUserDefaults standardUserDefaults] setObject:source[@"userid"] forKey:@"userid"];
            PerfectOrderListViewController *orderListVC = [[PerfectOrderListViewController alloc] init];
            [self.navigationController pushViewController:orderListVC animated:YES];
            
        }
        
    } Failure:^(NSError *net_error) {
        
        [self.wait_hud hide:YES];
        self.alert_hud.detailsLabelText = kNotNetConnect;
        [self.alert_hud show:YES];
        [self.alert_hud hide:YES afterDelay:1.0f];
        
    }];
    
}

#pragma mark - layout Controller View
-(void)layoutControllerView {
    
    //布局载体view
    self.backgroundView = [[UIView alloc] init];
    [self.view addSubview:self.backgroundView];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (ZYHeight >= 667) {
            make.height.equalTo(self.view.mas_height).with.multipliedBy(0.15);//h
            make.top.equalTo(self.view.mas_top).with.offset(self.view.bounds.size.height*0.15);//y
        } else {
            make.height.equalTo(self.view.mas_height).with.multipliedBy(0.2);//h
            make.top.equalTo(self.view.mas_top).with.offset(self.view.bounds.size.height*0.2);//y
        }
        make.left.equalTo(self.view.mas_left);//x
        make.right.equalTo(self.view.mas_right);//w
    }];
    
    [self.backgroundView setBackgroundColor:[UIColor whiteColor]];
    
    //华丽丽的分割线
    self.cuttingLineView = [[UIView alloc] init];
    [self.backgroundView addSubview:self.cuttingLineView];
    
    [self.cuttingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);//h
        make.centerX.equalTo(self.backgroundView.mas_centerX);//x
        make.centerY.equalTo(self.backgroundView.mas_centerY);//y
        make.width.equalTo(@(ZYWidth-8));//w
    }];
    
    [self.cuttingLineView setBackgroundColor:ZYColor(245, 245, 245)];
    
    //小手机
    self.phoneImageView = [[UIImageView alloc] init];
    [self.backgroundView addSubview:self.phoneImageView];
    
    [self.phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(self.view.bounds.size.width*0.05);//w
        make.bottom.equalTo(self.cuttingLineView.mas_bottom).with.offset(-self.view.bounds.size.height*0.02);//h
        make.left.equalTo(self.backgroundView.mas_left).with.offset(self.view.bounds.size.width*0.02);//x
        make.top.equalTo(self.backgroundView.mas_top).with.offset(self.view.bounds.size.height*0.02);//y
    }];
    
    [self.phoneImageView setImage:[UIImage imageNamed:@"phone"]];
    self.phoneImageView.contentMode   = UIImageResizingModeStretch;
    
    //小锁
    self.lockImageView = [[UIImageView alloc] init];
    [self.backgroundView addSubview:self.lockImageView];
    
    [self.lockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(self.view.bounds.size.width*0.05);//w
        make.bottom.equalTo(self.backgroundView.mas_bottom).with.offset(-self.view.bounds.size.height*0.02);//h
        make.left.equalTo(self.backgroundView.mas_left).with.offset(self.view.bounds.size.width*0.02);//x
        make.top.equalTo(self.cuttingLineView.mas_top).with.offset(self.view.bounds.size.height*0.02);//y
    }];
    
    [self.lockImageView setImage:[UIImage imageNamed:@"password"]];
    self.lockImageView.contentMode   = UIImageResizingModeStretch;
    
    //输入手机号
    self.inputPhoneNumField = [[UITextField alloc] init];
    [self.backgroundView addSubview:self.inputPhoneNumField];
    
    [self.inputPhoneNumField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView.mas_top);//y
        make.left.equalTo(self.phoneImageView.mas_right).with.offset(self.view.bounds.size.width*0.02);//x
        make.height.equalTo(self.backgroundView.mas_height).with.multipliedBy(0.5);//h
        make.right.equalTo(self.backgroundView.mas_right);//w
    }];
    
    [self.inputPhoneNumField setPlaceholder:@"请输入登录账号"];
    self.inputPhoneNumField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //输入密码
    self.inputPasswordField = [[UITextField alloc] init];
    [self.backgroundView addSubview:self.inputPasswordField];
    
    [self.inputPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneImageView.mas_right).with.offset(self.view.bounds.size.width*0.02);//x
        make.top.equalTo(self.cuttingLineView.mas_bottom);//y
        make.right.equalTo(self.backgroundView.mas_right);//w
        make.height.equalTo(self.inputPhoneNumField.mas_height);//h
    }];
    
    [self.inputPasswordField setPlaceholder:@"请输入登录密码"];
    self.inputPasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inputPasswordField.secureTextEntry = YES;
    
    //登录按钮
    self.loginButton = [[UIButton alloc] init];
    [self.view addSubview:self.loginButton];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@35);//h
        make.left.equalTo(self.view.mas_left).with.offset(10);//x
        make.right.equalTo(self.view.mas_right).with.offset(-10);//w
        make.top.equalTo(self.backgroundView.mas_bottom).with.offset(50);//y
    }];
    
    [self.loginButton setBackgroundColor:ZYColor(250, 66, 136)];
    [self.loginButton.layer setCornerRadius:5.0f];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginToApp) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)loginToApp {

    [self loginC_netServer];
    
}

@end
