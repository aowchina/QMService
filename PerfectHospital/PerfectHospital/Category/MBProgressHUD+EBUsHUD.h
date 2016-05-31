//
//  MBProgressHUD+EBUsHUD.h
//  EBeautify
//
//  Created by Min-Fo_003 on 15/11/24.
//  Copyright © 2015年 min-fo013. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (EBUsHUD)

+(instancetype)myCustomHudWithView:(UIView *)view andCustomText:(NSString *)text andShowDim:(BOOL)isShow andSetDelay:(BOOL)isDelay andCustomView:(UIView *)customView;
//+ (MBProgressHUD *)showWithHudAtSupView:(UIView *)superView;
+ (void)buildHudWithtitle:(NSString *)title superView:(UIView *)view;

@end
