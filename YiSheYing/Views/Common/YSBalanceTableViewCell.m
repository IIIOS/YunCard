//
//  YSBalanceTableViewCell.m
//  YunCard
//
//  Created by helfy  on 15/7/9.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YSBalanceTableViewCell.h"

@implementation YSBalanceTableViewCell
{
    UILabel *typeLabel;
    UILabel *numberLabel;
    UILabel *dateLaabel;
    UILabel *statusLabel;
    
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setupView];
    }
    return self;
}

-(void)setupView
{
    typeLabel = [UILabel new];
    [self.contentView addSubview:typeLabel];
    
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.top.equalTo(@(5));
        make.height.equalTo(@(20));
        make.width.equalTo(@(100));//
    }];
    numberLabel = [UILabel new];
    numberLabel.textColor = kDefaultReadColor;
    numberLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-10));
        make.top.equalTo(@(5));
        make.height.equalTo(@(20));
        
        make.width.equalTo(@(150));//
    }];
    
    dateLaabel = [UILabel new];
    dateLaabel.textColor = [UIColor grayColor];
    dateLaabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:dateLaabel];
    [dateLaabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.bottom.equalTo(@(-5));
        make.height.equalTo(@(20));
        make.width.equalTo(@(100));//
    }];
    statusLabel = [UILabel new];
    
    statusLabel.textColor = [UIColor grayColor];
    statusLabel.font = [UIFont systemFontOfSize:14];
    statusLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:statusLabel];
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-10));
        make.bottom.equalTo(@(-5));
        make.height.equalTo(@(20));
        make.width.equalTo(@(150));//
    }];
    
}
//-(void)bindData:(YSBalanceModel *)data
//{
//    typeLabel.text = data.typeStr;//@"提现";
//    numberLabel.text = data.money;//@"－300.00";
//    dateLaabel.text = data.dateStr;//@"04-09";
//    statusLabel.text = data.isAction?@"已处理":@"未处理";//@"成功";
//}

+(float)cellHeigthForData:(id)cellObj;
{
    return 55;
}
@end
