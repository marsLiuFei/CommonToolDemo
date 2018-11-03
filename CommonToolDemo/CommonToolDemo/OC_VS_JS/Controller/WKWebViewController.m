//
//  WKWebViewController.m
//  OC_VS_JS
//
//  Created by 刘飞 on 2018/10/9.
//  Copyright © 2018年 ahxb. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>


#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define NAV_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height
@interface WKWebViewController ()<WKNavigationDelegate,UIScrollViewDelegate,WKUIDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *wkwebView;
@property (nonatomic, strong) CALayer *progresslayer;

@end

@implementation WKWebViewController

- (CALayer *)progresslayer
{
    if (!_progresslayer) {
        UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 3)];
        progress.backgroundColor = [UIColor clearColor];
        [self.view addSubview:progress];
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, 0, 3);
        layer.backgroundColor = [UIColor orangeColor].CGColor;
        [progress.layer addSublayer:layer];
        self.progresslayer = layer;
    }
    return _progresslayer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"WKWebView";
    [self configWkWebView];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 35, 35);
    [rightBtn setTitle:@"分享" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}
- (void )configWkWebView{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.minimumFontSize = 10;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.userContentController = [[WKUserContentController alloc] init];
    config.processPool = [[WKProcessPool alloc] init];
    self.wkwebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    [self.wkwebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.wkwebView.UIDelegate = self;
    self.wkwebView.navigationDelegate =self;
    [self.view addSubview:self.wkwebView];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"html"];
    NSURL *baseURL = [[NSBundle mainBundle] bundleURL];
    [self.wkwebView loadHTMLString:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] baseURL:baseURL];
    
    //js调OC 
    [config.userContentController addScriptMessageHandler:self name:@"showSendMsg"];
    [config.userContentController addScriptMessageHandler:self name:@"showParameterMsg"];
}
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    //js调OC
    if ([message.name isEqualToString:@"showSendMsg"]) {
        //不带参按钮点击时间处理
        [self showMsg:@"不带参"];
    }
    if ([message.name isEqualToString:@"showParameterMsg"]) {
        //带参按钮点击时间处理
        NSString *showMsg = @"";
        NSArray *args = message.body;
        for (NSString *str in args) {
            NSLog(@"参数 ---- %@",str);
            if ([showMsg isEqualToString:@""]) {
                showMsg = [NSString stringWithFormat:@"%@",str];
            }else{
                showMsg = [NSString stringWithFormat:@"%@-%@",showMsg,str];
            }
        }
        [self showMsg:showMsg];
    }
}
- (void)showMsg:(NSString *)msg {
    [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
}


//进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progresslayer.opacity = 1;
        if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
            return;
        }
        self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[@"new"] floatValue], 3);
        if ([change[@"new"] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.frame = CGRectMake(0, 0, 0, 3);
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
    [(WKWebView *)self.wkwebView removeObserver:self forKeyPath:@"estimatedProgress"];
}




#pragma mark -- OC调用js
- (void)shareBtnClick{
    //如果方法里需要传参数，需要用 '' 套着
    [self.wkwebView evaluateJavaScript:@"getJsValue()" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        //JS 返回结果
        NSLog(@"返回结果-%@ \n错误-%@",response,error);
        [self showMsg:[NSString stringWithFormat:@"JS中返回结果-%@",response]];
    }];
}




@end
