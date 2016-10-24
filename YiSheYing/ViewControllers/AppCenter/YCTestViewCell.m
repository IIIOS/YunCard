//
//  YCTestViewCell.m
//  YunCard
//
//  Created by Lwj on 15/12/2.
//  Copyright © 2015年 JiaJun. All rights reserved.
//

#import "YCTestViewCell.h"

@implementation YCTestViewCell

- (void)awakeFromNib {
    // Initialization code
    self.statusLabel.textColor = [UIColor redColor];
    self.courseLabel.textColor = [UIColor redColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setItem:(MyTestModel *)item
{
    self.nameLabel.text = item.subject;
    self.timeLabel.text = item.time;
    self.statusLabel.text = item.status;
    if (![item.status isEqualToString:@"已考完"]) {
        self.courseLabel.hidden = YES;
    }else{
        self.courseLabel.text = item.result;
    }
    
}
@end
