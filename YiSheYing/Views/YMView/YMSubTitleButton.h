//
//  YMSubTitleButton.h
//  YunCard
//
//  Created by helfy  on 15/6/13.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    YMSubTitleButtonTypeMode1=0,   //title 大
    YMSubTitleButtonTypeMode2,      //subTitle 大
}YMSubTitleButtonType;

@interface YMSubTitleButton : UIButton
@property(nonatomic,readonly) UILabel *subTitle;

-(id)initWithType:(YMSubTitleButtonType)type;
@end
