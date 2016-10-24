//
//  YSCalendarMonthModel.m
//  YunCard
//
//  Created by helfy  on 15/7/18.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YSCalendarMonthModel.h"
#import "NSDate+YSCalendar.h"
#import "YSCalendarDayModel.h"
@implementation YSCalendarMonthModel
{
    NSMutableArray *daysArray;
}

+(YSCalendarMonthModel *)monthModelForNow
{
    NSDateComponents *todayComponents= [[NSDate date] components];
    return [self monthModelForYear:todayComponents.year month:todayComponents.month];
 
}
+(YSCalendarMonthModel *)monthModelForYear:(NSUInteger)year month:(NSUInteger)month
{
    YSCalendarMonthModel *monthModel = [[YSCalendarMonthModel alloc] init];
    monthModel.year =year;
    monthModel.month =month;
    
    return monthModel;
}


#pragma mark -- tools

-(NSString *)getMonthString
{
    NSString *monthStr = @"";
    NSArray *months = @[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月"];
    monthStr = months[self.month-1];
    return monthStr;

}
//比较年、月、日。。  other 想对于target
-(YSCalendarDayType)compareDateComponents:(NSDateComponents *)target other:(NSDateComponents *)other
{
    int result =YSCalendarDayTypeNone;
    
    if(other.year < target.year)
    {
        result=YSCalendarDayPast;
    }
    else if(other.year > target.year)
    {
        result = YSCalendarDayFutur;
    }
    else  //年相同。。比较月
    {
        if(other.month < target.month)
        {
            result=YSCalendarDayPast;
        }
        else if(other.month > target.month)
        {
            result = YSCalendarDayFutur;
        }
        else  //月相同  比较日
        {
            if(other.day < target.day)
            {
                result=YSCalendarDayPast;
            }
            else if(other.day > target.day)
            {
                result = YSCalendarDayFutur;
            }
            else
            {
                result =YSCalendarDayToday;
            }
        }
        
    }
    
    return result;
}

#pragma mark --

-(NSArray *)daysForView
{
//   if(daysArray == nil)
//   {
       daysArray =[NSMutableArray array];
       
       NSDate *todayDate= [NSDate date];
     
       NSDateComponents *todayComponents= [todayDate components];
       
       
       NSDateComponents *moothComponents = [[NSDateComponents alloc] init];
       moothComponents.year = self.year;
       moothComponents.month = self.month;
       moothComponents.day = 1;
       NSDate *moothDate = [NSDate dateForComponents:moothComponents];
       
       
       NSUInteger weeklyOrdinality = [moothDate weeklyOrdinality];//计算这个的第一天是礼拜几,并转为int型
       // 用于填充空
       for (int day = 1; day < weeklyOrdinality; ++day) {
           YSCalendarDayModel *calendarDay = [YSCalendarDayModel calendarDayWithMonth:self day:day];
           calendarDay.style = YSCalendarDayTypeEmpty;//不显示
           [daysArray addObject:calendarDay];
       }
       
       NSUInteger daysCount = [moothDate numberOfDaysInCurrentMonth];//计算这个月有多少天
       for (int day = 1; day < daysCount + 1; ++day) {
           YSCalendarDayModel *calendarDay = [YSCalendarDayModel calendarDayWithMonth:self day:day];
         
           
           NSDateComponents *dayComponents = [[NSDateComponents alloc] init];
           dayComponents.year = self.year;
           dayComponents.month = self.month;
           dayComponents.day = day;
           calendarDay.style = [self compareDateComponents:todayComponents other:dayComponents];
               
        
        
           //todo 档期判断
           [daysArray addObject:calendarDay];
       }
   
//   }
    return daysArray;
}
@end
