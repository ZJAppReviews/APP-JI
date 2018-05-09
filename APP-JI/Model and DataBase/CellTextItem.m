//
//  CellTextItem.m
//  APP-JI
//
//  Created by 魏大同 on 16/4/4.
//  Copyright © 2016年 魏大同. All rights reserved.
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
