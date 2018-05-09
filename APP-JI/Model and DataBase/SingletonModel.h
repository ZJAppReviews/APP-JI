//
//  SingletonModel.h
//  APP-JI
//
//  Created by 魏大同 on 16/4/16.
//  Copyright © 2016年 魏大同. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingletonModel : NSObject

@property (nonatomic,strong) NSString *question;
@property (nonatomic,strong) NSString *firstRowswitch;

//声明单例方法
+(SingletonModel *)shareSingletonModel;
@end
