//
//  LFProvenceModel.h
//  CommonToolDemo
//
//  Created by 刘飞 on 2018/11/3.
//  Copyright © 2018年 ahxb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFProvenceModel : NSObject
/**
 *  ID
 */
@property(nonatomic, copy)NSString *areaId;
/**
 *  省名
 */
@property(nonatomic, copy)NSString *name;
/**
 *  城市数组
 */
@property(nonatomic, strong)NSMutableArray *cityList;


/** 字典转模型 */
+(instancetype)initWithDictionary:(NSDictionary*)dic;

-(instancetype)initWithDictionaty:(NSDictionary*)dic;
@end

NS_ASSUME_NONNULL_END
