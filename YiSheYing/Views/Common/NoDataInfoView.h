//
//  NoDataInfoView.h
//  YunCard
//
//  Created by Jinjin on 15/1/28.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShowNODataViewItem) {

    ShowNODataViewItemIcon =            1<<0,
    ShowNODataViewItemInfoLabel =       1<<1,
    ShowNODataViewItemActionBtn =       1<<2,
};

@interface NoDataInfoView : UIView
@property (nonatomic,strong) UIButton *actionBtn;
@property (nonatomic,assign) NSInteger centerOffset;
@property (nonatomic,assign) NSInteger topOffset;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,assign) ShowNODataViewItem showItems;


- (void)setInfoText:(NSString *)text;
- (void)setIconImage:(UIImage *)img;
@end
