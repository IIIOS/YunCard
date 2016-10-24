//
//  YMBaseTableViewCell.m
//  YunCard
//
//  Created by helfy  on 15/6/14.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YMBaseTableViewCell.h"

@implementation YMBaseTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)bindData:(id)data
{

}

+(float)cellHeigthForData:(id)cellObj
{
    return 40;
}

@end
