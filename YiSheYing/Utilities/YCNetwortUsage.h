//
//  YCNetwortUsage.h
//  YunCard
//
//  Created by Jinjin on 15/9/10.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCNetwortUsage : NSObject

+ (long long int)getGprs3GFlowIOBytes;
+ (long long int)getInterfaceBytes ;
+ (long long int)allUse;
+ (NSString *)bytesToAvaiUnit:(long long int)bytes ;
@end
