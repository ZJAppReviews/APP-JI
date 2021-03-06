//
//  DatabaseMethods.h
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/14.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseMethods : NSObject

- (void) initDatabaseAction;
- (void) addQuestion:(NSString *)question andType:(NSString *)type;
- (void) deleteQuestion:(NSString *)question;
- (void) addAnswer:(NSString *)answer WithQuestion:(NSString *)question;
- (BOOL) isQuestionRepeated:(NSString *)question;
- (NSString *) getTypeOfQuestion:(NSString *)question;

@end
