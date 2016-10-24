//
//  YCYuEViewController.m
//  YunCard
//
//  Created by Lwj on 15/12/5.
//  Copyright © 2015年 JiaJun. All rights reserved.
//

#import "YCYuEViewController.h"
#import "YCCardView.h"
@interface YCYuEViewController ()
@property (weak, nonatomic) IBOutlet YCCardView *CardView;
@property (weak, nonatomic) IBOutlet UIButton *chongzhiButton;

@end

@implementation YCYuEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"云卡账户", nil);
    YCUserModel *model = [YCUserModel currentUser];
    if ([model.studentNo isEqualToString:@"12345678"]) {
        self.chongzhiButton.hidden = YES;
    }else{
        self.chongzhiButton.hidden = NO;
    }
    YCUserModel *user = [YCUserModel currentUser];
    NSMutableDictionary *dict = [@{} mutableCopy];
    if (user.studentNo) {
        [dict setObject:user.studentNo forKey:@"stu_no"];
        [dict setObject:@"getUserInfo" forKey:@"action"];
        [AFNManager  postObject:dict
                        apiName:nil
                      modelName:@"YCUserModel"
               requestSuccessed:^(id responseObject){
                   
                   YCUserModel *newUser = (id)responseObject;
                   if ([newUser isKindOfClass:[YCUserModel class]]) {
                       [YCUserModel saveLoginUser:newUser];
                   }
                   [self.CardView bindDataWithModel:[YCUserModel currentUser]];
               }
                 requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
                     
                 }];
    }
}
- (IBAction)getMoneyButtonPressed:(id)sender {
    [self pushViewController:@"JJChongzhiViewController"];
}
- (IBAction)debtDetailPressed:(id)sender {
    [self pushViewController:@"YCTradeHisViewController"];
}

- (IBAction)yunCardLost:(id)sender {
    [self pushViewController:@"YCGuaShiViewController"];
}
@end
