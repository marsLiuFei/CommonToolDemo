//
//  LFCenterAlertView.m
//  CommonToolDemo
//
//  Created by 刘飞 on 2018/11/2.
//  Copyright © 2018年 ahxb. All rights reserved.
//

#import "LFCenterAlertView.h"

#define LFTuanNumViewHight 350.0
#define UI_View_Width  [UIScreen mainScreen].bounds.size.width
#define UI_View_Height [UIScreen mainScreen].bounds.size.height

@interface LFCenterAlertView()
{
    UIView *_contentView;
    
}
@end

@implementation LFCenterAlertView

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
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(30, UI_View_Height*0.5 - LFTuanNumViewHight*0.5, UI_View_Width-60, LFTuanNumViewHight)];
        _contentView.layer.cornerRadius = 5;
        _contentView.layer.masksToBounds=YES;
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
       
    }
}

//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    [view addSubview:self];
    [view addSubview:_contentView];
    
    [_contentView setFrame:CGRectMake(30, UI_View_Height*0.5 - LFTuanNumViewHight*0.5 , UI_View_Width-60, LFTuanNumViewHight)];
    _contentView.alpha=0;
    _contentView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
        self->_contentView.alpha = 1;
        self->_contentView.transform = CGAffineTransformMakeScale(1, 1);
        
    } completion:nil];
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView {
    [_contentView setFrame:CGRectMake(30, UI_View_Height*0.5 - LFTuanNumViewHight*0.5, UI_View_Width-60, LFTuanNumViewHight)];
    _contentView.transform = CGAffineTransformMakeScale(1, 1);
    _contentView.alpha = 1;
    //    self.alpha=1.0;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.alpha = 0.0;
                         [self->_contentView setFrame:CGRectMake(30, UI_View_Height*0.5 - LFTuanNumViewHight*0.5 , UI_View_Width-60, LFTuanNumViewHight)];
                         self->_contentView.transform = CGAffineTransformMakeScale(0.5, 0.5);
                         self->_contentView.alpha=0.0;
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         [self->_contentView removeFromSuperview];
                         
                     }];
    
}


@end
