//
//  XBUMManager.h
//  Jinrirong
//
//  Created by 刘飞 on 2018/6/13.
//  Copyright © 2018年 ahxb. All rights reserved.
//

#import <Foundation/Foundation.h>

//需要的头文件在这里导入，appdelegate中就不需要重新导入了
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>

#import <UMPush/UMessage.h>

#import <UMAnalytics/MobClick.h>

#import <UMCommonLog/UMCommonLogHeaders.h>

#import <UserNotifications/UserNotifications.h>

@interface XBUMManager : NSObject
+(void)initUmManagerWithLaunchOptions:(NSDictionary *)launchOptions Delegate:(id)delegate;

@end
