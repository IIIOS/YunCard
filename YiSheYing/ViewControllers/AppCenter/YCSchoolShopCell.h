//
//  YCSchoolShopCell.h
//  YunCard
//
//  Created by Lwj on 15/12/2.
//  Copyright © 2015年 JiaJun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessListModel.h"
@interface YCSchoolShopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hallLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *detaillLabel;
@property (nonatomic,strong)BusinessListModel *item;
@end
