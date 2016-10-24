//
//  YSWeekHeaderView.m
//  YunCard
//
//  Created by helfy  on 15/7/18.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YSWeekHeaderView.h"

#import "UIView+CGRectUtils.h"
@implementation YSWeekHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupView];
    }
    return self;
}


-(void)setupView
{
    self.clipsToBounds = YES;
    
    NSArray*weekTitle = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
   
    float x=20;
    float y=0;
    float width = (self.frameWidth - 40)/weekTitle.count;
    float heigth = self.frameHeight;
    
   for(NSString *str in weekTitle)
    {
        UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(x,y, width, heigth)];
        [weekLabel setBackgroundColor:[UIColor clearColor]];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        weekLabel.textColor = RGB(191, 191, 191);
        weekLabel.font = [UIFont systemFontOfSize:12];
        weekLabel.text = str;
        [self addSubview:weekLabel];
        x += width;
    }
    
    //line
    
    UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(30, self.frameHeight-1, (self.frameWidth - 60), 0.5)];
    lineView.backgroundColor =RGB(191, 191, 191);
    [self addSubview:lineView];
    
}
@end
