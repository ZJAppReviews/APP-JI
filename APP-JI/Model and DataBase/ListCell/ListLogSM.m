//
//  ListLogSM.m
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import "ListLogSM.h"

@implementation ListLogSM

static ListLogSM *shareObj = nil;

+(ListLogSM *)shareSingletonModel
{
    @synchronized(self){
        if(shareObj==nil)
        {
            shareObj = [[ListLogSM alloc]init];
        }
    }
    return shareObj;
}

-(id) init
{
    if (self = [super init]) {
        self.question = [[NSString alloc]init];
    }
    return self;
}


@end
