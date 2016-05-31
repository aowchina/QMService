//
//  PerfrectQRCodeViewController.m
//  PerfectHospital
//
//  Created by min－fo018 on 16/5/15.
//  Copyright © 2016年 Tracy. All rights reserved.
//

#import "PerfrectQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PerfectOrderDatailViewController.h"
#define orderBand @"order/Band.php"

@interface PerfrectQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property ( strong, nonatomic) AVCaptureSession *session;
@property ( strong, nonatomic) AVCaptureSession *capture_session;
@property ( strong, nonatomic) AVCaptureVideoPreviewLayer * layer;
@property ( strong, nonatomic) NSString *orderid;
@property ( assign, nonatomic) int line_tag;
@property ( strong, nonatomic) UIImageView *box_img;
@end

@implementation PerfrectQRCodeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self buildLeftBtn:ZYImageName(@"返回re")];
    [self buildNav:@"订单扫描"];

//    AVCaptureDevice *current_device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    
//    AVCaptureDeviceInput *device_input = [AVCaptureDeviceInput deviceInputWithDevice:current_device error:nil];
//    
//    AVCaptureMetadataOutput *data_output = [[AVCaptureMetadataOutput alloc] init];
//    
//    [data_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    
//    self.capture_session = [[AVCaptureSession alloc] init];
//    
//    [self.capture_session setSessionPreset:AVCaptureSessionPresetHigh];
//    
//    [self.capture_session addInput:device_input];
//    
//    [self.capture_session addOutput:data_output];
//    
//    data_output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
//    data_output.rectOfInterest = CGRectMake( 0.5, 0, 0.5, 1);
//    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.capture_session];
//    
//    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    layer.frame = self.view.bounds;
//    
//    [self.view.layer insertSublayer:layer atIndex:0];
//    [self.capture_session startRunning];
   
    
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    self.session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if (input) {
        [self.session addInput:input];
    }
    if (output) {
        [self.session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSMutableArray *a = [[NSMutableArray alloc] init];
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [a addObject:AVMetadataObjectTypeQRCode];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            [a addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [a addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [a addObject:AVMetadataObjectTypeCode128Code];
        }
        output.metadataObjectTypes = a;
//        output.rectOfInterest = CGRectMake( 0.5, 0.5, 0.5, 0.5);
    }
    self.layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.layer.frame = self.view.frame;
    [self.view.layer addSublayer:self.layer];
    self.line_tag = 107038;
    [self setOverlayPickerView];
    [self addAnimation];
    //开始捕获
    [self.session startRunning];
    
 
}

- (void)leftBtnAction:(UIButton *)button {

    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if ([metadataObjects count] >0) {
        
        [self.session stopRunning];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        self.orderid = metadataObject.stringValue;
        
        [self.wait_hud show:YES];
        [self.net_work asy_netWithUrlString:[self.base_url stringByAppendingString:orderBand] ParamArray:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],self.orderid] Success:^(id source, NSError *analysis_error) {
            
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
                            [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"订单不存在" andShowDim:NO andSetDelay:YES andCustomView:nil];
                            break;
                            
                        case 15:
                            [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"订单未支付全款" andShowDim:NO andSetDelay:YES andCustomView:nil];
                            break;
                            
                        case 16:
                            [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"订单已绑定其它服务人员" andShowDim:NO andSetDelay:YES andCustomView:nil];
                            break;
                            
                        default:
                            break;
                            
                    }
                    
                } else {
                    
                    [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerError andShowDim:NO andSetDelay:YES andCustomView:nil];
                }
                
            } else {
                
                [self.wait_hud hide:YES];
                
                PerfectOrderDatailViewController *order_detailC = [[PerfectOrderDatailViewController alloc] initWithNibName:@"PerfectOrderDatailViewController" bundle:nil];
                order_detailC.orderid = self.orderid;
                [self.navigationController pushViewController:order_detailC animated:YES];
                
            }
            
            
        } Failure:^(NSError *net_error) {
            
            [self.wait_hud hide:YES];
             [MBProgressHUD myCustomHudWithView:self.view andCustomText:kNotNetConnect andShowDim:NO andSetDelay:YES andCustomView:nil];
            
        }];
        
    }
    
}

- (void)setOverlayPickerView
{
    //左侧的view
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, ZYHeight)];
    leftView.alpha = 0.5;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    //右侧的view
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(ZYWidth-30, 0, 30, ZYHeight)];
    rightView.alpha = 0.5;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    //最上部view
    UIImageView* upView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, ZYWidth-60, (self.view.center.y-(ZYWidth-60)/2))];
    upView.alpha = 0.5;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    //底部view
    UIImageView * downView = [[UIImageView alloc] initWithFrame:CGRectMake(30, (self.view.center.y+(ZYWidth-60)/2), (ZYWidth-60), (ZYWidth-(self.view.center.y-(ZYWidth-60)/2)))];
    downView.alpha = 0.5;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    self.box_img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ZYWidth-60, ZYWidth-60)];
    self.box_img.center = self.view.center;
    self.box_img.image = [UIImage imageNamed:@"扫描框.png"];
    self.box_img.contentMode = UIViewContentModeScaleAspectFit;
    self.box_img.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.box_img];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(upView.frame), ZYWidth-60, 2)];
    line.tag = self.line_tag;
    line.image = [UIImage imageNamed:@"扫描线.png"];
    line.contentMode = UIViewContentModeScaleAspectFill;
    line.backgroundColor = [UIColor clearColor];
    [self.view addSubview:line];
    
    UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMinY(downView.frame), ZYWidth-60, 60)];
    msg.backgroundColor = [UIColor clearColor];
    msg.textColor = [UIColor whiteColor];
    msg.textAlignment = NSTextAlignmentCenter;
    msg.font = [UIFont systemFontOfSize:16];
    msg.text = @"将二维码放入框内,即可自动扫描";
    [self.view addSubview:msg];
    
}

/**
 *  @author Whde
 *
 *  添加扫码动画
 */
- (void)addAnimation{
    
    UIView *line = [self.view viewWithTag:self.line_tag];
    line.hidden = NO;
    CABasicAnimation *animation = [PerfrectQRCodeViewController moveYTime:2 fromY:[NSNumber numberWithFloat:0] toY:[NSNumber numberWithFloat:ZYWidth-60-2] rep:OPEN_MAX];
    [line.layer addAnimation:animation forKey:@"LineAnimation"];
    
}

+ (CABasicAnimation *)moveYTime:(float)time fromY:(NSNumber *)fromY toY:(NSNumber *)toY rep:(int)rep
{
    CABasicAnimation *animationMove = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animationMove setFromValue:fromY];
    [animationMove setToValue:toY];
    animationMove.duration = time;
    animationMove.delegate = self;
    animationMove.repeatCount  = rep;
    animationMove.fillMode = kCAFillModeForwards;
    animationMove.removedOnCompletion = NO;
    animationMove.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animationMove;
}


@end
