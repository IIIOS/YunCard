//
//  YCPayViewController.m
//  YunCard
//
//  Created by Jinjin on 15/8/21.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YCChongzhiViewController.h"
#import "YMTextView.h"
#import "MButton.h"
#import "UIView+CGRectUtils.h"


@interface YCChongzhiViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) UITextField *amountField;

@property (nonatomic,assign) CGFloat m;
@end

@implementation YCChongzhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"云卡充值";
    [self.tableView setTableFooterView:[self tableViewFooterView]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:@"AFPaySuccess" object:nil];
}

- (void)paySuccess{
    [self.navigationController popViewControllerAnimated:YES];
    YCUserModel *curUser = [YCUserModel currentUser];
    curUser.cardBalance = curUser.cardBalance + self.m*100;
    [YCUserModel saveLoginUser:curUser];
    
//    [self getUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    YMParameterCellObj *obj = self.cellObjs[0][0];
    [ ((UITextField *)obj.accessoryView) becomeFirstResponder];
}

-(void)setupData{
    
    [super setupData];
    NSMutableArray *array = [NSMutableArray array];
    
    YMParameterCellObj *obj = [[YMParameterCellObj alloc] initWithObjType:YMParameterCellObjTypeCustomView];
    obj.name = @"充值金额";
    obj.title = @"充值金额：";
    obj.isRequired = NO;
    
    UIView *accessoryView = [UIView new];
    accessoryView.backgroundColor = [UIColor clearColor];
    accessoryView.frameWidth = 150;
    obj.accessoryView = accessoryView;
    
    UITextField *textField = [[UITextField alloc] init];
    [accessoryView addSubview:textField];
    textField.textAlignment = NSTextAlignmentRight;;
    textField.borderStyle = UITextBorderStyleNone;
    textField.placeholder = @"0";
    textField.text = @"100";
    textField.font = [UIFont systemFontOfSize:14];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.delegate = self;
    self.amountField = textField;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"元";
    label.font = [UIFont systemFontOfSize:14];
    [accessoryView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(accessoryView.mas_right);
        make.width.mas_equalTo(@20);
        make.top.mas_equalTo(accessoryView).offset(-1);
        make.bottom.mas_equalTo(accessoryView);
    }];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(label.mas_left);
        make.left.mas_equalTo(accessoryView);
        make.top.mas_equalTo(accessoryView);
        make.bottom.mas_equalTo(accessoryView);
    }];
    
    obj.cellHeigth = 40;
    [array addObject:obj];
    
    obj = [[YMParameterCellObj alloc] initWithObjType:YMParameterCellObjTypeTextField];
    obj.name = @"一卡通密码";
    obj.key = @"password";
    obj.title = @"一卡通密码:";
    obj.isRequired = YES;
    ((UITextField *)obj.accessoryView).placeholder = nil;//@"请输入反馈信息";
    ((UITextField *)obj.accessoryView).secureTextEntry = YES;
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
    [footerView addSubview:actionButton];
    actionButton.layer.cornerRadius =5;
    
    
    [actionButton setNormalColor:kDefaultBlueColor SelectColor:[kDefaultBlueColor colorWithAlphaComponent:0.5]];
    
    [actionButton setTitle:@"安心付支付" forState:UIControlStateNormal];
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
    
    //todo 
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"xyaxfGatewayTrade://"]]) {
        
        [UIAlertView bk_showAlertViewWithTitle:@"请先安装校园安心付，才能付款" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"安装"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
           
            if (buttonIndex==1) {
                [[UIApplication	sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/xiao-yuan-an-xin-fu/id903647130?mt=8"]];
            }
        }];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSArray *array in self.cellObjs) {
        for (YMParameterCellObj *obj in array) {
            NSString *checkStr = [obj check] ;
            if(checkStr!= nil)
            {
                [SVProgressHUD showErrorWithStatus:checkStr];
                return;
            }else{
                if (obj.value) {
                    
                    [params setObject:obj.value forKey:obj.key];
                }
            }
        }
    }
    
    NSInteger amount = [self.amountField.text integerValue];
    if (amount<=0) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确金额"];
        return;
    }
    
    YCUserModel *user = [YCUserModel currentUser];
    //获取Order
    if (user.studentNo) [params setObject:user.studentNo forKey:@"stu_no"];
    [params setObject:@(amount*100) forKey:@"money"];
    [params setObject:@"recharge" forKey:@"action"];
    [params setObject:user.userName forKey:@"name"];
    
    self.m = amount;
    
    [SVProgressHUD showWithStatus:@"支付中.."];
    
    [AFNManager postObject:params apiName:nil modelName:[YCOrderModel modelName] requestSuccessed:^(id responseObject) {
        
        [SVProgressHUD showWithStatus:@"跳转到安心付.."];
        
        YCOrderModel *model = responseObject;
        NSString *head = @"xyaxfGatewayTrade://";
        NSString *urlScheme = @"yuncardpay";
        
        NSString *payString = [NSString stringWithFormat:@"%@%@&order_no=%@&summary=%@&amount=%.2f&school_code=%@&school_account=%@&name=%@&sign=%@"
                               ,head
                               ,urlScheme
                               ,model.order_no
                               ,model.summary
                               ,model.amt
                               ,model.school_code
                               ,model.school_account
                               ,model.name
                               ,model.sign];
        NSLog(@"payString: %@",payString);
        NSURL *url = [NSURL URLWithString:[payString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication	sharedApplication] openURL:url];
    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
        
        [SVProgressHUD showErrorWithStatus:errorMessage?:@"支付失败"];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    BOOL should = YES;
    NSString *newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (![StringUtils isAllNumbers:newStr] && newStr.length) {
        should = NO;
    }else{
        if (newStr.length && [[newStr substringToIndex:1] isEqualToString:@"0"]) {
            should = NO;
        }
    }
    return should;
}
@end
