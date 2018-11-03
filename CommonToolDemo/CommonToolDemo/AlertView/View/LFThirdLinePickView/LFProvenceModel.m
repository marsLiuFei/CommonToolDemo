//
//  LFProvenceModel.m
//  CommonToolDemo
//
//  Created by 刘飞 on 2018/11/3.
//  Copyright © 2018年 ahxb. All rights reserved.
//

#import "LFProvenceModel.h"
#import "LFCityModel.h"

@implementation LFProvenceModel
-(instancetype)initWithDictionaty:(NSDictionary *)dic
{
    if (self=[super init]) {
        self.areaId   =   dic[@"areaId"];
        self.name       =   dic[@"name"];
        self.cityList = [NSMutableArray new];
        for (NSDictionary *infoDic in dic[@"cityList"]) {
            LFCityModel *model = [LFCityModel initWithDictionary:infoDic];
            [self.cityList addObject:model];
        }
    }
    return self;
}

+(instancetype)initWithDictionary:(NSDictionary *)dic
{
    return [[LFProvenceModel alloc]initWithDictionaty:dic];
}
@end
