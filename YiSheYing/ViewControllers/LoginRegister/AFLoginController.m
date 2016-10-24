//
//  AFLoginController.m
//  Whatstock
//
//  Created by Jinjin on 14/12/14.
//  Copyright (c) 2014年 AnnyFun. All rights reserved.
//

#import "AFLoginController.h"

@interface AFLoginController ()<UIScrollViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UILabel *areaCodeLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScroll;
@property (weak, nonatomic) IBOutlet UITextField *pswField;
@property (weak, nonatomic) IBOutlet UITextField *phoneInput;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (weak, nonatomic) IBOutlet UIImageView *nicknameImage;
@property (weak, nonatomic) IBOutlet UIImageView *pswImage;
@property (assign, nonatomic) BOOL needDissmiss;

- (IBAction)registerBtnDidTap:(id)sender;
- (IBAction)doneBtnDidTap:(id)sender;
- (IBAction)saveBtnDidTap:(id)sender;
@end

@implementation AFLoginController
- (void)dealloc
{
    NSLog(@"AFLoginController dealloc");
}

+ (BOOL)checkIsLoginAndPresentLoginControllerWithController:(UIViewController *)vc{
    BOOL isLogin = [YCUserModel isLogin];
    if (!isLogin) {
        AFLoginController *loginVC = [[AFLoginController alloc] initWithNibName:@"AFLoginController" bundle:nil];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [vc presentViewController:navi animated:YES completion:^{
            
        }];
    }
    return isLogin;
}

+ (void)forceLoginAndShowMessage:(BOOL) show{
    AFLoginController *loginVC = [[AFLoginController alloc] initWithNibName:@"AFLoginController" bundle:nil];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [[self hostNavigationController] presentViewController:navi animated:YES completion:^{
        if (show) [SVProgressHUD showErrorWithStatus:@"登录失效\n需要重新登录"];
    }];
}

+ (UINavigationController *)hostNavigationController{
    
    if ([[[UIApplication sharedApplication] delegate].window.rootViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)[[UIApplication sharedApplication] delegate].window.rootViewController.presentedViewController;
    }
    else {
        return ((UINavigationController *)[[UIApplication sharedApplication] delegate].window.rootViewController);
    }
}


+ (void)autoLogin{
    
    NSDate *lastLoginDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"AFLoginDate"];
    if ([[NSDate date] timeIntervalSinceDate:lastLoginDate] > (5*60)) {
        
        YCUserModel *user = [YCUserModel currentUser];
        NSString *phone = [YCUserModel phoneForUser:user.studentNo];
        NSString *psw = [YCUserModel passwordForUser:user.studentNo];
        if (phone && psw) {
            [AFNManager  postObject:@{@"password":psw,@"stu_no":phone,@"action":@"login"}
                            apiName:nil
                          modelName:[YCUserModel modelName]
                   requestSuccessed:^(id responseObject) {
                       if ([responseObject isKindOfClass:[YCUserModel class]]) {
                           [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"AFLoginDate"];
                           [YCUserModel saveLoginUser:responseObject];
                       }
                   }
                     requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
                     }];
        }
    }else{
        YCUserModel *user = [YCUserModel currentUser];
        NSMutableDictionary *dict = [@{} mutableCopy];
        
        if (user.studentNo) {
            [dict setObject:user.studentNo forKey:@"stu_no"];
            [dict setObject:@"getUserInfo" forKey:@"action"];
            [AFNManager  postObject:dict
                            apiName:nil
                          modelName:@"YCUserModel"
                   requestSuccessed:^(id responseObject){
                       
                       YCUserModel *newUser = (id)responseObject;
                       if ([newUser isKindOfClass:[YCUserModel class]]) {
                           [YCUserModel saveLoginUser:newUser];
                       }
                   }
                     requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
                         
                     }];
        }
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    CGFloat tmpbrght =[UIScreen mainScreen].brightness;
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:tmpbrght ]forKey:@"AFuserBright"];
    self.title = @"登录";
    self.view.backgroundColor = RGB(13, 28, 25);
    self.navigationController.navigationBarHidden = YES;
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back_navi"] style:UIBarButtonItemStylePlain target:self action:@selector(popButtonClicked:)];
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                   target:self
                                   action:nil];
    flexSpacer.width = - 4;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:flexSpacer, leftButtonItem, nil];
    
    WS(ws);
    self.contentScroll.delegate = self;
    [self.contentScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(ws.view);
    }];
        
    self.nicknameImage.image = [[UIImage imageNamed:@"login_bg_top"] stretchableImageWithLeftCapWidth:8 topCapHeight:7];
    self.pswImage.image = [[UIImage imageNamed:@"login_bg_bottom"] stretchableImageWithLeftCapWidth:8 topCapHeight:7];
    
    self.phoneInput.delegate = self;
    self.phoneInput.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"AFLoginPhoneValue"];
    self.phoneInput.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入你的学号" attributes:@{NSForegroundColorAttributeName:RGB(142, 142, 142),NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [self.phoneInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.phoneInput.superview);
        make.left.mas_equalTo(ws.phoneInput.superview).offset(40);
        make.right.mas_equalTo(ws.phoneInput.superview).offset(-10);
        make.height.mas_equalTo(42);
    }];

    self.pswField.delegate = self;
    self.pswField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"AFLoginPSWValue"];
    self.pswField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入你的密码" attributes:@{NSForegroundColorAttributeName:RGB(142, 142, 142),NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [self.pswField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.phoneInput.mas_bottom);
        make.left.mas_equalTo(ws.phoneInput.mas_left);
        make.right.mas_equalTo(ws.phoneInput.mas_right);
        make.height.mas_equalTo(42);
    }];

    
    UIImage *bgImage = [[UIImage imageNamed:@"btn_bar_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7) resizingMode:UIImageResizingModeStretch];
    [self.doneBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    bgImage = [[UIImage imageNamed:@"btn_bar_h"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7) resizingMode:UIImageResizingModeStretch];
    [self.doneBtn setBackgroundImage:bgImage forState:UIControlStateHighlighted];
    
    self.saveBtn.selected = self.pswField.text.length>0;
    
//    self.phoneInput.text = @"000020300032";
//    
//    self.pswField.text = @"111111";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    int y = (arc4random() % 10000000) + 10000000;
    NSLog(@"%d",y);
    self.contentScroll.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+1);
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
//    if (SCREEN_HEIGHT>568) [self.phoneInput becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.title = nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//- (IBAction)popButtonClicked:(id)sender {
//    [self hideKeyboard];
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
//}

- (IBAction)registerBtnDidTap:(id)sender {
    [self hideKeyboard];
}

- (IBAction)doneBtnDidTap:(id)sender{
    
    NSString *phone = self.phoneInput.text;
    NSString *psw = self.pswField.text ;
    
    [self resignFields];
    
    if (![self isPhoneOK:phone]) {
        [SVProgressHUD showErrorWithStatus:@"学号格式不正确\n请输入正确的学号"];
        return;
    }
    if (![self isPasswordOK:psw]) {
        [SVProgressHUD showErrorWithStatus:@"密码格式不正确\n请输入6-20位字母或数字"];
        return;
    }
    
    if (self.saveBtn.selected) {
        //保存密码 和 账号
        [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"AFLoginPhoneValue"];
        [[NSUserDefaults standardUserDefaults] setObject:psw forKey:@"AFLoginPSWValue"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Logouthehe"];
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AFLoginPhoneValue"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AFLoginPSWValue"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    WS(ws);
    [SVProgressHUD showWithStatus:@"登录中.." maskType:SVProgressHUDMaskTypeClear];
    [AFNManager  postObject:@{@"password":psw,@"stu_no":phone,@"action":@"login"}
                    apiName:nil
                  modelName:[YCUserModel modelName]
           requestSuccessed:^(id responseObject) {
               [YCUserModel saveLoginUser:responseObject];
               if ([YCUserModel isLogin]) {
                   
                   [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"AFLoginDate"];
                   
                   
                   [YCUserModel saveLoginInfo:phone password:psw forUser:[YCUserModel currentUser].studentNo];
                   [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                   [ws dismissViewControllerAnimated:YES completion:0];
               }else{
                   [SVProgressHUD showErrorWithStatus:@"登录失败,请稍后再试"];
               }
           }
             requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
                 [SVProgressHUD showErrorWithStatus:errorMessage?:@"登录失败\n请稍后再试"];
             }];
}

- (IBAction)avatarDidTap:(id)sender{
    
    return;
    
    NSString *stirng = [StringUtils changeResBaseUrl];
    stirng = [stirng stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    NSArray *compoents = [stirng componentsSeparatedByString:@"/"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"服务器已经切换为%@",compoents[0]] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [alert show];
    
    [YCUserModel logout];
    [AFLoginController forceLoginAndShowMessage:NO];
}

- (IBAction)saveBtnDidTap:(UIButton *)sender{
    [self hideKeyboard];
    sender.selected = !sender.selected;
}

- (void)resignFields{
    
    [self.phoneInput resignFirstResponder];
    [self.pswField resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self resignFields];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (SCREEN_HEIGHT<=568) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, 20-225, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (SCREEN_HEIGHT<=568) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *newStr = [[NSMutableString alloc] initWithString:textField.text];
    [newStr replaceCharactersInRange:range withString:string];
   
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.pswField) {
        [self doneBtnDidTap:nil];
    }else{
        [self.pswField becomeFirstResponder];
    }
    return YES;
}

- (BOOL)isPhoneOK:(NSString *)str{
    return ![StringUtils isEmpty:str];
}

- (BOOL)isPasswordOK:(NSString *)str{
    //6-20位 字母或数字
    return [StringUtils isPassword:str];
}

@end
