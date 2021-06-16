//
//  WebViewController.m
//  NewsProject
//
//  Created by Daniil Oleynik on 16.06.2021.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()

@property (nonnull, nonatomic) WKWebView *webView;
@property (nonnull, nonatomic) NSURL *url;

@end

@implementation WebViewController
@synthesize webView, url;


- (instancetype)initWithUrl:(NSURL *)url
{
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.view = webView;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
}

@end
