//
//  YCOpenSettingViewController.h
//  YunCard
//
//  Created by Jinjin on 15/8/22.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "BaseViewController.h"

@interface YCOpenSettingViewController : BaseViewController
@property (nonatomic, weak) IBOutlet UIButton *delayOpenBtn;
@property (nonatomic, weak) IBOutlet UIButton *openBtn;
@property (nonatomic, weak) IBOutlet UIButton *cancelBtn;
@property (nonatomic, strong) NSString *infoText;
@property (nonatomic, weak) UIViewController *popupingViewController;
@property (nonatomic, copy) void (^openBlock) (BOOL isDelayOpen);
@end
