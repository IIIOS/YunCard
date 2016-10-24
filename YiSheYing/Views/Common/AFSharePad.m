//
//  AFSharePad.m
//  Whatstock
//
//  Created by Jinjin on 14/12/22.
//  Copyright (c) 2014年 AnnyFun. All rights reserved.
//

#import "AFSharePad.h"
#import "PopMenu.h"

@implementation AFSharePad


+ (void)showMenuAtView:(UIView *)view didSelectedItemCompletion:(DidSlelectedBlock)block{
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:3];
    MenuItem *menuItem = [MenuItem itemWithTitle:nil iconName:@"icon_share_qzone"];
    [items addObject:menuItem];
    menuItem = [MenuItem itemWithTitle:nil iconName:@"icon_share_qq"];
    [items addObject:menuItem];
    menuItem = [MenuItem itemWithTitle:nil iconName:@"icon_share_wechat"];
    [items addObject:menuItem];
    menuItem = [MenuItem itemWithTitle:nil iconName:@"icon_share_sina"];
    [items addObject:menuItem];
    
    PopMenu *popMenu = [[PopMenu alloc] initWithFrame:view.bounds items:items];
    popMenu.menuAnimationType = kPopMenuAnimationTypeSina;
    popMenu.didSelectedItemCompletion = ^(MenuItem *selectedItem) {
        if (block) {
            block(selectedItem.index);
        }
    };
    [popMenu showMenuAtView:view];
}

@end
