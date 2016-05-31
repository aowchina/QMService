//
//  OrderListTableViewCell.m
//  PerfectHospital
//
//  Created by minfo019 on 16/5/5.
//  Copyright © 2016年 Tracy. All rights reserved.
//

#import "OrderListTableViewCell.h"
#import "OrderListModel.h"
@interface OrderListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLalel;//时间
@property (weak, nonatomic) IBOutlet UILabel *orderNum;//订单号
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;//线
@property (weak, nonatomic) IBOutlet UILabel *lineLabel2;//线
@property (weak, nonatomic) IBOutlet UIImageView *orderImageView;//图片
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;//详情
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;//地址

@end

@implementation OrderListTableViewCell

- (void)reloadViewWithModel:(OrderListModel *)model {
    
    self.lineLabel.backgroundColor = ZYColor(245, 245, 245);
    self.lineLabel2.backgroundColor = ZYColor(245, 245, 245);
    
    self.timeLalel.text = model.create_time;
    self.timeLalel.textColor = ZYColor(132, 132, 133);
    self.orderNum.text = [NSString stringWithFormat:@"订单号:%@",model.orderid];
    self.orderNum.textColor = ZYColor(132, 132, 133);
    self.detailLabel.text = model.name;
    self.addressLabel.text = [NSString stringWithFormat:@"%@   ￥:%@元",model.hname,model.dj];
    self.addressLabel.font = ZYFont(15);
    self.addressLabel.textColor = ZYColor(132, 132, 133);
    [self.orderImageView sd_setImageWithURL:[NSURL URLWithString:model.simg]];
    
}

- (IBAction)payBtn:(UIButton *)sender {
    NSLog(@"支付");
}

- (void)awakeFromNib {
    self.backgroundColor = ZYClearColor;
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
