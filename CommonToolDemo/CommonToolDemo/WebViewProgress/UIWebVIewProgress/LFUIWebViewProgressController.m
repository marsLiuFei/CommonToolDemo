//
//  LFUIWebViewProgressController.m
//  CommonToolDemo
//
//  Created by 刘飞 on 2018/11/9.
//  Copyright © 2018年 ahxb. All rights reserved.
//

#import "LFUIWebViewProgressController.h"
#import "DKProgressLayer.h"
#import "UIWebView+DKProgress.h"

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface LFUIWebViewProgressController ()<UIWebViewDelegate>
@property(nonatomic, strong)UIWebView *webView;
@property(nonatomic, assign) DKProgressStyle style;
@end

@implementation LFUIWebViewProgressController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];

    
    self.webView.dk_progressLayer = [[DKProgressLayer alloc] initWithFrame:CGRectMake(0, 40, DK_DEVICE_WIDTH, 4)];
    self.webView.dk_progressLayer.progressColor = [UIColor greenColor];
    self.webView.dk_progressLayer.progressStyle = _style;
    
    [self.navigationController.navigationBar.layer addSublayer:self.webView.dk_progressLayer];
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
