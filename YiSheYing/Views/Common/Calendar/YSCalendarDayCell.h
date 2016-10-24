//
//  YSCalendarDayCell.h
//  YunCard
//
//  Created by helfy  on 15/7/18.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YSCalendarDayModel.h"
@interface YSCalendarDayCell : UICollectionViewCell

-(void)bindModel:(YSCalendarDayModel *)dayModel;

-(void)setIsEdit:(BOOL)isedit;
@end
