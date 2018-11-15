//
//  LFUIWebViewController.m
//  CommonToolDemo
//
//  Created by 刘飞 on 2018/11/3.
//  Copyright © 2018年 ahxb. All rights reserved.
//

#import "LFUIWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface LFUIWebViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@end

@implementation LFUIWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configWebView];
    
    UIButton *rightBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn1 setTitle:@"传参给js展示" forState:UIControlStateNormal];
    [rightBtn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    rightBtn1.frame = CGRectMake(0, 0, 80, 30);
    [rightBtn1 addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"获取js内容" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 80, 30);
    [rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:rightBtn],[[UIBarButtonItem alloc] initWithCustomView:rightBtn1]];
}
- (void )clickRightBtn{
    // 还可以直接调用js定义的方法
    // 比如getShareUrl()为js端定义好的方法，返回值为分享的内容
    // 我们就可以通过调用这个方法在returnStr中拿到js返回的分享内容
    NSString *returnStr = [self.webView stringByEvaluatingJavaScriptFromString:@"getShareUrl()"];
    NSLog(@"%@",returnStr);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:returnStr delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
}
- (void )clickBtn{
    [self.webView stringByEvaluatingJavaScriptFromString:@"alertMessage('+OC传递的内容')"];
}

- (void )configWebView{
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.delegate = self;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL *baseURL = [[NSBundle mainBundle] bundleURL];
    [self.webView loadHTMLString:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] baseURL:baseURL];
    // 如果不想要webView 的回弹效果
    self.webView.scrollView.bounces = NO;
    // UIWebView 滚动的比较慢，这里设置为正常速度
    self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    [self.view addSubview:self.webView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //获取页面title：
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"webViewTitle --- %@",title);
    
    
    //获取js上下文
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //js中调用 testMethod 方法 通过block调用OC的方法
    context[@"testMethod"] = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"js调用OC方法" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
        });
    };
    
    
    context[@"getMessage"] = ^() {
        NSArray *arguments = [JSContext currentArguments];
        NSString *content = @"";
        for (JSValue *jsValue in arguments) {
            NSLog(@"=======%@",jsValue);
            content = [NSString stringWithFormat:@"%@%@",content,jsValue];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"js传递出来的内容" message:content delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
        });
    };
    
}



@end
