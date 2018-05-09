//
//  CellTextItem.h
//  APP-JI
//
//  Created by 魏大同 on 16/4/4.
//  Copyright © 2016年 魏大同. All rights reserved.
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
