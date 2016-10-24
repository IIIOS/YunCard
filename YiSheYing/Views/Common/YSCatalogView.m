//
//  YSCatalogView.m
//  YunCard
//
//  Created by helfy  on 15/6/25.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YSCatalogView.h"
#import "MButton.h"
#import "UIView+CGRectUtils.h"
@implementation YSCatalogView
{
    
    NSMutableArray *buttonArray;
    UIView *selectView;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        [self setupView];
    }
    return self;
}
-(void)setupView
{
    buttonArray = [NSMutableArray array];
    self.backgroundColor = [UIColor whiteColor];
    
    selectView = [UIView new];
    selectView.backgroundColor = RGB(244, 61, 83);
    [self addSubview:selectView];
    
    WS(ws);
    [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(2));
        make.bottom.equalTo(ws);
    }];
    

    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.67)];
    bottomLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(ws.mas_bottom).offset(0);
        make.width.mas_equalTo(@(SCREEN_WIDTH));
        make.left.mas_equalTo(@0);
        make.height.mas_equalTo(@(0.5));
    }];
    
}

-(void)setupItemFor:(NSArray *)items
{
    
    int buttonWidth = self.width/items.count;
    selectView.frameWidth =buttonWidth;
    
    for (int index=0;index<items.count;index++) {
        NSString *title = items[index];
        UIButton *button =[UIButton new];
        button.tag = index;
        [self addSubview:button];
        [button setTitleColor:RGB(110, 110, 110) forState:UIControlStateNormal];
        [button setTitleColor:RGB(244, 61, 83) forState:UIControlStateSelected];
        [button titleLabel].font = [UIFont systemFontOfSize:16];
        [buttonArray addObject:button];
        [button addTarget:self action:@selector(itemDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:title forState:UIControlStateNormal];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(5));
            make.bottom.equalTo(@(-5));
            make.width.equalTo(@(buttonWidth-10));
            make.left.equalTo(@(buttonWidth*index+5));
        }];
    }
    
    selectView.frame = CGRectMake(5, self.frame.size.height-2, buttonWidth-10, 2);
    
    [selectView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(2));
        make.bottom.equalTo(self);
        make.width.equalTo(@(buttonWidth-10));
        make.left.equalTo(@(5));
    }];
}
-(void)setChooseItemForIndex:(int)index
{
    MButton *button =buttonArray[index];
    self.selectedIndex = index;
    [self itemDidTap:button];
}

-(void)itemDidTap:(MButton *)button
{
    for (MButton *subButton in buttonArray) {
        subButton.selected = NO;
    }
    button.selected =YES;
    [selectView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(2));
        make.bottom.equalTo(self);
        make.width.equalTo(button.mas_width);
        make.centerX.equalTo(button);
    }];
    [UIView beginAnimations:nil context:nil];
    [selectView layoutIfNeeded];
    [UIView commitAnimations];
    
    self.selectedIndex = (int)button.tag;
    
    if(self.delegate)
    {
        [self.delegate YSCatalogViewSelectItem:self itemIndex:self.selectedIndex];
        
    }
}


@end
