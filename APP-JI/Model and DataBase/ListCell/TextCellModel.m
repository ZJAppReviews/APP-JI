//
//  TextCellModel.m
//  APP-JI
//
//  Created by 魏大同 on 16/4/6.
//  Copyright © 2016年 魏大同. All rights reserved.
//

#import "TextCellModel.h"

@implementation TextCellModel

+(instancetype)JIWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.question = dict[@"question"];
        self.answer = dict[@"answerT"];
        self.type = dict[@"type"];
    }
    return self;
}
//取出字典中对应的每个key赋值给数据模型

@end
