//
//  LogSwitchCellModel.m
//  APP-JI
//
//  Created by 魏大同 on 16/4/28.
//  Copyright © 2016年 魏大同. All rights reserved.
//

#import "LogSwitchCellModel.h"

@implementation LogSwitchCellModel

+(instancetype)LogWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        self.answer = dict[@"answer"];
        self.time = dict[@"time"];
    }
    return self;
}
//取出字典中对应的每个key赋值给数据模型

@end
