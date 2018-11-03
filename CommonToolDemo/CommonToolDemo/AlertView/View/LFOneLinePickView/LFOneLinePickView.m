//
//  LFBottomAlertView.m
//  CommonToolDemo
//
//  Created by 刘飞 on 2018/11/2.
//  Copyright © 2018年 ahxb. All rights reserved.
//

#import "LFOneLinePickView.h"

#define LFTuanNumViewHight 300.0
#define UI_View_Width  [UIScreen mainScreen].bounds.size.width
#define UI_View_Height [UIScreen mainScreen].bounds.size.height

@interface LFOneLinePickView()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIView *_contentView;
}
@property(nonatomic, strong)NSArray *sourceDataArray;
@property(nonatomic,copy)NSString *pickerDateStr;
@property(nonatomic, assign)NSInteger selectedIndex;
@property(nonatomic, strong)UIPickerView *picker;
@end

@implementation LFOneLinePickView
-(NSArray *)sourceDataArray{
    if (!_sourceDataArray) {
        _sourceDataArray = [NSArray new];
    }
    return _sourceDataArray;
}
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
 

        self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, UI_View_Width, LFTuanNumViewHight-40)];
        self.picker.delegate   = self;
        self.picker.dataSource = self;
        [_contentView addSubview:self.picker];
    
        self.selectedIndex = 0;
    }
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1; // 返回1表明该控件只包含1列
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法返回teams.count，表明teams包含多少个元素，该控件就包含多少行
    return self.sourceDataArray.count;
}


// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
// 中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法根据row参数返回teams中的元素，row参数代表列表项的编号，
    // 因此该方法表示第几个列表项，就使用teams中的第几个元素
    ((UILabel *)[pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];//显示分隔线
    ((UILabel *)[pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];//显示分隔线
    return [self.sourceDataArray objectAtIndex:row];
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedIndex = row;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 45;
}


-(void)cancelAction{
    
    [self disMissView];
    
}

-(void)sureAction{
    self.pickerDateStr = [NSString stringWithFormat:@"%@", [self.sourceDataArray objectAtIndex:self.selectedIndex]];
    if (self.pickerBlock) {
        self.pickerBlock(self.pickerDateStr);
    }
    
    [self disMissView];
}



/**
 *  @param view 展示在哪个视图上
 *  @param sourceData 需要展示的数据数组
 *  @param nowShowString 当前展示的数据
 */
- (void)showInView:(UIView *)view sourceDataArray:(NSArray *)sourceData  nowShowString:(NSString *)nowShowString{
    if (!view) {
        return;
    }
    [view addSubview:self];
    [view addSubview:_contentView];
    
    self.sourceDataArray = sourceData;
    [self.picker reloadAllComponents];
    for (int i=0; i<self.sourceDataArray.count; i++) {
        if ([nowShowString isEqualToString:self.sourceDataArray[i]]) {
            [self.picker selectRow:i inComponent:0 animated:YES];
            self.selectedIndex = i;
        }
    }
    
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


@end
