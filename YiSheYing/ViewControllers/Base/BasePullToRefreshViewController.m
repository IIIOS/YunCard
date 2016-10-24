//
//  BasePullToRefreshViewController.m
//  TGO2
//
//  Created by  YangShengchao on 14-4-18.
//  Copyright (c) 2014年 SCSD_TGO_TEAM. All rights reserved.
//

#import "BasePullToRefreshViewController.h"

@interface BasePullToRefreshViewController ()

@property (nonatomic, assign) NSInteger loadTimes;

@end

@implementation BasePullToRefreshViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  必须释放headerView和footerView
 */
- (void)dealloc {
	[self.mjRefreshHeaderView free];
	[self.mjRefreshFooterView free];
}

- (void)viewDidLoad {
    self.dataArray = [NSMutableArray array];
    [super viewDidLoad];
    self.currentPageIndex = 0;                  //分页从1开始
    
    //判断是否需要刷新功能
    if ([self refreshEnable]) {
        if ([self showRefreshHeadView]) [self addRefreshHeaderView];
        
		//判断是否进入的时候就刷新
		if ([self shouldRefreshWhenEntered]) {
            
            if ([self shouldShowRefreshAnimationWhenEntered]) {
                [self.mjRefreshHeaderView beginRefreshing];
            }else{
                [self refreshWithSuccessed:self.successBlock failed:self.failedBlock];
            }
		}
	}
    
	//判断是否需要加载更多功能
	if ([self loadMoreEnable]) {
		[self addRefreshFooterView];
	}
    [self.nodataInfoView setInfoText:[self hintStringWhenNoData]];
}

- (YSLoadingView *)lodingView{

    if (nil==_lodingView && [self showLodingView]) {
        _lodingView = [[YSLoadingView alloc] initWithFrame:[self loadingViewFrame]];
        _lodingView.imagesArr = @[[UIImage imageNamed:@"loading_1"],
                                      [UIImage imageNamed:@"loading_2"],
                                      [UIImage imageNamed:@"loading_3"],
                                      [UIImage imageNamed:@"loading_4"]];
        [self.view addSubview:_lodingView];
    }
    return _lodingView;
}

- (CGRect)loadingViewFrame{

    CGFloat navibarY = self.navigationController.navigationBarHidden?0:CGRectGetMaxY(self.navigationController.navigationBar.frame);
    return CGRectMake(0, 0-navibarY, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)addRefreshHeaderView {
	WeakSelfType blockSelf = self;
	[self.mjRefreshHeaderView removeFromSuperview];
	[self.mjRefreshHeaderView free];
    
	self.mjRefreshHeaderView = [MJRefreshHeaderView header];
	self.mjRefreshHeaderView.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [blockSelf refreshWithSuccessed:blockSelf.successBlock failed:blockSelf.failedBlock];
    };
    self.mjRefreshHeaderView.scrollView = [self contentScrollView];
}

- (void)addRefreshFooterView {
	WeakSelfType blockSelf = self;
	self.mjRefreshFooterView = [MJRefreshFooterView footer];
	self.mjRefreshFooterView.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
		[blockSelf loadMoreWithSuccessed:blockSelf.successBlock failed:blockSelf.failedBlock];
	};
    self.mjRefreshFooterView.scrollView = [self contentScrollView];
}

/**
 *  下拉刷新
 *
 *  @param successed
 *  @param failed    
 */
- (void)refreshWithSuccessed:(PullToRefreshSuccessed)successed failed:(PullToRefreshFailed)failed {
    [SVProgressHUD show];
    WeakSelfType blockSelf = self;
    NSInteger curTimes = ++self.loadTimes;
    
    if (([self showLodingView] || !self.mjRefreshHeaderView.refreshing)&& self.dataArray.count==0) {
        [self.lodingView start];
        [self.mjRefreshHeaderView endRefreshing];
    }
    
    [AFNManager postObject:[self dictParamWithPage:0]
                  apiName:[self methodWithPath]
                modelName:[self modelNameOfData]
         requestSuccessed:^(id responseObject) {
             [SVProgressHUD dismiss];
             if (curTimes==blockSelf.loadTimes) {
                 
                 [blockSelf.lodingView stopWithDealy:0.9];

                 
                 [blockSelf.mjRefreshHeaderView endRefreshing];
                 [blockSelf hideHUDLoading];
                 blockSelf.currentPageIndex = 1;
                 
                 //1. 获取结果数组
                 NSArray *dataArray = nil;
                 if ([responseObject isKindOfClass:[NSArray class]]) {
                     dataArray = (NSArray *)responseObject;
                 }
                 //------------
                 
                 //2. 根据组装后的数组刷新列表
                 NSArray *newDataArray = [blockSelf preProcessData:dataArray];
                 
                 if ([newDataArray count] > 0) {
                     [blockSelf reloadByReplacing:newDataArray];
                 }
                 else {
                     //清空已有的数据
                     [blockSelf.dataArray removeAllObjects];
                 }
                 //------------
                 
                 if (successed) {
                     successed();
                 }
                 
//                 if (pageInfo) {
//                     blockSelf.pageInfo = pageInfo;
//                 }
                 [blockSelf reloadData];
             }
         }
           requestFailure: ^(NSInteger errorCode, NSString *errorMessage) {
               [SVProgressHUD dismiss];
               if (curTimes==blockSelf.loadTimes){
                 [blockSelf.lodingView stopWithDealy:0.9];

                   [blockSelf.mjRefreshHeaderView endRefreshing];
                   if (failed) {
                       failed();
                   }
                   [blockSelf reloadData];
               }
           }];
}

- (void)reloadByReplacing:(NSArray *)anArray {
	[self.dataArray removeAllObjects];
	[self.dataArray addObjectsFromArray:anArray];
    
	//保存数组至本地缓存（注意：只保存下拉刷新的数组！）
	if ([self shouldCacheArray]) {
		[self saveObjectToCache:anArray toKey:[self keyOfCachedArray]];
	}
}

/**
 *  上拉加载更多
 *
 *  @param successed
 *  @param failed
 */
- (void)loadMoreWithSuccessed:(PullToRefreshSuccessed)successed failed:(PullToRefreshFailed)failed {
    
    
	WeakSelfType blockSelf = self;
    NSInteger curTimes = ++self.loadTimes;
    [AFNManager postObject:[self dictParamWithPage:self.currentPageIndex]
                  apiName:[self methodWithPath]
                modelName:[self modelNameOfData]
         requestSuccessed:^(id responseObject) {
            
             if (curTimes==blockSelf.loadTimes) {
                 
                  [blockSelf.mjRefreshFooterView endRefreshing];
                 [blockSelf hideHUDLoading];
                 
                 
                 //1. 获取结果数组
                 NSArray *dataArray = nil;
                 if ([responseObject isKindOfClass:[NSArray class]]) {
                     dataArray = (NSArray *)responseObject;
                 }
                 //------------
                 
                 //2. 根据组装后的数组刷新列表
                 NSArray *newDataArray = nil;
                 if ([dataArray count] > 0) {
                     blockSelf.currentPageIndex++;//只要返回有数据就自增
                     newDataArray = [blockSelf preProcessData:dataArray];
                 }
                 if ([newDataArray count] > 0) {
                     //                     blockSelf.isTipsViewHidden = YES;
                     [blockSelf reloadByAdding:newDataArray];
                 }
                 else {
                     if ([blockSelf.dataArray count] == 0) {//判断总的数组是否为空
                         //                         blockSelf.isTipsViewHidden = NO;
                     }
                     [blockSelf showResultThenHide:@"没有更多了"];
                 }
                 //------------
                 
                 if (successed) {
                     successed();
                 }
//                 if (pageInfo) {
//                     blockSelf.pageInfo = pageInfo;
//                 }
             }
         } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
             if (curTimes==blockSelf.loadTimes) {
                 [blockSelf.mjRefreshFooterView endRefreshing];
//                 blockSelf.isTipsViewHidden = ([blockSelf.dataArray count] > 0);//判断总的数组是否为空
                 if (failed) {
                     failed();
                 }
             }
         }];
}

- (void)reloadByAdding:(NSArray *)anArray {
	
}

//- (void)setPageInfo:(AFPageInfoModel *)pageInfo{
//    
//    if (_pageInfo != pageInfo) {
//        _pageInfo = pageInfo;
//        
//        if (_pageInfo.hasMore && [self loadMoreEnable]) {
//            self.mjRefreshFooterView.hidden = NO;
////            self.mjRefreshFooterView.scrollView = [self contentScrollView];
//        }else{
//            self.mjRefreshFooterView.hidden = YES;
////            self.mjRefreshFooterView.scrollView = nil;
//        }
//    }
//}

#pragma mark - BaseViewController里关于缓存方法的重写

- (void)loadCache {
	[super loadCache];
    
	NSArray *cacheArray = [self loadCacheArray];
	if (cacheArray) {
		[self.dataArray addObjectsFromArray:cacheArray];
	}
}

#pragma mark - 可选的重写方法
- (NSString *)keyOfCachedArray{
    return KeyOfCachedArray;
}

- (BOOL)showLodingView{
    return YES;
}

//是否显示空数据占位图 默认为No
- (BOOL)showNoInfoView{
    return NO;
}

//空数据界面Action操作
- (void)noInfoActionButtonClicked:(id)sender{

}

//下拉刷新特有的缓存加载方法被基类的loadCache方法调用
- (NSArray *)loadCacheArray {
	if (![self shouldCacheArray]) {  //判断是否加载缓存
		return nil;
	}
    
	NSArray *cachedArray = [self cachedObjectByKey:[self keyOfCachedArray]];
	if ([cachedArray isKindOfClass:[NSArray class]] &&
	    [cachedArray count] > 0) {
		//有缓存内容
		return cachedArray;
	}
	else {
		//没有缓存内容
		return nil;
	}
}

- (NSArray *)preProcessData:(NSArray *)anArray {
	return anArray;
}

- (BOOL)shouldCacheArray {
	return NO;
}

- (BOOL)shouldShowRefreshAnimationWhenEntered{
    return NO;
}

- (BOOL)shouldRefreshWhenEntered {
	return YES;
}
- (BOOL)loadMoreEnable {
	return YES;
}

- (BOOL)refreshEnable {
	return YES;
}

- (BOOL)showRefreshHeadView{
    
    return YES;
}

- (NSInteger)cellCount {
	return [self.dataArray count];
}

- (NSString *)prefixOfUrl {
    return [StringUtils resBaseUrl];
}

- (NSString *)hintStringWhenNoData {
    return @"暂时没有内容";
}

#pragma mark - 必须重写的方法

- (NSString *)methodWithPath {
	return @"";
}

- (NSString *)nibNameOfCell {
	return @"";
}

- (NSArray *)arrayParamWithPage:(NSInteger)page {
	return @[];
}

- (NSDictionary *)dictParamWithPage:(NSInteger)page {
	return @{};
}

- (NSString *)modelNameOfData {
	return @"BasePageModel";
}

- (UIView *)layoutCellWithData:(id)object atIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (void)clickedCell:(id)object atIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - 必须在一级子类里重写的方法

/**
 *  目前只支持UItableView和UICollectionView
 */
- (UIScrollView *)contentScrollView {
    return nil;
}
- (void)reloadData {

}

@end
