//
//  YSMineViewController.m
//  YunCard
//
//  Created by helfy  on 15/6/13.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YSMineViewController.h"
#import "UIView+CGRectUtils.h"
#import "YMParametersTableViewCell.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "GABorderView.h"
#import "MButton.h"
#import "YCNetwortUsage.h"

#define kInfoLabelHeight 28
@interface YSMineViewController ()
{
    
}

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *classLabel;
@property (nonatomic, strong) UILabel *networkLabel;

@property (nonatomic, strong) UIImageView *headImageView;
@end

@implementation YSMineViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
//        currentUser = [YSUserModel currentUser];
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"个人中心";
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;

//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollsToTop = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(6, 0, 0, 0);
    
    [self.tableView  mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.view);
        make.right.equalTo (self.view);
        make.top.equalTo (self.view);
        make.bottom.equalTo (self.view);
    }];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-30, SCREEN_WIDTH, 30)];
    versionLabel.font = [UIFont systemFontOfSize:13];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:versionLabel];
    versionLabel.text = [NSString stringWithFormat:@"版本号:V%@",AppVersion];
}

- (NSString *)networkUsage{
    NSInteger last = [[NSUserDefaults standardUserDefaults] integerForKey:@"YCNetWorkUseAge"];
    NSString *all = [YCNetwortUsage bytesToAvaiUnit:[YCNetwortUsage allUse] - last];
    return all;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupData];
    [self setHeadView];
    [self sutupFooterView];

    [self.tableView reloadData];
    
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
                       YCUserModel *user = [YCUserModel currentUser];
                       self.nameLabel.text = user.nickName;
                       self.infoLabel.text = user.department;
                       self.classLabel.text = user.grade;
                       [self.headImageView setImageWithURLString:user.headImg placeholderImage:kAvatarPlaceHolder];
                   }
               }
                 requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
                 }];
    }
    self.networkLabel.text = [NSString stringWithFormat:@"本次流量使用: %@",[self networkUsage]];
}
#pragma mark - DataSource
-(void)setupData
{
    [super setupData];
    NSMutableArray *array = [NSMutableArray array];
    YMParameterCellObj *obj = nil;
 
    obj = [[YMParameterCellObj alloc] initWithObjType:YMParameterCellObjTypeNone];
    obj.title = @"热水器设置";
    obj.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    obj.cellHeigth = 50;
    obj.imageSize = CGSizeMake(15, 15);
    obj.headImage = [UIImage imageNamed:@"icon_shower_setting"];
    obj.cellAction = @selector(showerSetting);
//    [array addObject:obj];
   
    obj = [[YMParameterCellObj alloc] initWithObjType:YMParameterCellObjTypeNone];
    obj.title = @"密码设置";
    obj.imageSize = CGSizeMake(15, 15);
    obj.headImage = [UIImage imageNamed:@"icon_psw_setted"];
    obj.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    obj.cellHeigth = 50;
    obj.cellAction = @selector(passwordSetting);
    [array addObject:obj];
    
    obj = [[YMParameterCellObj alloc] initWithObjType:YMParameterCellObjTypeNone];
    obj.title = @"个人信息";
    obj.imageSize = CGSizeMake(15, 15);
    obj.headImage = [UIImage imageNamed:@"icon_profile_setting"];
    obj.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    obj.cellHeigth =50;
    obj.cellAction = @selector(profileSetting);
    [array addObject:obj];
    
    obj = [[YMParameterCellObj alloc] initWithObjType:YMParameterCellObjTypeNone];
    obj.title = @"通知列表";
    obj.imageSize = CGSizeMake(15, 15);
    obj.headImage = [UIImage imageNamed:@"icon_system_message"];
    obj.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    obj.cellHeigth =50;
    obj.cellAction = @selector(systemMessage);
    [array addObject:obj];
    [self.cellObjs addObject:array];
}

#pragma mark - setupView
-(void)setHeadView{
    
    self.nameLabel = [self getALabel];
    self.infoLabel = [self getALabel];
    self.classLabel = [self getALabel];
    
//    CGFloat top = 22;//9.5
    CGFloat top = 9.5;
    self.nameLabel.frame = CGRectMake(108, top, SCREEN_WIDTH-108-35, kInfoLabelHeight);
    self.infoLabel.frame = CGRectMake(108, top+kInfoLabelHeight, SCREEN_WIDTH-108-35, kInfoLabelHeight);
    self.classLabel.frame = CGRectMake(108, top+(kInfoLabelHeight*2), SCREEN_WIDTH-108-35, kInfoLabelHeight);
    
  
    GABorderView *headView = [[GABorderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 106)];
    headView.frameHeight = 106;
    headView.backgroundColor = [UIColor whiteColor];
    [self.tableView setTableHeaderView:headView];
    
    [headView addSubview:self.headImageView];
    [headView addSubview:self.nameLabel];
    [headView addSubview:self.infoLabel];
    [headView addSubview:self.classLabel];
}

- (void)sutupFooterView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    if (nil==self.networkLabel) {
        self.networkLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 200, 20)];
        self.networkLabel.font = [UIFont systemFontOfSize:14];
    }
    [view addSubview:self.networkLabel];    
    self.networkLabel.text = [NSString stringWithFormat:@"本次流量使用: %@",[self networkUsage]];
    
    MButton *actionButton = [MButton new];
    actionButton.layer.cornerRadius = 5;
    actionButton.layer.borderWidth = 0.65;
    actionButton.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.6] CGColor];
    [actionButton setNormalColor:[UIColor whiteColor] SelectColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5]];
    [actionButton setTitle:@"退出登录" forState:UIControlStateNormal];
    actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [actionButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [actionButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    actionButton.frame = CGRectMake(20, 120-44, SCREEN_WIDTH-20*2, 44);
    [view addSubview:actionButton];
}

- (void)logout{

    WS(ws);
    [UIAlertView bk_showAlertViewWithTitle:@" 将清空您的个人信息,确认退出吗？" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex==1) {
            [ws.navigationController popViewControllerAnimated:YES];
            [[NSUserDefaults standardUserDefaults]setObject:@"logout" forKey:@"Logouthehe"];
            [YCUserModel logout];
            [AFLoginController forceLoginAndShowMessage:NO];
        }
    }];
}

- (void)changeHeadImage{
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YMParametersTableViewCell *cell = (YMParametersTableViewCell *)[super tableView:sender cellForRowAtIndexPath:indexPath];

    cell.titleLabel.textColor = RGB(66, 66, 66);
    cell.titleLabel.font = [UIFont boldSystemFontOfSize:15];
   
    return cell;

}

#pragma mark - event respone

-(void)showerSetting
{
    [self pushViewController:@"YCShowerSettingController"];
}

-(void)passwordSetting
{
    [self pushViewController:@"YCEditPasswordController"];
}

-(void)profileSetting
{
    [self pushViewController:@"YCEditUserInfoController"];
}

-(void)systemMessage{
    [self pushViewController:@"YCNotiHisViewController"];
}

#pragma mark - Geter

- (UIImageView *)headImageView{
    
    if (nil==_headImageView) {
        
        CGFloat size = 70;
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 18, size, size)];
        _headImageView.layer.cornerRadius = 3;
        _headImageView.clipsToBounds = YES;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.image = kDefaultPlaceHolder;
        _headImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeadImage)];
        [_headImageView addGestureRecognizer:tap];
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, size-13, size, 13)];
        infoLabel.textColor = [UIColor whiteColor];
        infoLabel.text = @"点击上传头像";
        infoLabel.textAlignment = NSTextAlignmentCenter;
        infoLabel.font = [UIFont systemFontOfSize:11];
        infoLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
//        [_headImageView addSubview:infoLabel];
    }
    return _headImageView;
}

- (UILabel *)getALabel{
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(108, 0, SCREEN_WIDTH-108-35, kInfoLabelHeight)];
    infoLabel.textColor = RGB(142, 142, 142);
    infoLabel.text = nil;
    infoLabel.font = [UIFont systemFontOfSize:14];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kInfoLabelHeight-1, infoLabel.frame.size.width, 0.65)];
    line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    line.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    [infoLabel addSubview:line];
    
    return infoLabel;
}

@end
