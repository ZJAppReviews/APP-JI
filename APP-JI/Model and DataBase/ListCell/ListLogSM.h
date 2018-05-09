//
//  ListLogSM.h
//  APP-JI
//
//  Created by 魏大同 on 16/5/6.
//  Copyright © 2016年 魏大同. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListLogSM : NSObject

@property (nonatomic,strong) NSString *question;

//声明单例方法
+(ListLogSM *)shareSingletonModel;


@end
