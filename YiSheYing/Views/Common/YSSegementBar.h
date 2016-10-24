//
//  YSSegementBar.h
//  YunCard
//
//  Created by Jinjin on 15/6/14.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSSegementBar;
typedef void(^ItemDidChangeBlock) (YSSegementBar *segement,NSInteger itemIndex);

@interface YSSegementBar : UIView

@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,strong) UIColor            *normalColor;
@property (nonatomic,strong) UIColor            *selectedColor;
@property (nonatomic,copy  ) ItemDidChangeBlock itemDidChangeBlock;
- (instancetype)initWithFrame:(CGRect)frame andItemNames:(NSArray *)names;
@end

