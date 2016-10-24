//
//  YSAlertView.h
//  YunCard
//
//  Created by helfy  on 15/7/22.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSAlertViewDelegete <NSObject>

-(BOOL)alertViewDidTapOkButton:(id)alertView;

@end

@interface YSAlertView : UIView
@property (nonatomic,assign)id<YSAlertViewDelegete> delegate;

@property (nonatomic,readonly)UIView *customView; // 用户获取custom 的一些数据

-(id)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle cancelButton:(NSString *)cancelbutton okButton:(NSString *)okButton customView:(UIView *)customView;
-(void)showInView:(UIView *)view;


@end
