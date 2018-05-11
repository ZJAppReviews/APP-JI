//
//  CellArrowItem.m
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import "CellArrowItem.h"

@implementation CellArrowItem
-(instancetype)initWithIcon:(NSString *)icon andTitle:(NSString *)title
{
    if (self = [super init]) {
        self.icon = icon;
        self.title = title;
    }
    return self;
}

+(instancetype)itemWithIcon:(NSString *)icon andTitle:(NSString *)title
{
    return [[self alloc]initWithIcon:icon andTitle:title];
}

+(instancetype)itemWithIcon:(NSString *)icon andTitle:(NSString *)title vcClass:(Class)vcClass
{
    CellArrowItem *item = [self itemWithIcon:icon andTitle:title];
    item.vcClass = vcClass;
    return item;
}

@end
