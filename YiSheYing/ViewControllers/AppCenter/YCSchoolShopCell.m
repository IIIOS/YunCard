//
//  YCSchoolShopCell.m
//  YunCard
//
//  Created by Lwj on 15/12/2.
//  Copyright © 2015年 JiaJun. All rights reserved.
//

#import "YCSchoolShopCell.h"

@implementation YCSchoolShopCell
- (void)awakeFromNib
{
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setItem:(BusinessListModel *)item
{
    self.hallLabel.text = item.name;
    self.detaillLabel.text = item.introduce;
    [self.headImage setImageWithURLString:item.thumbnail placeholderImage:[UIImage imageNamed:@"defaultImage"]];
}

-(void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGPoint aPoints[2];

    aPoints[0] =CGPointMake(0, CGRectGetHeight(rect)-0.5);//loaction1

    aPoints[1] =CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect)-0.5);//loaction2

    CGContextAddLines(context, aPoints, 2);

    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexRGB:@"#F0F0F0"].CGColor);

    CGContextDrawPath(context, kCGPathStroke);

}
@end
