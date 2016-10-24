//
//  YSChooseValueView.h
//  YunCard
//
//  Created by helfy  on 15/7/20.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YSChooseValueViewDelegate <NSObject>

-(void)chooseValueDidChoose:(id)view index:(int)chooseIndex;

@end


@interface YSChooseValueView : UIView
@property (nonatomic,assign)id<YSChooseValueViewDelegate> delegate;

@property (nonatomic,strong)NSArray * values;

//用来标示
@property (nonatomic,strong)NSString * keyStr;

- (void)showInView:(UIView *) view;
- (void)cancelChoose;

@end
