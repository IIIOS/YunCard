//
//  YCXiaoWuViewController.m
//  YunCard
//
//  Created by Lwj on 15/12/2.
//  Copyright © 2015年 JiaJun. All rights reserved.
//

#import "YCXiaoWuViewController.h"
#import "GAItemButton.h"
#define SCREEN_Width  [UIScreen mainScreen].bounds.size.width
#define topViewHeight 80
#define midViewHeight 240
#define marginLeft    10
#define buttonHeight   120
#define bottonViewHeight  64
@interface YCXiaoWuViewController ()
@property(nonatomic,assign)CGFloat scrollviewCY;
@property(nonatomic,strong)UIScrollView *mainScrollview;
@end

@implementation YCXiaoWuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"教务";
    [self initScrollView];
    [self initBottonView];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    YCUserModel *user = [YCUserModel currentUser];
    NSString *psw = [YCUserModel passwordForUser:user.studentNo];
    NSString *stu_no = user.studentNo;
    [param setObject:stu_no forKey:@"stu_no"];
    [param setObject:psw forKey:@"password"];
    [param setObject:@"1" forKey:@"n"];
    [param setObject:@"123456789" forKey:@"t"];
    [param setObject:@"userInformation" forKey:@"action"];
    [SVProgressHUD show];
    [AFNManager postObject:param apiName:@"http://123.59.143.144:50000/yuncard/Htdoc/index.php" modelName:nil requestSuccessed:^(id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        [self initTopView:dic];
        [self initMidView:dic];
        [SVProgressHUD dismiss];
    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
        ;
    }];
}

- (void)initTopView:(NSDictionary *)dic
{
    NSString *str1 = [NSString stringWithFormat:@"姓名: %@",dic[@"name"]];
    NSString *str2 = [NSString stringWithFormat:@"学院: %@",dic[@"college"]];
    NSString *str3 = [NSString stringWithFormat:@"专业: %@",dic[@"major"]];
    NSString *str4 = [NSString stringWithFormat:@"班级: %@",dic[@"classes"]];
    NSArray *titleArray = @[str1,str2,str3,str4];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_Width, topViewHeight)];
    topView.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 140, topViewHeight)];
    [button setImage:[UIImage imageNamed:@"header"] forState:UIControlStateNormal];
    [topView addSubview:button];
    for (int i = 0; i < 4; i ++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(button.bounds) + 10, 5 + i * 18, CGRectGetWidth(self.view.bounds) - 2 *marginLeft, 15)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor darkTextColor];
        label.text = titleArray[i];
        [topView addSubview:label];
    }
    [self.mainScrollview addSubview:topView];
}

- (void)initMidView:(NSDictionary *)dic
{
    NSString *str1 = [NSString stringWithFormat:@"已修必修: %@门课",dic[@"required_course"]];
    NSString *str2 = [NSString stringWithFormat:@"已修选修: %@门课",dic[@"optional_course"]];
    NSString *str3 = [NSString stringWithFormat:@"已修绩点: %@",dic[@"point"]];
    NSString *str4 = [NSString stringWithFormat:@"已修学分: %@",dic[@"credit"]];
    NSArray *titleArray = @[str1,str3,str2,str4];
    UIView *midView = [[UIView alloc]initWithFrame:CGRectMake(0, topViewHeight, SCREEN_Width, midViewHeight)];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_Width, 21)];
    nameLabel.text = @"综合数据";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.backgroundColor = [UIColor colorWithRed:8/255.0 green:76/255.0 blue:118/255.0 alpha:1];
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.textColor = [UIColor whiteColor];
    NSInteger tag = 0;
    [midView addSubview:nameLabel];
    NSArray *colorArray = @[@"#e88d30",@"#c23b7d",@"#b4ca44",@"#975aa1"];
    CGFloat buttonWidth = (([UIScreen mainScreen].bounds.size.width) - marginLeft)/2;
    NSArray *imageArray = @[@"compulsory",@"gpa",@"optional",@"cap"];
    for (int i = 0; i < 2; i ++) {
        for (int j = 0; j < 2; j ++) {
            GAItemButton *button = [[GAItemButton alloc]initWithFrame:CGRectMake((buttonWidth + marginLeft) * i,j == 0? CGRectGetHeight(nameLabel.frame) + marginLeft: CGRectGetHeight(nameLabel.frame) + 2 *marginLeft+ j  * buttonHeight , buttonWidth, buttonHeight)];
            [button setImage:[UIImage imageNamed:imageArray[tag]] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            button.userInteractionEnabled = NO;
            button.imageHeight = 64;
            button.titleHeight = 35;
            button.imageEdgeInsets = UIEdgeInsetsMake(15, 20, 30, 20);
            button.gaTitleLabel.font = [UIFont systemFontOfSize:11];
            button.gaTitleLabel.textColor = [UIColor colorWithHexRGB:colorArray[tag]];
            button.gaTitleLabel.text = titleArray[tag];
            [midView addSubview:button];
            tag ++;
        }
    }
    [self.mainScrollview addSubview:midView];
    
}

- (void)initBottonView{
    CGFloat buttonWidth = ([UIScreen mainScreen].bounds.size.width)/2;
    NSArray *colorArray  = @[@"#0043b9",@"#d66561"];
    UIView *bottonView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - bottonViewHeight - 64, SCREEN_Width, bottonViewHeight)];
    NSArray *imageArray = @[@"schedule",@"exam"];
    NSArray *titleArray = @[@"课表",@"考试"];
    for (int i = 0; i < 2; i ++) {
        GAItemButton *button = [[GAItemButton alloc]initWithFrame:CGRectMake( buttonWidth * i, 0, buttonWidth, bottonViewHeight)];
        button.tag = 20 + i;
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        button.imageHeight = 32;
        button.titleHeight = 35;
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 30, 0);
        button.gaTitleLabel.text = titleArray[i];
        button.gaTitleLabel.textColor = [UIColor colorWithHexRGB:colorArray[i]];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [bottonView addSubview:button];
    }
    //横线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bottonView.frame), 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [bottonView addSubview:lineView];
    //竖线
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(bottonView.frame), 0, 0.5, CGRectGetHeight(bottonView.frame))];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [bottonView addSubview:lineView1];
    [self.mainScrollview addSubview:bottonView];
}

- (void)initScrollView
{
    self.mainScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_Width, [UIScreen mainScreen].bounds.size.height - 64)];
    self.scrollviewCY = topViewHeight + midViewHeight + bottonViewHeight + 64;
    self.mainScrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), self.scrollviewCY);
    [self.view addSubview:self.mainScrollview];
}

- (void)buttonPressed:(UIButton *)sender
{
    if (sender.tag == 20) {
        [self pushViewController:@"YCTimetableViewController"];
    }
    if (sender.tag == 21) {
        [self pushViewController:@"YCTestViewController"];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}
@end