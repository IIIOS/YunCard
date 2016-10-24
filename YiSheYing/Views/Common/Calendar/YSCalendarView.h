//
//  YSCalendarView.h
//  YunCard
//
//  Created by helfy  on 15/7/18.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSCalendarMonthModel.h"
#import "YSCalendarDayModel.h"

@protocol YSCalendarViewDelegate <NSObject>

//切换月份
-(void)calendarChangeMonthButtonDidTap:(id)calendarView currentMonth:(NSUInteger)month;

//切换年
-(void)calendarChangeYearButtonDidTap:(id)calendarView currentYear:(NSUInteger)year;

@optional
//超过设置的最多选择  不设置 则使用alert提醒
-(void)calendarDidExceedMaxChoose;

@end

@interface YSCalendarView : UIView

@property (nonatomic,assign) id<YSCalendarViewDelegate> delegate;
@property (nonatomic,assign) int  maxChooseCount;  //最多可以选择多少  默认0 表示不限制
@property (nonatomic,assign) BOOL  isEdit;  //为yes 情况下。档期已满也可选择

//选中的日期数组  空。表示为选中
@property (nonatomic,strong)NSMutableArray *chooseDays;
//通过新的年、月更新view
-(void)reloadViewForNewModel:(YSCalendarMonthModel *)monthModel;


-(CGSize )getViewSize;

-(YSCalendarMonthModel *)currentMonthModel;
//设置有档期的日期  接口单条数据如下
//{
//    "createtime": "300"
//},
-(void)setScheduleTims:(NSArray *)times;
@end
