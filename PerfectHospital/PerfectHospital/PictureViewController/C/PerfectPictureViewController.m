//
//  PerfectPictureViewController.m
//  PerfectHospital
//
//  Created by minfo019 on 16/5/6.
//  Copyright © 2016年 Tracy. All rights reserved.
//

#import "PerfectPictureViewController.h"
#import "TZImagePickerController.h"
#import "PerfectPictureCollectionViewCell.h"
#import "PerfectChoosePicView.h"
#define uploadImage @"order/Upload.php"
@interface PerfectPictureViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,deleteBtndelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,perfectChoosePicDelegate,MBProgressHUDDelegate> {
    UICollectionView *_collectionView;
    NSMutableArray *_selectedPhotos;
    
    CGFloat _itemWH;
    CGFloat _margin;
}
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) PerfectChoosePicView *perfectView;
@end

@implementation PerfectPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildNav:@"上传"];
    [self buildLeftBtn:ZYImageName(@"返回re")];
    _selectedPhotos = [NSMutableArray array];
    [self buildrigthBtn];
    [self configCollectionView];
    [self buildChooseBtn];
}

- (void)buildrigthBtn {
    //右按钮
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, 0, 50, 20);
    [returnBtn setTitle:@"提交" forState:UIControlStateNormal];
    [returnBtn setTitleColor:ZYColor(250, 66, 136) forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(rigthBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:returnBtn];
    self.navigationItem.rightBarButtonItem = leftBarButtonItem;
}

- (void)buildChooseBtn {
    UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseBtn.frame = CGRectMake(ZYWidth-90, ZYHeight-90, 60, 60);
    [chooseBtn setImage:ZYImageName(@"img_photo") forState:UIControlStateNormal];
    [chooseBtn addTarget:self action:@selector(chooseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseBtn];
}

- (void)configCollectionView {
    //布局collection
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (self.view.width - 2 * _margin - 4) / 3 - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_margin, 5, self.view.width - 2 * _margin, ZYHeight) collectionViewLayout:layout];
    CGFloat rgb = 244 / 255.0;
    _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 0, 0, 2);
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view insertSubview:_collectionView atIndex:0];
    [_collectionView registerClass:[PerfectPictureCollectionViewCell class] forCellWithReuseIdentifier:@"perfectPictureCell"];
}

#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PerfectPictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"perfectPictureCell" forIndexPath:indexPath];
    [cell.picImageV setImage:[UIImage imageWithData:_selectedPhotos[indexPath.row]]];
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark  - deleteBtndelegate -
- (void)deleBtnWithCell:(PerfectPictureCollectionViewCell *)cell {
    NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];
    [_selectedPhotos removeObjectAtIndex:indexPath.row];
    [_collectionView reloadData];
}

#pragma mark TZImagePickerControllerDelegate
/// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    if (_selectedPhotos.count + photos.count <= 9) {
        
        for (UIImage *image in photos) {
            [self saveImage:image withName:@"icon.png"];
            NSString *fullPath =[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"icon.png"];
            NSData *dataimg = [NSData dataWithContentsOfFile:fullPath];
            [_selectedPhotos addObject:dataimg];
        }
        [_collectionView reloadData];
        _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
        
    } else {
    
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"选图总数不能超过九张";
        [hud show:YES];
        [hud hide:YES afterDelay:2.0f];
        
    }
}

-(void)cameraButtonClickedPersonVC
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

//存到本地
- (void)saveImage:(UIImage*)currentImage withName:(NSString *)imageName{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    [imageData writeToFile:fullPath atomically:NO];
    
}

//点击完成执行方法,储存图片
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self saveImage:image withName:@"icon.png"];
    NSString *fullPath =[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"icon.png"];
    NSData *dataimg = [NSData dataWithContentsOfFile:fullPath];
    [_selectedPhotos addObject:dataimg];
    //    把图片展示
    [_collectionView reloadData];
    
}
//12-02
//对图片尺寸进行压缩--
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

#pragma mark - Action -
- (void)leftBtnAction:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rigthBtnAction:(UIButton *)btn {
   
    
    if (_selectedPhotos.count == 0) {
        
        self.alert_hud.detailsLabelText = @"请选择图片";
        [self.alert_hud show:YES];
        [self.alert_hud hide:YES afterDelay:1.0f];
        
    } else {
    
        [self.wait_hud show:YES];
        [self.net_work asyPOST_url:[self.base_url stringByAppendingString:uploadImage] Photo:_selectedPhotos Data:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],self.orderid] Success:^(id objc) {
            

            [self.wait_hud hide:YES];
            NSInteger code = [objc[@"errorcode"] integerValue];
            if (code == 0) {
                
                self.alert_hud.detailsLabelText = @"图片上传成功";
                self.alert_hud.delegate = self;
                [self.alert_hud show:YES];
                [self.alert_hud hide:YES afterDelay:1.0f];
                
            } else {
            
                if (code == 10 || code == 12 || code == 13 || code == 14 || code == 15 || code == 16 || code == 17) {
                    
                    switch (code) {
                            
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
                            self.alert_hud.detailsLabelText = @"只有待服务的订单能够传图";
                            [self.alert_hud show:YES];
                            [self.alert_hud hide:YES afterDelay:1.0f];
                            break;
                            
                        case 16:
                            self.alert_hud.detailsLabelText = @"您尚未绑定该订单";
                            [self.alert_hud show:YES];
                            [self.alert_hud hide:YES afterDelay:1.0f];
                            break;
                            
                        case 17:
                            self.alert_hud.detailsLabelText = @"选图不超过9张";
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
                
            }
            
        } andFailure:^(NSError *error) {
            
            [self.wait_hud hide:YES];
            self.alert_hud.detailsLabelText = kNotNetConnect;
            [self.alert_hud show:YES];
            [self.alert_hud hide:YES afterDelay:1.0f];
            
        }];
        
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud {

    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)chooseBtn:(UIButton *)btn {
    //背景图
    self.backView = [[UIView alloc] initWithFrame:self.view.window.bounds];
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.5;
    [self.view.window addSubview:self.backView];
    //提示选择框
    self.perfectView = [[PerfectChoosePicView alloc] initWithFrame:CGRectMake(20, 0, ZYWidth-40, ZYHeight*380/960)];
    self.perfectView.backgroundColor = [UIColor whiteColor];
    self.perfectView.center = self.backView.center;
    self.perfectView.delegate = self;
    [self.view.window addSubview:self.perfectView];
}

- (void)chooseCameraLabel {
    [self.backView removeFromSuperview];
    [self.perfectView removeFromSuperview];
    [self cameraButtonClickedPersonVC];
}

- (void)choosePhotosLabel {
    [self.backView removeFromSuperview];
    [self.perfectView removeFromSuperview];
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)chooseCancelLabel {
    [self.perfectView removeFromSuperview];
    [self.backView removeFromSuperview];
}

@end
