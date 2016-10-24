//
//  YCTradeHisCell.m
//  YunCard
//
//  Created by Jinjin on 15/8/22.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YCTradeHisCell.h"
#import "TimeUtils.h"
@implementation YCTradeHisCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)bindData:(YCTradeHisModel *)model{
 
    self.timeLabel.text = [model timeString];
    self.contentLabel.text = [NSString stringWithFormat:@"%@",model.tranName];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",model.tranAmt/100];
}
@end
