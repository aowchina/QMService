//
//  MBProgressHUD+EBUsHUD.m
//  EBeautify
//
//  Created by Min-Fo_003 on 15/11/24.
//  Copyright © 2015年 min-fo013. All rights reserved.
//

#import "MBProgressHUD+EBUsHUD.h"
//#import "SLHUDView.h"
@implementation MBProgressHUD (EBUsHUD)

+(instancetype)myCustomHudWithView:(UIView *)view andCustomText:(NSString *)text andShowDim:(BOOL)isShow andSetDelay:(BOOL)isDelay andCustomView:(UIView *)customView{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    hud.labelFont = ZYFont(16);
    hud.dimBackground = isShow;
    if (customView != nil) {
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = customView;
        [hud show:YES];
    } else {
        hud.mode = MBProgressHUDModeText;
        [hud show:YES];
        
    }
    if (isDelay == YES) {
        [hud hide:YES afterDelay:2];
    }
    return hud;
}

//+ (MBProgressHUD *)showWithHudAtSupView:(UIView *)superView {
//    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
//    hud.mode = MBProgressHUDModeCustomView;
//    hud.backgroundColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.2];
//    hud.margin = 0.f;
//    hud.color = [UIColor clearColor];
//    hud.cornerRadius = 5.f;
//    SLHUDView *hudView = [[SLHUDView alloc] initWithFrame:CGRectZero];
//    hud.customView = hudView;
//    [superView addSubview:hud];
//    return hud;
//}

+ (void)buildHudWithtitle:(NSString *)title superView:(UIView *)view {
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.labelFont = ZYFont(16);
    [view addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:2];
}


@end
