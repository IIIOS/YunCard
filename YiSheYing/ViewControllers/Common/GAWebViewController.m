//
//  GAWebViewController.m
//  BTC News
//
//  Created by tt on 14-1-14.
//  Copyright (c) 2014年 AnnyFun. All rights reserved.
//

#import "GAWebViewController.h"

@interface GAWebViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation GAWebViewController

- (void)dealloc
{
    NSLog(@"GAWebViewController dealloc");
    [self.webView stopLoading];
    self.webView.delegate = nil;
    [self.webView removeFromSuperview];
    self.webView = nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)loadUrl:(NSString *)url{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

//- (void)loadHtml:(NSString *)html baseUrlStr:(NSString *)baseURL{
//    [self.webView loadHTMLString:html baseURL:[NSURL URLWithString:baseURL]];
//}

- (void)viewDidLoad{

    self.title = self.params[@"title"]?:self.title;
    NSString *url  = self.params[@"url"];
//    [self.webView setScalesPageToFit:YES];

    if (url)[self loadUrl:url];
    
    [super viewDidLoad];
}

- (UIWebView *)webView{
    
    if (nil==_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
//        _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    
//    return YES;
//}

- (void)webViewDidStartLoad:(UIWebView *)webView{

    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

    if (error.code==-1009) {
        
    }
    else{
        
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
      [webView stringByEvaluatingJavaScriptFromString:@"var element = document.createElement('meta');  element.name = \"viewport\";  element.content = \"width=device-width,initial-scale=1.0,minimum-scale=0.5,maximum-scale=3,user-scalable=1\"; var head = document.getElementsByTagName('head')[0]; head.appendChild(element);"];
    
}
@end
