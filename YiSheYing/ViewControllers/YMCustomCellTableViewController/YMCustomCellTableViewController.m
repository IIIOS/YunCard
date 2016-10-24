//
//  YMCustomCellTableViewController.m
//  YunCard
//
//  Created by helfy  on 15/6/14.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YMCustomCellTableViewController.h"
#import "YMBaseTableViewCell.h"
@interface YMCustomCellTableViewController ()
{
    UITableView *tableView;
    
    Class tableCllClass;
}
@end

@implementation YMCustomCellTableViewController
@synthesize tableView =_tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view insertSubview:self.tableView atIndex:0];
 
    [self setupView];
    
    self.tableView.backgroundColor = RGB(244, 244, 244);
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - setupView  默认tableView全屏。。如需要重新布局。这重载该方法

-(void)setupView
{
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}
#pragma getter  父类不会创建tabView 而手写代码生成tableview
-(UITableView *)tableView
{
    if(tableView == nil && _tableView == nil)
    {
        tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.dataSource =(id) self;
        tableView.delegate  = (id)self;
        tableView.backgroundColor = [UIColor redColor];
    
    }
    
    return _tableView?_tableView:tableView;
}


#pragma mark     设置tableView
//identifier 为 kCellIdentifier
-(void)registerClass:(Class)cellClass
{
    tableCllClass = cellClass;
    [self registerClass:cellClass forCellReuseIdentifier:kCellIdentifier];
}
-(void)registerNib:(NSString *)nibName
{
    tableCllClass = NSClassFromString(nibName);
    [self.tableView registerNib:[UINib nibWithNibName:nibName bundle:nil]  forCellReuseIdentifier:kCellIdentifier];

}
//  自定义identifier。。用于tableView 中多个identifier使用
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier
{
    [self.tableView registerClass:cellClass forCellReuseIdentifier:identifier];
}
#pragma mark - 最终的子类必须重写的方法
//接口方法
- (NSString *)methodWithPath{
    return @"";
}

//自定义的cell布局文件
- (NSString *)nibNameOfCell{
    return @"";
}


//请求URL参数封装
- (NSDictionary *)dictParamWithPage:(NSInteger)page{

    return nil;
}

- (NSString *)modelNameOfData{
    
    return nil;
}

- (CGFloat)tableViewCellHeightForData:(id)object atIndexPath:(NSIndexPath *)indexPath{

    return [tableCllClass cellHeigthForData:object];
}
//根据数据来布局界面
- (UIView *)layoutCellWithData:(id)object atIndexPath:(NSIndexPath *)indexPath{
    
    YMBaseTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.delegate = (id)self;
    [cell bindData:object];
    return cell;
}


- (void)clickedCell:(id)object atIndexPath:(NSIndexPath *)indexPath{
    
}
@end
