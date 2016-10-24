//
//  YMInputAnimationView.m
//  dream
//
//  Created by helfy  on 15-3-30.
//  Copyright (c) 2015年 helfy . All rights reserved.
//

#import "YMInputAnimationView.h"
@implementation YMInputAnimationView
{
    UIView *contentView;
    
    UIToolbar *toolBar;
    
    UIView *picker;
    
    YMInputAnimationViewType pickerType;
    
    int chooseIndex;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithType:(YMInputAnimationViewType)type
{
    self = [super init];
    if(self)
    {
        
        pickerType = type;
        contentView = [UIView new];
        [self addSubview:contentView];
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(240));
            make.bottom.equalTo(self).offset(240);
            make.left.right.equalTo(self);
            
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(done)];
        tap.delegate = (id)self;
        [self addGestureRecognizer:tap];
        contentView.backgroundColor = RGB(240, 242, 242);
        toolBar =[UIToolbar new];
        UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
        [doneBtn setTintColor:[UIColor blueColor]];
        UIBarButtonItem *spaceBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        toolBar.items=@[spaceBtn,doneBtn];
        [contentView addSubview:toolBar];
        [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView);
            make.left.right.equalTo(contentView);
            make.height.equalTo(@(45));
            
        }];
        
      
    }
    return self;
}

-(void)setupPickerView
{
   
    switch (pickerType) {
        case YMInputAnimationViewTypeIsDate:
        {
            UIDatePicker *pickerView = [[UIDatePicker alloc] init];
            pickerView.datePickerMode = UIDatePickerModeDate;
            if( self.defaultValue)
            {
                pickerView.date = self.defaultValue;
            }
            
            if(self.minimumDate)
            {
              pickerView.minimumDate = self.minimumDate;
            }
            if(self.maximumDate)
            {
              pickerView.maximumDate = self.maximumDate;
            }
            
            picker=pickerView;
        }
            break;
        case YMInputAnimationViewTypeIsTime:
        {
            UIDatePicker *pickerView = [[UIDatePicker alloc] init];
            pickerView.datePickerMode = UIDatePickerModeTime;
            if( self.defaultValue)
            {
                pickerView.date = self.defaultValue;
            }
            if(self.minimumDate)
            {
                pickerView.minimumDate = self.minimumDate;
            }
            if(self.maximumDate)
            {
                pickerView.maximumDate = self.maximumDate;
            }
            picker=pickerView;
        }
            break;
        case YMInputAnimationViewTypeIsDateAndTime:
        {
            UIDatePicker *pickerView = [[UIDatePicker alloc] init];
            pickerView.datePickerMode = UIDatePickerModeDateAndTime;
            if( self.defaultValue)
            {
                pickerView.date = self.defaultValue;
            }
            if(self.minimumDate)
            {
                pickerView.minimumDate = self.minimumDate;
            }
            if(self.maximumDate)
            {
                pickerView.maximumDate = self.maximumDate;
            }
            picker=pickerView;
        }
            break;
        case YMInputAnimationViewTypeIsCustomData:
        {
            UIPickerView *pickerView = [UIPickerView new];
            pickerView.dataSource = (id)self;
            pickerView.delegate = (id)self;
            
            if( self.defaultValue)
            {
                chooseIndex =(int)[self.dataSourceArrry indexOfObject:self.defaultValue];
                [pickerView selectRow:chooseIndex inComponent:0 animated:NO];
            }
            
            picker=pickerView;
        }
            break;
        case YMInputAnimationViewTypeIsNone:
        {
        
        }
            break;
        default:
            break;
    }
}

-(void)done
{
    if(self.changeBlock)
    {
        
        id chooseValue=nil;
        switch (pickerType)
        {
            case YMInputAnimationViewTypeIsDate:
            case YMInputAnimationViewTypeIsTime:
            case YMInputAnimationViewTypeIsDateAndTime:
            {
                chooseValue = ((UIDatePicker *)picker).date;
            }
                break;
            case YMInputAnimationViewTypeIsCustomData:
            {

                
               chooseValue= self.dataSourceArrry[chooseIndex];
            }
                
                break;
            default:
            {
            
            }
        }
        self.changeBlock(chooseValue);
    }
    [self cancel];
}

-(void)cancel
{
    [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(240));
        make.bottom.equalTo(self).offset(240);
        make.left.right.equalTo(self);
        
    }];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor clearColor];
        [contentView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

   
}


-(void)showInView:(UIView *)view
{

    [self setupPickerView];
    
    [contentView addSubview:picker];
    picker.backgroundColor = [UIColor clearColor];
    [picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(toolBar.mas_bottom).priorityLow();
        make.bottom.equalTo(contentView).priorityLow();
        make.left.right.equalTo(contentView);
        //        make.height.equalTo(200);
    }];
    [view addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
      [contentView layoutIfNeeded];
    [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(240));
        make.bottom.equalTo(self);
        make.left.right.equalTo(self);
        
    }];
 
    
    [UIView beginAnimations:nil context:nil];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [contentView layoutIfNeeded];
    [UIView commitAnimations];

//    POPBasicAnimation *centerAnimation  = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
//    centerAnimation.toValue = self.frame.;
//    centerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    centerAnimation.duration = 10;
//    [contentView pop_addAnimation:animation forKey:@"scaleAnimation"];
//    
    
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (CGRectContainsPoint(contentView.frame, [touch locationInView:contentView])) {
        return NO;
    }
    
    return YES;
}
#pragma mark -
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return  1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return  self.dataSourceArrry.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

        return self.dataSourceArrry[row];

}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    chooseIndex = (int)row;
}




@end
