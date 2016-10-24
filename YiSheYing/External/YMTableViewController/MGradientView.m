//
//  MGradientView.m
//  MikeCrm
//
//  Created by helfy on 14/11/18.
//  Copyright (c) 2014年 helfy. All rights reserved.
//

#import "MGradientView.h"

@implementation MGradientView
{
    CAGradientLayer *gradientLayer;
}
@synthesize colors = _colors;
@synthesize type = _type;


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        gradientLayer =  [CAGradientLayer layer];
        [self.layer addSublayer:gradientLayer];
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self) {
        gradientLayer =  [CAGradientLayer layer];
        [self.layer addSublayer:gradientLayer];

    }
    return self;
}
-(void)setColors:(NSArray *)colors
{
    _colors = colors;
    [self drawGradient];
}
-(void)setType:(MGradientViewType)type
{
    _type =type;
    [self drawGradient];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    gradientLayer.frame = self.bounds;
    gradientLayer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

-(void)drawGradient
{
    if(self.colors)
    {

        gradientLayer.colors =  self.colors;
        float portion  = 1.0/(self.colors.count+1);
        NSMutableArray *locations = [@[] mutableCopy];
        for (int i =0; i<self.colors.count; i++) {
            [locations addObject:@(portion*(i+1))];
        }
        gradientLayer.locations  = locations;
        
        switch (self.type) {
            case MGradientViewTypeTopToBottom:
            {
                gradientLayer.startPoint = CGPointMake(0, 0);
                gradientLayer.endPoint   = CGPointMake(0, 1);
            }
                break;
            case MGradientViewTypeLeftToRight:
            {
                gradientLayer.startPoint = CGPointMake(0, 0);
                gradientLayer.endPoint   = CGPointMake(1, 0);
            }
                break;
            case MGradientViewTypeUpleftTolowRight:
            {
                gradientLayer.startPoint = CGPointMake(0, 0);
                gradientLayer.endPoint   = CGPointMake(1, 1);
            }
                break;
            case MGradientViewTypeUprightTolowLeft:
            {
                gradientLayer.startPoint = CGPointMake(0, 1);
                gradientLayer.endPoint   = CGPointMake(1, 0);
            }
                break;
            default:
                break;
        }
  
    }
}




@end
