//
//  YCTabBarViewController.m
//  YunCard
//
//  Created by Jinjin on 15/8/16.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YCTabBarViewController.h"
#import "AFLoginController.h"

#import "YCAppCenterController.h"
#import "YCPayViewController.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"


@interface YCTabBarViewController ()
@property (nonatomic,strong) RDVTabBarController *tabBarController;
@end

@implementation YCTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    YCPayViewController *payViewController = [[YCPayViewController alloc] initWithNibName:@"YCPayViewController" bundle:nil];
    YCAppCenterController *appCenterController = [[YCAppCenterController alloc] initWithNibName:@"YCAppCenterController" bundle:nil];
    
    UINavigationController *navi1 = [[UINavigationController alloc] initWithRootViewController:payViewController];
    UINavigationController *navi2 = [[UINavigationController alloc] initWithRootViewController:appCenterController];
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:@[navi1, navi2]];
    self.tabBarController = tabBarController;
    
    RDVTabBar *tabBar = [tabBarController tabBar];
    [tabBar setFrame:CGRectMake(CGRectGetMinX(tabBar.frame), CGRectGetMinY(tabBar.frame), CGRectGetWidth(tabBar.frame), 55)];

    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_bg_s"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_bg"];
    NSArray *tabBarItemImages = @[@"tabbar_icon_yunpay", @"tabbar_icon_app"];
    NSArray *titles = @[ @"应用中心",@"云支付"];
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setTitle:titles[index]];
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        
        UIImage *selectedimage = [UIImage imageNamed:[tabBarItemImages objectAtIndex:index]];
        UIImage *unselectedimage = [UIImage imageNamed:[tabBarItemImages objectAtIndex:index]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        index++;
    }
    
    self.tabBarController.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if (![YCUserModel isLogin]) {
        [self showLoginViewController];
    }else{
        
        YCPayViewController *payViewController = [[YCPayViewController alloc] initWithNibName:@"YCPayViewController" bundle:nil];
        UINavigationController *navi1 = [[UINavigationController alloc] initWithRootViewController:payViewController];

        [self presentViewController:self.tabBarController animated:NO completion:^{
            
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)showLoginViewController{

    AFLoginController *login = [[AFLoginController alloc] initWithNibName:@"AFLoginController" bundle:nil];
    [self presentViewController:login animated:NO completion:^{
        
    }];
}
@end
