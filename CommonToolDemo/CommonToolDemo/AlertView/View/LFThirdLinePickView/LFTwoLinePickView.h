//
//  LFTwoLinePickView.h
//  CommonToolDemo
//
//  Created by 刘飞 on 2018/11/3.
//  Copyright © 2018年 ahxb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^PickerValueBlock)(NSString *provence,NSString *city,NSString *count,NSString *provenceCode,NSString *cityCode,NSString *countCode);
@interface LFTwoLinePickView : UIView
@property(nonatomic,copy)PickerValueBlock pickerBlock;
/**
 *  @param view 展示在哪个视图上
 *  @param sourceData 需要展示的数据数组
 */
- (void)showInView:(UIView *)view sourceDataArray:(NSArray *)sourceData;
@end

NS_ASSUME_NONNULL_END
