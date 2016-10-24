//
//  MSAboutWebViewController.m
//  MSUnified
//
//  Created by Lwj on 15/12/1.
//  Copyright © 2015年 max. All rights reserved.
//

#import "MSAboutWebViewController.h"
@interface MSAboutWebViewController ()<UIWebViewDelegate>
@property(nonatomic, strong)UIWebView *webView;
@end

@implementation MSAboutWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initControl];
    self.title = self.titleStr;
}

- (id)initWithUrl:(NSURL *)url {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.url = url;
    }
    return self;
}

-(void)viewDidLayoutSubviews {
    self.webView.frame = self.view.bounds;
}

- (void)initControl {
    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    self.webView.userInteractionEnabled = YES;
    [self.view addSubview:self.webView];
    if (self.url) {
        [self.webView loadRequest:[NSMutableURLRequest requestWithURL:self.url]];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:@"var element = document.createElement('meta');  element.name = \"viewport\";  element.content = \"width=device-width,initial-scale=1.0,minimum-scale=0.5,maximum-scale=3,user-scalable=1\"; var head = document.getElementsByTagName('head')[0]; head.appendChild(element);"];
    
}@end
