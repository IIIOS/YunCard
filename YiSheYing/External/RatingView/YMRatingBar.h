//
//  YMRatingBar.h
//  YunCard
//
//  Created by helfy  on 15/7/22.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMRatingBar : UIView



@property (nonatomic,assign)CGSize itemSize;  //不设置 则使用image的size
@property (nonatomic,assign)float itemSpace;  //item间隔 默认0

@property (nonatomic,assign) int maxItemCount;  //最大评分数 默认5
@property (nonatomic,assign) int currentCount;  //当前评分数 默认0


@property (nonatomic,assign)BOOL canChoose;  //能选择评分  默认不能操作

-(void)drawRating;

-(CGRect)setupViewFrame;


-(void)setSelectImage:(UIImage *)selectImage deselectedImage:(UIImage *)deselectedImage;
@end
