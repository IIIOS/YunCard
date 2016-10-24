//
//  YMBaseTableViewCell.h
//  YunCard
//
//  Created by helfy  on 15/6/14.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YMBaseTableViewCellDelegate <NSObject>

-(void)tableViewCellButonDidTap:(id)cell buttonIndex:(int)index;

@end

@interface YMBaseTableViewCell : UITableViewCell
@property (nonatomic,assign)id<YMBaseTableViewCellDelegate>delegate;

-(void)bindData:(id)data;

+(float)cellHeigthForData:(id)cellObj;
@end
