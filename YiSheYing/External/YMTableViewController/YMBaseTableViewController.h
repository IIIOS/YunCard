//
//  YMBaseTableViewController.h
//  reSearchDemo
//
//  Created by helfy  on 15-4-15.
//  Copyright (c) 2015年 Kiwaro. All rights reserved.
//


//#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "YMParameterCellObj.h"

@interface YMBaseTableViewController : BaseViewController
@property(nonatomic,assign) BOOL isSectionMode;  //

@property(nonatomic,strong)  UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *cellObjs;

-(void)setupTableView;
-(void)setupData;

- (UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

-(YMParameterCellObj *)cellObjForKey:(NSString *)key;
@end
