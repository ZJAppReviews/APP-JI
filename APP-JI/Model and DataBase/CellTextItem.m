//
//  CellTextItem.m
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import "CellTextItem.h"

@implementation CellTextItem

-(instancetype)initWithText:(NSString *)text
{
    if (self = [super init]) {
        self.text = text;
    }
    return self;
}

+(instancetype)itemWithText:(NSString *)text
{
    return [[self alloc]initWithText:text];
}

@end
