//
//  NSDate+YSCalendar.h
//  YunCard
//
//  Created by helfy  on 15/7/18.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YSCalendar)
- (NSDate *)dateFromString:(NSString *)dateString;//NSString转NSDate

- (NSString *)stringFromDate:(NSDate *)date;//NSDate转NSString


- (NSUInteger)weeklyOrdinality;

- (NSUInteger)numberOfDaysInCurrentMonth;

- (NSDateComponents *)components;


+(NSDate *)dateForComponents:(NSDateComponents *)components;
@end
