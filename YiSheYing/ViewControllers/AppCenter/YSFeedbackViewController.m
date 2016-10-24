//
//  YSFeedbackViewController.m
//  YunCard
//
//  Created by helfy  on 15/6/29.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YSFeedbackViewController.h"
#import "YMTextView.h"
#import "MButton.h"
#import "UIView+CGRectUtils.h"

@interface YSFeedbackViewController ()

@property (nonatomic,strong) YCDeviceModel *deviceModel;
@end

@implementation YSFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投诉与报修";
    // Do any additional setup after loading the view.
    [self.tableView setTableFooterView:[self tableViewFooterView]];
//    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    self.deviceModel = self.params[@"device"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)setupTableView
{
    self.tableView  =[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview: self.tableView ];
    self.tableView .delegate = (id)self;
    self.tableView .dataSource = (id)self;
    
    [self.tableView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.view);
        make.right.equalTo (self.view);
        make.top.equalTo (self.view);
        make.bottom.equalTo (self.view);
    }];
}

- (void)setDeviceModel:(YCDeviceModel *)deviceModel{
    
    _deviceModel = deviceModel;
    
    YMParameterCellObj *obj = self.cellObjs[1][0];
    if (nil==self.deviceModel) {
        obj.accessoryView.userInteractionEnabled = YES;
        ((UITextField *)obj.accessoryView).placeholder = @"非设备问题不需要填写";
    }else{
        obj.accessoryView.userInteractionEnabled = NO;
        ((UITextField *)obj.accessoryView).placeholder = nil;
        ((UITextField *)obj.accessoryView).text = deviceModel.DEV_No;
    }
}
#pragma mark - setupData
-(void)setupData{
    
    [super setupData];
    NSMutableArray *array = [NSMutableArray array];
    
    YMParameterCellObj *obj = [[YMParameterCellObj alloc] initWithObjType:YMParameterCellObjTypeTextView];
    obj.name = @"投诉与报修内容";
    obj.key = @"desc";
    obj.isRequired = YES;
    ((YMTextView *)obj.accessoryView).placeHolder = @"请写下您的建议我们会尽快回复您！";
    obj.cellHeigth = 114;

    [array addObject:obj];
    [self.cellObjs addObject:array];
    
    obj = [[YMParameterCellObj alloc] initWithObjType:YMParameterCellObjTypeTextField];
    obj.name = @"设备号";
    obj.key = @"device_id";
    obj.title = @"设备号：";
    obj.isRequired = NO;
    ((UITextField *)obj.accessoryView).textAlignment = NSTextAlignmentRight;
    obj.cellHeigth = 40;
    obj.accessoryView.userInteractionEnabled = YES;
    ((UITextField *)obj.accessoryView).placeholder = @"非设备问题不需要填写";
    array = [NSMutableArray array];
    [array addObject:obj];
    [self.cellObjs addObject:array];
    
    
//    obj = [[YMParameterCellObj alloc] initWithObjType:YMParameterCellObjTypeTextView];
//    obj.name = nil;
//    obj.key = nil;
//    obj.isRequired = NO;
//    obj.title = @"历史交互记录";
//    obj.accessoryView.userInteractionEnabled = NO;
//    ((YMTextView *)obj.accessoryView).editable = NO;
//    obj.cellHeigth = 114;
//    array = [NSMutableArray array];
//    [array addObject:obj];
//    [self.cellObjs addObject:array];
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
    
    [actionButton setTitle:@"提交" forState:UIControlStateNormal];
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

#pragma mark - respone
-(void)submit
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSArray *array in self.cellObjs) {
        for (YMParameterCellObj *obj in array) {
            NSString *checkStr = [obj check] ;
            if(checkStr!= nil)
            {
                [SVProgressHUD showErrorWithStatus:checkStr];
                return;
            }
        }
    }
    
    YCUserModel *userModel = [YCUserModel currentUser];
    if (userModel.studentNo)[params setObject:userModel.studentNo forKey:@"stu_no"];
    [params setObject:@"feedback" forKey:@"action"];
    
    
    NSString *content = ((UITextField *)((YMParameterCellObj *)self.cellObjs[0][0]).accessoryView).text;
    NSString *deviceId = self.deviceModel.DEV_No;
    
    if (nil==deviceId) {
        YMParameterCellObj *obj = self.cellObjs[1][0];
        deviceId = ((UITextField *)obj.accessoryView).text;
    }
    
    if (deviceId) [params setObject:deviceId forKey:@"device_id"];
    if (content)  [params setObject:content forKey:@"desc"];
    if (content)  [params setObject:content forKey:@"msg"];
    [params setObject:deviceId.length == 0?@(2):@(1) forKey:@"type"];
    
    [SVProgressHUD showSuccessWithStatus:@"提交中..."];
    
    WS(ws);
    [AFNManager postObject:params apiName:nil modelName:nil requestSuccessed:^(id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
        [ws.navigationController popViewControllerAnimated:YES];
        
    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
        [SVProgressHUD showErrorWithStatus:errorMessage?:@"提交失败"];
        
    }];
}

@end
