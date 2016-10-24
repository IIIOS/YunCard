//
//  YCSchoolShopDetailViewcontroller.m
//  YunCard
//
//  Created by Lwj on 15/12/2.
//  Copyright © 2015年 JiaJun. All rights reserved.
//

#import "YCSchoolShopDetailViewcontroller.h"
#import "DennyTextfiled.h"
@interface YCSchoolShopDetailViewcontroller ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *usrNameLabel;
//描述
@property (weak, nonatomic) IBOutlet UILabel *deacLabel;
//消费总额
@property (weak, nonatomic) IBOutlet DennyTextfiled *saleTextField;
//实际支付
@property (weak, nonatomic) IBOutlet UILabel *actureMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhekouLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeight;
@property (weak, nonatomic) IBOutlet UILabel *zhifuStytle;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (nonatomic,strong)NSDictionary *prams;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view2;
@end

@implementation YCSchoolShopDetailViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.zhifuStytle.textColor = [UIColor whiteColor];
    self.label1.textColor = [UIColor whiteColor];
    self.actureMoneyLabel.textColor = [UIColor colorWithHexRGB:@"#de444a"];
    self.label2.textColor = [UIColor colorWithHexRGB:@"#5095bf"];
    self.label3.textColor = [UIColor colorWithHexRGB:@"#5095bf"];
    self.view1.backgroundColor = [UIColor colorWithHexRGB:@"#5095bf"];
    self.view2.backgroundColor = [UIColor colorWithHexRGB:@"#5095bf"];
    self.view3.backgroundColor = [UIColor colorWithHexRGB:@"#5095bf"];
    YCUserModel *user =  [YCUserModel currentUser];
//    NSString *psw = [YCUserModel passwordForUser:user.studentNo];
//self.saleTextField.textre
    self.usrNameLabel.text = user.studentNo;
    if (self.titleStr) {
        self.title = self.titleStr;
    }else {
        self.title = @"百汇超市";
    }
    if (self.descStr) {
        self.deacLabel.textColor = [UIColor colorWithHexRGB:@"63a7c9"];
        self.deacLabel.text = [NSString stringWithFormat:@"%@",self.descStr];
        self.deacLabel.numberOfLines = 3;
        self.deacLabel.font = [UIFont systemFontOfSize:13];
        CGSize labsize = [self.deacLabel sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT)];
        self.labelHeight.constant = labsize.height;
    }
    if (self.discount) {
        CGFloat num = [self.discount floatValue] * 10.0;
        self.zhekouLabel.text = [NSString stringWithFormat:@"%.1f折",num];
    }
    _saleTextField.layer.cornerRadius = 7;
    _saleTextField.layer.borderWidth = 1;
    [_saleTextField addTarget:self action:@selector(textFieldfunction:) forControlEvents:UIControlEventEditingChanged];
    _saleTextField.layer.borderColor = [UIColor colorWithHexRGB:@"#63a7c9"].CGColor;
}


- (IBAction)surePayButtonPressed:(UIButton *)sender {
    if([YCUserModel currentUser].cardNo.length == 0&& ![[NSUserDefaults standardUserDefaults]objectForKey:@"Logouthehe"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的账号已经挂失,请解挂后重新登录再试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }else {
        float num = ([self.discount floatValue] * [self.saleTextField.text floatValue]);
        NSString *str = [NSString stringWithFormat:@"%.2f",num];
        NSString *moneySt = str;

        if (self.saleTextField.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入消费总额"];
        }else if ([moneySt doubleValue] <= 0){
            [SVProgressHUD showErrorWithStatus:@"实际支付金额需大于0元"];
        }else{
            NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
            YCUserModel *user =  [YCUserModel currentUser];
            NSString *psw = [YCUserModel passwordForUser:user.studentNo];
            NSString *stu_no = user.studentNo;
            [param setObject:stu_no forKey:@"stu_no"];
            [param setObject:psw forKey:@"password"];
            [param setObject:@"1" forKey:@"n"];
            [param setObject:@"123456789" forKey:@"t"];
            [param setObject:@"getBillInfo" forKey:@"action"];
            [param setObject:moneySt forKey:@"amount"];
            [param setObject:self.business_id forKey:@"business_id"];
            [SVProgressHUD show];
            [AFNManager postObject:param apiName:@"http://123.59.143.144:50000/yuncard/Htdoc/index.php" modelName:nil requestSuccessed:^(NSDictionary *responseObject) {
                [SVProgressHUD dismiss];
                NSString *str =responseObject[@"flow_information_id"];
                if (str.length!=0) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
                    YCUserModel *user =  [YCUserModel currentUser];
                    NSString *psw = [YCUserModel passwordForUser:user.studentNo];
                    NSString *stu_no = user.studentNo;
                    [dic setObject:stu_no forKey:@"stu_no"];
                    [dic setObject:psw forKey:@"password"];
                    [dic setObject:@"1" forKey:@"n"];
                    [dic setObject:@"123456789" forKey:@"t"];
                    [dic setObject:@"pay" forKey:@"action"];
                    [dic setObject:str forKey:@"flow_information_id"];
                    self.params = [NSDictionary dictionaryWithDictionary:dic];
                    NSString *tmpStr = [NSString stringWithFormat:@"%@确认支付%@元吗? (%@折))",responseObject[@"flow_information_id"],moneySt,responseObject[@"discount"]];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:tmpStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alert show];
                }
            } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
                ;
            }];
        }
    }
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//   //    if (self.saleTextField.text isKindOfClass:[]) {
////        <#statements#>
////    }
//    if (self.saleTextField.text.length > 7) {
//        return NO;
//    }
//    return YES;
//}
- (void)textFieldfunction:(UITextField *)textField
{
    if ([textField isEqual:self.saleTextField]) {
        float num = ([self.discount floatValue] * [self.saleTextField.text floatValue]);
        NSString *str = [NSString stringWithFormat:@"¥ %.2f",num];
        if (self.saleTextField.text.length > 8) {
            self.saleTextField.text = [self.saleTextField.text substringWithRange:NSMakeRange(0, 8)];
        }
        self.actureMoneyLabel.text  = str;
        self.actureMoneyLabel.textColor = [UIColor redColor];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [SVProgressHUD show];
        [AFNManager postObject:self.params apiName:@"http://123.59.143.144:50000/yuncard/Htdoc/index.php" modelName:nil requestSuccessed:^(id responseObject) {
            [SVProgressHUD dismiss];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付成功" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alert show];
        } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
            ;
        }];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}
@end
