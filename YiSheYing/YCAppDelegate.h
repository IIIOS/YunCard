//
//  YCAppDelegate.h
//  YunCard
//
//  Created by tt on 14-9-17.
//  Copyright (c) 2014年 JiaJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCAppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *rootNavgation;
- (UINavigationController *)hostNavigationController;
@end
