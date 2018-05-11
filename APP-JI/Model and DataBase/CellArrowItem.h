//
//  CellArrowItem.h
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellArrowItem : NSObject

@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *title;
@property(nonatomic,assign) Class vcClass;     //要跳转的控制器


-(instancetype)initWithIcon:(NSString *)icon andTitle:(NSString *)title;
+(instancetype)itemWithIcon:(NSString *)icon andTitle:(NSString *)title;
+(instancetype)itemWithIcon:(NSString *)icon andTitle:(NSString *)title vcClass:(Class) vcClass;

@end
