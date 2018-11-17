//
//  LFUMShareViewController.m
//  CommonToolDemo
//
//  Created by 刘飞 on 2018/11/17.
//  Copyright © 2018年 ahxb. All rights reserved.
//

#import "LFUMShareViewController.h"
#import <UMShare/UMShare.h>
#import "SGActionView.h"
#import <UMAnalytics/MobClick.h>

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define NAV_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height

@interface LFUMShareViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, copy)NSArray *titles;

@end

@implementation LFUMShareViewController

-(NSArray *)titles{
    if (!_titles) {
        _titles = @[@"分享"];
    }
    return _titles;
}
//友盟统计页面点击次数
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
}
- (void )initTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
    [self.view addSubview:_tableView];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        [self shareViewBtnWithTitle:@"分享的标题" ShareContent:@"对你有帮助的话，走一波关注，star一下" SharePic:@"https://upload.jianshu.io/users/upload_avatars/3363476/30dff947-8f0f-4a91-998e-e38d8a8fdf5e.jpg?imageMogr2/auto-orient/strip|imageView2/1/w/240/h/240" URL:@"https://www.jianshu.com/u/2af7a3f33fc8"];
    }
}
//分享按钮被点击
- (void )shareViewBtnWithTitle:(NSString *)Title ShareContent:(NSString *)ShareContent SharePic:(NSString *)SharePic URL:(NSString *)URL{
    __weak typeof(self )wself = self;
    [SGActionView showGridMenuWithTitle:@"分享至"
                             itemTitles:@[@"微信好友", @"QQ", @"QQ空间", @"朋友圈", @"微博"]
                                 images:@[ [UIImage imageNamed:@"share_weixn"],
                                            [UIImage imageNamed:@"share_qq"],
                                            [UIImage imageNamed:@"share_space"],
                                           [UIImage imageNamed:@"share_friends"],
                                           [UIImage imageNamed:@"share_sina"]]
                         selectedHandle:^(NSInteger index) {
                             switch (index) {
                                 case 1:
                                     if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
                                         [wself shareTextToPlatformType:UMSocialPlatformType_WechatSession Title:Title ShareContent:ShareContent SharePic:SharePic URL:URL];
                                     }
                                     break;
                                  case 2:
                                  if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]) {
                                      [wself shareTextToPlatformType:UMSocialPlatformType_QQ Title:Title ShareContent:ShareContent SharePic:SharePic URL:URL];
                                  }
                                  break;
                                  case 3:
                                  if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Qzone]) {
                                      [wself shareTextToPlatformType:UMSocialPlatformType_Qzone Title:Title ShareContent:ShareContent SharePic:SharePic URL:URL];
                                  }
                                  break;
                                 case 4:
                                     if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatTimeLine]) {
                                         [wself shareTextToPlatformType:UMSocialPlatformType_WechatTimeLine Title:Title ShareContent:ShareContent SharePic:SharePic URL:URL];
                                     }
                                     break;
                                   case 5:
                                      if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Sina]) {
                                          [wself shareTextToPlatformType:UMSocialPlatformType_Sina Title:Title ShareContent:ShareContent SharePic:SharePic URL:URL];
                                      }
                                  break;
                                 default:
                                     break;
                             }
                         }];
}
#pragma mark - share type
//分享文本
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType Title:(NSString *)Title ShareContent:(NSString *)ShareContent SharePic:(NSString *)SharePic URL:(NSString *)URL
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //链接分享
    //        messageObject.text = shareUrl;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:Title descr:ShareContent thumImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:SharePic]]]];
    //设置网页地址
    shareObject.webpageUrl = URL;//分享产品的链接
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"%@ ",@"分享失败");
            [self alertMessage:@"分享失败"];
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                NSLog(@"%@",@"分享成功");
                [self alertMessage:@"分享成功"];
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

- (void )alertMessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

@end
