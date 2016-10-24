//
//  YSAlertView.m
//  YunCard
//
//  Created by helfy  on 15/7/22.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YSAlertView.h"
#import "MButton.h"
#import "UIView+CGRectUtils.h"
#define kDeviceWidth  [UIScreen mainScreen].bounds.size.width
#define kLeftSpace 20
#define kRigthSpace 20

@implementation YSAlertView
{
    UIView *contentView;
    UILabel *titleLabel;
    UILabel *subTitleLabel;
    

    int contentViewHeigth;
}

-(id)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle cancelButton:(NSString *)cancelbutton okButton:(NSString *)okButton customView:(UIView *)customView
{
    self = [super init];
    if(self)
    {
        [self sutupView];
        [self bind:title subTitle:subTitle cancelButton:cancelbutton okButton:okButton customView:customView];
   }
    
    return self;

}
-(void) sutupView
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    contentView = [UIView new];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius=2;
    contentView.layer.masksToBounds = YES;
    [self addSubview:contentView];
    
    
    titleLabel = [UILabel new];
    titleLabel.textColor = kDefaultReadColor;
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLabel];
    
    
    subTitleLabel = [UILabel new];
    subTitleLabel.textColor = RGB(66, 66, 66);
    subTitleLabel.font = [UIFont systemFontOfSize:16];
    subTitleLabel.numberOfLines = 0;
    subTitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [contentView addSubview:subTitleLabel];
}


-(void)bind:(NSString *)title subTitle:(NSString *)subTitle cancelButton:(NSString *)cancelButtonStr okButton:(NSString *)okButtonStr customView:(UIView *)customView
{
    
    float contentShowWidth  = kDeviceWidth-kLeftSpace-kRigthSpace-20;
    int totalHeigth=20;
    CGSize constrain = CGSizeMake(contentShowWidth, 9999);
    int textHeigth = 0;
    if(title.length >0)
    {
        titleLabel.text = title;
        textHeigth= [titleLabel.text boundingRectWithSize:constrain options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleLabel.font} context:Nil].size.height;
     
    }
    totalHeigth+=textHeigth;
    [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.right.equalTo(contentView).offset(-10);
        
        make.top.equalTo(contentView).offset(10);
        make.height.equalTo(@(textHeigth));
    }];

    int subTextHeigth = 0;
    if(subTitle.length >0)
    {
        subTitleLabel.text=subTitle;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = subTitleLabel.lineBreakMode;
        NSDictionary *attributes = @{NSFontAttributeName:subTitleLabel.font, NSParagraphStyleAttributeName:paragraphStyle};
        
        subTextHeigth= [subTitleLabel.text boundingRectWithSize:constrain options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:Nil].size.height;
        
        subTextHeigth +=20;
    }
    totalHeigth+=subTextHeigth;
    
    [subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.right.equalTo(contentView).offset(-10);
        make.top.equalTo(titleLabel.mas_bottom);
        make.height.equalTo(@(subTextHeigth));
    }];
    
    
    _customView = customView;
    if(customView)
    {
        totalHeigth+=customView.frameHeight;
        
        [contentView addSubview:customView];
        [customView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(customView.frameWidth));
            make.top.equalTo(subTitleLabel.mas_bottom);
            make.centerX.equalTo(contentView);
            make.height.equalTo(@(customView.frameHeight));
            
        }];
        
    }
    
    
    
    MButton *okButton;
    MButton *cancenButton;
    
    if(okButtonStr.length>0)
    {
        okButton= [MButton new];
        okButton.layer.cornerRadius=3;
        [okButton setTitle:okButtonStr forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(okButtonRespone) forControlEvents:UIControlEventTouchUpInside];
        
        [okButton setNormalColor:RGB(43, 182, 188) SelectColor:[RGB(43, 182, 188) colorWithAlphaComponent:0.8]];
        [contentView addSubview:okButton];
        
    }
    
    
    if(cancelButtonStr.length>0)
    {
        cancenButton= [MButton new];
        cancenButton.layer.cornerRadius=3;
        [cancenButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [cancenButton setTitle:cancelButtonStr forState:UIControlStateNormal];
        [cancenButton setNormalColor:kDefaultReadColor SelectColor:[kDefaultReadColor colorWithAlphaComponent:0.8]];
        [contentView addSubview:cancenButton];
        
    }
    
    float buttonHeigth=0;
    if(okButton && cancenButton)
    {
        buttonHeigth=45;
        [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(buttonHeigth-10));
            make.width.equalTo(cancenButton.mas_width);
            make.left.equalTo(contentView).offset(10);
            make.right.equalTo(cancenButton.mas_left).offset(-10);
            make.top.equalTo(customView?customView.mas_bottom:subTitleLabel.mas_bottom).offset(10);
        }];
        
        [cancenButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(buttonHeigth-10));
            make.width.equalTo(cancenButton.mas_width);
            make.right.equalTo(contentView).offset(-10);
            make.left.equalTo(okButton.mas_right).offset(10);
            make.top.equalTo(customView?customView.mas_bottom:subTitleLabel.mas_bottom).offset(10);
            
        }];
    }
    else
    {
        if(okButton)
        {
            buttonHeigth=45;
            [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(buttonHeigth-10));
                make.left.equalTo(contentView).offset(10);
                make.right.equalTo(contentView).offset(-10);
                make.top.equalTo(customView?customView.mas_bottom:subTitleLabel.mas_bottom).offset(10);
            }];
        }
        if(cancenButton)
        {
            buttonHeigth=50;
            [cancenButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(buttonHeigth-10));
     
                make.right.equalTo(contentView).offset(-10);
                make.left.equalTo(okButton).offset(10);
                make.top.equalTo(customView?customView.mas_bottom:subTitleLabel.mas_bottom).offset(10);
                
            }];
        }
    }
    
    totalHeigth+=buttonHeigth;
    
    
    contentViewHeigth=totalHeigth;
    [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kLeftSpace);
        make.right.equalTo(self).offset(-kRigthSpace);
        
        make.height.equalTo(@(contentViewHeigth));
        
        make.center.equalTo(self);
      
    }];
}


#pragma mark - UIKeyboardNotification

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
 
    
    float offset = endFrame.origin.y - beginFrame.origin.y;
    if(offset > 200) //收起
    {
        [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(kLeftSpace);
            make.right.equalTo(self).offset(-kRigthSpace);
            make.height.equalTo(@(contentViewHeigth));
            
            make.center.equalTo(self);
            
        }];
    }
    else if(offset < 200) //出现
    {
      
        [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(kLeftSpace);
            make.right.equalTo(self).offset(-kRigthSpace);
            make.height.equalTo(@(contentViewHeigth));
            
            make.top.equalTo(self).offset(([UIScreen mainScreen].bounds.size.height <=480)?50:100);
            //        make.centerY.equalTo(self).offset(offset);
        }];
    }

    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:^{
        [self layoutSubviews];
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark - respone
-(void)showInView:(UIView *)view
{
    [view addSubview:self];
    self.frame = view.bounds;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)dismiss
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self removeFromSuperview];
    
}


-(void)okButtonRespone
{
    if ([self.delegate respondsToSelector:@selector(alertViewDidTapOkButton:)]) {
        if([self.delegate alertViewDidTapOkButton:self])
        {
              [self dismiss];
        }
    }

    else{
        [self dismiss];
    }
}
@end
