//
//  MyTestModel.m
//  YunCard
//
//  Created by Lwj on 15/12/5.
//  Copyright © 2015年 JiaJun. All rights reserved.
//

#import "MyTestModel.h"

@implementation MyTestModel
- (id)initWithDic:(NSDictionary *)dic
{
    MyTestModel *model = [[MyTestModel alloc]init];
    model.subject = dic[@"subject"];
    model.time = dic[@"time"];
    model.result = dic[@"result"];
    if ([dic[@"is_end"] boolValue]) {
        model.status = @"已考完";
    }else{
        model.status = @"未开始";
    }
    return model;
}
@end
