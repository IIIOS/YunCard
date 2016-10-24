//
//  courceManger.m
//  YunCard
//
//  Created by Lwj on 15/12/4.
//  Copyright © 2015年 JiaJun. All rights reserved.
//

#import "courceManger.h"
#import "courceModel.h"
@implementation courceManger
+ (NSMutableArray *)getShowTagArray:(NSArray *)dataArray
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSInteger i = 0; i < dataArray.count; i ++) {
        NSArray *array1= (NSArray *)dataArray[i];
        if (array1.count != 0) {
            for (NSDictionary *dic in array1) {
                NSString *lessonString = [NSString stringWithString:dic[@"lesson"]];
                NSArray* stringArray = [lessonString componentsSeparatedByString: @","];
                NSInteger start = [stringArray.firstObject integerValue];
                NSInteger end = [stringArray.lastObject integerValue] + 1;
                courceModel *model = [[courceModel alloc]init];
                model.cource = dic[@"course"];
                NSMutableArray *indexArray = [NSMutableArray array];
                for (NSInteger k = start; k < end; k ++) {
                    [indexArray addObject:[NSNumber numberWithInteger:20 + i * 12 + k]];
                }
                model.minTag = start;
                model.showTagArray = indexArray;
                model.date = i;
                [tmpArray addObject:model];
                NSLog(@"%@",stringArray );
            }
        }
    }
    return tmpArray;
}
@end
