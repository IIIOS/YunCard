//
//  YCDeviceCell.m
//  YunCard
//
//  Created by Jinjin on 15/8/18.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YCDeviceCell.h"

@interface YCDeviceCell()

@property (nonatomic, weak) IBOutlet UIView *colorView;
@property (nonatomic, weak) IBOutlet UIImageView *iconView;
@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UIButton *actionBtn;
@property (nonatomic, weak) IBOutlet UIButton *repairBtn;


@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) id data;

- (IBAction)actionBtnDidTap:(id)sender;
- (IBAction)settingDidTap:(id)sender;
@end


@implementation YCDeviceCell
- (void)dealloc{
    [self stopTimer];
}

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bgImageView.image = [[UIImage imageNamed:@"home_device_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 4, 5, 6)];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    
    [self addGestureRecognizer:longPress];
    [self.actionBtn.titleLabel sizeToFit];
    self.actionBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
//    self.timeLabel.textColor = [UIColor whiteColor];
//    self.timeLabel.frame = CGRectMake(0, 0, 50, 50);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)stopTimer{
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)startTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(resetTime) userInfo:nil repeats:YES];
}

- (void)resetTime{

    NSDate *startDate = [self.data startUseDate];
    if (startDate) {
        [self setCountDown:[[NSDate date] timeIntervalSinceDate:startDate]];
    }else{
//        self.timeLabel.text = @"关闭\n未知时长";
        [self stopTimer];
    }
}

- (void)bindData:(YCDeviceModel *)model{

    self.data = model;
    
    BOOL isOn = model.deviceStatus!=YCDeviceStatusOff;
    self.statusLabel.text = [NSString stringWithFormat:@"状态: %@",model.deviceStatusString];
//    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.deviceIcon] placeholderImage:kDefaultPlaceHolder];
    if ([model.DVTP_ID integerValue] == 1) {
        [self.iconView setImage:[UIImage imageNamed:@"mid1"]];
    }else if ([model.DVTP_ID integerValue] == 2) {
        [self.iconView setImage:[UIImage imageNamed:@"mid2"]];
    }else {
        [self.iconView setImage:[UIImage imageNamed:@"header"]];

    }
    self.colorView.backgroundColor = isOn?RGB(34, 161, 214):RGB(105, 167, 60);
    self.titleLabel.text = [NSString stringWithFormat:@"%@-%@",model.DEV_Position,model.DEV_No];
    
    CGSize size = [self.statusLabel sizeThatFits:CGSizeMake(0, 0)];
    self.repairBtn.frame = CGRectMake(80+size.width-8, 33, 40, 40);
    self.actionBtn.userInteractionEnabled = NO;
//    self.timeLabel.hidden = YES;
    [self stopTimer];
    switch (model.deviceStatus) {
        case YCDeviceStatusOpenByMe: {
            NSDate *startDate = [model startUseDate];
//            self.timeLabel.text = @"关闭";
//            self.timeLabel.hidden = NO;
            self.actionBtn.userInteractionEnabled = YES;
            if (startDate && [model.DVTP_ID integerValue] == 2) { //只有洗衣机才显示
                [self startTimer];
                [self.actionBtn setTitle:@"使用中" forState:UIControlStateNormal];
                [self setCountDown:[[NSDate date] timeIntervalSinceDate:startDate]];
            }else {
                [self.actionBtn setTitle:@"关闭" forState:UIControlStateNormal];

            }
            [self.actionBtn setBackgroundImage:[[UIImage imageNamed:@"home_device_end"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 4, 5, 6)] forState:UIControlStateNormal];
            break;
        }
        case YCDeviceStatusOpenByOther: {
            [self.actionBtn setBackgroundImage:[[UIImage imageNamed:@"home_device_unable"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 4, 5, 6)] forState:UIControlStateNormal];
            [self.actionBtn setTitle:@"使用中" forState:UIControlStateNormal];
            break;
        }
        case YCDeviceStatusOff: {
            self.actionBtn.userInteractionEnabled = YES;
            [self.actionBtn setBackgroundImage:[[UIImage imageNamed:@"home_device_start"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 4, 5, 6)] forState:UIControlStateNormal];
            [self.actionBtn setTitle:@"开启" forState:UIControlStateNormal];
            break;
        }
        case YCDeviceStatusRepair: {
            [self.actionBtn setBackgroundImage:[[UIImage imageNamed:@"home_device_unable"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 4, 5, 6)] forState:UIControlStateNormal];
            [self.actionBtn setTitle:@"不可用" forState:UIControlStateNormal];
            break;
        }
        case YCDeviceStatusClose: {
            [self.actionBtn setBackgroundImage:[[UIImage imageNamed:@"home_device_unable"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 4, 5, 6)] forState:UIControlStateNormal];
            [self.actionBtn setTitle:@"设备维护中" forState:UIControlStateNormal];

            break;
        }        case YCDeviceStatusOpen: {
            [self.actionBtn setBackgroundImage:[[UIImage imageNamed:@"home_device_unable"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 4, 5, 6)] forState:UIControlStateNormal];
            [self.actionBtn setTitle:@"关闭中" forState:UIControlStateNormal];
            break;
        }
        default: {
            break;
        }
    }
}

- (void)setCountDown:(NSTimeInterval)interval{
    NSInteger m = ABS(interval / 60);
    NSInteger s = ABS(((NSInteger)interval) % 60);
    
    if (interval<0 && !(m==0 && s==0)) {
//        self.timeLabel.text = (s<10)?[NSString stringWithFormat:@"关闭\n-%li:0%li",(long)m,(long)s]:[NSString stringWithFormat:@"关闭\n-%li:%li",(long)m,(long)s];
    }else{
        
//        self.timeLabel.text = (s<10)?[NSString stringWithFormat:@"关闭\n%li:0%li",(long)m,(long)s]:[NSString stringWithFormat:@"关闭\n%li:%li",(long)m,(long)s];
    }
}

#pragma mark - Action Methods
- (IBAction)actionBtnDidTap:(id)sender{

    if (self.actionBlock) {
        self.actionBlock(self,YCDeviceActionTypeOp);
    }
}

- (IBAction)settingDidTap:(id)sender{

    if (self.actionBlock) {
        self.actionBlock(self,YCDeviceActionTypeSetting);
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture{
    if(gesture.state == UIGestureRecognizerStateBegan){
        if (self.actionBlock) {
            self.actionBlock(self,YCDeviceActionTypeDelete);
        }
    }
    }
@end
