//
//  LFCityModel.m
//  CommonToolDemo
//
//  Created by 刘飞 on 2018/11/3.
//  Copyright © 2018年 ahxb. All rights reserved.
//

#import "LFCityModel.h"
#import "LFCountyModel.h"

@implementation LFCityModel
-(instancetype)initWithDictionaty:(NSDictionary *)dic
{
    if (self=[super init]) {
        self.areaId     =   dic[@"areaId"];
        self.name       =   dic[@"name"];
        self.countList = [NSMutableArray new];
        for (NSDictionary *infoDic in dic[@"countList"]) {
            LFCountyModel *model = [LFCountyModel initWithDictionary:infoDic];
            [self.countList addObject:model];
        }
    }
    return self;
}

+(instancetype)initWithDictionary:(NSDictionary *)dic
{
    return [[LFCityModel alloc]initWithDictionaty:dic];
}
@end
