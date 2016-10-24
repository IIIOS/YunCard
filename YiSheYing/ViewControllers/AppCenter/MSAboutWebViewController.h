//
//  MSAboutWebViewController.h
//  MSUnified
//
//  Created by Lwj on 15/12/1.
//  Copyright © 2015年 max. All rights reserved.
//



@interface MSAboutWebViewController : UIViewController

@property(nonatomic, strong)NSURL *url;
- (id)initWithUrl:(NSURL *)url;
@property (nonatomic,strong)NSString *titleStr;
@end
