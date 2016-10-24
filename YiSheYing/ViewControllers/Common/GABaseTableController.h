//
//  GABaseTableController.h
//  YunCard
//
//  Created by Jinjin on 15/2/5.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "BaseViewController.h"

@interface GABaseTableController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

#pragma OverWrite
- (void)reloadData;
- (NSArray *)registerClassNames;  //Default: nil
- (NSArray *)registerCellNames;   //Default: @[@"GACommonCell"]
- (NSInteger)numberOfSection;   //Default: 0
- (NSInteger)rowForSection:(NSInteger)section; //Default: 0
- (CGFloat)heightForIndexPath:(NSIndexPath *)path;  //Default: 45
- (CGFloat)heightForHeaderInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; //Default: GACommonCell *cell
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)resignFileds;
- (UIEdgeInsets)insetOfCell;  //Default: 0,0,0,0
- (BOOL)needSetCellInset;       //默认NO
@end
