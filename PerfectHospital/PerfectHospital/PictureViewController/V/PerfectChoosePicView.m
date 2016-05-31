//
//  PerfectChoosePicView.m
//  PerfectHospital
//
//  Created by minfo019 on 16/5/6.
//  Copyright © 2016年 Tracy. All rights reserved.
//

#import "PerfectChoosePicView.h"

@implementation PerfectChoosePicView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildView];
    }
    return self;
}

- (void)buildView {
    //创建视图
    NSArray *colorArr = @[ZYColor(250, 66, 136),[UIColor grayColor],[UIColor purpleColor]];
    NSArray *textColorArr = @[ZYColor(250, 66, 136),[UIColor grayColor],[UIColor grayColor],[UIColor blackColor]];
    NSArray *array = @[@"  选择照片",@"  拍照",@"  相册",@"取消"];
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, ZYHeight*0.1*i, self.width, ZYHeight*0.1)];
        label.text = array[i];
        label.textColor = textColorArr[i];
        label.tag = 1000+i;
        [self addSubview:label];
        if (i < 3) {
            UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, ZYHeight*0.1*(i+1)-1, self.width, 1)];
            [lineImage setBackgroundColor:colorArr[i]];
            [self addSubview:lineImage];
            if (i == 0) {
                lineImage.height = 2;
            }
        }
    }
    
    self.cameraL = [self viewWithTag:1001];
    self.photosL = [self viewWithTag:1002];
    self.cancelL = [self viewWithTag:1003];
    self.cancelL.textAlignment = NSTextAlignmentCenter;
    self.cameraL.userInteractionEnabled = YES;
    self.photosL.userInteractionEnabled = YES;
    self.cancelL.userInteractionEnabled = YES;
    
    //添加手势
    UITapGestureRecognizer *cameraTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraTap)];
    UITapGestureRecognizer *photosTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photosTap)];
    UITapGestureRecognizer *cancelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelTap)];
    
    [self.cameraL addGestureRecognizer:cameraTap];
    [self.photosL addGestureRecognizer:photosTap];
    [self.cancelL addGestureRecognizer:cancelTap];
}

#pragma mark - Action -
- (void)cameraTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseCameraLabel)]) {
        [self.delegate chooseCameraLabel];
    }
}

- (void)photosTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(choosePhotosLabel)]) {
        [self.delegate choosePhotosLabel];
    }
}

- (void)cancelTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseCancelLabel)]) {
        [self.delegate chooseCancelLabel];
    }
}

@end
