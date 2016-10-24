//
//  YCGuaShiViewController.m
//  YunCard
//
//  Created by Jinjin on 15/8/22.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YCGuaShiViewController.h"
#import "MButton.h"
#import "YCCardView.h"
#import "ZCTradeView.h"
@interface YCGuaShiViewController ()<UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet YCCardView *cardView;
@property (nonatomic, strong) MButton *actionButton;

@end

@implementation YCGuaShiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"云卡挂失";
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-63);
    
    self.actionButton = [MButton new];
    self.actionButton.layer.cornerRadius =5;
    [self.actionButton setNormalColor:RGB(234, 78, 91) SelectColor:[RGB(234, 78, 91) colorWithAlphaComponent:0.5]];
    
    [self.actionButton setTitle:@"确认挂失" forState:UIControlStateNormal];
    self.actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.actionButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    self.actionButton.frame = CGRectMake(20, 215, SCREEN_WIDTH-20*2, 44);
    [self.scrollView addSubview:self.actionButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.cardView bindDataWithModel:[YCUserModel currentUser]];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//- (void)getCardStatus{
//
//    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
//    if ([YCUserModel currentUser].studentNo)[param setObject:[YCUserModel currentUser].studentNo forKey:@"stu_no"];
//    [param setObject:@"handLost" forKey:@"action"];
//    if ([YCUserModel currentUser].cardNo)[param setObject:[YCUserModel currentUser].cardNo forKey:@"card_no"];
//    [param setObject:password forKey:@"password"];
//    [param setObject:@"1" forKey:@"op"]; //1 挂失 2 解挂
//
//    [SVProgressHUD showWithStatus:@"挂失中.."];
//    [AFNManager  postObject:param
//                    apiName:nil
//                  modelName:@"BaseModel"
//           requestSuccessed:^(id responseObject) {
//               NSDictionary *dict = responseObject;
//               //"cardStatus": "1" 卡状态0正常 1已挂失 2 已冻结
//               NSInteger status = [dict[@"cardStatus"] integerValue];
//               switch (status) {
//                   case 0:
//                       [SVProgressHUD showErrorWithStatus:@"挂失失败\n请稍后再试"];
//                       break;
//                   case 1:
//                       [SVProgressHUD showSuccessWithStatus:@"已挂失"];
//                       break;
//                   case 2:
//                       [SVProgressHUD showErrorWithStatus:@"挂失失败\n卡片已冻结"];
//                       break;
//
//                   default:
//                       break;
//               }
//           }
//             requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
//                 [SVProgressHUD showErrorWithStatus:errorMessage?:@"挂失失败\n请稍后再试"];
//             }];
//}

- (void)submit{
    if([YCUserModel currentUser].cardNo.length == 0&& ![[NSUserDefaults standardUserDefaults]objectForKey:@"Logouthehe"]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你的帐号已经挂失,请勿重新挂失" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入登录密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"挂失", nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        
        UITextField *filed = [alertView textFieldAtIndex:0];
        
        NSString *password = filed.text;
        
        if ([StringUtils isEmpty:password]) {
            [SVProgressHUD showErrorWithStatus:@"请输入密码"];
            return;
        }
        
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
        if ([YCUserModel currentUser].studentNo)[param setObject:[YCUserModel currentUser].studentNo forKey:@"stu_no"];
        [param setObject:@"handLost" forKey:@"action"];
        if ([YCUserModel currentUser].cardNo)[param setObject:[YCUserModel currentUser].cardNo forKey:@"card_no"];
        [param setObject:password forKey:@"password"];
        [param setObject:@"1" forKey:@"op"]; //1 挂失 2 解挂
        
        WS(ws);
        
        [SVProgressHUD showWithStatus:@"挂失中.."];
        [AFNManager  postObject:param
                        apiName:nil
                      modelName:@"BaseModel"
               requestSuccessed:^(id responseObject) {
                   [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Logouthehe"];
                   [YCUserModel logout];
                   [AFLoginController forceLoginAndShowMessage:NO];
//                   NSDictionary *dict = responseObject;
//                   //"cardStatus": "1" 卡状态0正常 1已挂失 2 已冻结
//                   NSInteger status = [dict[@"cardStatus"] integerValue];
//                   switch (status) {
//                       case 0:
//                           [UIAlertView bk_showAlertViewWithTitle:@"挂失失败\n请稍后再试" message:nil cancelButtonTitle:@"好的" otherButtonTitles:nil handler:NULL];
//                           break;
//                       case 1:
//                           [UIAlertView bk_showAlertViewWithTitle:@"已挂失" message:nil cancelButtonTitle:@"好的" otherButtonTitles:nil handler:NULL];
//                           break;
//                       case 2:
//                           [UIAlertView bk_showAlertViewWithTitle:@"挂失失败\n卡片已冻结" message:nil cancelButtonTitle:@"好的" otherButtonTitles:nil handler:NULL];
//                           break;
//                           
//                       default:
//                           break;
//                   }
//                   [ws setBtnStatus:status];
                   [SVProgressHUD dismiss];
               }
                 requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
                     [SVProgressHUD showErrorWithStatus:errorMessage?:@"你的帐号已经挂失,请勿重新挂失"];
                 }];
    }
}

- (void)setBtnStatus:(NSInteger)status{
    
    switch (status) {
        case 0:
            [self.actionButton setTitle:@"确认挂失" forState:UIControlStateNormal];
            self.actionButton.userInteractionEnabled = YES;
            break;
        case 1:
            [self.actionButton setTitle:@"已挂失" forState:UIControlStateNormal];
            self.actionButton.userInteractionEnabled = NO;
            break;
        case 2:
            [self.actionButton setTitle:@"卡片已冻结" forState:UIControlStateNormal];
            self.actionButton.userInteractionEnabled = NO;
            break;
            
        default:
            break;
    }
}
@end
