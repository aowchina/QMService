//
//  PerfectOrderDatailViewController.h
//  PerfectHospital
//
//  Created by minfo019 on 16/5/5.
//  Copyright © 2016年 Tracy. All rights reserved.
//

#import "PerfectBaseViewController.h"

@interface PerfectOrderDatailViewController : PerfectBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *orderImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;//详情
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;//地址
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel2;//价格
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;//积分
@property (weak, nonatomic) IBOutlet UILabel *integralPriceL;//积分钱
@property (weak, nonatomic) IBOutlet UILabel *rebatesLabel;//返积分
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;//订单号
@property (weak, nonatomic) IBOutlet UILabel *orderTimeL;//订单时间
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;//电话

@property ( strong, nonatomic) NSString *orderid;

@end
