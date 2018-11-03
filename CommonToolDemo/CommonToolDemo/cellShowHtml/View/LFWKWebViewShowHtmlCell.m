//
//  LFWKWebViewShowHtmlCell.m
//  CommonToolDemo
//
//  Created by 刘飞 on 2018/11/3.
//  Copyright © 2018年 ahxb. All rights reserved.
//

#import "LFWKWebViewShowHtmlCell.h"
#import <WebKit/WebKit.h>

@interface LFWKWebViewShowHtmlCell ()<WKUIDelegate,WKNavigationDelegate>
@property(nonatomic,strong)WKWebView * wkWebView;
@end

static CGFloat staticheight = 0;
@implementation LFWKWebViewShowHtmlCell
+(CGFloat)cellHeight
{
    return staticheight;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.wkWebView];
    }
    return self;
}

-(WKWebView *)wkWebView{
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] init];
        
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        wkWebConfig.userContentController = wkUController;
        wkWebConfig.userContentController = wkUController;
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1) configuration:wkWebConfig];
        _wkWebView.navigationDelegate = self;
        _wkWebView.userInteractionEnabled = NO;
        _wkWebView.UIDelegate = self;
        _wkWebView.scrollView.scrollEnabled = NO;
    }
    return _wkWebView;
}
-(void)setHtmlString:(NSString *)htmlString{
    _htmlString = htmlString;
    NSString *jSString =  [NSString stringWithFormat:@"<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'><meta name='apple-mobile-web-app-capable' content='yes'><meta name='apple-mobile-web-app-status-bar-style' content='black'><meta name='format-detection' content='telephone=no'><style type='text/css'>img{width:%fpx}</style>%@", [UIScreen mainScreen].bounds.size.width-15, _htmlString];
    [self.wkWebView loadHTMLString:jSString baseURL:nil];
}
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    __weak typeof(self)bself = self;
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id data, NSError * _Nullable error) {
        CGFloat height = [data floatValue];
        //ps:js可以是上面所写，也可以是document.body.scrollHeight;在WKWebView中前者offsetHeight获取自己加载的html片段，高度获取是相对准确的，但是若是加载的是原网站内容，用这个获取，会不准确，改用后者之后就可以正常显示，这个情况是我尝试了很多次方法才正常显示的
        CGRect webFrame = webView.frame;
        webFrame.size.height = height;
        webView.frame = webFrame;
        if (staticheight != height+1) {
            staticheight = height+1;
            if (staticheight > 0) {
                if (bself.reloadBlock) {
                   bself.reloadBlock();
                }
            }
        }
    }];


}
@end
