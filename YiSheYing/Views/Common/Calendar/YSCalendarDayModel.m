//
//  YSCalendarDayModel.m
//  YunCard
//
//  Created by helfy  on 15/7/18.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YSCalendarDayModel.h"
#import "NSDate+YSCalendar.h"
#import "YSCalendarMonthModel.h"
@implementation YSCalendarDayModel
#pragma mark - 类方法
+ (YSCalendarDayModel *)calendarDayWithMonth:(YSCalendarMonthModel *)month day:(NSUInteger)day
{
    YSCalendarDayModel *calendarDay = [[YSCalendarDayModel alloc] init];//初始化自身
    calendarDay.month = month;//月
    calendarDay.day = day;//日
    
    return calendarDay;
}

+ (YSCalendarDayModel *)calendarDayWithTimeInterval:(NSTimeInterval)time
{
    YSCalendarDayModel *calendarDay = [[YSCalendarDayModel alloc] init];//初始化自身
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateComponents *components = [date components];
    
    calendarDay.month =[YSCalendarMonthModel monthModelForYear:components.year month:components.month];
    calendarDay.day = components.day;//日
    
    return calendarDay;
}
#pragma mark -

-(BOOL)sameOtherModel:(YSCalendarDayModel *)other
{
    BOOL same = NO;
    
    if(self.month.year == other.month.year
       && self.month.month == other.month.month
       && self.day == other.day)
    {
        same = YES;
    }
    
    return same;
}
//返回当前天的NSDate对象
- (NSDate *)date
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.year = self.month.year;
    c.month = self.month.month;
    c.day = self.day;
    return [[NSCalendar currentCalendar] dateFromComponents:c];
}

//返回当前天的NSString对象
- (NSString *)toString
{
    NSDate *date = [self date];
    NSString *string = [date stringFromDate:date];
    return string;
}
@end
