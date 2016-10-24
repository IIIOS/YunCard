//
//  YCUserResulitController.m
//  YunCard
//
//  Created by Jinjin on 15/8/23.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YCUserResulitController.h"
#import "UIViewController+CWPopup.h"

@interface YCUserResulitController ()
@property (nonatomic, weak) IBOutlet UIButton *closeBtn;
@property (nonatomic, weak) IBOutlet UILabel *rateLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *costLabel;


- (IBAction)closeBtnTap:(id)sender;
@end

@implementation YCUserResulitController
- (void)dealloc
{
    self.popupingViewController = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.cornerRadius = 3;
    
    UIView *view = [self.view viewWithTag:1020];
    view.layer.cornerRadius = 3;
    view.layer.borderWidth = 0.65f;
    view.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.6] CGColor];
    
    [self.closeBtn setBackgroundImage:[[UIImage imageNamed:@"btn_img_cancle"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 4, 5, 6)] forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.data = _data;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setData:(id)data{
    
    _data = data;
    YCUseResultModel *model = data;
    if ([model isKindOfClass:[YCUseResultModel class]]) {
        self.rateLabel.text = [NSString stringWithFormat:@"费率：%@",model.fee_rate?:@""];
        self.timeLabel.text = [NSString stringWithFormat:@"本次消费时间：%@",model.time?:@""];
        self.costLabel.text = [NSString stringWithFormat:@"本次消费总额：%@",model.total_fee?:@""];
    }else{
        self.rateLabel.text = @"费率：";
        self.timeLabel.text = @"本次消费时间：";
        self.costLabel.text = @"本次消费总额";
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

- (IBAction)closeBtnTap:(id)sender{
    [self.popupingViewController dismissPopupViewControllerAnimated:YES completion:^{
        
    }];
}
@end
