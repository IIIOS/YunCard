//
//  NoDataInfoView.m
//  YunCard
//
//  Created by Jinjin on 15/1/28.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "NoDataInfoView.h"

#define kNoInfoContentWidth (self.frame.size.width)
#define kNoInfoIconWidth    100
#define kNoInfoLabelHeight  40
#define kNoInfoLabelOffset  60
#define kNoInfoItemYOffset  10
#define kNoInfoBtnHeight    40
#define kNoInfoBtnWidth     275


@interface NoDataInfoView()

@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *infoLabel;
@end

@implementation NoDataInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init{
    
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNoInfoContentWidth, 500)];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.autoresizingMask = UIViewAutoresizingNone;
    [self addSubview:self.contentView];
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kNoInfoContentWidth-kNoInfoIconWidth)/2, 0, kNoInfoIconWidth, kNoInfoIconWidth)];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.iconImageView];

    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(kNoInfoLabelOffset, kNoInfoIconWidth+kNoInfoItemYOffset, (kNoInfoContentWidth-kNoInfoLabelOffset*2), kNoInfoLabelHeight)];
    self.infoLabel.numberOfLines = 2;
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.textColor = RGB(30, 30, 30);
    self.infoLabel.text = @"当前无数据";
    self.infoLabel.font = [UIFont systemFontOfSize:14];
    self.infoLabel.autoresizingMask = UIViewAutoresizingNone;
    [self.contentView addSubview:self.infoLabel];

    self.actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.actionBtn.frame = CGRectMake((kNoInfoContentWidth-kNoInfoBtnWidth)/2, kNoInfoIconWidth+kNoInfoItemYOffset+kNoInfoLabelHeight+kNoInfoItemYOffset, kNoInfoBtnWidth, kNoInfoBtnHeight);
    self.actionBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.actionBtn setTitle:@"刷新试试" forState:UIControlStateNormal];
    self.actionBtn.autoresizingMask = UIViewAutoresizingNone;
    [self.actionBtn setBackgroundImage:[UIImage imageNamed:@"btn_bar_normal"] forState:UIControlStateNormal];
    [self.actionBtn setBackgroundImage:[UIImage imageNamed:@"btn_bar_h"] forState:UIControlStateHighlighted];
    [self.contentView addSubview:self.actionBtn];

    _showItems = ShowNODataViewItemIcon|ShowNODataViewItemInfoLabel|ShowNODataViewItemActionBtn;
    _centerOffset = 0;
    
    self.topOffset = 100;
}


- (void)setCenterOffset:(NSInteger)centerOffset{
    _centerOffset = centerOffset;
    [self remakeConstraints];
}


- (void)setTopOffset:(NSInteger)topOffset{
    _topOffset = topOffset;
    [self remakeConstraints];
}

- (void)setShowItems:(ShowNODataViewItem)showItems{
    
    _showItems = showItems;
    [self remakeConstraints];
}


- (void)setInfoText:(NSString *)text{
    self.infoLabel.text = text;
    [self remakeConstraints];
}

- (void)setIconImage:(UIImage *)img{
    self.iconImageView.image = img;
    [self remakeConstraints];
}

- (void)remakeConstraints{
    
    CGFloat contentTatalHeight = 0;
    NSInteger countOfItem = 0;
    
    self.actionBtn.hidden = YES;
    self.infoLabel.hidden = YES;
    self.iconImageView.hidden = YES;
    
    if ((self.showItems&ShowNODataViewItemIcon)) {
        self.iconImageView.hidden = NO;
        self.iconImageView.frame = CGRectMake((kNoInfoContentWidth-kNoInfoIconWidth)/2, contentTatalHeight, kNoInfoIconWidth, kNoInfoIconWidth);
        countOfItem += 1;
        contentTatalHeight += kNoInfoIconWidth;
    }
    if ((self.showItems&ShowNODataViewItemInfoLabel)) {
        self.infoLabel.hidden = NO;
        self.infoLabel.frame = CGRectMake(kNoInfoLabelOffset, contentTatalHeight+countOfItem*kNoInfoItemYOffset, (kNoInfoContentWidth-kNoInfoLabelOffset*2), kNoInfoLabelHeight);
        countOfItem += 1;
        contentTatalHeight += kNoInfoLabelHeight;
    }
    if (self.showItems & ShowNODataViewItemActionBtn) {
        self.actionBtn.hidden = NO;
        self.actionBtn.frame = CGRectMake((kNoInfoContentWidth-kNoInfoBtnWidth)/2, contentTatalHeight+countOfItem*kNoInfoItemYOffset, kNoInfoBtnWidth, kNoInfoBtnHeight);
        countOfItem += 1;
        contentTatalHeight += kNoInfoBtnHeight;
    }
    
    self.contentView.frame = CGRectMake(0, self.topOffset, kNoInfoContentWidth, MAX(contentTatalHeight+(countOfItem-1)*kNoInfoItemYOffset, 0));
    self.contentView.center = CGPointMake(self.contentView.center.x, self.contentView.center.y+self.centerOffset);
}

- (void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    [self remakeConstraints];
}
@end
