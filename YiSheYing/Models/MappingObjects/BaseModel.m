
//  BaseModel.m
//  SCSDTGO
//
//  Created by  YangHangbin on 14-3-3.
//  Copyright (c) 2014年 SCSD_TGO_TEAM. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"resp_desc": @"message",
                                                       @"resp_code": @"code",
                                                       @"data": @"data"}];
}
@end

@implementation AFPageInfoModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end