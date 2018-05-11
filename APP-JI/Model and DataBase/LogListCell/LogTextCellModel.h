//
//  LogTextCellModel.h
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogTextCellModel : NSObject

@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *answer;

+(instancetype)LogWithDict:(NSDictionary *)dict;    //模型赋值类方法
-(instancetype)initWithDict:(NSDictionary *)dict;     //对象方法

@end
