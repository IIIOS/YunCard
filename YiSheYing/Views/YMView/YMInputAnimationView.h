//
//  YMInputAnimationView.h
//  dream
//
//  Created by helfy  on 15-3-30.
//  Copyright (c) 2015年 helfy . All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  enum{
    YMInputAnimationViewTypeIsDate =0,
    YMInputAnimationViewTypeIsTime ,
    YMInputAnimationViewTypeIsDateAndTime ,
    YMInputAnimationViewTypeIsCustomData ,
    YMInputAnimationViewTypeIsNone,
    
}YMInputAnimationViewType;

@interface YMInputAnimationView : UIView
-(id)initWithType:(YMInputAnimationViewType)type;
@property (nonatomic,strong) NSArray *dataSourceArrry;
@property (nonatomic,strong) id defaultValue;


@property (nonatomic,strong) id minimumDate;
@property (nonatomic,strong) id maximumDate;



@property(nonatomic,strong) void(^changeBlock)(id chooseValue);

-(void)showInView:(UIView *)view;
@end
