//
//  LFOneLinePickView.h
//  CommonToolDemo
//
//  Created by 刘飞 on 2018/11/2.
//  Copyright © 2018年 ahxb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PickerBlock)(NSString *resultStr);

@interface LFOneLinePickView : UIView
@property(nonatomic,copy)PickerBlock pickerBlock;
/**
 *  @param view 展示在哪个视图上
 *  @param sourceData 需要展示的数据数组
 *  @param nowShowString 当前展示的数据
 */
- (void)showInView:(UIView *)view sourceDataArray:(NSArray *)sourceData  nowShowString:(NSString *)nowShowString;
@end

NS_ASSUME_NONNULL_END
