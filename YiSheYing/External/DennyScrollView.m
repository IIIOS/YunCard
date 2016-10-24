//
//  DennyScrollView.m
//  YunCard
//
//  Created by Lwj on 15/12/4.
//  Copyright © 2015年 JiaJun. All rights reserved.
//
#define IMAGE_WITH_NAME(__NAME) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:__NAME]]

#import "DennyScrollView.h"

@implementation DennyScrollView

- (id)initWithFrame:(CGRect)frame imageArray:(NSMutableArray *)imageArray
{
    if (self = [super initWithFrame:frame]) {
        _imageNames = [NSMutableArray array];
        _imageViews = [NSMutableArray array];
        for (LunBoModel *model in imageArray) {
            [_imageNames addObject:model.img_url];
        }
        _currentPageIndex = 0;
        [self initializeUserInterface];
    }
    return self;
}

- (void)initializeUserInterface {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectInset(self.bounds, -5, 0)];
    _scrollView.contentOffset = CGPointMake(CGRectGetWidth(_scrollView.bounds), 0);
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.bounds) * 3,
                                         CGRectGetHeight(_scrollView.bounds));
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.bounds = self.bounds;
        imageView.center = CGPointMake(CGRectGetWidth(_scrollView.bounds) / 2 + CGRectGetWidth(_scrollView.bounds) * i,
                                       CGRectGetHeight(_scrollView.bounds) / 2);

        NSInteger index = [self actualIndexWithIndex:_currentPageIndex + i - 1];
        imageView.contentMode = UIViewContentModeScaleToFill;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        tapGesture.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:tapGesture];
        imageView.userInteractionEnabled = YES;

        [imageView setImageWithURLString:_imageNames[index]];
//        imageView.image = [UIImage imageNamed:_imageNames[[self actualIndexWithIndex:_currentPageIndex - 1 + i]]] ;
        [_scrollView addSubview:imageView];
        [_imageViews addObject:imageView];
    }
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.frame = CGRectMake(0, self.frame.size.height , self.frame.size.width, 20);
    _pageControl.numberOfPages = [_imageNames count];
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    [self addSubview:_pageControl];
    
    [self startTimer];
}

- (void)updateScrollViewWithContentOffset:(CGPoint)contentOffset {
    
    BOOL shouldUpdateScrollView = NO;
    if (contentOffset.x <= 0) {
        _currentPageIndex = [self actualIndexWithIndex:_currentPageIndex - 1];
        shouldUpdateScrollView = YES;
    }
    else if (contentOffset.x >= CGRectGetWidth(_scrollView.bounds) * 2) {
        _currentPageIndex = [self actualIndexWithIndex:_currentPageIndex + 1];
        shouldUpdateScrollView = YES;
    }
    if (!shouldUpdateScrollView) {
        return;
    }
    NSString *imageName1 = [_imageNames objectAtIndex:[self actualIndexWithIndex:_currentPageIndex - 1]];
    NSString *imageName2 = [_imageNames objectAtIndex:[self actualIndexWithIndex:_currentPageIndex]];
    NSString *imageName3 = [_imageNames objectAtIndex:[self actualIndexWithIndex:_currentPageIndex + 1]];
    [_imageViews[0] setImageWithURLString:imageName1];
    [_imageViews[1] setImageWithURLString:imageName2];
    [_imageViews[2] setImageWithURLString:imageName3];
//    [(UIImageView *)_imageViews[0] setImage:[UIImage imageNamed:_imageNames[[self actualIndexWithIndex:_currentPageIndex - 1]]]];
//    [(UIImageView *)_imageViews[1] setImage:[UIImage imageNamed:_imageNames[[self actualIndexWithIndex:_currentPageIndex ]]]];
//    [(UIImageView *)_imageViews[2] setImage:[UIImage imageNamed:_imageNames[[self actualIndexWithIndex:_currentPageIndex + 1]]]];

    _pageControl.currentPage = _currentPageIndex;
    _scrollView.contentOffset = CGPointMake(CGRectGetWidth(_scrollView.bounds), 0);
}

- (void)startTimer {
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                  target:self
                                                selector:@selector(processTimer:)
                                                userInfo:nil
                                                 repeats:YES];
    }
    else {
        _timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
    }
}

- (void)pauseTimer {
    
    if (_timer && _timer.isValid) {
        _timer.fireDate = [NSDate distantFuture];
    }
}

- (void)stopTimer {
    
    if (_timer && _timer.isValid) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)processTimer:(NSTimer *)timer {
    
    [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.bounds) * 2, 0)
                         animated:YES];
}

- (NSInteger)actualIndexWithIndex:(NSInteger)index {
    
    NSInteger maximumIndex = [_imageNames count] - 1;
    NSInteger minimumIndex = 0;
    if (index > maximumIndex) {
        index = minimumIndex;
    }
    else if (index < 0) {
        index = maximumIndex;
    }
    return index;
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self updateScrollViewWithContentOffset:scrollView.contentOffset];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self startTimer];
}

#pragma mark -------------clickIamgeView
- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clikeScrollViewCallBack:index:)]) {
        [self.delegate clikeScrollViewCallBack:self index:_currentPageIndex];
    }
}

@end
