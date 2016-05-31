//
//  PerfectPictureCollectionViewCell.h
//  PerfectHospital
//
//  Created by minfo019 on 16/5/6.
//  Copyright © 2016年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol deleteBtndelegate;

@interface PerfectPictureCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *picImageV;

@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, assign) id<deleteBtndelegate> delegate;

@end

@protocol deleteBtndelegate <NSObject>

- (void)deleBtnWithCell:(PerfectPictureCollectionViewCell *)cell;

@end