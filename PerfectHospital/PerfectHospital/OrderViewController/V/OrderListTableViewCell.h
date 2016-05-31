//
//  OrderListTableViewCell.h
//  PerfectHospital
//
//  Created by minfo019 on 16/5/5.
//  Copyright © 2016年 Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderListModel;
@interface OrderListTableViewCell : UITableViewCell

@property (nonatomic, strong) OrderListModel *orderListModel;

- (void)reloadViewWithModel:(OrderListModel *)model;

@end
