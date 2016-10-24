//
//  AFLoginController.h
//  Whatstock
//
//  Created by Jinjin on 14/12/14.
//  Copyright (c) 2014年 AnnyFun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AFLoginController : BaseViewController

/**
 *  检测是否登陆，同时弹出登录窗口
 *
 *  @param vc 弹出窗口的ViewController
 *
 *  @return NO-未登录，弹出窗口    YES-已经登录，不做任何操作
 */
+ (BOOL)checkIsLoginAndPresentLoginControllerWithController:(UIViewController *)vc;

+ (void)forceLoginAndShowMessage:(BOOL) show;

+ (void)autoLogin;
@end
