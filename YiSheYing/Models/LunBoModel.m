//
//  LunBoModel.m
//  YunCard
//
//  Created by Lwj on 15/12/12.
//  Copyright © 2015年 JiaJun. All rights reserved.
//

#import "LunBoModel.h"

@implementation LunBoModel
- (id)initWithDic:(NSDictionary *)dic
{
    LunBoModel *model = [[LunBoModel alloc]init];
    model.img_id = dic[@"img_id"];
    model.img_url = dic[@"img_url"];
    model.link = dic[@"link"];
    return model;
}
@end
