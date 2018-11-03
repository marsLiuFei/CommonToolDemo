//
//  LFCountyModel.m
//  CommonToolDemo
//
//  Created by 刘飞 on 2018/11/3.
//  Copyright © 2018年 ahxb. All rights reserved.
//

#import "LFCountyModel.h"

@implementation LFCountyModel
-(instancetype)initWithDictionaty:(NSDictionary *)dic
{
    if (self=[super init]) {
        self.areaId     =   dic[@"areaId"];
        self.name       =   dic[@"name"];
    }
    return self;
}

+(instancetype)initWithDictionary:(NSDictionary *)dic
{
    return [[LFCountyModel alloc]initWithDictionaty:dic];
}
@end
