//
//  LFAlertViewController.m
//  CommonToolDemo
//
//  Created by 刘飞 on 2018/11/2.
//  Copyright © 2018年 ahxb. All rights reserved.
//

#import "LFAlertViewController.h"

#import "LFCenterAlertView.h"
#import "LFBottomAlertView.h"
#import "LFOneLinePickView.h"
#import "LFTwoLinePickView.h"
#import "LFDatePickView.h"

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define NAV_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height

@interface LFAlertViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, copy)NSArray *titles;
@end

@implementation LFAlertViewController
-(NSArray *)titles{
    if (!_titles) {
        _titles = @[@"基础中间弹框-可在此基础上定制自己的样式",@"基础底部弹出框-可在此基础上定制自己的样式",@"底部弹出一列pickView",@"省市区三级联动",@"日期选择器"];
    }
    return _titles;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        LFCenterAlertView *alertView = [LFCenterAlertView new];
        //选择展示在不同的视图会有不同的效果
//        [alertView showInView:self.view];
        [alertView showInView:[UIApplication sharedApplication].keyWindow];
    }
    else if (indexPath.row==1){
        LFBottomAlertView *alertView = [LFBottomAlertView new];
        [alertView showInView:[UIApplication sharedApplication].keyWindow]; 
    }
    else if (indexPath.row==2){
        NSArray *showArr = @[@"非狐外传",@"雪山飞狐",@"连城诀",@"天龙八部",@"射雕英雄传",@"白马啸西风",@"鹿鼎记"];
        LFOneLinePickView *pickView = [LFOneLinePickView new];
        [pickView showInView:[UIApplication sharedApplication].keyWindow sourceDataArray:showArr nowShowString:@"天龙八部"];
        pickView.pickerBlock = ^(NSString * _Nonnull resultStr) {
            NSLog(@"选择了 --%@",resultStr);
        };
    }
    else if (indexPath.row==3){
        LFTwoLinePickView *pickView = [LFTwoLinePickView new];
        [pickView showInView:[UIApplication sharedApplication].keyWindow sourceDataArray:@[]];
    }
    else if (indexPath.row==4){
        LFDatePickView *datePcikView = [LFDatePickView new];
        [datePcikView showInView:[UIApplication sharedApplication].keyWindow];
    }
}


@end
