//
//  LFUIWebViewShowHtmlCell.m
//  CommonToolDemo
//
//  Created by 刘飞 on 2018/11/3.
//  Copyright © 2018年 ahxb. All rights reserved.
//

#import "LFUIWebViewShowHtmlCell.h"

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define UI_View_Height [UIScreen mainScreen].bounds.size.height

@interface LFUIWebViewShowHtmlCell ()<UIWebViewDelegate,UIWebViewDelegate>

@property (nonatomic,strong)UIWebView *webview;

@end
static CGFloat staticheight = 0;
@implementation LFUIWebViewShowHtmlCell
+(CGFloat)cellHeight
{
    return staticheight;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.webview];
    }
    return self;
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    self.webview.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    self.webview.hidden = NO;
    if (staticheight != height+1) {
        staticheight = height+1;
        if (staticheight > 0) {
            if (_reloadBlock) {
                _reloadBlock();
            }
        }
    }
}
-(UIWebView *)webview
{
    if (!_webview) {
        _webview =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];//这里一定要写1，不然高度不准确
        _webview.userInteractionEnabled = NO;
        _webview.hidden = YES;
    }
    return _webview;
}




-(void)setHtmlString:(NSString *)htmlString
{
    _htmlString = htmlString;
    self.webview.delegate = self;
    if (_htmlString.length==0||[_htmlString isKindOfClass:[NSNull class]]) {
        staticheight = 0;
        if (_reloadBlock) {
            _reloadBlock();
        }
    }else{
        [self.webview loadHTMLString:[self reSizeImageWithHTML:_htmlString] baseURL:nil];
    }
    
}

//  让html文本适应屏幕
-(nullable NSString *)reSizeImageWithHTML:(NSString *)html {
    return [NSString stringWithFormat:@"<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'><meta name='apple-mobile-web-app-capable' content='yes'><meta name='apple-mobile-web-app-status-bar-style' content='black'><meta name='format-detection' content='telephone=no'><style type='text/css'>img{width:%fpx}</style>%@", SCREEN_WIDTH-15, html];//-SIZE(15)是为了html文本距离右边一定的间距，不然太紧贴边缘了
}





- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
