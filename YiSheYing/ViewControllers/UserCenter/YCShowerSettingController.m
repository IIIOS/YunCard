//
//  YCShowerSettingController.m
//  YunCard
//
//  Created by Jinjin on 15/8/23.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YCShowerSettingController.h"
#import "GABorderView.h"

@interface YCShowerSettingController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) IBOutlet UIView *borderView1;
@property (nonatomic, weak) IBOutlet UIView *borderView2;

@property (nonatomic, weak) IBOutlet UITextField *delayField;
@property (nonatomic, weak) IBOutlet UITextField *maxMField;
@property (nonatomic, weak) IBOutlet UITextField *maxSField;

@property (nonatomic, strong) IBOutlet UIButton *saveBtn;

@property (nonatomic, strong) YCShowerSettingModel *model;
- (IBAction)saveSettingBtnDidTap:(id)sender;

@end

@implementation YCShowerSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"热水器设置";
    self.model = [[YCShowerSettingModel alloc] initWithString:[YCUserModel currentUser].wash_setting error:NULL];
    
    self.borderView1.layer.borderWidth = 0.65;
    self.borderView1.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.6] CGColor];
    
    self.borderView2.layer.borderWidth = 0.65;
    self.borderView2.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.6] CGColor];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveBtn];
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                   target:self
                                   action:nil];
    flexSpacer.width = -7;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:flexSpacer, leftButtonItem, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.model = [[YCShowerSettingModel alloc] initWithString:[YCUserModel currentUser].wash_setting error:NULL];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)setModel:(YCShowerSettingModel *)model{
    
    _model = model;
    self.delayField.text = model.delay_time?[NSString stringWithFormat:@"%.0f",model.delay_time]:nil;
    
    NSInteger min = model.delay_close / 60;
    self.maxMField.text = min?[NSString stringWithFormat:@"%li",min]:nil;
    
    NSInteger s = ((int)model.delay_close) % 60;
    self.maxSField.text = s?[NSString stringWithFormat:@"%li",s]:nil;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)saveSettingBtnDidTap:(id)sender{
    
    [self setEditing:NO];
    
    CGFloat maxMTime = [self.maxMField.text floatValue];
    CGFloat maxSTime = [self.maxSField.text floatValue];
    
    CGFloat maxTime = maxMTime*60 + maxSTime;
    CGFloat delayTime = [self.delayField.text floatValue];
    
    if (nil==self.model) {
        self.model = [YCShowerSettingModel new];
    }
    self.model.delay_close = maxTime;
    self.model.delay_time = delayTime;
    
    YCUserModel *userModel = [YCUserModel currentUser];
    userModel.wash_setting = [self.model toJSONString];
    [YCUserModel saveLoginUser:userModel];
    
    [SVProgressHUD showWithStatus:@"设置中.." maskType:SVProgressHUDMaskTypeClear];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    [param setObject:@"editUserInfo" forKey:@"action"];
    if (userModel.studentNo)[param setObject:userModel.studentNo forKey:@"stu_no"];
    if (userModel.wash_setting) [param setObject:userModel.wash_setting forKey:@"wash_setting"];
    
    WS(ws);
    [AFNManager  postObject:param
                    apiName:nil
                  modelName:@"BaseModel"
           requestSuccessed:^(id responseObject) {
               [SVProgressHUD showSuccessWithStatus:@"设置成功"];
               [ws.navigationController popViewControllerAnimated:YES];
           }
             requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
                 [SVProgressHUD showErrorWithStatus:errorMessage?:@"设置失败\n请稍后再试"];
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self viewBeginFirst:textField keyBoardHeight:ycSSKeyBoardHeight];
    return YES;
}


-(void)keyboardWillShow:(NSNotification *)notification{
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float height = rect.size.height;
    NSArray *fields = @[self.delayField,self.maxMField,self.maxSField];
    for (UITextField *field in fields) {
        if ([field isFirstResponder]) {
            [self viewBeginFirst:field keyBoardHeight:height];
            break;
        }
    }
}

static CGFloat ycSSKeyBoardHeight = 0;
- (void)viewBeginFirst:(UIView *)view keyBoardHeight:(CGFloat)height{
    
    ycSSKeyBoardHeight = height;
    
    [self.scrollView setContentInset:UIEdgeInsetsMake(self.scrollView.contentInset.top, self.scrollView.contentInset.left, height, self.scrollView.contentInset.right)];
    
    BOOL find = NO;
    CGFloat contentOffset = 0;
    CGRect fieldRect = [view convertRect:view.frame toView:self.scrollView];
    CGFloat margin = 30;
    CGFloat maxY = CGRectGetMaxY(fieldRect);
    CGFloat scrollHeight = CGRectGetHeight(self.scrollView.frame);
    if ((maxY+margin+height)>scrollHeight) {
        find = YES;
        contentOffset = maxY - (scrollHeight-height) + margin;
    }
    if(find){
        [self.scrollView setContentOffset:CGPointMake(0, contentOffset) animated:YES];
    }
}

-(void)keyboardWillHide:(NSNotification *)notification{
    [self.scrollView setContentInset:UIEdgeInsetsMake(self.scrollView.contentInset.top, self.scrollView.contentInset.left, 0, self.scrollView.contentInset.right)];
}
@end
