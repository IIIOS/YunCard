//
//  YMRatingBar.m
//  YunCard
//
//  Created by helfy  on 15/7/22.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YMRatingBar.h"
#import "UIView+CGRectUtils.h"
@implementation YMRatingBar
{
    NSMutableArray *startItems;
    
    
    UIImage *selectImage;   //选择评分图片
    UIImage *deselectedImage; //未选择图片

}
-(id)init
{
    self = [super init];
    if(self)
    {
         self.backgroundColor = [UIColor clearColor];
        [self setDefault];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

-(void)setDefault
{
    startItems = [NSMutableArray array];
    self.maxItemCount = 5;
    self.itemSpace = 0;
    self.canChoose = NO;
}


-(void)tap:(UITapGestureRecognizer *)gesture{
    if(self.canChoose){
        CGPoint point = [gesture locationInView:self];
        int chooseIndex=0;
        for (UIImageView *startImageView in startItems) {
            if(startImageView.x > point.x) //
            {
               break;
            }
            else{
                chooseIndex =(int)startImageView.tag;;
            }
        }
        
        self.currentCount =chooseIndex;
        [self setNeedsDisplay];
        
    }
}



-(CGRect)setupViewFrame
{
    self.frame = CGRectMake(0, 0, self.maxItemCount*(self.itemSize.width+self.itemSpace), self.itemSize.height+10);
    return  self.frame;
}
#pragma mark - setter

-(void)setSelectImage:(UIImage *)newSelectImage deselectedImage:(UIImage *)newDeselectedImage;
{
    selectImage = newSelectImage;
    deselectedImage = newDeselectedImage;
    
    if(CGSizeEqualToSize(self.itemSize, CGSizeZero))
    {
        self.itemSize = selectImage?selectImage.size:deselectedImage.size;
    }
}

-(void)setItemSize:(CGSize)itemSize
{
    
    _itemSize = itemSize;
    [self setupViewFrame];
}
-(void)setMaxItemCount:(int)maxItemCount
{
    _maxItemCount = maxItemCount;
    [self setupViewFrame];
}
-(void)setItemSpace:(float)itemSpace
{
    _itemSpace = itemSpace;
    [self setupViewFrame];
}
#pragma mark - draw
-(void)drawRating
{
    for (int index=0; index<self.maxItemCount; index++) {
        BOOL isExit =NO;
        if(index < startItems.count)
        {
            isExit = YES;
        }
        
        UIImageView *startImageView ;
        if(isExit)
        {
            startImageView = startItems[index];
        }
        else{
            startImageView=[[UIImageView alloc] init];
              [self addSubview:startImageView];
            [startItems addObject:startImageView];
        }
        startImageView.tag = index+1;
        startImageView.frame = CGRectMake(index*(self.itemSize.width+self.itemSpace),5, self.itemSize.width, self.itemSize.height);
       
        startImageView.image = (self.currentCount > index)?selectImage:deselectedImage;
        
    }
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.backgroundColor = [UIColor clearColor];
    [self drawRating];
}

@end
