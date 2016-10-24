//
//  YCTestViewController.m
//  YunCard
//
//  Created by Lwj on 15/12/2.
//  Copyright © 2015年 JiaJun. All rights reserved.
//

#import "YCTestViewController.h"
#import "YCTestViewCell.h"
#import "MyTestModel.h"
@interface YCTestViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)UILabel *nodataLabel;
@end


@implementation YCTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的考试";
    self.nodataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMidY(self.view.bounds), SCREEN_WIDTH, 21)];
    self.nodataLabel.text = @"没有您的考试记录";
    self.nodataLabel.font = [UIFont systemFontOfSize:13];
    self.nodataLabel.textColor = [UIColor grayColor];
    self.nodataLabel.textAlignment = NSTextAlignmentCenter;
    self.mainTableView.tableFooterView = [[UIView alloc]init];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    self.dataSource = [NSMutableArray array];
    YCUserModel *user = [YCUserModel currentUser];
    NSString *psw = [YCUserModel passwordForUser:user.studentNo];
    NSString *stu_no = user.studentNo;
    [param setObject:stu_no forKey:@"stu_no"];
    [param setObject:psw forKey:@"password"];
    [param setObject:@"1" forKey:@"n"];
    [param setObject:@"123456789" forKey:@"t"];
    [param setObject:@"examination" forKey:@"action"];
    [SVProgressHUD show];
    [AFNManager postObject:param apiName:@"http://123.59.143.144:50000/yuncard/Htdoc/index.php" modelName:nil requestSuccessed:^(id responseObject) {
        [SVProgressHUD dismiss];

        NSArray *array = (NSArray *)responseObject;
        for (NSDictionary *dic in array) {
            [self.dataSource addObject:[[MyTestModel alloc] initWithDic:dic]];
        }
        if (self.dataSource.count == 0) {
            [self.mainTableView addSubview:self.nodataLabel];
        }else{
            [self.mainTableView reloadData];
        }
    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
        ;
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTestModel *model;
    if (self.dataSource.count != 0) {
         model = self.dataSource[indexPath.row];
    }
    static  NSString  *CellIdentiferId = @"YCTestViewCellrCellID";
    YCTestViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"YCTestViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.item = model;
    };
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
