//
//  LFDatePickView.h
//  CommonToolDemo
//
//  Created by 刘飞 on 2018/11/3.
//  Copyright © 2018年 ahxb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^PickerBlock)(NSString *resultStr);
@interface LFDatePickView : UIView
@property(nonatomic,copy)PickerBlock pickerBlock;
/**
 *  @param view 展示在哪个视图上
 */
- (void)showInView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
