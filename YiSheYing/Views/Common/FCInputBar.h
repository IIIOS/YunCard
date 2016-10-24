//
//  FCInputBar.h
//  FunnyCamera
//
//  Created by Jinjin on 14/12/1.
//  Copyright (c) 2014年 AnnyFun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangeToFrameAnimation)(CGRect toFrame);
@protocol FCInputBarDelegate <NSObject>

- (void)didSendText:(NSString *)text;
- (BOOL)shouldBeginSendText:(NSString *)text;
@end

@interface FCInputBar : UIView

@property (nonatomic,strong) UITextView *inputView;
@property (nonatomic,weak) id<FCInputBarDelegate> delegate;
@property (nonatomic,strong) ChangeToFrameAnimation changeBlock;
@end
