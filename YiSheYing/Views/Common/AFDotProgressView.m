//
//  AFDotProgressView.m
//  Test
//
//  Created by Jinjin on 15/7/6.
//  Copyright (c) 2015年 Jinjin. All rights reserved.
//

#import "AFDotProgressView.h"
#define LEFT_OFFSET 25
#define RIGHT_OFFSET 25
#define kProgressHeight 6
#define kRadius  5
#define kProgressTackHeight (kProgressHeight-4)
@interface AFDotProgressView()
{
    CAGradientLayer *_lineGradient;
    CAShapeLayer *_strokeLayer;
}
@property (nonatomic,strong) CAGradientLayer *gradientLayer;
@property (nonatomic,strong) CAShapeLayer *bgLayer;
@property (nonatomic,strong) CAShapeLayer *progressLayer;

@end


@implementation AFDotProgressView

#pragma mark - init
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setupView];
    }
    return self;
    
}
-(id)init{
    
    self = [super init];
    if(self)
    {
        
        [self setupView];
    }
    return self;
}
#pragma mark - setupView
-(void)setupView
{
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - point

-(CGPoint)getCenterPointForIndex:(NSInteger) i{
    return CGPointMake((i/(float)(self.maxValue-1)) * (self.frame.size.width-RIGHT_OFFSET-LEFT_OFFSET) + LEFT_OFFSET, self.frame.size.height/2.0);
}


- (UIBezierPath *)getBgPath{
    

    UIBezierPath *path=[UIBezierPath bezierPath];
    if (self.maxValue>1) {
         CGFloat centerY = self.frame.size.height/2;
       
        CGPoint startPoint = CGPointMake(LEFT_OFFSET, centerY);
        [path moveToPoint:startPoint];
        [path addLineToPoint:CGPointMake(self.frame.size.width-RIGHT_OFFSET-LEFT_OFFSET, centerY)];
        
        for (NSInteger index=0; index<self.maxValue; index++) {
            startPoint = [self getCenterPointForIndex:index];
            CGFloat radius ;
            if(index ==0 || index == self.maxValue-1)
            {
                radius = kRadius;
            }
            else{
                radius = kRadius-2;
            }
            [path addArcWithCenter:startPoint radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];

            [path moveToPoint:startPoint];
            
        }
    }
    [path fill];
    
    return path;
}

- (UIBezierPath *)getProgressPath{
    
    UIBezierPath *path=[UIBezierPath bezierPath];
    if (self.maxValue>1) {
        CGFloat centerY = self.frame.size.height/2;
        
        CGPoint startPoint = CGPointMake(LEFT_OFFSET, centerY);
        [path moveToPoint:startPoint];
        [path addLineToPoint:CGPointMake([self getCenterPointForIndex:self.currentValue].x, centerY)];
        
        for (NSInteger index=0; index<self.currentValue+1; index++) {
            startPoint = [self getCenterPointForIndex:index];
            CGFloat radius ;
            if(index ==0 || index == self.maxValue-1)
            {
                radius = kRadius;
            }
            else{
                radius = kRadius-2;
            }
            [path addArcWithCenter:startPoint radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
            
            [path moveToPoint:startPoint];
            
        }
    }
    [path fill];
    
    return path;
}


#pragma mark - setter
-(void)setProgressBgColor:(UIColor *)progressBgColor
{
    self.bgLayer.fillColor= [progressBgColor CGColor];
    self.bgLayer.strokeColor= [progressBgColor CGColor];
    
    [self setNeedsDisplay];
}

-(void)setCurrentValue:(int)currentValue
{
    _currentValue = currentValue;
    [self setNeedsDisplay];
}
#pragma mark -getter
- (CAShapeLayer *)bgLayer{
    if (nil==_bgLayer) {
        
        _bgLayer = [CAShapeLayer layer];
        _bgLayer.fillColor= [[UIColor whiteColor] CGColor];
        _bgLayer.strokeColor= [[UIColor whiteColor] CGColor];
        _bgLayer.lineWidth = kProgressHeight;
        [self.layer addSublayer:_bgLayer];
    }
    return _bgLayer;
}
- (CAShapeLayer *)progressLayer{
    if (nil==_progressLayer) {
        
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.fillColor= [[UIColor whiteColor] CGColor];
        _progressLayer.strokeColor= [[UIColor whiteColor] CGColor];
        _progressLayer.lineWidth = kProgressTackHeight;
    }
    return _progressLayer;
}

- (CAGradientLayer *)gradientLayer{
    
    if (nil==_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        //        [lineGradient setLocations:@[@0.1,@0.8,@0.9,@1]];
        _gradientLayer.startPoint = CGPointMake(0,0.5);
        _gradientLayer.endPoint = CGPointMake(1,0.5);
        _gradientLayer.colors = @[(id)RGB(242, 223, 93).CGColor,
                                  (id)RGB(250, 80, 65).CGColor];
        [self.layer addSublayer:_gradientLayer];
    }
    return _gradientLayer;
}


#pragma mark -draw
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    self.bgLayer.path = [self getBgPath].CGPath;
    self.progressLayer.path = [self getProgressPath].CGPath;
    self.gradientLayer.mask = self.progressLayer;
}

@end
