//
//  JJChongzhiViewController.m
//  YunCard
//
//  Created by Denny on 15/12/24.
//  Copyright © 2015年 JiaJun. All rights reserved.
//

#import "JJChongzhiViewController.h"

@interface JJChongzhiViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UITextField *pswTextfied;
@property (weak, nonatomic) IBOutlet UIButton *ChongzhiButton;
@property(nonatomic,strong)NSString *moneyStr;

@end

@implementation JJChongzhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.moneyStr = @"100";//默认值
    self.title = @"云卡充值";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:@"AFPaySuccess" object:nil];
}

- (void)paySuccess{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    YCUserModel *curUser = [YCUserModel currentUser];
    curUser.cardBalance = curUser.cardBalance + [self.moneyStr integerValue]*100;
    [YCUserModel saveLoginUser:curUser];
    
}
- (IBAction)onButtonOne:(UIButton *)sender {
    sender.selected = YES;
    self.button2.selected = NO;
    self.button3.selected = NO;
    self.moneyStr = @"100";
}
- (IBAction)onButtonTwo:(UIButton *)sender {
    sender.selected = YES;
    self.button1.selected = NO;
    self.button3.selected = NO;
    self.moneyStr = @"200";
}
- (IBAction)onButtonThree:(UIButton *)sender {
    sender.selected = YES;
    self.button1.selected = NO;
    self.button2.selected = NO;
    self.moneyStr = @"500";
}

- (IBAction)onButtonPressed:(UIButton *)sender {
    if ([self check]) {
        if([YCUserModel currentUser].cardNo.length == 0&& ![[NSUserDefaults standardUserDefaults]objectForKey:@"Logouthehe"]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的账号已经挂失,请解挂后重新登录再试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            
            [alert show];
        }else {
            //
            YCUserModel *user = [YCUserModel currentUser];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:@"recharge" forKey:@"action"];
            [dic setObject:@([self.moneyStr floatValue] * 100) forKey:@"money"];
            [dic setObject:self.pswTextfied.text forKey:@"password"];
            [dic setObject:user.userName forKey:@"name"];
            [dic setObject:user.studentNo forKey:@"stu_no"];
            [SVProgressHUD showWithStatus:@"支付中.."];
            [AFNManager postObject:dic apiName:nil modelName:[YCOrderModel modelName] requestSuccessed:^(id responseObject) {
                
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
    }
}

-(BOOL)check
{
    if (self.moneyStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择充值金额"];
        return NO;
    }
    if (self.pswTextfied.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入充值密码"];
        return NO;
    }
    if (self.pswTextfied.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入充值密码"];
        return NO;
    }
    
    YCUserModel *user = [YCUserModel currentUser];
    if (![[YCUserModel passwordForUser:user.studentNo] isEqualToString:self.pswTextfied.text]) {
        [SVProgressHUD showErrorWithStatus:@"密码输入错误"];
        return NO;
    }
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"xyaxfGatewayTrade://"]]) {
        [UIAlertView bk_showAlertViewWithTitle:@"请先安装校园安心付，才能付款" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"安装"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex==1) {
                [[UIApplication	sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/xiao-yuan-an-xin-fu/id903647130?mt=8"]];
            }
        }];
        return NO;
    }
    return YES;
}

@end
