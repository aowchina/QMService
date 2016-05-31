//
//  PerfectOrderDatailViewController.m
//  PerfectHospital
//
//  Created by minfo019 on 16/5/5.
//  Copyright © 2016年 Tracy. All rights reserved.
//

#import "PerfectOrderDatailViewController.h"
#import "PerfectPictureViewController.h"
#import "PerfectOrderListViewController.h"
#define orderDetail @"order/Detail.php"

@interface PerfectOrderDatailViewController ()

@property ( strong, nonatomic) NSDictionary *source;

@end

@implementation PerfectOrderDatailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildNav:@"订单详情"];
    [self buildLeftBtn:ZYImageName(@"返回re")];
    
    /**
     *  网络请求
     */
    [self orderDetailC_netServer];
    
}

- (void)orderDetailV_model:(id)source {

    self.detailLabel.text = [NSString stringWithFormat:@"【%@】%@",source[@"name"],source[@"fname"]];
    self.addressLabel.text = source[@"hname"];
    self.addressLabel.font = ZYFont(15);
    self.priceLabel.font = ZYFont(15);
    self.priceLabel.text = [NSString stringWithFormat:@"￥:%@",source[@"have_pay"]];
    self.priceLabel2.text = [NSString stringWithFormat:@"￥:%@",source[@"have_pay"]];
    self.integralLabel.text = [NSString stringWithFormat:@"实付款(积分抵消%@元)",source[@"point_money"]];
    self.integralPriceL.text = [NSString stringWithFormat:@"￥:%@",source[@"true_pay"]];
    self.rebatesLabel.text = [NSString stringWithFormat:@"返积分%@点",source[@"get_point"]];
    self.orderLabel.text = [NSString stringWithFormat:@"订单号:%@",source[@"orderid"]];
    self.orderTimeL.text = [NSString stringWithFormat:@"下单时间:%@",source[@"ctime"]];
    self.phoneLabel.text = [NSString stringWithFormat:@"联系方式:%@",source[@"tel"]];
    [self.orderImageView sd_setImageWithURL:[NSURL URLWithString:source[@"simg"]]];
    
    
}


- (void)orderDetailC_netServer {

    [self.wait_hud show:YES];
    
    [self.net_work asy_netWithUrlString:[self.base_url stringByAppendingString:orderDetail] ParamArray:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],self.orderid] Success:^(id source, NSError *analysis_error) {
        
        if (analysis_error) {
            
            [self.wait_hud hide:YES];
            NSInteger code = analysis_error.code;
            if (code == 10 || code == 12 || code == 13 || code == 14 || code == 15 || code == 16) {
                
                switch (analysis_error.code) {
                        
                    case 10:
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        break;
                        
                    case 12:
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        break;
                        
                    case 13:
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        break;
                      
                    case 14:
                        self.alert_hud.detailsLabelText = @"订单不存在";
                        [self.alert_hud show:YES];
                        [self.alert_hud hide:YES afterDelay:1.0f];
                        break;
                        
                    case 15:
                        self.alert_hud.detailsLabelText = @"订单尚未预定";
                        [self.alert_hud show:YES];
                        [self.alert_hud hide:YES afterDelay:1.0f];
                        break;
                       
                    case 16:
                        self.alert_hud.detailsLabelText = @"您尚未绑定该订单";
                        [self.alert_hud show:YES];
                        [self.alert_hud hide:YES afterDelay:1.0f];
                        break;
                        
                    default:
                        break;
                        
                }
                
            } else {
                
                self.alert_hud.detailsLabelText = kServerError;
                [self.alert_hud show:YES];
                [self.alert_hud hide:YES afterDelay:1.0f];
                
            }

        } else {
        
            [self.wait_hud hide:YES];
            [self orderDetailV_model:source];
            self.source = source;
            
        }
        
    } Failure:^(NSError *net_error) {
        
        [self.wait_hud hide:YES];
        self.alert_hud.detailsLabelText = kNotNetConnect;
        [self.alert_hud show:YES];
        [self.alert_hud hide:YES afterDelay:1.0f];
        
    }];
    
}

- (IBAction)submitBtn:(UIButton *)sender {
    
    PerfectPictureViewController *perfectPictureVC = [[PerfectPictureViewController alloc] init];
    perfectPictureVC.orderid = self.source[@"orderid"];
    [self.navigationController pushViewController:perfectPictureVC animated:YES];
    
}

#pragma mark - Action -
- (void)leftBtnAction:(UIButton *)button {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
