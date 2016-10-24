//
//  BusinessListModel.m
//  YunCard
//
//  Created by Lwj on 15/12/10.
//  Copyright © 2015年 JiaJun. All rights reserved.
//

#import "BusinessListModel.h"

@implementation BusinessListModel
- (id)initWithDic:(NSDictionary *)dic
{
    BusinessListModel *model = [[BusinessListModel alloc]init];
    model.business_id = dic[@"business_id"];
    model.name = dic[@"name"];
    model.introduce = dic[@"introduce"];
    model.discount = dic[@"discount"];
    model.consumption_count = dic[@"consumption_count"];
    model.entering_time = dic[@"entering_time"];
    model.thumbnail = dic[@"thumbnail"];
    return model;
}
@end
