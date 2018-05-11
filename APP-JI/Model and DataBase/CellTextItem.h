//
//  CellTextItem.h
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellTextItem : NSObject

@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSString *question;
@property (nonatomic) int type;
@property (nonatomic) int notifi;

-(instancetype)initWithText:(NSString *)text;
+(instancetype)itemWithText:(NSString *)text;

@end
