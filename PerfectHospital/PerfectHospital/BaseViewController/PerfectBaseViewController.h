//
//  PerfectBaseViewController.h
//  PerfectHospital
//
//  Created by minfo019 on 16/5/5.
//  Copyright © 2016年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDQProjectNetWork.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface PerfectBaseViewController : UIViewController

@property ( strong, nonatomic) NSMutableString *base_url;
@property ( strong, nonatomic) DDQProjectNetWork *net_work;
/**
 *  用于等待的hud
 */
@property ( strong, nonatomic) MBProgressHUD *wait_hud;
/**
 *  用于提示的hud
 */
@property ( strong, nonatomic) MBProgressHUD *alert_hud;

- (void)buildNav:(NSString *)title;//导航条标题

- (void)buildLeftBtn:(UIImage *)image;//左按钮加图片


@end
