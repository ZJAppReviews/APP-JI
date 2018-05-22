//
//  AuthenticMethods.m
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/14.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import "AuthenticMethods.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface AuthenticMethods ()

@end

@implementation AuthenticMethods

static bool haveAuthented;



+ (BOOL) isAuthented{
    if(haveAuthented){
        return TRUE;
    }else{
        
        LAContext *LAContent = [[LAContext alloc]init];
        [LAContent evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请完成验证以查看内容" reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                
                haveAuthented = 1;

                }else {
                NSLog(@"身份验证失败！ \nerrorCode : %ld, errorMsg : %@",(long)error.code, error.localizedDescription);
                }
        }];
    }

    if(haveAuthented == 1){
        NSLog(@"yes!!!!!");
        return true;
    }else{
        NSLog(@"NOOOO!!!!!");

        return false;
    }

    }
@end



