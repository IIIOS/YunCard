//
//  BusinessListModel.h
//  YunCard
//
//  Created by Lwj on 15/12/10.
//  Copyright © 2015年 JiaJun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessListModel : NSObject
@property (nonatomic, strong)NSString  *business_id;
@property (nonatomic, strong)NSString  *name;
@property (nonatomic, strong)NSString  *introduce;
@property (nonatomic, strong)NSNumber  *discount;
@property (nonatomic, strong)NSString  *consumption_count;
@property (nonatomic, strong)NSString  *thumbnail;
@property (nonatomic, strong)NSString  *entering_time;
- (id)initWithDic:(NSDictionary *)dic;
@end
