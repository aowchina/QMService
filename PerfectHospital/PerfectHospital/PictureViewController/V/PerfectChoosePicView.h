//
//  PerfectChoosePicView.h
//  PerfectHospital
//
//  Created by minfo019 on 16/5/6.
//  Copyright © 2016年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol perfectChoosePicDelegate;

@interface PerfectChoosePicView : UIView

@property (nonatomic, strong) UILabel *cameraL;//拍照
@property (nonatomic, strong) UILabel *photosL;//相册
@property (nonatomic, strong) UILabel *cancelL;//取消

@property (nonatomic, assign) id<perfectChoosePicDelegate> delegate;
@end

@protocol perfectChoosePicDelegate <NSObject>

- (void)chooseCameraLabel;
- (void)choosePhotosLabel;
- (void)chooseCancelLabel;

@end