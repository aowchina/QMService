//
//  PerfectBaseViewController.m
//  PerfectHospital
//
//  Created by minfo019 on 16/5/5.
//  Copyright © 2016年 Tracy. All rights reserved.
//

#import "PerfectBaseViewController.h"

@interface PerfectBaseViewController ()

@end

@implementation PerfectBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //baseUrl
    self.base_url = [[NSMutableString alloc] initWithString:@"http://139.196.172.208/qm/serverapi/"];
    
    //网络请求
    self.net_work = [DDQProjectNetWork instanceObjc];
    
    //初始化hud
    self.wait_hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.wait_hud];
    self.wait_hud.detailsLabelText = @"请稍等...";
    
    self.alert_hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.alert_hud];
    self.alert_hud.mode = MBProgressHUDModeText;
    

}

- (void)buildNav:(NSString *)title {
    //设置子控制器的文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:20];
    label.text = title;
    label.textColor = ZYColor(250, 66, 136);
    self.navigationItem.titleView = label;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)buildLeftBtn:(UIImage *)image {
    //左按钮
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, 0, 25, 25);
    [returnBtn setImage:image forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:returnBtn];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

#pragma mark - Action -
- (void)leftBtnAction:(UIButton *)button {
    
}

@end
