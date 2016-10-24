//
//  GAWebViewController.h
//  BTC News
//
//  Created by tt on 14-1-14.
//  Copyright (c) 2014年 AnnyFun. All rights reserved.
//

#import "BaseViewController.h"

@interface GAWebViewController : BaseViewController

- (void)loadUrl:(NSString *)url;
- (void)loadHtml:(NSString *)html baseUrlStr:(NSString *)baseURL;

@end

