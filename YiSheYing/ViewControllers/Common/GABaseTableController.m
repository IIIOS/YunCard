//
//  GABaseTableController.m
//  YunCard
//
//  Created by Jinjin on 15/2/5.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "GABaseTableController.h"

@interface GABaseTableController ()


@end

@implementation GABaseTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.backgroundColor = [UIColor clearColor];
    if([self needSetCellInset])self.tableView.separatorInset = [self insetOfCell];
    for (NSString *string in [self registerCellNames]) {
        [self.tableView registerNib:[UINib nibWithNibName:string bundle:nil] forCellReuseIdentifier:string];
    }
    for (NSString *string in [self registerClassNames]) {
        [self.tableView registerClass:NSClassFromString(string) forCellReuseIdentifier:string];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    CGFloat tabBarHeight = self.hidesBottomBarWhenPushed?0:CGRectGetHeight(self.tabBarController.tabBar.frame);
    CGFloat height = SCREEN_HEIGHT-CGRectGetHeight(self.navigationController.navigationBar.frame)-tabBarHeight;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    
    [self reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self resignFileds];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - OverWrite
- (void)reloadData{

    [self.tableView reloadData];
}

- (NSArray *)registerCellNames{
    
    return @[@"GACommonCell"];
}

- (NSArray *)registerClassNames{

    return nil;
}

- (NSInteger)numberOfSection{
    
    return 0;
}

- (NSInteger)rowForSection:(NSInteger)section{
    
    return 0;
}

- (CGFloat)heightForIndexPath:(NSIndexPath *)path{

    return 45;
}

- (CGFloat)heightForHeaderInSection:(NSInteger)section{
    
    CGFloat height = 0.01;
    if (section==0) {
        height = kViewContentTopPadding;
    }
    return height;
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


}

- (void)resignFileds{

}
//Default: 0,0,0,0
- (UIEdgeInsets)insetOfCell{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (BOOL)needSetCellInset{      //默认NO
    return NO;
}

#pragma mark - UITableViewDelegate & DataSource
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self resignFileds];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self numberOfSection];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self rowForSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self heightForIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return [self heightForHeaderInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GACommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GACommonCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self didSelectRowAtIndexPath:indexPath];
}


-(void)viewDidLayoutSubviews
{
    if ([self needSetCellInset]) {
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:[self insetOfCell]];
        }
        
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:[self insetOfCell]];
        }
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self needSetCellInset]) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:[self insetOfCell]];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:[self insetOfCell]];
        }
    }
}
@end
