//
//  CellArrowItem.m
//  APP-JI
//
//  Created by 魏大同 on 16/4/4.
//  Copyright © 2016年 魏大同. All rights reserved.
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
