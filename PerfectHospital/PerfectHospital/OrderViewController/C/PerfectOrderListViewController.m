//
//  PerfectOrderListViewController.m
//  PerfectHospital
//
//  Created by minfo019 on 16/5/5.
//  Copyright © 2016年 Tracy. All rights reserved.
//

#import "PerfectOrderListViewController.h"
#import "OrderListTableViewCell.h"
#import "OrderListModel.h"
#import "PerfectOrderDatailViewController.h"
#import "PerfrectQRCodeViewController.h"

#define orderList @"order/List.php"
#define orderBand @"order/Band.php"

@interface PerfectOrderListViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *searchTextF;//搜索

@property ( strong, nonatomic) NSMutableArray *listC_source;


@end

@implementation PerfectOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildNav:@"订单列表"];
    [self buildLeftBtn:ZYImageName(@"img_scan")];
    
    [self buildTopView];
    [self buildTabelView];
    
    /**
     *  网络请求
     */
    self.listC_source = [NSMutableArray array];
    [self orderListC_netServerWithPage:1];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        int num = page + 1;
        [self orderListC_netServerWithPage:num];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self.listC_source removeAllObjects];
        [self orderListC_netServerWithPage:1];
        [self.tableView.mj_header endRefreshing];
        
    }];
    
}
/**
 *  确定按钮的点击点击
 */
- (void)getTextFieldContent {

    [self.wait_hud show:YES];

    [self.net_work asy_netWithUrlString:[self.base_url stringByAppendingString:orderBand] ParamArray:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],self.searchTextF.text] Success:^(id source, NSError *analysis_error) {
        
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
                        self.alert_hud.detailsLabelText = @"订单已绑定其它服务人员";
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
            PerfectOrderDatailViewController *detailC = [[PerfectOrderDatailViewController alloc] init];
            detailC.orderid = source[@"orderid"];
            [self.navigationController pushViewController:detailC animated:YES];
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            
        }

        
    } Failure:^(NSError *net_error) {
        
        [self.wait_hud hide:YES];
        self.alert_hud.detailsLabelText = kNotNetConnect;
        [self.alert_hud show:YES];
        [self.alert_hud hide:YES afterDelay:1.0f];
        
    }];
    
}

/**
 *  列表请求
 */
static int page = 2;
- (void)orderListC_netServerWithPage:(int)page {

    [self.wait_hud show:YES];
    
    [self.net_work asy_netWithUrlString:[self.base_url stringByAppendingString:orderList] ParamArray:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],[NSString stringWithFormat:@"%d",page]] Success:^(id source, NSError *analysis_error) {
        
        if (analysis_error) {
            
            [self.wait_hud hide:YES];
            if (analysis_error.code == 10 || analysis_error.code == 12 || analysis_error.code == 13) {
                
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
            for (NSDictionary *dic in source) {
                
                OrderListModel *listModel = [OrderListModel mj_objectWithKeyValues:dic];
                [self.listC_source addObject:listModel];
                
            }
            
            [self.tableView reloadData];
            
        }
        
        
    } Failure:^(NSError *net_error) {
        
        [self.wait_hud hide:YES];
        self.alert_hud.detailsLabelText = kNotNetConnect;
        [self.alert_hud show:YES];
        [self.alert_hud hide:YES afterDelay:1.0f];
        
    }];
    
}

/**
 * @ author Tracy
 *
 * @ date
 *
 * @ func   创建tableView
 */
- (void)buildTabelView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, ZYWidth, ZYHeight-110)];
    self.tableView.backgroundColor = ZYColor(245, 245, 245);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    //设置代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderListTableViewCell" bundle:nil] forCellReuseIdentifier:@"Ordercell"];
}

- (void)buildTopView {
    //底图
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.width.offset(ZYWidth);
        make.height.offset(46);
    }];
    topView.backgroundColor = ZYColor(245, 245, 245);
    //搜索框
    UIImageView *searchImageView = [[UIImageView alloc] init];
    [topView addSubview:searchImageView];
    [searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.centerY.equalTo(topView.mas_centerY);
    }];
    searchImageView.image = ZYImageName(@"searchBar");
    //搜索镜
    UIImageView *glassView = [[UIImageView alloc] init];
    [topView addSubview:glassView];
    [glassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchImageView.mas_left).offset(8);
        make.centerY.equalTo(searchImageView.mas_centerY);
    }];
    glassView.image = ZYImageName(@"img_search");
    //搜索内容
    self.searchTextF = [[UITextField alloc] init];
    [topView addSubview:self.searchTextF];
    [self.searchTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(glassView.mas_right).offset(2);
        make.centerY.equalTo(searchImageView.mas_centerY);
        make.height.equalTo(searchImageView.mas_height).offset(-3);
        make.width.offset(ZYWidth-60);
    }];
    self.searchTextF.delegate = self;
    self.searchTextF.placeholder = @"查询";
    [self.searchTextF setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(getTextFieldContent)];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationController.navigationBar.tintColor = ZYColor(250, 66, 136);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    self.navigationItem.rightBarButtonItem = nil;
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.listC_source.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderListTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"Ordercell" forIndexPath:indexPath];
    
    OrderListModel *listModel = self.listC_source[indexPath.row];
    [cell reloadViewWithModel:listModel];
    
    return cell;
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 190;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PerfectOrderDatailViewController *orderDetailVC = [[PerfectOrderDatailViewController alloc] init];
    OrderListModel *listModel = self.listC_source[indexPath.row];
    orderDetailVC.orderid = listModel.orderid;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
    
}

#pragma mark - Action -
- (void)leftBtnAction:(UIButton *)button {
    
    PerfrectQRCodeViewController *QRCodeC = [[PerfrectQRCodeViewController alloc] init];
    [self.navigationController pushViewController:QRCodeC animated:YES];
    
}



@end
