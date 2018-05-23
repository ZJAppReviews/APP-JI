//
//  AuthenticMethods.h
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/14.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AuthenticDelegate <NSObject>

-(void)pushDetailViewWithQuestion:(NSString *)question andType:(NSString *)type;

@end

@interface AuthenticMethods : NSObject

@property (nonatomic,assign) id<AuthenticDelegate>aDelegate;

- (void) authenticWithQuestion:(NSString *)question andType:(NSString *)type;

@end
