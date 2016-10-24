//
//  UIView+CGRectUtil.h
//  CGRectUtil
//
//  Created by martin on 28/07/2013.
//  Copyright (c) 2013 doduck.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CGRectUtils.h"

@interface UIView (CGRectUtils)

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;

@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;

@end
