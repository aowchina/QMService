//
//  PerfectPictureCollectionViewCell.m
//  PerfectHospital
//
//  Created by minfo019 on 16/5/6.
//  Copyright © 2016年 Tracy. All rights reserved.
//

#import "PerfectPictureCollectionViewCell.h"

@implementation PerfectPictureCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //图片
        _picImageV = [[UIImageView alloc] init];
        _picImageV.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _picImageV.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_picImageV];
        self.clipsToBounds = YES;
        //删除按钮
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteBtn setImage:ZYImageName(@"treands_photo_del") forState:UIControlStateNormal];
        [self.deleteBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.deleteBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _picImageV.frame = self.bounds;
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.height.and.width.offset(20);
    }];
}

- (void)deleteBtn:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleBtnWithCell:)]) {
        [self.delegate deleBtnWithCell:self];
    }
}


@end
