//
//  CodeViewController.m
//  YunCard
//
//  Created by Denny on 15/12/15.
//  Copyright © 2015年 JiaJun. All rights reserved.
//

#import "CodeViewController.h"
#import "UIViewController+CWPopup.h"
#import "YCQrCodeViewController.h"
#define QrWidth 200
#define QrHeight 200
#define BarWidth 280
#define BarHeight 80
@interface CodeViewController ()
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)CGFloat bright;
@property (nonatomic, strong)UIView  *mainView;
@property (nonatomic, strong)UILabel *userNameLabel;
@property (nonatomic, strong)UILabel *alertLabel;
@property (nonatomic,strong)UIImageView *qrImageView;//二维码
@property (nonatomic,strong)UIImageView *barImageView; //条形码
@end

@implementation CodeViewController

static dispatch_queue_t get_check_server_connection_queue() {
    static dispatch_queue_t check_server_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        check_server_queue = dispatch_queue_create("server.connection.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return check_server_queue;
}

-  (void)viewWillAppear:(BOOL)animated {
    //亮度调节
    self.bright = [UIScreen mainScreen].brightness;
    [YCUserModel currentUser].bright = [UIScreen mainScreen].brightness;
    CGFloat tmpbrght = [YCUserModel currentUser].bright;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:tmpbrght ]forKey:@"AFuserBright"];
     [[NSUserDefaults standardUserDefaults] setObject:@"have"forKey:@"AFuserBrightishave"];
    [YCUserModel currentUser].fromBackground = @"1";

    [[UIScreen mainScreen]setBrightness:MAXFLOAT];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[UIScreen mainScreen]setBrightness:self.bright];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexRGB:@"#2a394e"];
    CGFloat mainHeight = BarHeight + QrHeight + 21 * 2 + 20 + 50;

    //init mainView
    CGFloat merrginLeft = 20;
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(merrginLeft, (CGRectGetHeight(self.view.bounds) - mainHeight)/2 - 32 , CGRectGetWidth(self.view.bounds) - 2 * merrginLeft,mainHeight)];
    self.mainView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainView];
    self.title = @"刷卡";
    if([YCUserModel currentUser].cardNo.length == 0 && ![[NSUserDefaults standardUserDefaults]objectForKey:@"Logouthehe"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的账号已经挂失,请解挂后重新登录再试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }else {
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"刷新", nil) style:UIBarButtonItemStylePlain target:self action:@selector(refresh)];
        self.navigationItem.rightBarButtonItem = rightBarButton;

        //条形码
        YCUserModel *user = [YCUserModel currentUser];
        self.barImageView = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.mainView.bounds) - BarWidth )/2 , 15 ,BarWidth, BarHeight)];
        [self.barImageView setImage:[self generateBarCode:user.studentNo width:BarWidth height:BarHeight]];
        [self.mainView addSubview:self.barImageView];
        
        self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.barImageView.frame.origin.x, CGRectGetMaxY(self.barImageView.frame), CGRectGetWidth(self.barImageView.frame), 21)];
        self.userNameLabel.text  = NSLocalizedString(user.studentNo, nil);
        self.userNameLabel.textColor = [UIColor blackColor];
        self.userNameLabel.textAlignment = NSTextAlignmentCenter;
        [self.mainView addSubview:self.userNameLabel];
        
        //二维码
        self.qrImageView = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.mainView.bounds) -QrWidth)/2 , CGRectGetMaxY(self.userNameLabel.frame) + 35, QrWidth, QrHeight)];
        self.qrImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.mainView addSubview:self.qrImageView];
        [self getCodeDataFromNet];
        
        self.alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.mainView.bounds) - 21  -15, CGRectGetWidth(self.mainView.frame), 21)];
        self.alertLabel.textColor = [UIColor blackColor];
        self.alertLabel.textAlignment = NSTextAlignmentCenter;
        self.alertLabel.font = [UIFont systemFontOfSize:14];
        self.alertLabel.text = NSLocalizedString(@"每分钟刷新一次", nil);
        [self.mainView addSubview:self.alertLabel];
        
        //每一分钟循环
        dispatch_async(get_check_server_connection_queue(), ^{
            self.timer = [NSTimer timerWithTimeInterval:60 target:self selector:@selector(getCodeDataFromNet) userInfo:nil repeats:YES];
            NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
            [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
            [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
            [runLoop run];
        });
    }

    }
- (void)getCodeDataFromNet
{
//    获取二维码字符串
    YCUserModel *user = [YCUserModel currentUser];
    NSString *psw = [YCUserModel passwordForUser:user.studentNo];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    [param setObject:@"getQr" forKey:@"action"];
    if (user.studentNo)[param setObject:user.studentNo forKey:@"stu_no"];
    if (psw)[param setObject:psw forKey:@"password"];
    if ([self uuid]) {
        [param setObject:[self uuid] forKey:@"IMEI"];
    }
    [param setObject:@"1" forKey:@"n"];
    [param setObject:@"123456789" forKey:@"t"];
    [SVProgressHUD showWithStatus:@"获取二维码.." maskType:SVProgressHUDMaskTypeClear];
    WS(ws);
    [AFNManager  postObject:param
                    apiName:@"http://123.59.143.144:50000/yuncard/Htdoc/index.php"
                  modelName:nil
           requestSuccessed:^(id responseObject) {
               
               if ([responseObject isKindOfClass:[NSDictionary class]] && responseObject[@"qr"]) {
                   [SVProgressHUD dismiss];
                   UIImage *qrImage = [ws generateQRCode:responseObject[@"qr"] width:300 height:300];
                   [ws.qrImageView setImage:qrImage];
               }else{
                   [SVProgressHUD showErrorWithStatus:@"获取失败"];
               }
           }
             requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
                 [SVProgressHUD showErrorWithStatus:errorMessage?:@"获取失败"];
             }];
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

- (UIImage *)generateBarCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    // 生成条形码图片
    CIImage *barcodeImage;
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    barcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = width / barcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = height / barcodeImage.extent.size.height;
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"AFuserBrightishave"];
    [YCUserModel currentUser].fromBackground = @"";
    [[UIScreen mainScreen]setBrightness:self.bright];
    [super viewWillDisappear:animated];
    [self.timer invalidate];
}

- (NSString*)uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result ;
}

- (void)refresh
{
    [self getCodeDataFromNet];
}
@end
