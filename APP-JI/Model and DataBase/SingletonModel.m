//
//  SingletonModel.m
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
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
