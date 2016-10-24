//
//  YCTimetableViewController.m
//  YunCard
//
//  Created by Lwj on 15/12/3.
//  Copyright © 2015年 JiaJun. All rights reserved.
//

#import "YCTimetableViewController.h"
#import "courceManger.h"
#import "courceModel.h"
#define cwidth ([UIScreen mainScreen].bounds.size.width)/8
#define marginTop 25.0
#define cheight 60.0
@interface YCTimetableViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollview;
@property(nonatomic,strong)NSMutableArray *colorArray;
@property(nonatomic,assign)NSInteger colorIndex;
@end

@implementation YCTimetableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.colorArray = [NSMutableArray arrayWithObjects:@"#FF5D5D",@"#F7A340",@"#99E363",@"#4EDAC4",@"#7A89E2",@"#A85BBE",@"D03C85",@"CE6B6B", nil];
    self.title = @"我的课表";
    self.mainScrollview.contentSize = CGSizeMake(SCREEN_WIDTH, marginTop + cheight * 10 + 5);
    [self initView];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    YCUserModel *user = [YCUserModel currentUser];
    NSString *psw = [YCUserModel passwordForUser:user.studentNo];
    NSString *stu_no = user.studentNo;
    [param setObject:stu_no forKey:@"stu_no"];
    [param setObject:psw forKey:@"password"];
    [param setObject:@"1" forKey:@"n"];
    [param setObject:@"123456789" forKey:@"t"];
    [param setObject:@"courseTable" forKey:@"action"];
    [SVProgressHUD show];
    [AFNManager postObject:param apiName:@"http://123.59.143.144:50000/yuncard/Htdoc/index.php" modelName:nil requestSuccessed:^(id responseObject) {
        NSArray *arrray = (NSArray *)responseObject;
        [self adjustLabelHide:arrray];
        [SVProgressHUD dismiss];
    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
        ;
    }];

}

- (void)initView{
    NSArray *dateTitle = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    for (int i = 0; i < 7; i ++) {
        //竖线
        UIView *vlineView = [[UIView alloc]initWithFrame:CGRectMake((i + 1) * cwidth, 0, 1, marginTop + cheight * 10)];
        vlineView.backgroundColor = [UIColor lightGrayColor];
        UILabel *dataLabel = [[UILabel alloc]initWithFrame:CGRectMake((i + 1) * cwidth, 0, cwidth, marginTop)];
        dataLabel.text = dateTitle[i];
        dataLabel.textColor = [UIColor darkTextColor];
        dataLabel.font = [UIFont systemFontOfSize:14];
        dataLabel.textAlignment = NSTextAlignmentCenter;
        [self.mainScrollview addSubview:dataLabel];
        [self.mainScrollview addSubview:vlineView];
    }
    
    CGFloat top = 25.0;
    NSArray *countTitle = @[@"第1节",@"第2节",@"第3节",@"第4节",@"第5节",@"第6节",@"第7节",@"第8节",@"第9节",@"第10节"];
    for (int j = 0; j < 11; j ++) {
        //横线
        UIView *hLineView = [[UIView alloc]initWithFrame:CGRectMake(0, top + j * cheight , [UIScreen mainScreen].bounds.size.width, 1)];
        hLineView.backgroundColor = [UIColor lightGrayColor];
        UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, top + j * cheight, cwidth, cheight)];
        if (j != 10) {
            countLabel.text = countTitle[j];
            countLabel.textColor = [UIColor darkTextColor];
            countLabel.font = [UIFont systemFontOfSize:12];
            countLabel.textAlignment = NSTextAlignmentCenter;
            [self.mainScrollview addSubview:countLabel];
        }
        [self.mainScrollview addSubview:hLineView];
    }
}

- (void)adjustLabelHide:(NSArray *)tmpArray
{
    NSMutableArray *array = [courceManger getShowTagArray:tmpArray];
    for (courceModel *model in array) {
        UILabel *mainLabel = [[UILabel alloc]initWithFrame:CGRectMake((model.date + 1) * cwidth + 1, marginTop + (model.minTag %20 - 1) * cheight, cwidth - 2, model.showTagArray.count * cheight)];
        mainLabel.numberOfLines = 10;
        mainLabel.layer.cornerRadius = 8;
        mainLabel.clipsToBounds = YES;
        mainLabel.textColor = [UIColor whiteColor];
        mainLabel.textAlignment = NSTextAlignmentCenter;
        mainLabel.font = [UIFont systemFontOfSize:11];
        mainLabel.text = model.cource;
        mainLabel.backgroundColor = [UIColor colorWithHexRGB:self.colorArray[self.colorIndex]];
        self.colorIndex ++;
        if (self.colorIndex == 8) {
            self.colorIndex = 0;
        }
        [self.mainScrollview addSubview:mainLabel];
    }
}



@end
