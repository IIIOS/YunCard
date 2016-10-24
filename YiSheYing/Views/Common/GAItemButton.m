//
//  GACategoryItemButton.m
//  YunCard
//
//  Created by Jinjin on 15/1/16.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "GAItemButton.h"
#define kGAItemButtonImgHeight 31
#define kGAItemButtonLabelHeight 60

@interface GAItemButton ()
@property (nonatomic,strong) UIColor *normalColor;
@property (nonatomic,strong) UIColor *selectedColor;

@end

@implementation GAItemButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
        [self resetFrame:frame];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    [self resetFrame:frame];
}

- (void)resetFrame:(CGRect)frame{
    
    CGFloat imgHeight = self.imageHeight?:kGAItemButtonImgHeight;
    CGFloat labelHeight = self.titleHeight?:kGAItemButtonLabelHeight;
    
    
    CGFloat height = CGRectGetHeight(frame);
    CGFloat width = CGRectGetWidth(frame);
    CGFloat leftAndRight = (width-imgHeight)/2;
    CGFloat top = 30;
    CGFloat bottom   = height -top  -imgHeight;
    self.imageEdgeInsets = UIEdgeInsetsMake(top, leftAndRight, bottom, leftAndRight);
    
    self.gaTitleLabel.frame = CGRectMake(0, height-labelHeight, width, labelHeight);
}

- (UILabel *)gaTitleLabel{
    
    if (nil==_gaTitleLabel) {
        _gaTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _gaTitleLabel.textColor = self.normalColor;
        _gaTitleLabel.font = [UIFont boldSystemFontOfSize:13];
        _gaTitleLabel.textAlignment = NSTextAlignmentCenter;
        _gaTitleLabel.text = nil;
        [self addSubview:_gaTitleLabel];
    }
    return _gaTitleLabel;
}

- (void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    _gaTitleLabel.textColor = selected?self.selectedColor:self.normalColor;
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state{
    
    [super setTitleColor:color forState:state];
    if (state==UIControlStateNormal) self.normalColor = color;
    if (state==UIControlStateSelected) self.selectedColor = color;
    
    _gaTitleLabel.textColor = self.selected?self.selectedColor:self.normalColor;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    
    _gaTitleLabel.text = title;
}

- (void)setTitleHeight:(CGFloat)titleHeight{
    
    _titleHeight = titleHeight;
    [self resetFrame:self.frame];
}

- (void)setImageHeight:(CGFloat)imageHeight{
    _imageHeight = imageHeight;
    [self resetFrame:self.frame];
}
@end
