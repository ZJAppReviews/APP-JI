//
//  ListLogSM.m
//  APP-JI
//
//  Created by 魏大同 on 16/5/6.
//  Copyright © 2016年 魏大同. All rights reserved.
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
