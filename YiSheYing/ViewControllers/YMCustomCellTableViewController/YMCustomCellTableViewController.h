//
//  YMCustomCellTableViewController.h
//  YunCard
//
//  Created by helfy  on 15/6/14.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import <UIKit/UIKit.h>

//为保证刷新机制一致。。。继承于BasePullToRefreshTableViewController
#import "BasePullToRefreshTableViewController.h"
@interface YMCustomCellTableViewController : BasePullToRefreshTableViewController


//如需自定义布局。则重载
-(void)setupView;

//identifier 为 kCellIdentifier
-(void)registerClass:(Class)cellClass;

//identifier 为 kCellIdentifier
-(void)registerNib:(NSString *)nibName;


//  自定义identifier。。用于tableView 中多个identifier使用
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;
@end
