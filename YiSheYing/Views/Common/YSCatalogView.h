//
//  YSCatalogView.h
//  YunCard
//
//  Created by helfy  on 15/6/25.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YSCatalogViewDelegte <NSObject>
-(void)YSCatalogViewSelectItem:(id)catalogView itemIndex:(int)index;
@end


@interface YSCatalogView : UIView
@property(nonatomic,assign) int width;
@property(nonatomic,assign) int selectedIndex;

@property (nonatomic,assign)id<YSCatalogViewDelegte>delegate;
-(void)setupItemFor:(NSArray *)items;
-(void)setChooseItemForIndex:(int)index;
@end
