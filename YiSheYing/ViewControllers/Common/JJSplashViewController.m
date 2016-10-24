//
//  JJSplashViewController.m
//  Footprints
//
//  Created by tt on 14-10-15.
//  Copyright (c) 2014年 JiaJun. All rights reserved.
//

#import "JJSplashViewController.h"

@interface JJSplashViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *skipBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *welcomeScroll;

- (IBAction)skipBtnDidTap:(id)sender;

@end

@implementation JJSplashViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupDefaultUI];
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
#pragma mark -
#pragma mark UI Methods
- (void)setupDefaultUI{
    self.welcomeScroll.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    NSInteger pageCount = 3;
    for (NSInteger index=0; index<pageCount; index++) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:self.welcomeScroll.bounds];
        img.clipsToBounds = YES;
        img.contentMode = UIViewContentModeScaleAspectFill;
        if (SCREEN_HEIGHT<568) {
            img.image = [UIImage imageNamed:[NSString stringWithFormat:@"start_page_small_%li.jpg",(long)(index+1)]];
        }else{
            img.image = [UIImage imageNamed:[NSString stringWithFormat:@"start_page_%li.jpg",(long)(index+1)]];
        }
        img.frame = CGRectMake(index*CGRectGetWidth(self.welcomeScroll.frame), 0, CGRectGetWidth(self.welcomeScroll.frame), SCREEN_HEIGHT);
        [self.welcomeScroll addSubview:img];
    }
    self.skipBtn.frame = CGRectMake(0, 0, 78, 33);
    [self.welcomeScroll bringSubviewToFront:self.skipBtn];
    CGFloat bottom = (SCREEN_HEIGHT<568)?90:110;
    self.skipBtn.center = CGPointMake(SCREEN_WIDTH/2 + (pageCount-1)*SCREEN_WIDTH, SCREEN_HEIGHT-bottom);
    self.welcomeScroll.contentSize = CGSizeMake(pageCount*CGRectGetWidth(self.welcomeScroll.frame), SCREEN_HEIGHT);
    self.welcomeScroll.delegate = self;
    
    WS(ws);
    [self.welcomeScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(ws.view);
    }];
}

- (IBAction)skipBtnDidTap:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kGASplashDidBackNotification object:nil];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
@end
