//
//  YCTestViewCell.h
//  YunCard
//
//  Created by Lwj on 15/12/2.
//  Copyright © 2015年 JiaJun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTestModel.h"
@interface YCTestViewCell : UITableViewCell
@property(nonatomic, strong)MyTestModel *item;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end
