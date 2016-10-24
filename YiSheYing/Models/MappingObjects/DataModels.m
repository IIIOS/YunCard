//
//  DataModels.h.m
//  TGOMarket
//
//  Created by  YangShengchao on 14-4-29.
//  Copyright (c) 2014年 SCSD_TGO_TEAM. All rights reserved.
//

#import "DataModels.h"
#import "TimeUtils.h"

@implementation CommonBaseModel

+ (NSString *)modelName{
    return NSStringFromClass(self);
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

/**
 *  添加反序列化方法
 *
 *  @param aDecoder
 *
 *  @return
 */
-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        unsigned int outCount = 0;
        objc_property_t *properties = class_copyPropertyList([self class], &outCount);
        
        @try {
            for (int i = 0; i < outCount; i++) {
                objc_property_t property = properties[i];
                NSString *key=[[NSString alloc] initWithCString:property_getName(property)
                                                       encoding:NSUTF8StringEncoding];
                id value = [aDecoder decodeObjectForKey:key];
                if (value) {
                    [self setValue:value forKey:key];
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception: %@", exception);
            return nil;
        }
        @finally {
            
        }
        
        free(properties);
    }
    return self;
}

/**
 *  添加序列化方法
 *
 *  @param aCoder
 */
- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        NSString *key=[[NSString alloc] initWithCString:property_getName(property)
                                               encoding:NSUTF8StringEncoding];
        
        id value=[self valueForKey:key];
        if (value && key) {
            if ([value isKindOfClass:[NSObject class]]) {
                [aCoder encodeObject:value forKey:key];
            } else {
                NSNumber * v = [NSNumber numberWithInt:(int)value];
                [aCoder encodeObject:v forKey:key];
            }
        }
    }
    free(properties);
    properties = NULL;
}

- (NSTimeInterval)getRealTimeInteral:(NSTimeInterval)interval{
    
    NSTimeInterval realInterval = interval;
    if (realInterval > 100000000.0f * 1000.0f) {//判断单位是秒还是毫秒
        realInterval = realInterval / 1000.0f;
    }
    return realInterval;
}
@end



@implementation YCUserModel
static YCUserModel *currentUserModel;
+ (instancetype)currentUser{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"AFLoginedUser"];
        currentUserModel = [[YCUserModel alloc] initWithDictionary:userInfo error:NULL];
    });
    return currentUserModel;
}

+ (void)saveLoginUser:(YCUserModel *)newUser{
    if (newUser != currentUserModel) {
        
        currentUserModel = newUser;
        NSDictionary *userInfo = [newUser toDictionary];
        [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"AFLoginedUser"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kAFNotiDidLogin object:nil];
    }else{
        NSDictionary *userInfo = [currentUserModel toDictionary];
        [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"AFLoginedUser"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)logout{
    currentUserModel = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AFLoginedUser"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AFLoginPhoneValue"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AFLoginPSWValue"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Logouthehe"];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isLogin{
    return nil!=[[YCUserModel currentUser] studentNo];
}

+ (void)saveLoginInfo:(NSString*)phone password:(NSString *)pwd forUser:(NSString *)uid{
    
    if (phone && pwd && uid) {
        [[NSUserDefaults standardUserDefaults] setObject:phone forKey:[NSString stringWithFormat:@"AFLoginedUserPhone_%@",uid]];
        [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:[NSString stringWithFormat:@"AFLoginedUserPSW_%@",uid]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSString *)passwordForUser:(NSString *)uid{
    NSString *password = nil;
    if (uid) {
        password = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"AFLoginedUserPSW_%@",uid]];
    }
    return password;
}

+ (NSString *)phoneForUser:(NSString *)uid{
    NSString *phone = nil;
    if (uid) {
        phone = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"AFLoginedUserPhone_%@",uid]];
    }
    return phone;
}
@end

@implementation YCDeviceModel
- (NSString *)deviceStatusString{
    
    NSString *statusStr = nil;
    switch (self.deviceStatus) {
        case YCDeviceStatusOpenByMe: {
            statusStr = @"已开启";
            break;
        }
        case YCDeviceStatusOpenByOther: {
            statusStr = @"使用中";
            break;
        }
        case YCDeviceStatusOff: {
            statusStr = @"空闲";
            break;
        }
        case YCDeviceStatusRepair: {
            statusStr = @"维修中";
            break;
        }
        case YCDeviceStatusOpen: {
            statusStr = @"关闭中";
            break;
        } case YCDeviceStatusClose: {
            statusStr = @"设备维护中";
            break;
        }
        default: {
            break;
        }
    }
    return statusStr;
}

- (BOOL)isOpenByMe{
    return self.deviceStatus==YCDeviceStatusOpenByMe;
}

//- (NSDate *)startUseDate{
//    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-self.lt];
//    return date;
//}
@end

@implementation YCOrderModel


@end

@implementation YCTradeHisModel

- (NSString *)timeString{
    NSString *datestr;
    if (self.DepositNo) {
        datestr = self.DepositNo;
    }else {
        datestr = self.tranDate;
    }
    if (self.tranDate.length == 14) {
         return [TimeUtils timeStringFromDate:[TimeUtils dateFromString:datestr withFormat:@"yyyyMMddHHmmss"] withFormat:@"MM-dd HH:mm"];
    }else {
     return [TimeUtils timeStringFromDate:[TimeUtils dateFromString:datestr withFormat:@"yyyyMMdd"] withFormat:@"MM-dd"];
    }
   
}
@end

@implementation YCTradeMonthModel

@end


@implementation YCShowerSettingModel

@end

@implementation YCUseResultModel

@end

@implementation YCVersionCheckModel

@end


@implementation YCVersionModel

@end

@implementation YCLoudongModel

@end

@implementation YCNotiModel

@end
