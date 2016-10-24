//
//  YCNotiHisViewController.m
//  YunCard
//
//  Created by Jinjin on 15/11/18.
//  Copyright © 2015年 JiaJun. All rights reserved.
//

#import "YCNotiHisViewController.h"
#import "YCTradeHisCell.h"
#import "GAWebViewController.h"
#import "TimeUtils.h"
#import "GACommonCell.h"

@interface YCNotiHisViewController ()

@end

@implementation YCNotiHisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
     self.title = @"通知列表";
    [self.tableView registerNib:[UINib nibWithNibName:@"GACommonCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)refresh{
    [self refreshWithSuccessed:self.successBlock failed:self.failedBlock];
}

#pragma mark - 可选的重写方法
- (BOOL)showLodingView{
    
    return NO;
}

- (BOOL)shouldCacheArray{
    
    return NO;
}

- (NSString *)keyOfCachedArray{
    return NSStringFromClass([self class]);
}

//空数据界面的Frame
- (CGRect)noInfoViewFrame{
    
    return CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

//是否显示空数据占位图 默认为No
- (BOOL)showNoInfoView{
    return NO;
}

//空数据界面Action操作
- (void)noInfoActionButtonClicked:(id)sender{
    [self refresh];
}

//当没有数据的时候显示提示文本
- (NSString *)hintStringWhenNoData{
    return @"暂时没有记录";
}

//对数组进行预处理
- (NSArray *)preProcessData:(NSArray *)anArray{
    return anArray;
}
//是否开放加载更多的功能（默认YES）
- (BOOL)loadMoreEnable{
    return YES;
}

#pragma mark - 最终的子类必须重写的方法
//接口方法
- (NSString *)methodWithPath{
    
    return nil;
}

//自定义的cell布局文件
- (NSString *)nibNameOfCell{

    return nil;
}

//请求URL参数封装
- (NSDictionary *)dictParamWithPage:(NSInteger)page{
    
    YCUserModel *user = [YCUserModel currentUser];
    NSString *psw = [YCUserModel passwordForUser:user.studentNo];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    [param setObject:@"getJPushHistory" forKey:@"action"];
    if (user.studentNo)[param setObject:user.studentNo forKey:@"stu_no"];
    if (psw)[param setObject:psw forKey:@"password"];
    [param setObject:@(page) forKey:@"page_index"];
    [param setObject:kDefaultPageSize forKey:@"page_size"];
    return param;
}

- (NSString *)modelNameOfData{
    
    return @"YCNotiModel";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableViewCellHeightForData:(id)object atIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

//根据数据来布局界面
- (UIView *)layoutCellWithData:(id)object atIndexPath:(NSIndexPath *)indexPath{
    YCNotiModel *data = self.dataArray[indexPath.row];
    
    GACommonCell *cell = (id)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.gaNameLabel.text = data.title;
    cell.gaDetailLabel.text = [TimeUtils friendTimeStringForTimestamp:data.time];
    return cell;
}

- (void)clickedCell:(id)object atIndexPath:(NSIndexPath *)indexPath{
    YCNotiModel *data = self.dataArray[indexPath.row];
    [self pushViewController:@"GAWebViewController" withParams:@{@"title":@"通知详细",@"url":data.url?:@" "}];
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
