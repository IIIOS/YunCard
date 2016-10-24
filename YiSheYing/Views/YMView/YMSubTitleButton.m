//
//  YMSubTitleButton.m
//  YunCard
//
//  Created by helfy  on 15/6/13.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YMSubTitleButton.h"
#import "UIView+CGRectUtils.h"
@implementation YMSubTitleButton
{
    UILabel *subTitle;
    CGFloat spacing;
    YMSubTitleButtonType buttonType;
}

-(id)initWithType:(YMSubTitleButtonType)type
{
    self = [super init];
    if(self)
    {
        buttonType =type;
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.titleLabel.font=[UIFont systemFontOfSize:14.0];
        
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [self setTitleColor:kMainColor forState:UIControlStateHighlighted];
        spacing = 2;
        
        subTitle = [[UILabel alloc] init];
        [self addSubview:subTitle];
        
        
        switch (type) {
            case YMSubTitleButtonTypeMode1:
            {
                subTitle.backgroundColor = [UIColor clearColor];
                subTitle.textAlignment=NSTextAlignmentCenter;
                subTitle.font=[UIFont systemFontOfSize:12.0];
                subTitle.textColor = [UIColor grayColor];
                subTitle.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
                subTitle.layer.borderWidth = 1;
            }
                break;
            case YMSubTitleButtonTypeMode2:
            {
                self.titleLabel.font=[UIFont systemFontOfSize:12.0];
                subTitle.font=[UIFont boldSystemFontOfSize:16];
                subTitle.textColor = [UIColor grayColor];
            }
            default:
                break;
        }
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        buttonType =YMSubTitleButtonTypeMode1;
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.titleLabel.font=[UIFont systemFontOfSize:14.0];
        
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [self setTitleColor:kMainColor forState:UIControlStateHighlighted];
        spacing = 2;
        
        
        subTitle = [[UILabel alloc] init];
        [self addSubview:subTitle];
        subTitle.backgroundColor = [UIColor clearColor];
        subTitle.textAlignment=NSTextAlignmentCenter;
        subTitle.font=[UIFont systemFontOfSize:12.0];
        subTitle.textColor = [UIColor grayColor];
 
    }
    
    return self;
    
}


-(UILabel *)subTitle
{
    return subTitle;
}
-(void)setImageAndTitleSpacing:(CGFloat)newSpacing
{
    spacing =newSpacing;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect subTtitleRect =contentRect;
    UIFont *font =[UIFont systemFontOfSize:14];
    switch (buttonType) {
        case YMSubTitleButtonTypeMode1:
        {
            font =[UIFont systemFontOfSize:14];
        }
            break;
        case YMSubTitleButtonTypeMode2:
        {
            font =[UIFont systemFontOfSize:12];
            
        }
        default:
            break;
    }
    NSString *titleStr = [self titleForState:self.state];
    CGSize textSize = [titleStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    font , NSFontAttributeName,
                                                    nil]];
    contentRect.size = textSize;
    contentRect.origin.x= (self.frameWidth-textSize.width)/2.0;
    
    
    
    //
    NSString *subTitleStr = subTitle.text;
    CGSize  subTextSize = [subTitleStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           subTitle.font, NSFontAttributeName,
                                                           nil]];
    subTextSize.width = subTextSize.width +10;
    subTextSize.height = subTextSize.height +2;
    subTtitleRect.size = subTextSize;
    subTtitleRect.origin.x= (self.frameWidth-subTextSize.width)/2.0;
    
    
    contentRect.origin.y = (self.frameHeight-(textSize.height+subTextSize.height +spacing))/2.0;;
    subTtitleRect.origin.y = contentRect.origin.y+contentRect.size.height +spacing;
    
    
    subTitle.frame =subTtitleRect;
    subTitle.layer.cornerRadius =subTtitleRect.size.height/2.0;
    
    return contentRect;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super beginTrackingWithTouch:touch withEvent:event];
    subTitle.textColor =[self titleColorForState:UIControlStateHighlighted];

    return YES;
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super continueTrackingWithTouch:touch withEvent:event];
    CGPoint touchPoint  =[touch locationInView:self];
    
    float w = 70;
    CGRect rect = CGRectMake(-w,-w, self.frameWidth+w*2, self.frameHeight+w*2);
    
    if(!CGRectContainsPoint(rect, touchPoint))
    {
        subTitle.textColor =[self titleColorForState:UIControlStateNormal];

    }
    else{
        
        subTitle.textColor =[self titleColorForState:UIControlStateHighlighted];
      
    }
    return YES;
}
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    
    subTitle.textColor =[self titleColorForState:UIControlStateNormal];

}
- (void)cancelTrackingWithEvent:(UIEvent *)event{
    [super cancelTrackingWithEvent:event];

    subTitle.textColor =[self titleColorForState:UIControlStateNormal];
}
@end
