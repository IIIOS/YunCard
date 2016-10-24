//
//  YSCalendarDayModel.h
//  YunCard
//
//  Created by helfy  on 15/7/18.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YSCalendarMonthModel;

typedef NS_ENUM(NSInteger, YSCalendarDayType) {
    YSCalendarDayTypeNone=0,   //正常显示
    YSCalendarDayTypeEmpty,   //不显示
    YSCalendarDayPast,          //过去的日期
    YSCalendarDayToday,         //当前日期
    YSCalendarDayFutur,         //将来的日期
    YSCalendarDayFull,          //有档期
 
};


@interface YSCalendarDayModel : NSObject

@property (assign, nonatomic) YSCalendarDayType style;

@property (assign,nonatomic) BOOL isSelect;  //选择
@property (nonatomic, assign) NSUInteger day;//天
@property (nonatomic, strong) YSCalendarMonthModel * month;//月
@property (nonatomic, assign) NSUInteger week;//周




+ (YSCalendarDayModel *)calendarDayWithMonth:(YSCalendarMonthModel *)month day:(NSUInteger)day;

+ (YSCalendarDayModel *)calendarDayWithTimeInterval:(NSTimeInterval)time;


//比较是否为同一天
-(BOOL)sameOtherModel:(YSCalendarDayModel *)other;


- (NSDate *)date;//返回当前天的NSDate对象
- (NSString *)toString;//返回当前天的NSString对象

@end
