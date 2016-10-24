//
//  YCPayViewController.m
//  YunCard
//
//  Created by Jinjin on 15/8/18.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YCPayViewController.h"
#import "GAItemButton.h"
#import "QRCodeReaderViewController.h"
#import "YCDeviceCell.h"
#import "MJRefresh.h"
#import "UIViewController+CWPopup.h"
#import "YCQrCodeViewController.h"
#import "YCOpenSettingViewController.h"
#import "YCUserResulitController.h"
#import "YCTipsViewController.h"

#import <AVOSCloud/AVOSCloud.h>

@interface YCPayViewController ()<UITableViewDataSource,UITableViewDelegate,UITabBarControllerDelegate>

@property (nonatomic, strong) IBOutlet UIButton *scanBtn;
@property (nonatomic, strong) IBOutlet UIButton *userBtn;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) IBOutlet UIButton *appBtn;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *topView;
@property (nonatomic, strong) MJRefreshHeaderView *refreshHeader;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) GAItemButton *moneyBtn;

- (IBAction)userCenterBtnDidTap:(id)sender;
- (IBAction)appBtnDidTap:(id)sender;
- (IBAction)scanBtnDidTap:(id)sender;
@end

@implementation YCPayViewController

- (void)dealloc
{
    [_refreshHeader free];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    self.view.backgroundColor = RGB(42, 57, 78);
    self.navigationItem.titleView = [self getNavgationView];
    self.tabBarItem.title = @"云支付";
    //配置导航栏样式
    [self configNavigationBar];
    //配置Table
    [self configTable];
    
    //加载顶部的Btns
    [self loadTopActionBtns];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onRefresh) name:@"KnotificationAPPPay" object:nil];
    }
    return self;
}
- (void)onRefresh {
    [self refresh];
}
- (UIView *)getNavgationView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    button.userInteractionEnabled = NO;
    [button setImage:[UIImage imageNamed:@"wingpass"] forState:UIControlStateNormal];
    [button setTitle:@" 云卡" forState:UIControlStateNormal];
    [view addSubview:button];
    return view;
}

static dispatch_queue_t get_check_server_connection_queue() {
    static dispatch_queue_t check_server_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        check_server_queue = dispatch_queue_create("server.connection.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return check_server_queue;
}
- (void)startRequestBadgeWithDelegate {
    dispatch_async(get_check_server_connection_queue(), ^{
        self.timer = [NSTimer timerWithTimeInterval:3. target:self selector:@selector(getNotificationFromNet) userInfo:nil repeats:YES];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
        [runLoop run];
    });
}
- (void)getNotificationFromNet {
//    [self refresh];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self.timer invalidate];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if([YCUserModel currentUser].cardNo.length == 0 && ![[NSUserDefaults standardUserDefaults]objectForKey:@"Logouthehe"]) {
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
    }else {
        [self refresh];
    }
    [self startRequestBadgeWithDelegate];
    self.moneyBtn.gaTitleLabel.text = @"账户";
}


#pragma mark - Private Methods
- (void)reloadData{
    
    [self.tableView reloadData];
}

- (void)refresh{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
//    if([YCUserModel currentUser].cardNo.length == 0&& ![[NSUserDefaults standardUserDefaults]objectForKey:@"Logouthehe"]) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的账号已经挂失,请解挂后重新登录再试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }else {
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
        if ([YCUserModel currentUser].studentNo)[param setObject:[YCUserModel currentUser].studentNo forKey:@"stu_no"];
        [param setObject:@"getDeviceList" forKey:@"action"];
        WS(ws);
        [AFNManager  postObject:param
                        apiName:nil
                      modelName:[YCDeviceModel modelName]
               requestSuccessed:^(id responseObject) {
                   [SVProgressHUD dismiss];
                   if([YCUserModel currentUser].cardNo.length == 0 && ![[NSUserDefaults standardUserDefaults]objectForKey:@"Logouthehe"]) {
                       
                       UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的账号已经挂失,请解挂后重新登录再试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                       
                       [alert show];
                   }else {
                   
                       if ([responseObject isKindOfClass:[NSArray class]]) {
                           ws.dataSource = [responseObject mutableCopy];
                           
                           for (YCDeviceModel *model in ws.dataSource) {
                               
                               //初始化使用时间
                               if (model.deviceStatus==YCDeviceStatusOpenByMe) {
                                   model.startUseDate = [NSDate dateWithTimeIntervalSinceNow:-model.lt];
                               }
                               
                               //检测是否有开启中
                               //检测是否有关闭中
                               
                               if (model.deviceStatus==YCDeviceStatusOpen || model.deviceStatus==YCDeviceStatusClose) {
                                   [ws performSelector:@selector(refresh) withObject:nil afterDelay:1.5];
                               }
                               //                       if ([model.DVTP_ID integerValue] == 2 && model.) {
                               //                           <#statements#>
                               //                       }
                           }
                           [ws reloadData];
                       }

                   }
                   
                   [ws.refreshHeader endRefreshing];
               }
                 requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
                     if (![errorMessage isEqualToString:@"输入信息不完整"]) {
                         [SVProgressHUD showErrorWithStatus:errorMessage];
                     }
                     
                     if (ws.dataSource.count==0) {
                         //                     [ws performSelector:@selector(refresh) withObject:nil afterDelay:1.5];
                     }
                     [ws.refreshHeader endRefreshing];
                     
                 }];
}


static BOOL isAdding = NO;
- (void)addDevice:(NSString *)dId{
    
    if (isAdding) {
        return;
    }
    isAdding = YES;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    if ([YCUserModel currentUser].studentNo)[param setObject:[YCUserModel currentUser].studentNo forKey:@"stu_no"];
    [param setObject:@"bindDevice" forKey:@"action"];
    [param setObject:dId forKey:@"qrcode"];
    
    WS(ws);
    [SVProgressHUD showWithStatus:@"绑定中.." maskType:SVProgressHUDMaskTypeClear];
    [AFNManager  postObject:param
                    apiName:nil
                  modelName:@"BaseModel"
           requestSuccessed:^(id responseObject) {
               isAdding = NO;
               [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
               [ws.refreshHeader beginRefreshing];
           }
             requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
                 isAdding = NO;
                 [SVProgressHUD showErrorWithStatus:errorMessage?:@"绑定失败\n请稍后再试"];
             }];
}

- (void)configNavigationBar{
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.userBtn];
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                   target:self
                                   action:nil];
    flexSpacer.width = -10;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:flexSpacer, leftButtonItem, nil];
    
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.appBtn];
    flexSpacer = [[UIBarButtonItem alloc]
                  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                  target:self
                  action:nil];
    flexSpacer.width = -10;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:flexSpacer, rightButtonItem, nil];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@" "]];
    
    self.navigationController.navigationBar.barTintColor = RGB(13, 28, 25);

    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    
}

- (void)configTable{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    footer.backgroundColor = [UIColor clearColor];
    [footer addSubview:self.scanBtn];
    self.scanBtn.center = CGPointMake(SCREEN_WIDTH*0.5, 90);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YCDeviceCell" bundle:nil] forCellReuseIdentifier:@"YCDeviceCell"];
//    self.tableView.tableFooterView = footer;
    self.tableView.rowHeight = 100;
    self.tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.refreshHeader.scrollView = self.tableView;
}

- (void)loadTopActionBtns{
    NSArray *titles = @[@"余额:200.0元",@"刷卡",@"扫一扫"];
    NSArray *images = @[@"home_btn_wallet",@"home_btn_qrcode",@"home_btn_billing"];
    CGFloat width = SCREEN_WIDTH / 3;
    for (NSInteger index=0; index<titles.count; index++) {
        GAItemButton *btn = [[GAItemButton alloc] initWithFrame:CGRectMake(index*width, 0, width, 107)];
        btn.gaTitleLabel.text = titles[index];
        [btn setImage:[UIImage imageNamed:images[index]] forState:UIControlStateNormal];
        [btn setBackgroundColor:RGB(13, 28, 25)];
        btn.tag = index;
        [btn addTarget:self action:@selector(topBtnDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:btn];
        
        if (index==0) {
            self.moneyBtn = btn;
        }
    }
}

- (UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    
    // 生成二维码图片
    CIImage *qrcodeImage;
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    qrcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = width / qrcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = height / qrcodeImage.extent.size.height;
    CIImage *transformedImage = [qrcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}

- (void)operatingDevice:(YCDeviceModel *)model{
    
    if (model.deviceStatus==YCDeviceStatusOff) {
        //开设备
        [self openDevice:model];
    }else if(model.deviceStatus==YCDeviceStatusOpenByMe){
        //关设备 结账
        [self closeDevice:model];
    }else if (model.deviceStatus==YCDeviceStatusOpenByOther){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"别人正在使用该设备" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }else if (model.deviceStatus==YCDeviceStatusRepair){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"设备正在维修中" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }else if (model.deviceStatus==YCDeviceStatusOpen){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"设备开启中，不可用" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }else if (model.deviceStatus==YCDeviceStatusClose){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"设备关闭中，不可用" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}

static BOOL isDeleting = NO;
- (NSString *)devName:(YCDeviceModel *)model {
    if ([model.DVTP_ID integerValue] == 1) {
        return @"热水";
    }else if ([model.DVTP_ID integerValue] == 2) {
        return @"洗衣机";
    }else if ([model.DVTP_ID integerValue] == 2) {
        return @"洗衣机";
    }else if ([model.DVTP_ID integerValue] == 3) {
        return @"门禁机";
    }else if ([model.DVTP_ID integerValue] == 4) {
        return @"食堂刷卡机";
    }else if ([model.DVTP_ID integerValue] == 5) {
        return @"商家刷卡机";
    }else if ([model.DVTP_ID integerValue] == 6) {
        return @"直饮水机";
    }else {
        return @"";
    }
}
- (void)deleteDevice:(YCDeviceModel *)model{
        if (isDeleting) {
            return;
        }
    NSString *str = [self devName:model];
    [UIAlertView bk_showAlertViewWithTitle:[NSString stringWithFormat:@"确定解绑%@？",str] message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"解绑"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex==1) {
            [SVProgressHUD showWithStatus:@"解除绑定中.." maskType:SVProgressHUDMaskTypeClear];
            NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
            if ([YCUserModel currentUser].studentNo)[param setObject:[YCUserModel currentUser].studentNo forKey:@"stu_no"];
            [param setObject:@"unbindDevice" forKey:@"action"];
            [param setObject:model.DEV_No forKey:@"device_id"];
            
            WS(ws);
            [AFNManager  postObject:param
                            apiName:nil
                          modelName:@"BaseModel"
                   requestSuccessed:^(id responseObject) {
                       [SVProgressHUD showSuccessWithStatus:@"解除绑定成功"];
                       [ws.dataSource removeObject:model];
                       [ws.tableView reloadData];
                   }
                     requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
                         [SVProgressHUD showErrorWithStatus:errorMessage?:@"解除绑定失败\n请稍后再试"];
                     }];
        }
        
        isDeleting = NO;
    }];
//    if (isDeleting) {
//        return;
//    }
//
//    isDeleting = YES;
//    if (model.isOpenByMe) {
//        [UIAlertView bk_showAlertViewWithTitle:@"设备还在使用中" message:@"请先关闭设备，才能解除绑定哦！" cancelButtonTitle:@"好的" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//            
//            isDeleting = NO;
//        }];
//    }else{
//        NSString *str = [self devName:model];
//        [UIAlertView bk_showAlertViewWithTitle:[NSString stringWithFormat:@"确定解绑%@？",str] message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"解绑"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//            if (buttonIndex==1) {
//                [SVProgressHUD showWithStatus:@"解除绑定中.." maskType:SVProgressHUDMaskTypeClear];
//                NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
//                if ([YCUserModel currentUser].studentNo)[param setObject:[YCUserModel currentUser].studentNo forKey:@"stu_no"];
//                [param setObject:@"unbindDevice" forKey:@"action"];
//                [param setObject:model.DEV_No forKey:@"device_id"];
//                
//                WS(ws);
//                [AFNManager  postObject:param
//                                apiName:nil
//                              modelName:@"BaseModel"
//                       requestSuccessed:^(id responseObject) {
//                           [SVProgressHUD showSuccessWithStatus:@"解除绑定成功"];
//                           [ws.dataSource removeObject:model];
//                           [ws.tableView reloadData];
//                       }
//                         requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
//                             [SVProgressHUD showErrorWithStatus:errorMessage?:@"解除绑定失败\n请稍后再试"];
//                         }];
//            }
//            
//            isDeleting = NO;
//        }];
//    }
}

- (void)settingDevice:(YCDeviceModel *)model{
    [self pushViewController:@"YSFeedbackViewController" withParams:model?@{@"device":model}:nil];
}

- (void)openDevice:(YCDeviceModel *)model{
    
//    if ((model.deviceType!=YCDeviceTypeShower) && (model.deviceType!=YCDeviceTypeWasher)) {
//        return;
//    }
    
    WS(ws);
    YCOpenSettingViewController *open = [[YCOpenSettingViewController alloc] initWithNibName:@"YCOpenSettingViewController" bundle:nil];
    open.popupingViewController = self.tabBarController;
    if (model.deviceType == YCDeviceTypeShower) {
        
        open.openBlock = ^(BOOL isDelayOpen){
            
            YCShowerSettingModel *settingModel = [[YCShowerSettingModel alloc] initWithString:[YCUserModel currentUser].wash_setting error:NULL];
            
            NSTimeInterval delayTime = 0;
            NSTimeInterval maxTime = settingModel.delay_close?:(60 * 5);
            if (isDelayOpen) {
                delayTime = settingModel.delay_time;
            }
            //打开热水器
            [ws openShower:model delayTime:delayTime maxTime:maxTime isOpen:YES];
            
        };
    }else{
        
//        open.infoText = @"开启电源后请即刻按\"洗衣机开始按钮\"\n开始洗衣";
        open.infoText = @"确认开启?";
        open.openBlock = ^(BOOL isDelayOpen){
            
            //打开洗衣机
            [ws openWasher:model isOpen:YES];
        };
    }
    [self.tabBarController presentPopupViewController:open animated:YES completion:^{
        
    }];
}

- (void)closeDevice:(YCDeviceModel *)model{
//    if (model.deviceType == YCDeviceTypeShower) {
//        //关闭热水器
//        [self openShower:model delayTime:0 maxTime:0 isOpen:NO];
//    }else{
//        //关闭洗衣机
////        [self openWasher:model isOpen:NO];
//    }
       //关闭热水器
    [self openShower:model delayTime:0 maxTime:0 isOpen:NO];

}

- (void)openWasher:(YCDeviceModel *)model isOpen:(BOOL)isOpen{

    [SVProgressHUD showWithStatus:isOpen?@"开启中..":@"关闭中.." maskType:SVProgressHUDMaskTypeClear];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    if ([YCUserModel currentUser].studentNo)[param setObject:[YCUserModel currentUser].studentNo forKey:@"stu_no"];
    NSLog(@"%@",model.DVTP_ID);
    if ([model.DVTP_ID isEqualToString:@"1"]) {
        [param setObject:@"openShower"forKey:@"action"];
    }else if ([model.DVTP_ID isEqualToString:@"2"]){
        [param setObject:@"openWasher"forKey:@"action"];
    }
    [param setObject:model.DEV_No forKey:@"device_id"];
    
    WS(ws);
    [AFNManager  postObject:param
                    apiName:nil
                  modelName:isOpen?@"BaseModel":@"YCUseResultModel"
           requestSuccessed:^(id responseObject) {
               if (isOpen) {
                   [SVProgressHUD showSuccessWithStatus:@"开启成功"];
                   model.deviceStatus = YCDeviceStatusOpenByOther;
               }else{
                   [SVProgressHUD dismiss];
                   model.deviceStatus = YCDeviceStatusClose;
                   [ws showResult:responseObject];
               }
               [ws.tableView reloadData];
               [ws performSelector:@selector(refresh) withObject:nil afterDelay:0.1];
           }
             requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
                 
                 [SVProgressHUD dismiss];
                 
                 [UIAlertView bk_showAlertViewWithTitle:nil message:errorMessage?:(isOpen?@"开启失败\n请稍后再试":@"关闭失败\n请稍后再试") cancelButtonTitle:@"好的" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                     
                 }];
             }];
}

- (void)openShower:(YCDeviceModel *)model delayTime:(NSTimeInterval)delay maxTime:(NSTimeInterval)maxTime isOpen:(BOOL)isOpen{
    
    /*
     节点	说明	类型	约束	是否必填
     stu_no	用户账号	string		是
     action	openShower	string		是
     device_id	设备编码	string		是
     
     time	开启时长	int		是
     delay_open	延时开启时长	int		否
     delay_close	延时关闭时长	int		否
     token	登录token	string		是
     */
    
    if ([model.DVTP_ID integerValue] == 2) {
        model.deviceStatus = YCDeviceStatusOpenByOther;
        [self.tableView reloadData];
        return;
    }
    [SVProgressHUD showWithStatus:isOpen?@"开启中..":@"关闭中.." maskType:SVProgressHUDMaskTypeClear];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    if ([YCUserModel currentUser].studentNo)[param setObject:[YCUserModel currentUser].studentNo forKey:@"stu_no"];
    [param setObject:model.DEV_No forKey:@"device_id"];
    
    if (isOpen) {
        [param setObject:@"openShower" forKey:@"action"];
        [param setObject:@(maxTime) forKey:@"time"];
        [param setObject:@(delay) forKey:@"delay_open"];
        [param setObject:@"0" forKey:@"delay_close"];
        
    }else{
        [param setObject:@"closeShower" forKey:@"action"];
        
    }
    
    WS(ws);
    [AFNManager  postObject:param
                    apiName:nil
                  modelName:isOpen?@"BaseModel":@"YCUseResultModel"
           requestSuccessed:^(id responseObject) {
               if (isOpen) {
                   [SVProgressHUD showSuccessWithStatus:@"开启成功"];
                   model.deviceStatus = YCDeviceStatusOpen;
               }else{
                   [SVProgressHUD dismiss];
                   model.deviceStatus = YCDeviceStatusClose;
//                   [ws showResult:responseObject];
               }
               [ws.tableView reloadData];
               [ws performSelector:@selector(refresh) withObject:nil afterDelay:0.01];
           }
             requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
                 [SVProgressHUD dismiss];
                 
                 [UIAlertView bk_showAlertViewWithTitle:nil message:errorMessage?:(isOpen?@"开启失败\n请稍后再试":@"关闭失败\n请稍后再试") cancelButtonTitle:@"好的" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                     
                 }];
             }];
}

- (void)showResult:(YCUseResultModel *)data{
    //TODO
    YCUserResulitController *result = [[YCUserResulitController alloc] initWithNibName:@"YCUserResulitController" bundle:nil];
    result.popupingViewController = self.tabBarController;
    result.data = data;
    [self.tabBarController presentPopupViewController:result animated:YES completion:^(void) {
        NSLog(@"popup view presented");
    }];
}

#pragma mark - Action Methods

- (void)topBtnDidTap:(UIButton *)btn{
    switch (btn.tag) {
        case 0:
        {
            [self pushViewController:@"YCYuEViewController"];
//            if (![[AVAnalytics getConfigParams:[NSString stringWithFormat:@"Review_%@",AppVersion]] boolValue]) {
//                
//                [self pushViewController:@"YCChongzhiViewController"];
//            }else{
//                //                YCTipsViewController *result = [[YCTipsViewController alloc] initWithNibName:@"YCTipsViewController" bundle:nil];
//                //                result.popupingViewController = self.tabBarController;
//                //                result.message = @"充值请前往图书馆一楼校园云卡服务中心\n联系电话：15282866833";
//                //                result.titleStr = @"一卡通";
//                //                [self.tabBarController presentPopupViewController:result animated:YES completion:^(void) {
//                //                    NSLog(@"popup view presented");
//                //                }];
//            }
        }
            break;
        case 1:
        {
            [self pushViewController:@"CodeViewController"];
//            //获取二维码字符串
//            YCUserModel *user = [YCUserModel currentUser];
//            NSString *psw = [YCUserModel passwordForUser:user.studentNo];
//            
//            NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
//            [param setObject:@"accessCtrl" forKey:@"action"];
//            if (user.studentNo)[param setObject:user.studentNo forKey:@"studentNo"];
//            if (psw)[param setObject:psw forKey:@"password"];
//            
//            [SVProgressHUD showWithStatus:@"获取二维码.." maskType:SVProgressHUDMaskTypeClear];
//            WS(ws);
//            [AFNManager  postObject:param
//                            apiName:nil
//                          modelName:nil
//                   requestSuccessed:^(id responseObject) {
//                       
//                       if ([responseObject isKindOfClass:[NSDictionary class]] && responseObject[@"qr"]) {
//                           [SVProgressHUD dismiss];
//                           UIImage *qrImage = [ws generateQRCode:responseObject[@"qr"] width:300 height:300];
//                           YCQrCodeViewController *samplePopupViewController = [[YCQrCodeViewController alloc] initWithNibName:@"YCQrCodeViewController" bundle:nil];
//                           samplePopupViewController.qrImage = qrImage;
//                           [ws.tabBarController presentPopupViewController:samplePopupViewController animated:YES completion:^(void) {
//                               NSLog(@"popup view presented");
//                           }];
//                       }else{
//                           [SVProgressHUD showErrorWithStatus:@"获取失败"];
//                       }
//                   }
//                     requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
//                         [SVProgressHUD showErrorWithStatus:errorMessage?:@"获取失败"];
//                     }];
        }
            break;
        case 2:
            [self saoyisao];
//            [self pushViewController:@"YCTradeHisViewController"];
            break;
            
        default:
            break;
    }
}

- (IBAction)userCenterBtnDidTap:(id)sender{
    
    [self pushViewController:@"YSMineViewController"];
}

- (IBAction)appBtnDidTap:(id)sender{
    [self pushViewController:@"YCNotiHisViewController"];
}

- (IBAction)scanBtnDidTap:(id)sender{
    
    if ([QRCodeReader isAvailable]) {
        NSArray *types = @[AVMetadataObjectTypeQRCode];
        WS(ws);
        QRCodeReaderViewController *reader = [[QRCodeReaderViewController alloc] initWithCancelButtonTitle:@"取消" metadataObjectTypes:types];
        reader.modalPresentationStyle = UIModalPresentationFormSheet;
        [reader setCompletionWithBlock:^(NSString *resultAsString) {
            if (resultAsString) {
                [ws addDevice:resultAsString];
            }
            [ws dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
        
        //调整前置摄像头位置
        UIButton *switchCameraButton = [reader valueForKey:@"switchCameraButton"];
        if ([[switchCameraButton class] isSubclassOfClass:[UIButton class]]) {
            switchCameraButton.hidden = YES;
        }
        
        [self presentViewController:reader animated:YES completion:NULL];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"当前设备不支持扫描二维码" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YCDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCDeviceCell"];
    YCDeviceModel *model = self.dataSource[indexPath.row];
    [cell bindData:model];
    
    WS(ws);
    cell.actionBlock = ^(YCDeviceCell *tCell,YCDeviceActionType type){
        
        NSInteger index = [tableView indexPathForCell:tCell].row;
        YCDeviceModel *model = self.dataSource[index];
        switch (type) {
            case YCDeviceActionTypeSetting:
                [ws settingDevice:model];
                break;
            case YCDeviceActionTypeOp:
                [ws operatingDevice:model];
                break;
            case YCDeviceActionTypeDelete:
                [ws deleteDevice:model];
                break;
            default:
                break;
        }
    };
    return cell;
}

#pragma mark - Getter
- (MJRefreshHeaderView *)refreshHeader{
    if (nil==_refreshHeader) {
        _refreshHeader = [MJRefreshHeaderView header];
        WS(ws);
        self.refreshHeader.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
            [ws refresh];
        };
    }
    return _refreshHeader;
}

#pragma mark(Denny) ------扫一扫
- (void)saoyisao{
    if ([QRCodeReader isAvailable]) {
        NSArray *types = @[AVMetadataObjectTypeQRCode];
        WS(ws);
        QRCodeReaderViewController *reader = [[QRCodeReaderViewController alloc] initWithCancelButtonTitle:@"取消" metadataObjectTypes:types];
        reader.modalPresentationStyle = UIModalPresentationFormSheet;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:reader];
        
        [reader setCompletionWithBlock:^(NSString *resultAsString) {
            if (resultAsString) {
                [ws addDevice:resultAsString];
            }
            [ws dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
        
        //调整前置摄像头位置
        UIButton *switchCameraButton = [reader valueForKey:@"switchCameraButton"];
        if ([[switchCameraButton class] isSubclassOfClass:[UIButton class]]) {
            switchCameraButton.hidden = YES;
        }
        
        [self presentViewController:nav animated:YES completion:NULL];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"当前设备不支持扫描二维码" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}
@end
