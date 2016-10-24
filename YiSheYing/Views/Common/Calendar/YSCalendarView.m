//
//  YSCalendarView.m
//  YunCard
//
//  Created by helfy  on 15/7/18.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YSCalendarView.h"
#import "YSCalendarMonthModel.h"
#import "YSCalendarDayModel.h"
#import "YSCalendarDayCell.h"
#import "YSWeekHeaderView.h"
#import "UIView+CGRectUtils.h"
#import "MButton.h"
@implementation YSCalendarView
{
    UICollectionView* collectionView;
    
    MButton *monthButton;
    MButton *yearButton;

    YSCalendarMonthModel *monthModel;  //当前界面对应的年、月
    
    NSMutableArray *scheduleArray;
    
    NSArray *calendays;
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        scheduleArray = [NSMutableArray array];
        self.chooseDays = [NSMutableArray array];
        [self setupView];
        [self setupCollectionView];
    }
    return self;
}

#pragma mark - setupView
-(void)setupView
{
    monthButton = [MButton new];
   [monthButton setTitleColor:RGB(244, 61, 83) forState:UIControlStateNormal];
//    [monthButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [monthButton addTarget:self action:@selector(chooseMonth) forControlEvents:UIControlEventTouchUpInside];
    monthButton.imageAtEnd = YES;
    monthButton.arrangement = MButtonContentArrangementHorizontal;
    [monthButton setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    [monthButton setImageShowSize:CGSizeMake(10, 10)];
    [self addSubview:monthButton];
    monthButton.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [monthButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(25));
        make.width.equalTo(@(60));
        make.height.equalTo(@(40));
        make.top.equalTo(self);
    }];
    
    yearButton = [MButton new];
    [yearButton setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    [yearButton setImageShowSize:CGSizeMake(10, 10)];
    yearButton.imageAtEnd = YES;
    yearButton.arrangement = MButtonContentArrangementHorizontal;
    
    [yearButton setTitleColor:RGB(244, 61, 83) forState:UIControlStateNormal];
//    [yearButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [yearButton addTarget:self action:@selector(chooseYear) forControlEvents:UIControlEventTouchUpInside];
    yearButton.titleLabel.font = [UIFont systemFontOfSize:12];
    
  [self addSubview:yearButton];
    [yearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-25));
        make.width.equalTo(@(60));
        make.height.equalTo(@(40));
        make.top.equalTo(self);
    }];
}

-(void)setupCollectionView
{
    

    UICollectionViewFlowLayout *allFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    allFlowLayout.minimumInteritemSpacing =1;
    allFlowLayout.minimumLineSpacing =3;
    allFlowLayout.headerReferenceSize = CGSizeMake(self.frameWidth, 25);//头部视图的框架大小
    
    
    collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:allFlowLayout];
    collectionView.backgroundColor =[UIColor clearColor];
    collectionView.dataSource = (id)self;
    collectionView.delegate = (id)self;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.scrollEnabled = NO;
    [self addSubview:collectionView];
    [collectionView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self);
        make.right.equalTo (self);
        make.top.equalTo (self).offset(40);
        make.bottom.equalTo (self);
    }];
    [collectionView registerClass:[YSCalendarDayCell class] forCellWithReuseIdentifier:@"YSCalendarDayCell"];
    [collectionView registerClass:[YSWeekHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YSWeekHeaderView"];

    
}


#pragma mark -- getter

-(YSCalendarMonthModel *)currentMonthModel
{
    return monthModel;
}

-(CGSize )getViewSize
{
    return collectionView.contentSize;
}
#pragma mark - 设置档期日期
-(void)setScheduleTims:(NSArray *)times
{
    
    [scheduleArray removeAllObjects];
    for (NSDictionary *dic in times) {
        NSTimeInterval time = [dic[@"createtime"] doubleValue];
        YSCalendarDayModel *dayModel = [YSCalendarDayModel calendarDayWithTimeInterval:time];
        dayModel.style = YSCalendarDayFull;
        [scheduleArray addObject:dayModel];
    }
     [self reloadView];
}
#pragma mark - reload
-(void)reloadViewForNewModel:(YSCalendarMonthModel *)newModel
{
    monthModel=newModel;
    if(monthModel)
    {
        [self reloadView];
    }
}


-(void)reloadView
{
    
//     ﹀
    [monthButton setTitle:[NSString stringWithFormat:@"%@",[monthModel getMonthString]] forState:UIControlStateNormal];
    [yearButton setTitle:[NSString stringWithFormat:@"%@",@(monthModel.year).stringValue] forState:UIControlStateNormal];
    
    //设置已排档期
    //先改变选择的日期的状态  主要用于切换月份后
    calendays= [monthModel daysForView];
//    //状态重置
//    for (YSCalendarDayModel *model in days) {
//        model.isSelect = NO;
//    }
    
    
    for (YSCalendarDayModel *otherModel in calendays) {
        for (YSCalendarDayModel *model in scheduleArray) {
            if([model sameOtherModel:otherModel])
            {
                if(otherModel.style ==YSCalendarDayToday ||  otherModel.style ==YSCalendarDayFutur)
                {
                    otherModel.style = YSCalendarDayFull;
                }
                
                continue;
            }
        }
    }
    
 
    for (YSCalendarDayModel *model in calendays) {
        for (YSCalendarDayModel *otherModel in self.chooseDays) {
            if([model sameOtherModel:otherModel])
            {
                model.isSelect = YES;
                continue;
            }
        }
    }
    
 
    [collectionView reloadData];
    
}

#pragma mark chooseOperation
//
-(void)addSelectModel:(YSCalendarDayModel *)model
{
    BOOL canAdd = YES;
    if(self.maxChooseCount >0)
    {
        if(self.chooseDays.count >= self.maxChooseCount)
        {
            canAdd = NO;
        }
    }
    if(canAdd)
    {
        [self.chooseDays addObject:model];
    }
    else//不能再添加。。选中状态设置为NO
    {
        YSCalendarDayModel *firstObj = [self.chooseDays firstObject];
        firstObj.isSelect = NO;
        [self.chooseDays removeObject:firstObj];
        [self.chooseDays addObject:model];
        [collectionView reloadData];
        
//        model.isSelect = NO;
//        if([self.delegate respondsToSelector:@selector(calendarDidExceedMaxChoose)])
//        {
//            [self.delegate calendarDidExceedMaxChoose];
//        }
//        else{
//        
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"最多可以选%i个",self.maxChooseCount] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alert show];
//        }
        
    }
}

-(void)removeSelectModel:(YSCalendarDayModel *)model
{
    
    for (YSCalendarDayModel *otherModel in self.chooseDays) {
        if([model sameOtherModel:otherModel])
        {
            [self.chooseDays removeObject:otherModel];
            return;
        }
    }
}



#pragma mark - UICollectionViewDelegate
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.frameWidth-50)/7.0, (self.frameWidth-50)/7.0);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,20,0,20);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;//optionArray.count;
}
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return calendays.count;
}


//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)sender cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YSCalendarDayCell *cell = [sender dequeueReusableCellWithReuseIdentifier:@"YSCalendarDayCell" forIndexPath:indexPath];
    [cell setIsEdit:self.isEdit];
    YSCalendarDayModel *model = [calendays  objectAtIndex:indexPath.row];
    [cell bindModel:model];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)sender viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;

    if (kind == UICollectionElementKindSectionHeader){
     
        YSWeekHeaderView *header = [sender dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YSWeekHeaderView" forIndexPath:indexPath];
        reusableview = header;
    }
    return reusableview;

}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)sender didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YSCalendarDayCell *cell = (YSCalendarDayCell*)[sender cellForItemAtIndexPath:indexPath];
    YSCalendarDayModel *model = [calendays  objectAtIndex:indexPath.row];
    model.isSelect = !model.isSelect;
    
    if(model.isSelect)
    {
        [self addSelectModel:model];
    }
    else{
        [self removeSelectModel:model];
    }
    [cell bindModel:model];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YSCalendarDayModel *model = [calendays  objectAtIndex:indexPath.row];
    BOOL canSelect = YES;
  if(model.style == YSCalendarDayFull || model.style == YSCalendarDayPast ||  model.style == YSCalendarDayTypeEmpty)
  {
      canSelect = NO;
  }
    
    
    if(self.isEdit && model.style == YSCalendarDayFull)
    {
        canSelect = YES;
    }
    return canSelect;
}

#pragma mark -- respone
-(void)chooseMonth
{
    [self.delegate calendarChangeMonthButtonDidTap:self currentMonth:monthModel.month];
    
}

-(void)chooseYear
{
    [self.delegate calendarChangeYearButtonDidTap:self currentYear:monthModel.year];
    
}
@end
