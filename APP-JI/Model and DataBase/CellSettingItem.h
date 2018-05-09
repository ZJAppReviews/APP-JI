//
//  CellSettingItem.h
//  APP-JI
//
//  Created by 魏大同 on 16/3/29.
//  Copyright © 2016年 魏大同. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellSettingItem : NSObject

@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *title;
@property(nonatomic,assign) Class vcClass;     //要跳转的控制器


-(instancetype)initWithIcon:(NSString *)icon andTitle:(NSString *)title;
+(instancetype)itemWithIcon:(NSString *)icon andTitle:(NSString *)title;
+(instancetype)itemWithIcon:(NSString *)icon andTitle:(NSString *)title vcClass:(Class) vcClass;

@end
