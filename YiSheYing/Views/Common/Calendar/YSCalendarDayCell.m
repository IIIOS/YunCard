//
//  YSCalendarDayCell.m
//  YunCard
//
//  Created by helfy  on 15/7/18.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YSCalendarDayCell.h"
#import "UIView+CGRectUtils.h"
@implementation YSCalendarDayCell
{
    UILabel *dayLabel;

    UIView *statusView; //不同状态下的背景
    
    BOOL isEdit;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
-(void)setupView
{
    statusView = [UIView new];
    statusView.layer.masksToBounds = YES;
    statusView.layer.cornerRadius = (self.frameWidth-10)/2;
    [self.contentView addSubview:statusView];
    [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.center.equalTo(self.contentView);
        make.width.height.equalTo(@(self.frameWidth - 10));
    }];

    
    dayLabel = [UILabel new];
    [self.contentView addSubview:dayLabel];
    dayLabel.textColor = RGB(191, 191, 191);
    dayLabel.font = [UIFont systemFontOfSize:12];
    
    dayLabel.textAlignment =NSTextAlignmentCenter;
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}




-(void)bindModel:(YSCalendarDayModel *)dayModel
{
    dayLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)dayModel.day];
    [self hiddenContent:NO];
    
    statusView.hidden = YES;

    switch (dayModel.style) {
        case YSCalendarDayTypeEmpty://不显示
        {
            [self hiddenContent:YES];
        }
            break;
        case YSCalendarDayPast:
        {
            dayLabel.textColor = RGB(215, 216, 216);
        }
            break;
        case YSCalendarDayToday:
        {
            if(isEdit)
            {
                dayLabel.textColor = RGB(50, 50, 50);
            }
            else{
                dayLabel.textColor = RGB(244, 61, 83);
                
            }
            statusView.hidden = NO;
            statusView.layer.borderColor = dayLabel.textColor.CGColor;
            statusView.layer.borderWidth=1;
            statusView.backgroundColor = [UIColor clearColor];
        }
            break;
        case YSCalendarDayFutur:
        {
            if(isEdit)
            {
                dayLabel.textColor = RGB(50, 50, 50);
                
            }
            else{
                dayLabel.textColor = RGB(244, 61, 83);
            }
      }
            break;
            
        case YSCalendarDayFull:
        {
            if(isEdit)
            {
                dayLabel.textColor = RGB(244, 61, 83);
            }
            else{
                dayLabel.textColor = RGB(191, 191, 191);
                
            
            }
          
        }
            break;
        default:break;
            
    }
    
    
    if (dayModel.isSelect) {
        dayLabel.textColor = [UIColor whiteColor];
        statusView.hidden = NO;
        statusView.layer.borderColor = [UIColor clearColor].CGColor;
        statusView.layer.borderWidth=0;
        statusView.backgroundColor =RGB(244, 61, 83);
    }
}
-(void)setIsEdit:(BOOL)isedit
{
    isEdit = isedit;
}
-(void)hiddenContent:(BOOL)hidden{
    
    dayLabel.hidden = hidden;
}



@end
