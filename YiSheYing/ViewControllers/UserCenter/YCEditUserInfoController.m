//
//  YCEditUserInfoController.m
//  YunCard
//
//  Created by Jinjin on 15/8/23.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YCEditUserInfoController.h"
#import "YMTextView.h"
#import "MButton.h"
#import "UIView+CGRectUtils.h"
#import "YMParametersTableViewCell.h"

@interface YCEditUserInfoController ()

@end

@implementation YCEditUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人设置";
    [self.tableView setTableFooterView:[self tableViewFooterView]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setupData{
    
    [super setupData];
    NSMutableArray *array = [NSMutableArray array];
    
    YMParameterCellObj *obj = [[YMParameterCellObj alloc] initWithObjType:YMParameterCellObjTypeTextField];
    obj.name = @"手机号";
    obj.key = @"phone";
    obj.title = @"手机号:";
    obj.isRequired = NO;
    ((UITextField *)obj.accessoryView).placeholder = nil;//@"请输入反馈信息";
    ((UITextField *)obj.accessoryView).textAlignment = NSTextAlignmentRight;
    obj.cellHeigth = 45;
    [array addObject:obj];
    
    [self.cellObjs addObject:array];
    
    
    array = [NSMutableArray array];
    obj = [[YMParameterCellObj alloc] initWithObjType:YMParameterCellObjTypeLabel];
    obj.title = @"姓名:";
    ((UILabel *)obj.accessoryView).text = nil;
    ((UILabel *)obj.accessoryView).textAlignment = NSTextAlignmentRight;
    obj.cellHeigth = 45;
    [array addObject:obj];
    
    obj = [[YMParameterCellObj alloc] initWithObjType:YMParameterCellObjTypeLabel];
    obj.title = @"学号:";
    ((UILabel *)obj.accessoryView).text = nil;
    ((UILabel *)obj.accessoryView).textAlignment = NSTextAlignmentRight;
    obj.cellHeigth = 45;
    [array addObject:obj];
    
    obj = [[YMParameterCellObj alloc] initWithObjType:YMParameterCellObjTypeLabel];
    obj.title = @"校区:";
    ((UILabel *)obj.accessoryView).text = nil;
    ((UILabel *)obj.accessoryView).textAlignment = NSTextAlignmentRight;
    obj.cellHeigth = 45;
    [array addObject:obj];
    
    obj = [[YMParameterCellObj alloc] initWithObjType:YMParameterCellObjTypeLabel];
    obj.title = @"学院:";
    ((UILabel *)obj.accessoryView).text = nil;
    ((UILabel *)obj.accessoryView).textAlignment = NSTextAlignmentRight;
    obj.cellHeigth = 45;
    [array addObject:obj];
    
    obj = [[YMParameterCellObj alloc] initWithObjType:YMParameterCellObjTypeLabel];
    obj.title = @"专业:";
    ((UILabel *)obj.accessoryView).text = nil;
    ((UILabel *)obj.accessoryView).textAlignment = NSTextAlignmentRight;
    obj.cellHeigth = 45;
    [array addObject:obj];
    
    obj = [[YMParameterCellObj alloc] initWithObjType:YMParameterCellObjTypeLabel];
    obj.title = @"生源地:";
    ((UILabel *)obj.accessoryView).text = nil;
    ((UILabel *)obj.accessoryView).textAlignment = NSTextAlignmentRight;
    obj.cellHeigth = 45;
    [array addObject:obj];
    
    obj = [[YMParameterCellObj alloc] initWithObjType:YMParameterCellObjTypeLabel];
    obj.title = @"毕业院校:";
    ((UILabel *)obj.accessoryView).text = nil;
    ((UILabel *)obj.accessoryView).textAlignment = NSTextAlignmentRight;
    obj.cellHeigth = 45;
    [array addObject:obj];
    
    obj = [[YMParameterCellObj alloc] initWithObjType:YMParameterCellObjTypeLabel];
    obj.title = @"家庭住址:";
    ((UILabel *)obj.accessoryView).text = nil;//@"请输入反馈信息";
    ((UILabel *)obj.accessoryView).textAlignment = NSTextAlignmentRight;
    obj.cellHeigth = 45;
    [array addObject:obj];
    
    obj = [[YMParameterCellObj alloc] initWithObjType:YMParameterCellObjTypeLabel];
    obj.title = @"民族:";
    ((UILabel *)obj.accessoryView).text = nil;//@"请输入反馈信息";
    ((UILabel *)obj.accessoryView).textAlignment = NSTextAlignmentRight;
    obj.cellHeigth = 45;
    [array addObject:obj];
    
    [self.cellObjs addObject:array];

    
    [self reloadData];
}

- (void)reloadData{
    
    YCUserModel *model = [YCUserModel currentUser];
    ((UITextField *)((YMParameterCellObj *)self.cellObjs[0][0]).accessoryView).text = model.phone;
    
    ((UILabel *)((YMParameterCellObj *)self.cellObjs[1][0]).accessoryView).text = model.userName.length?model.userName:@"不可修改";
    ((UILabel *)((YMParameterCellObj *)self.cellObjs[1][1]).accessoryView).text = model.studentNo.length?model.studentNo:@"不可修改";
    ((UILabel *)((YMParameterCellObj *)self.cellObjs[1][2]).accessoryView).text = model.school_zone.length?model.school_zone:@"不可修改";
    ((UILabel *)((YMParameterCellObj *)self.cellObjs[1][3]).accessoryView).text = model.department.length?model.department:@"不可修改";
    ((UILabel *)((YMParameterCellObj *)self.cellObjs[1][4]).accessoryView).text = model.major.length?model.major:@"不可修改"; //专业
    ((UILabel *)((YMParameterCellObj *)self.cellObjs[1][5]).accessoryView).text = model.from.length?model.from:@"不可修改";
    ((UILabel *)((YMParameterCellObj *)self.cellObjs[1][6]).accessoryView).text = model.graduated.length?model.graduated:@"不可修改";
    ((UILabel *)((YMParameterCellObj *)self.cellObjs[1][7]).accessoryView).text = model.home_address.length?model.home_address:@"不可修改";
    ((UILabel *)((YMParameterCellObj *)self.cellObjs[1][8]).accessoryView).text = model.nation.length?model.nation:@"不可修改";
    
//    ((UILabel *)[((YMParameterCellObj *)self.cellObjs[1][1]).accessoryView viewWithTag:10002]).text = model.from;
//    ((UITextField *)((YMParameterCellObj *)self.cellObjs[1][2]).accessoryView).text = model.graduated;
//    ((UITextField *)((YMParameterCellObj *)self.cellObjs[1][3]).accessoryView).text = model.home_address;
//    ((UILabel *)[((YMParameterCellObj *)self.cellObjs[1][4]).accessoryView viewWithTag:10002]).text = model.nation;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section==1) {
        
        return @"  基本信息";
    }else{
        return @"  录入信息";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)chooseView{
    UIView *chooseView = [[UIView alloc] init];
    chooseView.frameWidth = 200;
    
    MButton *actionButton = [MButton new];
    actionButton.layer.cornerRadius = 3;
    [chooseView addSubview:actionButton];
    
    [actionButton setNormalColor:kDefaultBlueColor SelectColor:[kDefaultBlueColor colorWithAlphaComponent:0.5]];
    [actionButton setImage:[UIImage imageNamed:@"cx_down_arrow_white"] forState:UIControlStateNormal];
    actionButton.frame = CGRectMake(SCREEN_WIDTH-50, 10, 45, 25);
    [actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(45));
        make.right.equalTo(chooseView);
        make.height.equalTo(@25);
        make.centerY.equalTo(chooseView);
    }];
    
    UILabel *textLabel = [UILabel new];
    [chooseView addSubview:textLabel];
    textLabel.text = nil;
    textLabel.tag = 10002;
    textLabel.textAlignment = NSTextAlignmentRight;
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(chooseView);
        make.right.equalTo(actionButton.mas_left).with.offset(-8);
        make.centerY.equalTo(chooseView);
    }];
    return chooseView;
}

#pragma mark - footer View
-(UIView *)tableViewFooterView
{
    UIView *footerView = [UIView new];
    footerView.frameHeight = 74;
    
    MButton *actionButton = [MButton new];
    [footerView addSubview:actionButton];
    actionButton.layer.cornerRadius =5;

    [actionButton setNormalColor:kDefaultBlueColor SelectColor:[kDefaultBlueColor colorWithAlphaComponent:0.5]];
    [actionButton setTitle:@"确认" forState:UIControlStateNormal];
    actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [actionButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView).offset(20);
        make.bottom.equalTo(footerView).offset(-10);
        make.trailing.equalTo(footerView).offset(-10).priorityHigh();
        make.leading.equalTo(footerView).offset(10).priorityHigh();
    }];
    return footerView;
}

- (void)submit{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSArray *array in self.cellObjs) {
        for (YMParameterCellObj *obj in array) {
            NSString *checkStr = [obj check] ;
            if(checkStr!= nil)
            {
                [SVProgressHUD showErrorWithStatus:checkStr];
                return;
            }else{
                if (obj.value && obj.key) [params setObject:obj.value forKey:obj.key];
            }
        }
    }
    
    
//    NSString *from = ((UILabel *)[((YMParameterCellObj *)self.cellObjs[1][1]).accessoryView viewWithTag:10002]).text;
//    NSString *nation = ((UILabel *)[((YMParameterCellObj *)self.cellObjs[1][4]).accessoryView viewWithTag:10002]).text;
//    
//    if (from) [params setObject:from forKey:@"from"];
//    if (nation) [params setObject:nation forKey:@"nation"];
    
    YCUserModel *user = [YCUserModel currentUser];
    //获取Order
    if (user.studentNo) [params setObject:user.studentNo forKey:@"stu_no"];
    [params setObject:@"editUserInfo" forKey:@"action"];
    [SVProgressHUD showWithStatus:@"修改中.."];
    WS(ws);
    [AFNManager postObject:params apiName:nil modelName:@"YCUserModel" requestSuccessed:^(id responseObject) {
     
        if ([responseObject isKindOfClass:[YCUserModel class]]) {
            [YCUserModel saveLoginUser:responseObject];
        }
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        [ws.navigationController popViewControllerAnimated:YES];
        
    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
        [SVProgressHUD showErrorWithStatus:errorMessage?:@"修改失败"];
        
    }];
}

- (void)chooseFrom{
    [self setEditing:NO];
    NSLog(@"选择生源地");
}
- (void)chooseNation{
    
    [self setEditing:NO];
    NSLog(@"选择民族");
}
@end
