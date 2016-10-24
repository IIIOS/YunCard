//
//  MyTestModel.h
//  YunCard
//
//  Created by Lwj on 15/12/5.
//  Copyright © 2015年 JiaJun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTestModel : NSObject
@property (nonatomic, strong)NSString  *subject;
@property (nonatomic, strong)NSString  *time;
@property (nonatomic, strong)NSString  *result;
@property (nonatomic, strong)NSString  *status;


- (id)initWithDic:(NSDictionary *)dic;
@end
