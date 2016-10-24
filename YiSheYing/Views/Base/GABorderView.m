//
//  GABorderView.m
//  YunCard
//
//  Created by Jinjin on 15/1/15.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "GABorderView.h"

@interface GABorderView()

@property (nonatomic,strong) NSMutableDictionary *linesDict;
@end

@implementation GABorderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
    
    self.linesDict = [@{} mutableCopy];
    self.location = GABorderLocationBottom|GABorderLocationTop;
}

- (void)setLocation:(GABorderLocation)location{
    
    if (_location!=location){
        _location = location;
        [self removeAllBorder];
    }
    if (_location & GABorderLocationLeft)       [self addBorderForLocation:GABorderLocationLeft];
    if (_location & GABorderLocationRight)      [self addBorderForLocation:GABorderLocationRight];
    if (_location & GABorderLocationTop)        [self addBorderForLocation:GABorderLocationTop];
    if (_location & GABorderLocationBottom)     [self addBorderForLocation:GABorderLocationBottom];
    if (_location & GABorderLocationMiddle)     [self addBorderForLocation:GABorderLocationMiddle];
//    if (_location & GABorderLocationAll)        [self addBorderForLocation:GABorderLocationAll];
}

- (void)removeAllBorder{
    
    for (NSString *key in self.linesDict) {
        UIView *view = self.linesDict[key];
        view.hidden = YES;
    }
}

- (void)addBorderForLocation:(GABorderLocation)location{
    
    NSString *key = nil;
    switch (location) {
        case GABorderLocationBottom:
            key = @"bottom";
            break;
        case GABorderLocationTop:
            key = @"top";
            break;
        case GABorderLocationRight:
            key = @"right";
            break;
        case GABorderLocationLeft:
            key = @"left";
            break;
        case GABorderLocationMiddle:
            key = @"middle";
            break;
        default:
            break;
    }
    if (key) {
        UIView *view = self.linesDict[key];
        if (nil==view) {
            view = [[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = kDefaultBorderColor;
            [self addSubview:view];
            [self.linesDict setObject:view forKey:key];
        }
        [self makeConstraints:location forView:view];
        view.hidden = NO;
    }
}

- (void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    self.location = self.location;
}

- (void)makeConstraints:(GABorderLocation)location forView:(UIView *)view{
    switch (location) {
        case GABorderLocationBottom:
        {
            view.frame = CGRectMake(0, self.frame.size.height-kDefaultBorderWidth, self.frame.size.width, kDefaultBorderWidth);
        }
            break;
        case GABorderLocationTop:
        {
            view.frame = CGRectMake(0, 0, self.frame.size.width, kDefaultBorderWidth);
        }
            break;
        case GABorderLocationRight:
        {
            view.frame = CGRectMake(self.frame.size.width-kDefaultBorderWidth, 0, kDefaultBorderWidth, self.frame.size.height);
        }
            break;
        case GABorderLocationLeft:
        {
            view.frame = CGRectMake(0, 0, kDefaultBorderWidth, self.frame.size.height);
        }
            break;
        case GABorderLocationMiddle:
        {
            view.frame = CGRectMake(0, (self.frame.size.height)/2, self.frame.size.width, kDefaultBorderWidth);
        }
            break;
        default:
            break;
    }
}

@end
