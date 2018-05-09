//
//  SingletonModel.m
//  APP-JI
//
//  Created by 魏大同 on 16/4/16.
//  Copyright © 2016年 魏大同. All rights reserved.
//

#import "SingletonModel.h"

@implementation SingletonModel

static SingletonModel *shareObj = nil;

+(SingletonModel *)shareSingletonModel
{
    @synchronized(self){
        if(shareObj==nil)
        {
            shareObj = [[SingletonModel alloc]init];
        }
    }
    return shareObj;
}

-(id) init
{
    if (self = [super init]) {
        self.question = [[NSString alloc]init];
        self.firstRowswitch = [[NSString alloc]init];
    }
    return self;
}


@end
