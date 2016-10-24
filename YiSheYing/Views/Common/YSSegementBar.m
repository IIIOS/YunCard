//
//  YSSegementBar.m
//  YunCard
//
//  Created by Jinjin on 15/6/14.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YSSegementBar.h"

#define kYSSegementIndicatorHeight 2
@interface YSSegementBar ()
@property (nonatomic,strong) UIView *indicator;
@property (nonatomic,strong) NSMutableArray *btnsArr;
@property (nonatomic,strong) UIView *btnContentView;
@end


@implementation YSSegementBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame andItemNames:(NSArray *)names{

    self = [super initWithFrame:frame];
    if (self) {

        CGFloat indicatorHeight = kYSSegementIndicatorHeight;
        self.backgroundColor = [UIColor colorWithRed:243.0/255 green:243.0/255 blue:243.0/255 alpha:1];
        _btnContentView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-indicatorHeight)];
        _btnContentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_btnContentView];
        
        //TopLine
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRed:249.0/255 green:249.0/255 blue:249.0/255 alpha:1];
        [self addSubview:line];
        
        if (names.count) {
            
            _btnsArr = [NSMutableArray array];
            CGFloat width = _btnContentView.frame.size.width / names.count;
            CGFloat height = _btnContentView.frame.size.height;
            CGFloat x = 0;
            for (NSString *name in names) {
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(x, 0, width, height);
                [btn  setTitle:name forState:UIControlStateNormal];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
                [btn addTarget:self action:@selector(itemDidTap:) forControlEvents:UIControlEventTouchUpInside];
                [_btnsArr addObject:btn];
                
                btn.tag = [names indexOfObject:name];
                [_btnContentView addSubview:btn];
                
                x+=width;
            }
            
            _normalColor = [UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:1];
            _selectedColor = [UIColor colorWithRed:244/255.0 green:61/255.0 blue:83/255.0 alpha:1];
            [self resetBtnsColor];
            
            
            _indicator = [[UIView alloc] initWithFrame:CGRectZero];
            _indicator.backgroundColor = _selectedColor;
            [self addSubview:self.indicator];
            
            _currentIndex = 0;
            [self changeToIndex:_currentIndex];
            
        }
    }
    return self;
}

- (void)resetBtnsColor{
    
    for (UIButton *btn in self.btnsArr) {
        [btn setTitleColor:_normalColor forState:UIControlStateNormal];
        [btn setTitleColor:_selectedColor forState:UIControlStateSelected];
    }
}

- (void)setNormalColor:(UIColor *)normalColor{
    
    _normalColor = normalColor;
    [self resetBtnsColor];
}

- (void)setSelectedColor:(UIColor *)selectedColor{
    
    _selectedColor = selectedColor;
    self.indicator.backgroundColor = _selectedColor;
    [self resetBtnsColor];
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    
    _currentIndex = currentIndex;
    [self changeToIndex:currentIndex];
}

- (void)changeToIndex:(NSInteger)index{
    
    UIButton *selectedBtn = nil;
    for (UIButton *btn in self.btnsArr) {
        btn.selected = btn.tag==index;
        if (btn.tag==index) {
            selectedBtn = btn;
        }
    }
    self.indicator.frame = CGRectMake(selectedBtn.frame.origin.x, self.btnContentView.frame.size.height, selectedBtn.frame.size.width, kYSSegementIndicatorHeight);
    
    if (self.itemDidChangeBlock) {
        self.itemDidChangeBlock(self,index);
    }
}

- (void)itemDidTap:(UIButton *)btn{
    
    self.currentIndex = btn.tag;
}

@end
