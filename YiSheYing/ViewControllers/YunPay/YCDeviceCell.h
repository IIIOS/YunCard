//
//  YCDeviceCell.h
//  YunCard
//
//  Created by Jinjin on 15/8/18.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YCDeviceActionType) {

    YCDeviceActionTypeOp = 1,
    YCDeviceActionTypeSetting = 2,
    YCDeviceActionTypeDelete = 3,
};

@class YCDeviceCell;
typedef void(^YCDeviceActionBlock) (YCDeviceCell *theCell,YCDeviceActionType type);
@interface YCDeviceCell : UITableViewCell

- (void)bindData:(YCDeviceModel *)mode;

@property (nonatomic, copy) YCDeviceActionBlock actionBlock;

@end
