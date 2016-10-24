//
//  YCCardView.m
//  YunCard
//
//  Created by Jinjin on 15/8/20.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YCCardView.h"

@interface YCCardView()
@property (nonatomic,strong) UILabel *moneyLabel;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *noLabel;
@end

@implementation YCCardView

- (instancetype)init{
    
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupView{

    self.clipsToBounds = YES;
    self.layer.cornerRadius = 13;
    self.layer.borderWidth = 1.5;
    self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8].CGColor;
    
    CGFloat topHeight = 48;
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ac_logo"]];
    logo.frame = CGRectMake(12, (topHeight-36)*0.5, 36, 36);
    [self addSubview:logo];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 150, topHeight)];
    title.numberOfLines = 0;
    title.text = @"四川工业科技学院\n学生云卡";
    title.font = [UIFont systemFontOfSize:14];
    [self addSubview:title];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(12, 48, self.frame.size.width-24, 0.5)];
    line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    [self addSubview:line];
    [self initLabel];
}


- (void)bindDataWithModel:(YCUserModel *)model{
    
    self.moneyLabel.text = [NSString stringWithFormat:@"余额：%.2f",model.cardBalance / 100.0];
    self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@",model.nickName?:@""];
    self.noLabel.text = [NSString stringWithFormat:@"学号：%@",model.studentNo?:@""];

}
- (void)initLabel
{
    _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, self.frame.size.width-20, 24)];
    _moneyLabel.font = [UIFont systemFontOfSize:20];
    _moneyLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _moneyLabel.textAlignment = NSTextAlignmentLeft;
    _moneyLabel.textColor = RGB(0, 0, 0);
    [self addSubview:_moneyLabel];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, self.frame.size.width-20, 16)];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = RGB(212, 212, 212);
    [self addSubview:_nameLabel];
    
    _noLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, self.frame.size.width-20, 16)];
    _noLabel.font = [UIFont systemFontOfSize:14];
    _noLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _noLabel.textAlignment = NSTextAlignmentLeft;
    _noLabel.textColor = RGB(212, 212, 212);
    [self addSubview:_noLabel];
}


@end
