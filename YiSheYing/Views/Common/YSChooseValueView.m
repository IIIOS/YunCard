//
//  YSChooseValueView.m
//  YunCard
//
//  Created by helfy  on 15/7/20.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YSChooseValueView.h"
#import "UIView+CGRectUtils.h"
#import "MButton.h"


#define kShowMaxRow  10
@implementation YSChooseValueView
{
    
    UIView *contentView;
    UITableView *valueList;
 
    MButton *cancelButton;
    

}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setupView];
    }
    return self;
}

#pragma mark - setupView
-(void)setupView
{
    contentView.backgroundColor = [UIColor redColor];
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frameWidth, 0)];
    [self addSubview:contentView];

    valueList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,self.frameWidth, 0) style:UITableViewStylePlain];
    valueList.rowHeight=40;
    valueList.delegate = (id)self;
    valueList.dataSource = (id)self;
    [valueList registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [contentView addSubview:valueList];

    
    cancelButton = [[MButton alloc] initWithFrame:CGRectMake(0, 0, self.frameWidth, 40)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelChoose) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setNormalColor:kDefaultReadColor SelectColor:[kDefaultReadColor colorWithAlphaComponent:0.8]];
    [contentView addSubview:cancelButton];

}


#pragma mark - setData
-(void)setValues:(NSArray *)values
{
    _values = values;
    
   
    [valueList reloadData];
}



-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    if(_values.count > kShowMaxRow)
    {
        valueList.scrollEnabled =YES;
        valueList.frame = CGRectMake(0, 0, contentView.frameWidth, valueList.rowHeight*kShowMaxRow);
    }
    else
    {
        valueList.scrollEnabled =NO;
        valueList.frame = CGRectMake(0, 0, contentView.frameWidth, valueList.rowHeight*_values.count);
        
    }
    
    contentView.frame = CGRectMake(0, self.frameHeight -(valueList.frameHeight+cancelButton.frameHeight), self.frameWidth, valueList.frameHeight+cancelButton.frameHeight);
    
    cancelButton.y = contentView.frameHeight-cancelButton.frameHeight;
    
    
  
}

-(void)layoutSubviews
{
    if ([valueList respondsToSelector:@selector(setSeparatorInset:)]) {
        [valueList setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([valueList respondsToSelector:@selector(setLayoutMargins:)]) {
        [valueList setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
#pragma mark TableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
   return self.values.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier =@"UITableViewCell";
    
    UITableViewCell *cell = [sender dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = self.values[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [sender deselectRowAtIndexPath:indexPath animated:YES];
  
    if([self.delegate respondsToSelector:@selector(chooseValueDidChoose:index:)])
    {
        [self.delegate chooseValueDidChoose:self index:(int)indexPath.row];
    }
    
    [self cancelChoose];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }

    
    
}

#pragma mark - animation

- (void)showInView:(UIView *) view
{
    
    [view addSubview:self];
    self.frame = view.bounds;
    contentView.frame = CGRectMake(0, self.frameHeight, self.frameWidth, contentView.frameHeight);
   
    [UIView beginAnimations:nil context:nil];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    contentView.y=self.frameHeight-contentView.frameHeight;
    [UIView commitAnimations];
}

- (void)cancelChoose
{

    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor clearColor];
        contentView.y = self.frameHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
    
}

@end
