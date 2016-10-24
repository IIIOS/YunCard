//
//  YCSchoolShopViewController.m
//  YunCard
//
//  Created by Lwj on 15/12/2.
//  Copyright © 2015年 JiaJun. All rights reserved.
//

#import "YCSchoolShopViewController.h"
#import "YCSchoolShopDetailViewcontroller.h"
#import "YCSchoolShopCell.h"
#import "BusinessListModel.h"
#import <MJRefresh/MJRefresh.h>

@interface YCSchoolShopViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mainTableview;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong,nonatomic)NSMutableArray *dataSourceArray;
@property (weak, nonatomic) IBOutlet UIButton *howButton;
@property (nonatomic,assign)NSInteger page;


@end

@implementation YCSchoolShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"云卡商户";
    self.page = 1;
    self.mainTableview.tableFooterView = [[UIView alloc]init];

    self.mainTableview.tableHeaderView = self.headView;
    [self refreshDataFromNet];
    self.mainTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshDataFromNet];
    }];
    
    self.mainTableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreDataFromNet];
    }];

    }
- (void)refreshDataFromNet {
    self.page = 1;
    self.dataSourceArray = [NSMutableArray array];

    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    YCUserModel *user = [YCUserModel currentUser];
    NSString *psw = [YCUserModel passwordForUser:user.studentNo];
    NSString *stu_no = user.studentNo;
    [param setObject:stu_no forKey:@"stu_no"];
    [param setObject:psw forKey:@"password"];
    [param setObject:@"1" forKey:@"n"];
    [param setObject:@"123456789" forKey:@"t"];
    [param setObject:@"businessList" forKey:@"action"];
    [param setObject:@(10) forKey:@"page_size"];
    [param setObject:@(1) forKey:@"page"];
    self.howButton.hidden = YES;
    [SVProgressHUD show];
    [AFNManager postObject:param apiName:@"http://123.59.143.144:50000/yuncard/Htdoc/index.php" modelName:nil requestSuccessed:^(id responseObject) {
        NSArray *arrray = (NSArray *)responseObject;
        for (NSDictionary *dic in arrray) {
            [self.dataSourceArray addObject:[[BusinessListModel alloc]initWithDic:dic]];
        }
        [SVProgressHUD dismiss];
        [self.mainTableview reloadData];
        [self.mainTableview.mj_header endRefreshing];
    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
        [self.mainTableview.mj_header endRefreshing];
        [SVProgressHUD dismiss];

    }];

}

- (void)loadMoreDataFromNet{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    YCUserModel *user = [YCUserModel currentUser];
    NSString *psw = [YCUserModel passwordForUser:user.studentNo];
    NSString *stu_no = user.studentNo;
    [param setObject:stu_no forKey:@"stu_no"];
    [param setObject:psw forKey:@"password"];
    [param setObject:@"1" forKey:@"n"];
    [param setObject:@"123456789" forKey:@"t"];
    [param setObject:@"businessList" forKey:@"action"];
    [param setObject:@(10) forKey:@"page_size"];
    [param setObject:@(++self.page ) forKey:@"page"];
    self.howButton.hidden = YES;
    [SVProgressHUD show];
    [AFNManager postObject:param apiName:@"http://123.59.143.144:50000/yuncard/Htdoc/index.php" modelName:nil requestSuccessed:^(id responseObject) {
        NSArray *arrray = (NSArray *)responseObject;
        for (NSDictionary *dic in arrray) {
            [self.dataSourceArray addObject:[[BusinessListModel alloc]initWithDic:dic]];
        }
        [SVProgressHUD dismiss];
        [self.mainTableview reloadData];
        [self.mainTableview.mj_footer endRefreshing];
    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
        [self.mainTableview.mj_header endRefreshing];
        [SVProgressHUD dismiss];
        
    }];
}
//如何使用校商
- (IBAction)buttonPressed:(UIButton *)sender {
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BusinessListModel *model = self.dataSourceArray[indexPath.row];
    static  NSString  *CellIdentiferId = @"YCSchoolShopCellCellID";
    YCSchoolShopCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"YCSchoolShopCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.item = model;
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BusinessListModel *model = self.dataSourceArray[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YCSchoolShopDetailViewcontroller *vc = [[YCSchoolShopDetailViewcontroller alloc]init];
    vc.business_id = model.business_id;
    vc.discount = model.discount;
    vc.titleStr = model.name;
    vc.descStr = model.introduce;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}
@end
