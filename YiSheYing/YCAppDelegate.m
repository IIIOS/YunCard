//
//  YCAppDelegate.m
//  YunCard
//
//  Created by tt on 14-9-17.
//  Copyright (c) 2014年 JiaJun. All rights reserved.
//

#import "YCAppDelegate.h"
#import "YCTabBarViewController.h"
#import "YCPayViewController.h"
#import "APService.h"
#import "YCAppCenterController.h"
#import "YCNetwortUsage.h"
#import <Bugtags/Bugtags.h>
#import <AVOSCloud/AVOSCloud.h>
#import "YCNotiHisViewController.h"
#import "GAWebViewController.h"
#import <MobClick.h>
@interface YCAppDelegate ()
{
}
@end


@implementation YCAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
    [AVOSCloud setApplicationId:@"sjDk6cOJ25oemEGzOwWRPAO8"
                      clientKey:@"iUYf4LWmzPr3x47OOsm6RelA"];
    
    [Bugtags startWithAppKey:@"71af6607635a1aec2b6cc809d4178381" invocationEvent:BTGInvocationEventNone];
    [self initUmengSDK];

    [[StorageManager sharedInstance] ensureAllDirectories];
    
    [self setDefaultAppearance];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self initRootViewController];
    
    
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    
    // Required
    [APService setupWithOption:launchOptions];
    
    return YES;
}

- (void)handleNoti:(NSDictionary *)userInfo{
    
    NSString *detailUrl = userInfo[@"msg_url"];
    if (nil==detailUrl) {
        NSDictionary *extras = userInfo[@"extras"];
        if ([extras isKindOfClass:[NSDictionary class]]) {
            detailUrl = extras[@"msg_url"];
        }
    }
    
    UIViewController *controller = nil;
    
    if (detailUrl) {
        GAWebViewController *webContro = [[GAWebViewController alloc] init];
        webContro.title = @"通知详细";
        [webContro loadUrl:detailUrl];
        controller = webContro;
    }else{
        YCNotiHisViewController *notiList = [[YCNotiHisViewController alloc] initWithNibName:@"YCNotiHisViewController" bundle:nil];
        controller = notiList;
    }
    
    controller.hidesBottomBarWhenPushed = YES;
    [[self hostNavigationController] pushViewController:controller animated:NO];
}

- (void)initUmengSDK
{
    [MobClick startWithAppkey:@"568f54f8e0f55a1a9b00016b" reportPolicy:SEND_INTERVAL channelId:nil];
    [MobClick setLogSendInterval:200];
    
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
    [self handleNoti:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    [self handleNoti:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"AFuserBrightishave"]) {
        CGFloat bright = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AFuserBright"] floatValue];
        [[UIScreen mainScreen]setBrightness:bright];
    }
   
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Kopenguang" object:nil];
    if ([YCUserModel currentUser].fromBackground.length !=0) {
        [[UIScreen mainScreen]setBrightness:MAXFLOAT];
    }

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [AFLoginController autoLogin];
    
    [self checkVersion:NO andCanSkip:YES];
    
    NSInteger usage = [YCNetwortUsage allUse];
    [[NSUserDefaults standardUserDefaults] setInteger:usage forKey:@"YCNetWorkUseAge"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [AVAnalytics updateOnlineConfigWithBlock:^(NSDictionary *dict, NSError *error) {
        
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[url scheme] isEqualToString:@"yuncardpay"]) {
        
        [SVProgressHUD dismiss];
        NSLog(@"安心付回调： %@",url);
        NSString *host = [url host];
        if ([host isEqualToString:@"success"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AFPaySuccess" object:nil];
            [UIAlertView bk_showAlertViewWithTitle:@"支付成功" message:nil cancelButtonTitle:@"好的" otherButtonTitles:nil handler:NULL];
        } else if ([host isEqualToString:@"failed"]) {
            
            [UIAlertView bk_showAlertViewWithTitle:@"支付失败" message:nil cancelButtonTitle:@"好的" otherButtonTitles:nil handler:NULL];
            [SVProgressHUD showErrorWithStatus:@"支付失败"];// 支付失败处理
        } else if ([host isEqualToString:@"cancel"]) {
            
            [UIAlertView bk_showAlertViewWithTitle:@"支付取消" message:nil cancelButtonTitle:@"好的" otherButtonTitles:nil handler:NULL];
        }
    }
    return YES;
}


- (void)setDefaultAppearance{
    [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];
    [SVProgressHUD setForegroundColor:[[UIColor whiteColor] colorWithAlphaComponent:1]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setBarTintColor:kDefaultNaviBarColor];
    if (IOS8) {
         [[UINavigationBar appearance] setTranslucent:NO];
    }
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bg.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(115, 115, 115),NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(0, 0, 0),NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];
    
    [[UITabBar appearance] setBarTintColor:RGB(201, 201, 201)];
    [[UITabBar appearance] setTintColor:RGB(0, 0, 0)];
//     [[UITabBar appearance] setTintColor:RGB(115, 115, 115)];
    
    [[UILabel appearance] setTextColor:RGB(66, 66, 66)];
//    [[UISwitch appearance] setOnTintColor:kDefaultNaviBarColor];
}
#pragma mark - public
- (UINavigationController *)hostNavigationController
{
    if ([self.window.rootViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)self.window.rootViewController.presentedViewController;
    }else if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
        return (UINavigationController *)([(UITabBarController *)self.window.rootViewController selectedViewController]);
    }
    else {
        return ((UINavigationController *)self.window.rootViewController);
    }
}


#pragma mark - RootViewController
- (void)initRootViewController{
    
    
    
    YCPayViewController *payViewController = [[YCPayViewController alloc] initWithNibName:@"YCPayViewController" bundle:nil];
    UINavigationController *navi1 = [[UINavigationController alloc] initWithRootViewController:payViewController];
  navi1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"云支付" image:[UIImage imageNamed:@"tabbar_icon_yunpayNormal"] selectedImage:[[UIImage imageNamed:@"tabbar_icon_yunpay"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    navi1.navigationBar.translucent = NO;
    
    
    YCAppCenterController *appController = [[YCAppCenterController alloc] initWithNibName:@"YCAppCenterController" bundle:nil];
    UINavigationController *navi2 = [[UINavigationController alloc] initWithRootViewController:appController];
     navi2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"应用中心" image:[UIImage imageNamed:@"tabbar_icon_appNormal"] selectedImage:[[UIImage imageNamed:@"tabbar_icon_app"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    navi2.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    navi2.navigationBar.translucent = NO;
   
    
    UITabBarController *controller = [[UITabBarController alloc] init];
    controller.delegate  = self;
    controller.viewControllers = @[navi2,navi1];
    
    self.window.rootViewController = controller;

    
    if (![YCUserModel isLogin]) {
        AFLoginController *login = [[AFLoginController alloc] initWithNibName:@"AFLoginController" bundle:nil];
        [self.window.rootViewController presentViewController:login animated:NO completion:^{
            
        }];
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if(tabBarController.selectedIndex == 0)    //"我的账号"
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"KnotificationAPPPay" object:nil];
    }
    return YES;
}

#pragma mark - 版本管理
#define kHaveLoadedVersion @"kHaveLoadedVersion"
//检测当前版本是否是第一次启动
- (BOOL)isFirstLoadForVersion:(NSString *)version{
    NSString *haveLoadedVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kHaveLoadedVersion];
    return ![version isEqualToString:haveLoadedVersion];
}

//将当前版本设置最新启动的版本
- (void)setCurrentLoadVersion:(NSString *)version{
    
    if (version) {
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:kHaveLoadedVersion];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}




#pragma mark - 版本更新
- (void)checkVersion:(BOOL)showMessage andCanSkip:(BOOL)skip {
//    
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    
//    YCUserModel *curUser = [YCUserModel currentUser];
//    if (curUser.studentNo)[param setObject:curUser.studentNo forKey:@"stu_no"];
//    [param setObject:@"getVersionInfo" forKey:@"action"];
//    [param setObject:@"ios" forKey:@"os"];
//    [param setObject:@"student" forKey:@"type"];
//    
//    if(showMessage) [SVProgressHUD showWithStatus:@"检测中.."];
//    
//    [AFNManager postObject:param apiName:@"" modelName:[YCVersionCheckModel modelName] requestSuccessed:^(id responseObject) {
//        
//        if ([responseObject isKindOfClass:[YCVersionCheckModel class]]) {
//            BOOL need =   [self checkVersionInfo:skip withNewModel:responseObject];
//            if (showMessage) {
//                if (need) [SVProgressHUD popActivity];
//                else [SVProgressHUD showSuccessWithStatus:@"当前是最新版本"];
//            }
//        }else{
//            if (showMessage) [SVProgressHUD showErrorWithStatus:@"获取更新失败"];
//        }
//        
//    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
//        if (showMessage) [SVProgressHUD showErrorWithStatus:@"获取更新失败"];
//    }];
}

- (BOOL)checkVersionInfo:(BOOL)canSkip withNewModel:(YCVersionCheckModel *)model{
    
    NSString *localVersion = AppVersion;//本地的版本号
    if (!model) {
        return NO;
    }
    
    NSString *newVersion = model.ios.version;//最新的版本号
    
    //---版本号大小判断---added by ysc------
    BOOL needUpdate = NO, isFixed = NO;
    NSArray *oldVersionArray = [localVersion componentsSeparatedByString:@"."];
    NSArray *newVersionArray = [newVersion componentsSeparatedByString:@"."];
    for (int i = 0; i < MIN([oldVersionArray count], [newVersionArray count]); i++) {
        NSInteger oldIndex = [oldVersionArray[i] integerValue];
        NSInteger newIndex = [newVersionArray[i] integerValue];
        if (newIndex < oldIndex) {
            needUpdate = NO;
            isFixed = YES;
            break;
        }
        else if (newIndex > oldIndex) {
            needUpdate = YES;
            isFixed = YES;
            break;
        }
    }
    if (!isFixed && [newVersionArray count] > [oldVersionArray count]) {
        needUpdate = YES;
    }
    //-----------------END---------------
    
    NSString *downloadUrl = model.ios.download_url;
    NSString *showMessage = model.ios.release_notes;
    BOOL isForcedUpdate = model.ios.isForcedUpdate;
    if ([newVersion isKindOfClass:[NSNull class]]) {
        newVersion = @"";
    }
    if ([downloadUrl isKindOfClass:[NSNull class]]) {
        downloadUrl = @"";
    }
    if ([showMessage isKindOfClass:[NSNull class]]) {
        showMessage = @"";
    }
    
    //检测这个版本是否不再提示更新
    BOOL isSkipThisVersion = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"IsSkipThisVersion-%@", newVersion]];
    
    if (!canSkip) {
        isSkipThisVersion = NO;
    }
    
    if (!isSkipThisVersion) {
        //简单判空
        if (newVersion && [newVersion length] > 0 &&
            downloadUrl && [downloadUrl length] > 0) {
            if (needUpdate) {
                //------added by ysc 根据updateType(0-不强制 1-强制)判断更新的策略
                UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:[NSString stringWithFormat:@"有版本%@需要更新", newVersion]
                                                                    message:showMessage];
                [alertView bk_addButtonWithTitle:@"立刻升级" handler:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadUrl]];
                    exit(0);
                }];
                
                if ( !isForcedUpdate ) {   //非强制更新的话才显示更多选项
                    [alertView bk_addButtonWithTitle:@"忽略此版本" handler:^{
                        //检测这个版本是否不再提示更新
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"IsSkipThisVersion-%@", newVersion]];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }];
                    [alertView bk_setCancelButtonWithTitle:@"取消" handler:nil];//稍后提示 不做任何操作，下次启动再次检测
                }
                [alertView show];
                //-----------------------END---------------------------------
            }
        }
    }
    return needUpdate;
}

@end
