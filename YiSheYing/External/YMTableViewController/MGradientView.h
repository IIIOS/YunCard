//
//  MGradientView.h
//  MikeCrm
//
//  Created by helfy on 14/11/18.
//  Copyright (c) 2014年 helfy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum  {
    MGradientViewTypeTopToBottom = 0,//从上到小
    MGradientViewTypeLeftToRight = 1,//从左到右
     MGradientViewTypeUpleftTolowRight = 2,//左上到右下
     MGradientViewTypeUprightTolowLeft = 3,//右上到左下
}MGradientViewType;

@interface MGradientView : UIView
@property (nonatomic,assign)MGradientViewType type;
@property (nonatomic,strong)NSArray *colors;

@end
