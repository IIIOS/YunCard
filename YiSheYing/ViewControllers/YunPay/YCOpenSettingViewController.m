//
//  YCOpenSettingViewController.m
//  YunCard
//
//  Created by Jinjin on 15/8/22.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YCOpenSettingViewController.h"
#import "UIViewController+CWPopup.h"

@interface YCOpenSettingViewController ()



@property (nonatomic, strong) IBOutlet UILabel *delayTimeLabel;


@property (nonatomic, strong) YCShowerSettingModel *model;

- (IBAction)delayOpenBtnTap:(id)sender;
- (IBAction)openBtnTap:(id)sender;
- (IBAction)cancelBtnTap:(id)sender;
@end

@implementation YCOpenSettingViewController
- (void)dealloc
{
    self.popupingViewController = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [[YCShowerSettingModel alloc] initWithString:[YCUserModel currentUser].wash_setting error:NULL];

    // Do any additional setup after loading the view from its nib.
    [self.delayOpenBtn addSubview:self.delayTimeLabel];
    self.delayTimeLabel.textColor = [UIColor whiteColor];
    [self.delayOpenBtn setBackgroundImage:[[UIImage imageNamed:@"home_device_end"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 4, 5, 6)] forState:UIControlStateNormal];
    [self.openBtn setBackgroundImage:[[UIImage imageNamed:@"home_open_now"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 4, 5, 6)] forState:UIControlStateNormal];
//    [self.cancelBtn setTitleColor:RGB(242, 242, 242) forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundImage:[[UIImage imageNamed:@"home_open_cancel"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 4, 5, 6)] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setModel:(YCShowerSettingModel *)model{
    _model = model;
    [self reloadDelayTime];
}

- (IBAction)delayOpenBtnTap:(id)sender{
    if (self.openBlock) {
        self.openBlock(YES);
    }
    [self back];
}

- (IBAction)openBtnTap:(id)sender{
    if (self.openBlock) {
        self.openBlock(NO);
    }
    [self back];
}

- (IBAction)cancelBtnTap:(id)sender{
    [self back];
}

- (void)back{
    [self.popupingViewController dismissPopupViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)setInfoText:(NSString *)infoText{
    
    _infoText = infoText;
    [self reloadDelayTime];
}

- (void)reloadDelayTime{
    
    
    self.delayTimeLabel.text = [NSString stringWithFormat:@"延时开启\n(%.0fs)",_model.delay_time];
    if (self.infoText.length) {
        self.delayTimeLabel.text = self.infoText;
        self.delayOpenBtn.userInteractionEnabled = NO;
    }
}
@end
