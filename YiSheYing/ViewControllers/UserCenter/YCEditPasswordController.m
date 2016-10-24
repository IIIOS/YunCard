//
//  YCEditPasswordController.m
//  YunCard
//
//  Created by Jinjin on 15/8/23.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YCEditPasswordController.h"
#import "YMTextView.h"
#import "MButton.h"
#import "UIView+CGRectUtils.h"

@interface YCEditPasswordController ()

@end

@implementation YCEditPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"密码设置";
    [self.tableView setTableFooterView:[self tableViewFooterView]];
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


-(void)setupData{
    
    [super setupData];
    NSMutableArray *array = [NSMutableArray array];
    
    YMParameterCellObj *obj = [[YMParameterCellObj alloc] initWithObjType:YMParameterCellObjTypeTextField];
    obj.name = @"原始密码";
    obj.key = @"password";
    obj.title = @"输入原始密码:";
    obj.isRequired = YES;
    ((UITextField *)obj.accessoryView).placeholder = nil;//@"请输入反馈信息";
    ((UITextField *)obj.accessoryView).textAlignment = NSTextAlignmentRight;
    obj.cellHeigth = 45;
    [array addObject:obj];
   
    obj = [[YMParameterCellObj alloc] initWithObjType:YMParameterCellObjTypeTextField];
    obj.name = @"新密码";
    obj.key = @"new_password";
    obj.title = @"输入新密码:";
    obj.isRequired = YES;
    ((UITextField *)obj.accessoryView).placeholder = nil;//@"请输入反馈信息";
    ((UITextField *)obj.accessoryView).textAlignment = NSTextAlignmentRight;
    obj.cellHeigth = 45;
    [array addObject:obj];
    
    obj = [[YMParameterCellObj alloc] initWithObjType:YMParameterCellObjTypeTextField];
    obj.name = @"验证密码";
    obj.key = @"new_password";
    obj.title = @"再次输入:";
    obj.isRequired = YES;
    ((UITextField *)obj.accessoryView).placeholder = nil;//@"请输入反馈信息";
    ((UITextField *)obj.accessoryView).textAlignment = NSTextAlignmentRight;
    obj.cellHeigth = 45;
    [array addObject:obj];
    
    [self.cellObjs addObject:array];
}

#pragma mark - footer View
-(UIView *)tableViewFooterView
{
    UIView *footerView = [UIView new];
    footerView.frameHeight = 74;
    
    MButton *actionButton = [MButton new];
    actionButton.tag = 100;
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
                [params setObject:obj.value forKey:obj.key];
            }
        }
    }
    
    NSString *newPsw = ((YMParameterCellObj *)self.cellObjs[0][1]).value;
    NSString *rePsw = ((YMParameterCellObj *)self.cellObjs[0][2]).value;
    if (![newPsw isEqualToString:rePsw]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致"];
        return;
    }
    
    YCUserModel *user = [YCUserModel currentUser];
    //获取Order
    if (user.studentNo) [params setObject:user.studentNo forKey:@"stu_no"];
    [params setObject:@"changePassword" forKey:@"action"];
    [SVProgressHUD showWithStatus:@"设置中.."];
    WS(ws);
    MButton *button = (MButton *)[self.view viewWithTag:100];
    button.enabled = NO;
    [AFNManager postObject:params apiName:nil modelName:nil requestSuccessed:^(id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"设置成功"];
        [ws performSelector:@selector(onlogout) withObject:nil afterDelay:0.1];
        button.enabled = YES;
    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
        [SVProgressHUD showErrorWithStatus:errorMessage?:@"设置失败"];
        button.enabled = YES;
    }];
}
- (void)onlogout {
    [[NSUserDefaults standardUserDefaults]setObject:@"logout" forKey:@"Logouthehe"];
    [YCUserModel logout];
    [AFLoginController forceLoginAndShowMessage:NO];

}
@end
