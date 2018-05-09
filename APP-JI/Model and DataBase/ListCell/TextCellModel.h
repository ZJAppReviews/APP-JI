//
//  TextCellModel.h
//  APP-JI
//
//  Created by 魏大同 on 16/4/6.
//  Copyright © 2016年 魏大同. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextCellModel : NSObject

@property (nonatomic,copy) NSString *question;
@property (nonatomic,copy) NSString *answer;
@property (nonatomic,copy) NSString *type;

+(instancetype)JIWithDict:(NSDictionary *)dict;    //模型赋值类方法
-(instancetype)initWithDict:(NSDictionary *)dict;     //对象方法

@end
