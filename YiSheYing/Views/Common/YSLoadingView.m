//
//  YSLoadingView.m
//  YunCard
//
//  Created by Jinjin on 15/7/4.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YSLoadingView.h"
@interface YSLoadingView ()
{
    BOOL isStart;
}
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIView *bgView;
@end

@implementation YSLoadingView
- (void)dealloc{
    
    [self stop];
    NSLog(@"YSLoadingView dealloc");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIImageView *)imageView{
    
    if (nil==_imageView) {
        
        self.bgView.frame = CGRectMake(0, 0, 60, 60);
        self.bgView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);

        _imageView = [[UIImageView alloc] initWithFrame:self.bgView.bounds];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.bgView addSubview:_imageView];
        
        [self addSubview:self.bgView];
    }
    return _imageView;
}

- (UIView *)bgView{

    if (nil==_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _bgView.clipsToBounds = YES;
        _bgView.layer.cornerRadius = 4;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (void)rotateImageView{
    if (isStart && self.imagesArr.count) {
        [UIView animateWithDuration:.45f delay:0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            self.imageView.layer.transform = CATransform3DConcat(_imageView.layer.transform, CATransform3DMakeRotation(M_PI_2,0.0,1.0,0.0));
        }completion:^(BOOL finished){
            NSInteger index = ([self.imagesArr indexOfObject:_imageView.image]+1)%self.imagesArr.count;
            _imageView.image = [self.imagesArr objectAtIndex:index];
        }];
        
        [self performSelector:@selector(rotateImageView) withObject:nil afterDelay:.45f];
    }
}

- (void)start{
    [self stop];
    self.hidden = NO;
    isStart = YES;
    if (self.imagesArr.count) self.imageView.image = [self.imagesArr objectAtIndex:0];
    [self rotateImageView];
}

- (void)stop{
    isStart = NO;
    self.hidden = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
- (void)stopWithDealy:(NSTimeInterval)interval{
    [self performSelector:@selector(stop) withObject:nil afterDelay:interval];
}
@end
