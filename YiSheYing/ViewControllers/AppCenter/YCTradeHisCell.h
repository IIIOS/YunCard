//
//  YCTradeHisCell.h
//  YunCard
//
//  Created by Jinjin on 15/8/22.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCTradeHisCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UILabel *moneyLabel;
- (void)bindData:(YCTradeHisModel *)model;
@end
