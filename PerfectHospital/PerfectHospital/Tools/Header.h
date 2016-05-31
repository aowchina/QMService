//
//  Header.h
//  PerfectHospital
//
//  Created by minfo019 on 16/5/5.
//  Copyright © 2016年 Tracy. All rights reserved.
//

#ifndef Header_h
#define Header_h

//cartory
#import "UIView+ZYFrame.h"
#import "MBProgressHUD+EBUsHUD.h"
#import "NSDictionary+ZY.h"
#import "UIImageView+WebCache.h"
#import <MJRefresh/MJRefresh.h>
#import <IQKeyboardManager/KeyboardManager.h>
#import <Masonry/Masonry.h>
#import <MJExtension/MJExtension.h>

#define kNotNetConnect @"当前网络状态异常"
#define kServerError @"服务器繁忙"

// RGB颜色
#define ZYColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//屏幕宽高宏定义
#define ZYHeight [[UIScreen mainScreen] bounds].size.height
#define ZYWidth [UIScreen mainScreen].bounds.size.width

// 设置透明色
#define ZYClearColor [UIColor clearColor]

// 设置图片
#define ZYImageName(name) [UIImage imageNamed:(name)]

#define ZYFont(float) [UIFont systemFontOfSize:(float)]


#endif /* Header_h */
