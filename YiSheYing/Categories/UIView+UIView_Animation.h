//
//  NSObject+UIView_Animation.h
//  Whatstock
//
//  Created by Jinjin on 14/12/14.
//  Copyright (c) 2014年 AnnyFun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (keyboardAnimation)

+ (void)animateWithKeyboardNotification:(NSNotification *)noti animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

@end

