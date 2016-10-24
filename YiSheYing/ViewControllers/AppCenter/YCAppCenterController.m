//
//  YCAppCenterController.m
//  YunCard
//
//  Created by Jinjin on 15/8/18.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YCAppCenterController.h"
#import "YCCardView.h"
#import "YCQrCodeViewController.h"
#import "QRCodeReaderViewController.h"
#import "MJRefresh.h"
#import "UIViewController+CWPopup.h"
#import "GAItemButton.h"
#import "YCAppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import "YCUserResulitController.h"
#import "YCTipsViewController.h"
#import "DennyScrollView.h"
#import "LunBoModel.h"
#define ButtonHeight 107
#import "CodeViewController.h"
#import "MSAboutWebViewController.h"
typedef NS_ENUM(NSInteger, YCAppType) {
    
    YCAppTypeChongzhi = 0,
    YCAppTypeChaxun = 1,
    YCAppTypeGuashi = 2,
    YCAppTypeYidong = 10,
    YCAppTypeJiaofei = 3,
    YCAppTypeFankui = 4,
    YCAppTypeHelp = 5,
    YCAppTypeNoti = 6,
    YCAppTyXiaoWu = 7,
    YCAPPTyXiaoShang = 8
};

@interface YCAppCenterController ()<DennyScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) BOOL reviewing;
@property (nonatomic, strong) GAItemButton *moneyBtn;
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong) MJRefreshHeaderView *refreshHeader;
@property (strong, nonatomic) IBOutlet UIButton *notifiBtn;
@property(nonatomic, assign)CGFloat buttonWidth;
@property (strong, nonatomic) IBOutlet UIButton *userBtn;
@property (nonatomic,strong)NSMutableArray *lunboArray;
@end

@implementation YCAppCenterController
- (void)dealloc
{
    [_refreshHeader free];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.titleView = [self getNavgationView];
    self.tabBarItem.title = @"应用中心";
     _buttonWidth = [UIScreen mainScreen].bounds.size.width/3;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, MAX(SCREEN_HEIGHT-64-47, 4 * ButtonHeight + 100  ));
    self.reviewing = [[AVAnalytics getConfigParams:[NSString stringWithFormat:@"Review_%@",AppVersion]] boolValue];
    [self initTopView];
    [self configNavigationBar];
    [self getMainView];
    [self getBottonScrollview];
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
- (void)initTopView
{
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ButtonHeight)];
    [self.view addSubview:self.topView];
    
    NSArray *titles = @[@"余额:200.0元",@"刷卡",@"扫一扫"];
    NSArray *images = @[@"home_btn_wallet",@"home_btn_qrcode",@"home_btn_billing"];
    CGFloat width = SCREEN_WIDTH / 3;
    for (NSInteger index=0; index<titles.count; index++) {
        GAItemButton *btn = [[GAItemButton alloc] initWithFrame:CGRectMake(index*width, 0, width, ButtonHeight)];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    YCUserModel *model = [YCUserModel currentUser];
//    self.moneyBtn.gaTitleLabel.text = [NSString stringWithFormat:@"账户: %.2f",model.cardBalance / 100.0];
    self.moneyBtn.gaTitleLabel.text = @"账户";
}

- (void)showApp:(UIButton *)btn{
    switch (btn.tag) {
        case YCAppTypeFankui:
        {
            [self pushViewController:@"YSFeedbackViewController"];
        }
            break;
        case YCAppTypeYidong:
        {
            [self pushViewController:@"YCChargeViewController"];
        }
            break;
        case YCAppTypeJiaofei:
        {
            [self pushViewController:@"YCDianFeiViewController"];
        }
            break;            
        case YCAppTypeChongzhi:{
            [self pushViewController:@"YCChongzhiViewController"];
        }
            break;
            
        case YCAppTypeGuashi:{
            [self pushViewController:@"YCGuaShiViewController"];
        }
            break;
        case YCAppTypeChaxun:{
            [self pushViewController:@"YCTradeHisViewController"];
            break;
        }
        case YCAppTypeHelp:{
            [self pushViewController:@"GAWebViewController" withParams:@{@"title":@"使用说明",@"url":@"http://www.wingpass.cn/manual/"}];
        }
            break;
        case YCAppTypeNoti:{
            [self pushViewController:@"YCNotiHisViewController"];
        }
            break;
        case YCAppTyXiaoWu:{
            [self pushViewController:@"YCXiaoWuViewController"];
        }
            break;
        case YCAPPTyXiaoShang:{
            [self pushViewController:@"YCSchoolShopViewController"];
        }
            break;
        default:
            break;
    }
}
#pragma mark ------------top
- (void)topBtnDidTap:(UIButton *)btn{
        switch (btn.tag) {
            case 0:
            {
                //Denny
                [self pushViewController:@"YCYuEViewController"];
            }
                break;
            case 1:
            {
                [self pushViewController:@"CodeViewController"];
            }
                break;
            case 2:
                [self saoyisao];
                break;
            default:
                break;
        }
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
    if([YCUserModel currentUser].cardNo.length == 0&& ![[NSUserDefaults standardUserDefaults]objectForKey:@"Logouthehe"]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的账号已经挂失,请解挂后重新登录再试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return;
        
    }
    
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

#pragma mark - Getter
- (MJRefreshHeaderView *)refreshHeader{
    if (nil==_refreshHeader) {
        _refreshHeader = [MJRefreshHeaderView header];
//        WS(ws);
//        self.refreshHeader.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
////            [ws refresh];
//        };
    }
    return _refreshHeader;
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


#pragma mark -------------------------导航栏

- (void)configNavigationBar{
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.userBtn];
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                   target:self
                                   action:nil];
    flexSpacer.width = -10;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:flexSpacer, leftButtonItem, nil];
    
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.notifiBtn];
    flexSpacer = [[UIBarButtonItem alloc]
                  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                  target:self
                  action:nil];
    flexSpacer.width = -10;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:flexSpacer, rightButtonItem, nil];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@" "]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    self.navigationController.navigationBar.barTintColor = RGB(13, 28, 25);

}
- (IBAction)notificationButtonPresed:(UIButton *)sender {
    [self pushViewController:@"YCNotiHisViewController"];
}
- (IBAction)userCenterButtonPressed:(UIButton *)sender {
    [self pushViewController:@"YSMineViewController"];
}
#pragma mark -----------------------DeennyDesin
- (void)getMainView{
    NSArray *imageArray = @[@"school_senate",@"school_bus",@"bubbles",@"chuangke",@"elec",@"more"];
    NSArray *titleArray = @[@"校务",@"校商",@"报修",@"创客",@"电费",@"更多"];
    NSInteger buttonTag = 0;
    for (int i = 0; i < 2; i ++) {
        for (int j = 0; j < 3; j ++) {
            GAItemButton *button = [[GAItemButton alloc]initWithFrame: CGRectMake(_buttonWidth * j, i * ButtonHeight, _buttonWidth, ButtonHeight)];
            button.gaTitleLabel.text = titleArray[buttonTag];
            button.gaTitleLabel.textColor = [UIColor lightGrayColor];
            button.tag = buttonTag;
            button.backgroundColor = [UIColor whiteColor];
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:imageArray[buttonTag]] forState:UIControlStateNormal];
            [self.scrollView addSubview:button];
            buttonTag ++;
        }
    }
    //line
    for (int m = 0; m < 2; m ++) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(_buttonWidth * (m + 1), 0, 0.5, ButtonHeight * 2)];
        lineView.backgroundColor =[UIColor colorWithHexRGB:@"#E4E9F7"];
        [self.scrollView addSubview:lineView];
    }
    UIView *hLineView = [[UIView alloc]initWithFrame:CGRectMake(0, ButtonHeight, SCREEN_WIDTH, 0.5)];
    hLineView.backgroundColor = [UIColor colorWithHexRGB:@"#E4E9F7"];
    [self.scrollView addSubview:hLineView];
}

- (void)getBottonScrollview
{
    self.lunboArray = [NSMutableArray array];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    YCUserModel *user = [YCUserModel currentUser];
    NSString *psw = [YCUserModel passwordForUser:user.studentNo];
    NSString *stu_no = user.studentNo;
    if (psw) {
        [param setObject:psw forKey:@"password"];
    }
    if (stu_no) {
        [param setObject:stu_no forKey:@"stu_no"];
    }
    [param setObject:@"1" forKey:@"n"];
    [param setObject:@"123456789" forKey:@"t"];
    [param setObject:@"getCarouselImg" forKey:@"action"];
    [SVProgressHUD show];
    [AFNManager postObject:param apiName:@"http://123.59.143.144:50000/yuncard/Htdoc/index.php" modelName:nil requestSuccessed:^(id responseObject) {
        NSArray *array = (NSArray *)responseObject;
        for (NSDictionary *dic in array) {
            [self.lunboArray addObject:[[LunBoModel alloc] initWithDic:dic]];
        }
        CGFloat margin = 15;
        DennyScrollView *dennyView = [[DennyScrollView alloc]initWithFrame:CGRectMake(0, 2 * ButtonHeight + margin, [UIScreen mainScreen].bounds.size.width, SCREEN_WIDTH/2) imageArray:self.lunboArray];
        dennyView.delegate = self;
        [self.scrollView addSubview:dennyView];
        [SVProgressHUD dismiss];
    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
        ;
    }];
   
}
- (void)buttonPressed:(UIButton *)sender
{
    if (sender.tag == 0) {
        [self pushViewController:@"YCXiaoWuViewController"];
    }
    if (sender.tag == 1) {
        [self pushViewController:@"YCSchoolShopViewController"];
    }
    if (sender.tag == 2) {
        [self pushViewController:@"YSFeedbackViewController"];
    }
    if (sender.tag == 3) {
        YCUserModel *user = [YCUserModel currentUser];
        NSString *stu_no = user.studentNo;
        MSAboutWebViewController *about = [[MSAboutWebViewController alloc]init];
        NSString *urlStr = [NSString stringWithFormat:@"http://123.59.143.144:50000/pages/index.php?type=chuangke&stu_no=%@",stu_no];
        about.url =[NSURL URLWithString:urlStr];
        about.titleStr  = @"创客";
        [about setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:about animated:YES];
    }
    if (sender.tag == 4) {
        [self pushViewController:@"YCDianFeiViewController"];
    }
    if (sender.tag == 5) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"功能建设中,敬请期待!!!" delegate:nil cancelButtonTitle:@"朕知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}
#pragma mark ---------------------DennyScrollViewDelegate

- (void)clikeScrollViewCallBack:(DennyScrollView *)vc index:(NSInteger)index
{
    YCUserModel *user = [YCUserModel currentUser];
    NSString *stu_no = user.studentNo;

    LunBoModel *model = [[LunBoModel alloc]init];
    model = self.lunboArray[index];
    MSAboutWebViewController *about = [[MSAboutWebViewController alloc]init];
    if (model.link) {
        if ([model.link isContainString:@"?"]) {
            about.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&stu_no=%@",model.link,stu_no]];
        }else {
            about.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?stu_no=%@",model.link,stu_no]];
        }
    }
    [about setHidesBottomBarWhenPushed:YES];
    if (about.url) {
        [self.navigationController pushViewController:about animated:YES];
    }
}
@end
