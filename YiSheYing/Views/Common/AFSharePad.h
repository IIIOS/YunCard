//
//  AFSharePad.h
//  Whatstock
//
//  Created by Jinjin on 14/12/22.
//  Copyright (c) 2014年 AnnyFun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidSlelectedBlock) (NSInteger index);
@interface AFSharePad : UIView
+ (void)showMenuAtView:(UIView *)view didSelectedItemCompletion:(DidSlelectedBlock)block;
@end
