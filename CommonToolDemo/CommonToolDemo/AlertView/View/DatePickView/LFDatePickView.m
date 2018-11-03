//
//  LFBottomAlertView.m
//  CommonToolDemo
//
//  Created by 刘飞 on 2018/11/2.
//  Copyright © 2018年 ahxb. All rights reserved.
//

#import "LFDatePickView.h"

#define LFTuanNumViewHight 300.0
#define UI_View_Width  [UIScreen mainScreen].bounds.size.width
#define UI_View_Height [UIScreen mainScreen].bounds.size.height

@interface LFDatePickView()
{
    UIView *_contentView;
}
@property(nonatomic,weak)UIDatePicker *datePicker;
@property(nonatomic,copy)NSString *pickerDateStr;
@end

@implementation LFDatePickView

- (id)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupContent];
    }
    return self;
}

- (void)setupContent {
    self.frame = CGRectMake(0, 0, UI_View_Width,UI_View_Height);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];//点击空白地方移除视图
    
    if (_contentView == nil) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, UI_View_Height, UI_View_Width, LFTuanNumViewHight)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer * maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = _contentView.bounds;
        maskLayer.path = maskPath.CGPath;
        _contentView.layer.mask = maskLayer;
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:cancelBtn];
        
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(UI_View_Width-70, 0, 70, 40)];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:sureBtn];
        
        
        //创建UIDatePicker
        UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, UI_View_Width, LFTuanNumViewHight-40)];
        //设置区域
        picker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        //设置时间显示模式
        picker.datePickerMode = UIDatePickerModeDate;
        NSString *str = @"1900-01";
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"yyyy/MM"];
        NSDate *newDate = [dateFormatter1 dateFromString:str];
        picker.minimumDate = newDate;
        picker.maximumDate = [NSDate date];
        [picker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        [_contentView addSubview:picker];
        self.datePicker = picker;
        [self dateChange:self.datePicker];
    }
}
-(void)dateChange:(UIDatePicker *)picker{
    
    // 创建时格式化
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    
    //设置时间格式
    formatter.dateFormat=@"yyyy-MM-dd";
    
    //把NSDate类型转换为字符串类型
    NSString *str=[formatter stringFromDate:picker.date];//picker.date属性就是当前UIDatePicker显示的时间
    
    self.pickerDateStr = str;
    
}
//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    [view addSubview:self];
    [view addSubview:_contentView];
    
    
    _contentView.alpha=0;
    
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
        self->_contentView.alpha = 1;
        [self->_contentView setFrame:CGRectMake(0, UI_View_Height - LFTuanNumViewHight, UI_View_Width, LFTuanNumViewHight)];
        
    } completion:nil];
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView {
    _contentView.alpha = 1;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.alpha = 0.0;
                         [self->_contentView setFrame:CGRectMake(0, UI_View_Height , UI_View_Width, 0)];
                         self->_contentView.alpha=0.0;
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         [self->_contentView removeFromSuperview];
                         
                     }];
    
}
-(void)cancelAction{
    
    [self disMissView];
    
}

-(void)sureAction{
    if (self.pickerBlock) {
        self.pickerBlock(self.pickerDateStr);
    }
    
    [self disMissView];
}


@end
