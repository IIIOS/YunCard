//
//  YCTipsViewController.m
//  YunCard
//
//  Created by Jinjin on 15/8/23.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YCTipsViewController.h"
#import "UIViewController+CWPopup.h"

@interface YCTipsViewController ()
@property (nonatomic, weak) IBOutlet UIButton *closeBtn;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;

- (IBAction)closeBtnTap:(id)sender;
@end

@implementation YCTipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.view.layer.cornerRadius = 3;
    
    UIView *view = [self.view viewWithTag:1020];
    view.layer.cornerRadius = 3;
    view.layer.borderWidth = 0.65f;
    view.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.6] CGColor];
    
    [self.closeBtn setBackgroundImage:[[UIImage imageNamed:@"btn_img_cancle"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 4, 5, 6)] forState:UIControlStateNormal];
    
    self.titleLabel.text = self.titleStr?:@"提示信息";
    self.messageLabel.text = self.message;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTitleStr:(NSString *)titleStr{
    
    _titleStr = titleStr;
    self.titleLabel.text = titleStr;
}

- (void)setMessage:(NSString *)message{
    
    _message = message;
    self.messageLabel.text = message;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeBtnTap:(id)sender{
    [self.popupingViewController dismissPopupViewControllerAnimated:YES completion:^{
        
    }];
}
@end
