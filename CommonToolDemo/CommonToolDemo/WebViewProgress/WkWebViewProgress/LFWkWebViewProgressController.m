//
//  LFWkWebViewProgressController.m
//  CommonToolDemo
//
//  Created by 刘飞 on 2018/11/9.
//  Copyright © 2018年 ahxb. All rights reserved.
//

#import "LFWkWebViewProgressController.h"
#import <WebKit/WebKit.h>

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define NaviHeight self.navigationController.navigationBar.frame.size.height
#define StatusBarHeight  [[UIApplication sharedApplication] statusBarFrame].size.height

@interface LFWkWebViewProgressController ()<WKUIDelegate,WKNavigationDelegate>
@property(nonatomic,strong)WKWebView * singWebView;
@property(nonatomic,strong)CALayer * progresslayer;

@end

@implementation LFWkWebViewProgressController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.singWebView];
}
-(void)setUrlStr:(NSString *)urlStr{
    _urlStr = urlStr;
    [self.singWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
}
-(void)setHtmlString:(NSString *)htmlString{
    _htmlString = htmlString;
    [self.singWebView loadHTMLString:_htmlString baseURL:nil];
}
- (CALayer *)progresslayer
{
    if (!_progresslayer) {
        UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(0, NaviHeight+StatusBarHeight, SCREEN_WIDTH, 4)];
        progress.backgroundColor = [UIColor clearColor];
        [self.view addSubview:progress];
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, 0, 4);
        layer.backgroundColor = [UIColor greenColor].CGColor;
        [progress.layer addSublayer:layer];
        self.progresslayer = layer;
    }
    return _progresslayer;
}

- (WKWebView *)singWebView
{
    if (!_singWebView) {
        //初始化一个WKWebViewConfiguration对象
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        //        //初始化偏好设置属性：preferences
        config.preferences = [WKPreferences new];
        //是否支持JavaScript
        config.preferences.javaScriptEnabled = YES;
        //不通过用户交互，是否可以打开窗口
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width,inital-scale=1.0,maximum-scale=1.0,user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);";
        
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        
        config.userContentController = wkUController;
        _singWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:config];
        _singWebView.UIDelegate = self;
        _singWebView.navigationDelegate = self;
        //WKWebView有一个属性estimatedProgress，就是当前网页加载的进度，所以首先监听这个属性
        [_singWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return _singWebView;
}
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
}
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progresslayer.opacity = 1;
        //不要让进度条倒着走...有时候goback会出现这种情况
        if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
            return;
        }
        self.progresslayer.frame = CGRectMake(0, NaviHeight, self.view.bounds.size.width * [change[@"new"] floatValue], 4);
        if ([change[@"new"] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.frame = CGRectMake(0, NaviHeight, 0, 4);
            });
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

/**
 清理网页缓存
 */
- (void)deleteWebCache {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        NSSet *websiteDataTypes = [NSSet setWithArray:@[WKWebsiteDataTypeDiskCache,
                                                        //WKWebsiteDataTypeOfflineWebApplicationCache,
                                                        WKWebsiteDataTypeMemoryCache,
                                                        //WKWebsiteDataTypeLocalStorage,
                                                        //WKWebsiteDataTypeCookies,
                                                        //WKWebsiteDataTypeSessionStorage,
                                                        //WKWebsiteDataTypeIndexedDBDatabases,
                                                        //WKWebsiteDataTypeWebSQLDatabases
                                                        ]];
        //// Date from
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        //// Execute
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            // Done
        }];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}

- (void)dealloc{
    [self deleteWebCache];
    [(WKWebView *)self.singWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}





@end
