//
//  MJZoomingScrollView.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSPhotoView;

@protocol YSPhotoViewDelegate <NSObject>
- (void)photoViewImageFinishLoad:(YSPhotoView *)photoView;
- (void)photoViewSingleTap:(YSPhotoView *)photoView;
- (void)photoViewDidEndZoom:(YSPhotoView *)photoView;
- (UIImageView *)srcImageViewForPhotoView:(YSPhotoView *)photoView;
@end

@interface YSPhotoView : UIScrollView <UIScrollViewDelegate>
// 图片
@property (nonatomic, copy)   NSString *photoUrl;
@property (nonatomic, strong)  UIImage *placeHolder;

// 代理
@property (nonatomic, weak) id<YSPhotoViewDelegate> photoViewDelegate;


- (void)handleSingleTap:(UITapGestureRecognizer *)tap;

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap;
@end