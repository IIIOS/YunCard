//
//  YCTradeHisViewController.m
//  YunCard
//
//  Created by Jinjin on 15/8/22.
//  Copyright (c) 2015年 JiaJun. All rights reserved.
//

#import "YCTradeHisViewController.h"
#import "TimeUtils.h"
#import "YCTradeHisCell.h"
#import "MAKMonthPicker.h"

@interface YCTradeHisViewController ()
@property (nonatomic,weak) IBOutlet UIView *footerView;
@property (nonatomic,weak) IBOutlet UIView *headerView;
@property (nonatomic,weak) IBOutlet UILabel *timeLabel;
@property (nonatomic,weak) IBOutlet UILabel *endTimeLabel;
@property (nonatomic,weak) IBOutlet UILabel *allMoneyLabel;


@property (nonatomic,strong) IBOutlet UIView *pickerBgView;
@property (weak, nonatomic) IBOutlet UIView *pickerContentView;
@property (weak, nonatomic) IBOutlet UIDatePicker *monthPicker;
@property (weak, nonatomic) IBOutlet UIButton *pickerBlack;
@property (strong, nonatomic) IBOutlet UIButton *chaxunBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhichuBtn;
@property (weak, nonatomic) IBOutlet UIButton *chongzhiBtn;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic, strong) IBOutlet UIView *sectionHeaderView;

@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;


@property (nonatomic, weak) NSDate *currentSetDate;

- (IBAction)dismissPicker;
- (IBAction)showPicker:(UIButton *)btn;
- (IBAction)typeChange:(UIButton *)btn;
- (IBAction)didPickerChangeData;
- (IBAction)chaxunBtnDidTap;
@end

@implementation YCTradeHisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"账单查询";
//    self.tableView.tableHeaderView = self.headerView;
//    self.tableView.tableFooterView = self.footerView;
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
    
    self.timeLabel.text = [TimeUtils timeStringFromDate:self.beginDate withFormat:@"yyyy年MM月dd日"];
    self.endTimeLabel.text = [TimeUtils timeStringFromDate:self.endDate withFormat:@"yyyy年MM月dd日"];
    
    [self hidePicker:YES animation:NO];
    
    
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.chaxunBtn];
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]
                  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                  target:self
                  action:nil];
    flexSpacer.width = -10;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:flexSpacer, rightButtonItem, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)hidePicker:(BOOL)hide animation:(BOOL)animation{
    
    if (!hide) {
        self.pickerBgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.pickerBgView];
    }
    
    [UIView animateWithDuration:YES?0.35:0 animations:^{
        
        self.pickerBlack.alpha = hide?0:1;
        self.pickerContentView.frame = hide?CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 202):CGRectMake(0, SCREEN_HEIGHT-202, SCREEN_WIDTH, 202);
    } completion:^(BOOL finished) {
        
        if (hide) {
            [self.pickerBgView removeFromSuperview];
        }
    }];
}


- (IBAction)dismissPicker{
    self.currentSetDate = nil;
    [self hidePicker:YES animation:YES];
}


- (IBAction)showPicker:(UIButton *)btn{
    if (btn.tag==0) {
        self.currentSetDate = self.beginDate;
    }else{
        self.currentSetDate = self.endDate;
    }
    self.monthPicker.date = self.currentSetDate;
    [self hidePicker:NO animation:YES];
}

- (IBAction)chaxunBtnDidTap{

    [self refresh];
}


- (IBAction)typeChange:(UIButton *)btn{

    self.chongzhiBtn.selected = NO;
    self.zhichuBtn.selected = NO;
    btn.selected = YES;
    [self refresh];
}

- (void)didPickerChangeData{
    
    if (self.currentSetDate==self.beginDate) {
        self.beginDate = self.monthPicker.date;
        self.timeLabel.text = [TimeUtils timeStringFromDate:self.beginDate withFormat:@"yyyy年MM月dd日"];
    }else{
        self.endDate = [TimeUtils endOfDay:self.monthPicker.date];
        self.endTimeLabel.text = [TimeUtils timeStringFromDate:self.endDate withFormat:@"yyyy年MM月dd日"];
    }
    [self hidePicker:YES animation:YES];
    [self refresh];
}

- (void)refresh{
    [self refreshWithSuccessed:self.successBlock failed:self.failedBlock];
}

- (NSDate *)beginDate{
    
    if (nil==_beginDate) {
        _beginDate = [TimeUtils beginningOfMonth:[NSDate date]];
    }
    return _beginDate;
}
- (NSDate *)endDate{
    
    if (nil==_endDate) {
        _endDate = [TimeUtils endOfDay:[NSDate date]];
    }
    return _endDate;
}

#pragma mark - 可选的重写方法
- (BOOL)showLodingView{
    
    return NO;
}

- (BOOL)shouldCacheArray{
    
    return NO;
}

- (NSString *)keyOfCachedArray{
    return NSStringFromClass([self class]);
}

//空数据界面的Frame
- (CGRect)noInfoViewFrame{
    
    return CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

//是否显示空数据占位图 默认为No
- (BOOL)showNoInfoView{
    return NO;
}

//空数据界面Action操作
- (void)noInfoActionButtonClicked:(id)sender{
    [self refresh];
}

//当没有数据的时候显示提示文本
- (NSString *)hintStringWhenNoData{
    return @"暂时没有记录";
}

//对数组进行预处理
- (NSArray *)preProcessData:(NSArray *)anArray{
    return anArray;
}
//是否开放加载更多的功能（默认YES）
- (BOOL)loadMoreEnable{
    return YES;
}

#pragma mark - 最终的子类必须重写的方法
//接口方法
- (NSString *)methodWithPath{
    
    return nil;
}

//自定义的cell布局文件
- (NSString *)nibNameOfCell{
    
    return @"YCTradeHisCell";
}

//请求URL参数封装
- (NSDictionary *)dictParamWithPage:(NSInteger)page{
    page ++;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    if ([YCUserModel currentUser].studentNo)[param setObject:[YCUserModel currentUser].studentNo forKey:@"stu_no"];
    [param setObject:@"getCardTransaction" forKey:@"action"];
    [param setObject:@(page) forKey:@"page_index"];
    [param setObject:kDefaultPageSize forKey:@"page_size"];
    NSString *type = self.chongzhiBtn.selected?@"chongru":@"zhichu";
    [param setObject:kDefaultPageSize forKey:@"page_size"];
    [param setObject:type forKey:@"type"];
    [param setObject:[TimeUtils timeStringFromDate:self.beginDate withFormat:@"yyyyMMddHHmmss"] forKey:@"begin_date"];
    [param setObject:[TimeUtils timeStringFromDate:self.endDate withFormat:@"yyyyMMddHHmmss"] forKey:@"end_date"];
    return param;
}

- (NSString *)modelNameOfData{
    
    return @"YCTradeHisModel";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionHeaderView;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"明细";
//}

- (CGFloat)tableViewCellHeightForData:(id)object atIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

//根据数据来布局界面
- (UIView *)layoutCellWithData:(id)object atIndexPath:(NSIndexPath *)indexPath{
    
    
    YCTradeHisModel *data = self.dataArray[indexPath.row];
    YCTradeHisCell *cell = (id)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    [cell bindData:data];
    return cell;
}

- (void)clickedCell:(id)object atIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
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
@end
