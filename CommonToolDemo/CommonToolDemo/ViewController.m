//
//  ViewController.m
//  CommonToolDemo
//
//  Created by 刘飞 on 2018/11/2.
//  Copyright © 2018年 ahxb. All rights reserved.
//

#import "ViewController.h"
#import "LFAlertViewController.h"
#import "LFCellShowHtmlViewController.h"
#import "LFOC_VS_JSViewController.h"
#import "LFLoadWebProgressViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, copy)NSArray *titles;
@end

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define NAV_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height


@implementation ViewController
-(NSArray *)titles{
    if (!_titles) {
        _titles = @[@"弹出框控件",@"cell加载html文本",@"OC与JS交互",@"显示网页加载进度"];
    }
    return _titles;
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
        LFAlertViewController *vc = [LFAlertViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row==1){
        LFCellShowHtmlViewController *vc = [LFCellShowHtmlViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row==2){
        LFOC_VS_JSViewController *vc = [LFOC_VS_JSViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row==3){
        LFLoadWebProgressViewController *vc = [LFLoadWebProgressViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
