//
//  YSCalendarMonthModel.h
//  YunCard
//
//  Created by helfy  on 15/7/18.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSCalendarMonthModel : NSObject
@property (nonatomic, assign) NSUInteger month;//月
@property (nonatomic, assign) NSUInteger year;//年


//YSCalendarDayModel 的集合，，
-(NSArray *)daysForView;

//获取月份 字符串 比如：一月。。
-(NSString *)getMonthString;

+(YSCalendarMonthModel *)monthModelForNow;
+(YSCalendarMonthModel *)monthModelForYear:(NSUInteger)year month:(NSUInteger)month;



@end
