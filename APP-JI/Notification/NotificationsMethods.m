//
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//


#import "NotificationsMethods.h"
#import <UserNotifications/UserNotifications.h>


@implementation NotificationsMethods

- (BOOL)setUserNotification:(NSString *)question withDate:(NSDateComponents *)UNTime andType:(NSString *)questionType {

    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];

    //判断用户是否打开推送通知
    UNAuthorizationOptions options = UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert;
    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if(error){
            NSLog(@"推送权限获取失败！");
        }
    }];
    
    //注册本地推送通知
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = question;
    content.badge = @1;
    
    //添加快捷响应方法
    if ([questionType isEqualToString:@"switch"]){
        UNNotificationAction *answerYes = [UNNotificationAction actionWithIdentifier:@"yes" title:@"是" options:UNNotificationActionOptionNone];
        UNNotificationAction *answerNo = [UNNotificationAction actionWithIdentifier:@"no" title:@"不是" options:UNNotificationActionOptionNone];
        UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:question actions:@[answerYes,answerNo] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithArray:@[category]]];
    }else if ([questionType isEqualToString:@"text"]){
        UNTextInputNotificationAction *answerText =[UNTextInputNotificationAction actionWithIdentifier:@"answerText" title:@"记录" options:UNNotificationActionOptionNone textInputButtonTitle:@"记录" textInputPlaceholder:@"" ];
        UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:question actions:@[answerText] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithArray:@[category]]];
    }
    content.categoryIdentifier = question;
    
    //添加提醒触发时间
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:UNTime repeats:YES];

    //触发提醒
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:question content:content trigger:trigger];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
    
    return YES;
}

- (BOOL)cancelNotification:(NSString *)question{
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removePendingNotificationRequestsWithIdentifiers:@[question]];

    return YES;
}



@end
