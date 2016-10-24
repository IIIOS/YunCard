//
//  YCSystemMessageController.m
//  YunCard
//
//  Created by Jinjin on 15/9/9.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YCSystemMessageController.h"
#import "GAWebViewController.h"

@interface YCSystemMessageController ()

@end

@implementation YCSystemMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"系统通知";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
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
    return @"暂时没有通知";
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
    
    return @"YCTradeHisCell";
}

//请求URL参数封装
- (NSDictionary *)dictParamWithPage:(NSInteger)page{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    if ([YCUserModel currentUser].studentNo)[param setObject:[YCUserModel currentUser].studentNo forKey:@"stu_no"];
//    [param setObject:@"getCardTransaction" forKey:@"action"];
//    [param setObject:@(page) forKey:@"page_index"];
//    [param setObject:kDefaultPageSize forKey:@"page_size"];
//    [param setObject:[TimeUtils timeStringFromDate:self.beginDate withFormat:@"yyyyMMddHHmmss"] forKey:@"begin_date"];
//    
//    NSDate *endDate = [TimeUtils endOfMonth:self.beginDate];
//    [param setObject:[TimeUtils timeStringFromDate:endDate withFormat:@"yyyyMMddHHmmss"] forKey:@"end_date"];
    return param;
}

- (NSString *)modelNameOfData{
    return nil;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//    return 25;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return nil;
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"明细";
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (CGFloat)tableViewCellHeightForData:(id)object atIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

//根据数据来布局界面
- (UIView *)layoutCellWithData:(id)object atIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = (id)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
  
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = @"123123123123123";
    
    return cell;
}

- (void)clickedCell:(id)object atIndexPath:(NSIndexPath *)indexPath{
 
    GAWebViewController *web = [[GAWebViewController alloc] init];
    [web loadUrl:@"http://baidu.com"];
    web.title = @"通知标题";
    [self.navigationController pushViewController:web animated:YES];
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
