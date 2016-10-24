//
//  AFDotProgressView.h
//  Test
//
//  Created by Jinjin on 15/7/6.
//  Copyright (c) 2015年 Jinjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFDotProgressView : UIView
@property (nonatomic,assign)int maxValue;
@property (nonatomic,assign)int currentValue;
@property (nonatomic,retain) UIColor *progressBgColor;

@end
