//
//  LunBoModel.h
//  YunCard
//
//  Created by Lwj on 15/12/12.
//  Copyright © 2015年 JiaJun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LunBoModel : NSObject
@property (nonatomic, strong)NSString *img_id;
@property (nonatomic, strong)NSString  *img_url;
@property (nonatomic, strong)NSString  *link;
- (id)initWithDic:(NSDictionary *)dic;
@end
