//
//  YSLoadingView.h
//  YunCard
//
//  Created by Jinjin on 15/7/4.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSLoadingView : UIView
@property (nonatomic,strong) NSArray *imagesArr;

- (void)start;
- (void)stopWithDealy:(NSTimeInterval)interval;
@end
