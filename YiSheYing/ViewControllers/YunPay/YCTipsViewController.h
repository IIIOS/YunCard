//
//  YCTipsViewController.h
//  YunCard
//
//  Created by Jinjin on 15/8/23.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "BaseViewController.h"

@interface YCTipsViewController : BaseViewController

@property (nonatomic, weak) UIViewController *popupingViewController;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *titleStr;
@end
