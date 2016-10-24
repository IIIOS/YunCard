//
//  DennyTextfiled.m
//  YunCard
//
//  Created by Denny on 16/4/25.
//  Copyright © 2016年 JiaJun. All rights reserved.
//

#import "DennyTextfiled.h"
const CGFloat marginLeft =  5.0;
@implementation DennyTextfiled
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectMake(bounds.origin.x + marginLeft, bounds.origin.y, bounds.size.width - marginLeft, bounds.size.height);
    return inset;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectMake(bounds.origin.x + marginLeft, bounds.origin.y, bounds.size.width - marginLeft, bounds.size.height);
    return inset;
}
@end
