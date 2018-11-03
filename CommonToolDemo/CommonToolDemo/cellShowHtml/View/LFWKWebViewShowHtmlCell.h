//
//  LFWKWebViewShowHtmlCell.h
//  CommonToolDemo
//
//  Created by 刘飞 on 2018/11/3.
//  Copyright © 2018年 ahxb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^ReloadBlock)(void);
@interface LFWKWebViewShowHtmlCell : UITableViewCell
@property(nonatomic,copy)NSString *htmlString;
@property(nonatomic,copy)ReloadBlock reloadBlock;
+(CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_END
