//
//  DennyScrollView.h
//  YunCard
//
//  Created by Lwj on 15/12/4.
//  Copyright © 2015年 JiaJun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LunBoModel.h"

@class DennyScrollView;
@protocol DennyScrollViewDelegate <NSObject>

@optional
- (void)clikeScrollViewCallBack:(DennyScrollView *)vc index:(NSInteger)index;

@end
@interface DennyScrollView : UIView<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *imageNames;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) NSMutableArray *imageViews;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger currentPageIndex;
@property (nonatomic,assign)id<DennyScrollViewDelegate>delegate;
- (void)initializeUserInterface;
- (id)initWithFrame:(CGRect)frame imageArray:(NSMutableArray *)imageArray;
- (void)updateScrollViewWithContentOffset:(CGPoint)contentOffset;

- (void)startTimer;
- (void)pauseTimer;
- (void)stopTimer;
- (void)processTimer:(NSTimer *)timer;

- (NSInteger)actualIndexWithIndex:(NSInteger)index;
@end
