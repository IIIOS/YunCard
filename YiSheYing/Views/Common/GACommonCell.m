//
//  GACommonCell.m
//  YunCard
//
//  Created by Jinjin on 15/1/29.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "GACommonCell.h"

@implementation GACommonCell

- (void)awakeFromNib {
    // Initialization code
        [self makeConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType{

    [super setAccessoryType:accessoryType];
    [self makeConstraints];
}

- (void)makeConstraints{
    WS(ws);
    CGFloat right = -(self.accessoryType==UITableViewCellAccessoryNone?15:(10+25));
    [self.gaNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@15);
        make.top.mas_equalTo(@0);
        make.bottom.mas_equalTo(ws);
        make.width.mas_equalTo(@(SCREEN_WIDTH-100));
    }];
    [self.gaDetailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@(125));
        make.top.mas_equalTo(@0);
        make.bottom.mas_equalTo(ws);
        make.right.mas_equalTo(ws).with.offset(right);
    }];
}
@end
