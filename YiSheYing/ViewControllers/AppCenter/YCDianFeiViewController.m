//
//  YCDianFeiViewController.m
//  YunCard
//
//  Created by Jinjin on 15/9/9.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YCDianFeiViewController.h"
#import "GABorderView.h"
#import "MButton.h"
#import "NIDropDown.h"

@interface YCDianFeiViewController ()<UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet GABorderView *topView;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UITextField *yueField;
@property (nonatomic, weak) IBOutlet UIButton *buildingBtn;
@property (nonatomic, weak) IBOutlet UIButton *roomBtn;

@property (nonatomic, strong) NIDropDown *dropDown;
@property (nonatomic, strong) NSMutableArray *btnsArray;
@property (nonatomic, strong) UITextField *inputField;

@property (nonatomic, strong) NSArray *roomsData;


@property (nonatomic, strong) NSString *building;
@property (nonatomic, strong) NSString *room;


- (IBAction)pickerBtnDidTap:(id)sender;
@end

@implementation YCDianFeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-63);
    self.scrollView.delegate = self;
    self.title = @"缴纳电费";
    
    //btn_dianfei
    UIImage *image = [[UIImage imageNamed:@"btn_dianfei"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 3, 13, 34)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.roomBtn.frame];
    imageView.image = image;
    [self.roomBtn.superview insertSubview:imageView belowSubview:self.roomBtn];
    
    imageView = [[UIImageView alloc] initWithFrame:self.buildingBtn.frame];
    imageView.image = image;
    [self.buildingBtn.superview insertSubview:imageView belowSubview:self.buildingBtn];
   
    //line
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 55-kDefaultBorderWidth, SCREEN_WIDTH, kDefaultBorderWidth)];
    line.backgroundColor = kDefaultBorderColor;
    [self.topView addSubview:line];
    line = [[UIView alloc] initWithFrame:CGRectMake(0, 110-kDefaultBorderWidth, SCREEN_WIDTH, kDefaultBorderWidth)];
    line.backgroundColor = kDefaultBorderColor;
    [self.topView addSubview:line];
    
    CGFloat offset = 25;
    CGFloat padding = 15;
    CGFloat width = (SCREEN_WIDTH-offset*2-padding*2)/3;
    
    self.btnsArray = [NSMutableArray array];
    
    NSArray *texts = @[@"20元",@"50元",@"100元"];
    for (NSInteger index=0; index<3; index++) {
        
        CGRect frame = CGRectMake(padding+index*(width+offset), 220, width, 30);
            MButton *actionButton = [MButton new];
            actionButton.layer.cornerRadius =3;
            actionButton.tag = index;
            [actionButton setNormalColor:RGB(206, 206, 206) SelectColor:RGB(237, 127, 52)];
            [actionButton setTitle:texts[index] forState:UIControlStateNormal];
            actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [actionButton addTarget:self action:@selector(didChoose:) forControlEvents:UIControlEventTouchUpInside];
            actionButton.frame = frame;
            actionButton.selected = index==0;
            [self.scrollView addSubview:actionButton];
            [self.btnsArray addObject:actionButton];
    }
    
    MButton *actionButton = [MButton new];
    actionButton.layer.cornerRadius = 5;
    [actionButton setNormalColor:kDefaultBlueColor SelectColor:[kDefaultBlueColor colorWithAlphaComponent:0.5]];
    [actionButton setTitle:@"立即充值" forState:UIControlStateNormal];
    actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [actionButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    actionButton.frame = CGRectMake(padding, 355, SCREEN_WIDTH-padding*2, 44);
    [self.scrollView addSubview:actionButton];
    
    MButton *yueButton = [MButton new];
    yueButton.layer.cornerRadius = 4;
    [yueButton setNormalColor:RGB(234, 78, 91) SelectColor:[RGB(234, 78, 91) colorWithAlphaComponent:0.5]];
    [yueButton setTitle:@"点击查询余额" forState:UIControlStateNormal];
    yueButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [yueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yueButton addTarget:self action:@selector(refreshYue) forControlEvents:UIControlEventTouchUpInside];
    yueButton.frame = CGRectMake(210, 13, 100, 30);
    [self.yueField.superview addSubview:yueButton];
    
   self.roomsData = [self cachedObjectByKey:@"YCLoudongModel"];
    [self loadDefaultData];
    
    
    if (self.building && self.room) {
        
        [self refreshYue:NO];
    }
}

- (void)loadDefaultData{
    
    YCLoudongModel *model = [self.roomsData firstObject];
    self.room = [model.room firstObject];
    self.building = model.loudong;
    
}

- (void)setBuilding:(NSString *)building{

    _building = building;
    
    [self.buildingBtn setTitle:[NSString stringWithFormat:@"   %@",_building?:@"选择寝室号"] forState:UIControlStateNormal];
    
//    UIImage *image = [[UIImage imageNamed:@"btn_dianfei"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 3, 13, 34)];
//    [self.buildingBtn setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)setRoom:(NSString *)room{
    _room = room;
    
    [self.roomBtn setTitle:[NSString stringWithFormat:@"   %@",_room?:@"选择寝室号"] forState:UIControlStateNormal];
//    UIImage *image = [[UIImage imageNamed:@"btn_dianfei"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 3, 13, 34)];
//    [self.roomBtn setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super   viewWillAppear:animated];
    [self requestRoomData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)pickerBtnDidTap:(id)sender{
    NSMutableArray *array = [@[] mutableCopy];
    
    if (sender==self.buildingBtn) {
        for (YCLoudongModel *model in self.roomsData) {
            [array addObject:model.loudong];
        }
    }
    if (sender==self.roomBtn) {
        for (YCLoudongModel *model in self.roomsData) {
            if ([model.loudong isEqualToString:self.building]) {
                array = [model.room mutableCopy];
                break;
            }
        }
    }
    
    if(self.dropDown == nil) {
        CGFloat f = 200;
        self.dropDown = [[NIDropDown alloc] showDropDown:sender height:&f data:array imgArr:nil direction:@"down"];
        self.dropDown.delegate = (id)self;
    }
    else {
        [self.dropDown hideDropDown:sender];
        self.dropDown = nil;
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender value:(NSString *)value{
    
    if (sender.btnSender==self.buildingBtn) {
        self.building = value;
    }
    if (sender.btnSender==self.roomBtn) {
        self.room = value;
    }
    
    [self.dropDown hideDropDown:nil];
    self.dropDown = nil;
}

#pragma mark - UIPickerViewDataSource Implementation


- (void)requestRoomData{
    WS(ws);
    [AFNManager  postObject:@{@"action":@"readLoudongInfo"}
                    apiName:nil
                  modelName:@"YCLoudongModel"
           requestSuccessed:^(id responseObject){
               ws.roomsData = responseObject;
               if (nil==ws.room) {
                   [ws loadDefaultData];
               }
               [ws saveObjectToCache:responseObject toKey:@"YCLoudongModel"];
           }
             requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
             }];
}
- (void)refreshYue{

    [self refreshYue:YES];
}

- (void)refreshYue:(BOOL)showMessage{
    
    if ([StringUtils isEmpty:self.building]) {
        [SVProgressHUD showErrorWithStatus:@"请选择楼栋"];
        return;
    }
    if ([StringUtils isEmpty:self.room]) {
        [SVProgressHUD showErrorWithStatus:@"请选择寝室号"];
        return;
    }
    
    
    WS(ws);
    if (showMessage) [SVProgressHUD showWithStatus:@"查询中.."];
    [AFNManager  postObject:@{@"action":@"readElect",@"room":self.room,@"loudongId":self.building}
                    apiName:nil
                  modelName:nil
           requestSuccessed:^(id responseObject){
               NSString *restElect = responseObject[@"restElect"];
               ws.yueField.text = [NSString stringWithFormat:@"%@",restElect];
                if (showMessage) [SVProgressHUD showSuccessWithStatus:@"查询成功"];
           }
             requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
                 
                     if (showMessage) [SVProgressHUD showErrorWithStatus:errorMessage?:@"查询失败\n请稍后再试"];
             }];
}

- (void)didChoose:(UIButton *)tbtn{
    
    for (UIButton *btn in self.btnsArray) {
        btn.selected = NO;
    }
    tbtn.selected = YES;
    self.inputField.text = nil;
}

- (void)send{
 
    if ([StringUtils isEmpty:self.building]) {
        [SVProgressHUD showErrorWithStatus:@"请选择楼栋"];
        return;
    }
    if ([StringUtils isEmpty:self.room]) {
        [SVProgressHUD showErrorWithStatus:@"请选择寝室号"];
        return;
    }
    
    NSString *money = @"0";
        for (UIButton *btn in self.btnsArray) {
            if (btn.selected) {
                switch ([self.btnsArray indexOfObject:btn]) {
                    case 0:
                        money = @"20";
                        break;
                        case 1:
                        money = @"50";
                        break;
                    case 2:
                        money = @"100";
                        break;
                    default:
                        break;
                }
                
                break;
            }
        }
    
    
    
    CGFloat m = [money floatValue];
    if ([StringUtils isEmpty:money] || m<=0) {
        [SVProgressHUD showErrorWithStatus:@"请选择正确的充值金额"];
        return;
    }
    
    if ([StringUtils isEmpty:self.passwordField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入一卡通密码"];
        return;
    }
    
    YCUserModel *user = [YCUserModel currentUser];
    NSMutableDictionary *dict = [@{} mutableCopy];
    
    if (user.studentNo) [dict setObject:user.studentNo forKey:@"stu_no"];
    [dict setObject:@"buyElect" forKey:@"action"];
    [dict setObject:self.room forKey:@"room"];
    [dict setObject:self.building forKey:@"loudongId"];
    [dict setObject:self.passwordField.text forKey:@"password"];
    [dict setObject:[NSString stringWithFormat:@"%.0f",m*100] forKey:@"tradeMoney"];
    /*
     "studentNo":"201520152015",
     "action":"buyElect",
     "room":"102",
     "loudongId":"51",
     "password":"111111",
     "tradeMoney":"3000"
     */
    
    WS(ws);
    if([YCUserModel currentUser].cardNo.length == 0 && ![[NSUserDefaults standardUserDefaults]objectForKey:@"Logouthehe"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的账号已经挂失，请解挂后重新登录再试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [SVProgressHUD showWithStatus:@"充值中.."];
    [AFNManager  postObject:dict
                    apiName:nil
                  modelName:nil
           requestSuccessed:^(id responseObject){
               [ws refreshYue:NO];
               
               YCUserModel *curUser = [YCUserModel currentUser];
               curUser.cardBalance = curUser.cardBalance - m*100;
               [YCUserModel saveLoginUser:curUser];
//               [ws getUserInfo];
               
               [SVProgressHUD dismiss];
               [UIAlertView bk_showAlertViewWithTitle:@"充值成功。电量余额更新较慢，请次日查询请次日查询。" message:nil cancelButtonTitle:@"好的" otherButtonTitles:nil handler:NULL];
           }
             requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
                 [SVProgressHUD showErrorWithStatus:errorMessage?:@"充值失败\n请稍后再试"];
             }];
}
//
//- (void)getUserInfo{
//    
//    YCUserModel *user = [YCUserModel currentUser];
//    NSMutableDictionary *dict = [@{} mutableCopy];
//    
//    if (user.studentNo) {
//        [dict setObject:user.studentNo forKey:@"stu_no"];
//        [dict setObject:@"getUserInfo" forKey:@"action"];
//        [AFNManager  postObject:dict
//                        apiName:nil
//                      modelName:@"YCUserModel"
//               requestSuccessed:^(id responseObject){
//                   
//                   YCUserModel *newUser = (id)responseObject;
//                   if ([newUser isKindOfClass:[YCUserModel class]]) {
//                       [YCUserModel saveLoginUser:newUser];
//                   }
//               }
//                 requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
//                     
//                 }];
//    }
//}

- (void)resigin{
    
    [self.dropDown hideDropDown:nil];
    self.dropDown = nil;
    
    [self.inputField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self resigin];
}

- (UITextField *)inputField{
    if (nil==_inputField) {
        
        _inputField = [[UITextField alloc] init];
        _inputField.keyboardType = UIKeyboardTypeNumberPad;
        _inputField.borderStyle = UITextBorderStyleRoundedRect;
        _inputField.textAlignment = NSTextAlignmentCenter;
        _inputField.delegate = self;
    }
    return _inputField;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField==self.inputField) {
        
        [self didChoose:nil];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, -100, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    return YES;
}
@end
