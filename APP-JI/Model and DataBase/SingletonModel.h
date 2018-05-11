//
//  SingletonModel.h
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingletonModel : NSObject

@property (nonatomic,strong) NSString *question;
@property (nonatomic,strong) NSString *firstRowswitch;

//声明单例方法
+(SingletonModel *)shareSingletonModel;
@end
