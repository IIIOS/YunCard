//
//  YCChargeViewController.m
//  YunCard
//
//  Created by Jinjin on 15/8/21.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YCChargeViewController.h"
#import "MButton.h"

@interface YCChargeViewController ()
@property (nonatomic, weak) IBOutlet UITextField *phoneField;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *btnsArray;
@end

@implementation YCChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-63);
    self.title = @"手机充值";
    
    self.phoneField.text = [[YCUserModel currentUser] phone];
    
    CGFloat offset = 25;
    CGFloat padding = 15;
    CGFloat width = (SCREEN_WIDTH-offset*2-padding*2)/3;
    
    self.btnsArray = [NSMutableArray array];
    
    NSArray *texts = @[@"20元",@"50元",@"100元"];
    for (NSInteger index=0; index<3; index++) {
        MButton *actionButton = [MButton new];
        actionButton.layer.cornerRadius =3;
        actionButton.tag = index;
        [actionButton setNormalColor:RGB(206, 206, 206) SelectColor:RGB(237, 127, 52)];
        [actionButton setTitle:texts[index] forState:UIControlStateNormal];
        actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [actionButton addTarget:self action:@selector(didChoose:) forControlEvents:UIControlEventTouchUpInside];
        actionButton.frame = CGRectMake(padding+index*(width+offset), 105, width, 30);
        actionButton.selected = index==0;
        [self.scrollView addSubview:actionButton];
        
        [self.btnsArray addObject:actionButton];
    }
    
    MButton *actionButton = [MButton new];
    actionButton.layer.cornerRadius = 5;
    [actionButton setNormalColor:kDefaultBlueColor SelectColor:[kDefaultBlueColor colorWithAlphaComponent:0.5]];
    [actionButton setTitle:@"立即充值" forState:UIControlStateNormal];
    actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [actionButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    actionButton.frame = CGRectMake(padding, 170, SCREEN_WIDTH-padding*2, 44);
    [self.scrollView addSubview:actionButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)didChoose:(UIButton *)tbtn{
    
    for (UIButton *btn in self.btnsArray) {
        btn.selected = NO;
    }
    tbtn.selected = YES;
}

- (void)send{

}
@end
