//
//  LogSwitchCellModel.h
//  APP-JI
//
//  Created by 魏大同 on 16/4/28.
//  Copyright © 2016年 魏大同. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogSwitchCellModel : NSObject

@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *answer;

+(instancetype)LogWithDict:(NSDictionary *)dict;    //模型赋值类方法
-(instancetype)initWithDict:(NSDictionary *)dict;     //对象方法

@end
