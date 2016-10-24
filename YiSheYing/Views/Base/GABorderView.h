//
//  GABorderView.h
//  YunCard
//
//  Created by Jinjin on 15/1/15.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS (NSInteger, GABorderLocation) {
    GABorderLocationTop     = 1 << 0,
    GABorderLocationLeft    = 1 << 1,
    GABorderLocationBottom  = 1 << 2,
    GABorderLocationRight   = 1 << 3,
    GABorderLocationMiddle  = 1 << 4,
    GABorderLocationNone    = 1 << 5,
//    GABorderLocationAll    = 1 << 6,
};

@interface GABorderView : UIView
@property (nonatomic,assign) GABorderLocation location;
@end
