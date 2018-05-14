//
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//


#import "NotificationsMethods.h"
#import <UserNotifications/UserNotifications.h>


@implementation NotificationsMethods

- (void)setupNotifications :(NSString *)question{
    
    UIMutableUserNotificationAction *textAction = [[UIMutableUserNotificationAction alloc] init];
    textAction.identifier = @"quickreply_action";
    textAction.title = @"回复";
    textAction.activationMode = UIUserNotificationActivationModeBackground;
   
    textAction.authenticationRequired = YES;
    textAction.behavior = UIUserNotificationActionBehaviorTextInput;
    
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc]init];
    //category.identifier = @"category_qr";
    category.identifier = question;
    [category setActions:@[textAction] forContext:UIUserNotificationActionContextMinimal];
    NSSet *categories = [NSSet setWithObjects:category, nil];
    
    UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeSound |UIUserNotificationTypeBadge;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                             categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
}

- (BOOL)setUserNotification:(NSString *)question withDate:(NSDateComponents *)UNTime andType:(int)JiType {

    //判断用户是否打开推送通知
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert;
    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if(error){
            NSLog(@"推送权限获取失败！");
        }
    }];
    
    //注册本地推送通知
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.body = question;
    content.badge = @1;
    
    //添加快捷响应方法
    if (JiType == 1){
        UNNotificationAction *answerYes = [UNNotificationAction actionWithIdentifier:@"answerYes" title:@"是!" options:UNNotificationActionOptionNone];
        UNNotificationAction *answerNo = [UNNotificationAction actionWithIdentifier:@"answerNo" title:@"不是！" options:UNNotificationActionOptionNone];
        UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"JiNotifi" actions:@[answerYes,answerNo] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithArray:@[category]]];
    }else if (JiType == 0){
        UNTextInputNotificationAction *answerText =[UNTextInputNotificationAction actionWithIdentifier:@"answerText" title:@"记录" options:UNNotificationActionOptionNone textInputButtonTitle:@"记录" textInputPlaceholder:question];
        UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"JiNotifi" actions:@[answerText] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithArray:@[category]]];
    }
    content.categoryIdentifier = @"JiNotifi";
    
    //添加提醒触发时间
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:UNTime repeats:YES];

    //触发提醒
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"NotifiRequest" content:content trigger:trigger];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
    
    return YES;
}



- (void)presentNotificationNow:(NSString *)question andHour:(NSString *)hour minute:(NSString *)minute{
    
    UILocalNotification *reminder = [[UILocalNotification alloc] init];
    reminder.alertBody = question;
    reminder.alertTitle = @"来自纪的消息";
    //reminder.category = @"category_qr";
    reminder.category = question;
    int Hour = [hour intValue];
    int Minute = [minute intValue];
    reminder.fireDate = [NSDate dateWithTimeIntervalSince1970:(60*(Hour-8)+Minute)*60];//本次开启立即执行的周期
    reminder.repeatInterval=kCFCalendarUnitDay;//循环通知的周期
    reminder.applicationIconBadgeNumber=0; //应用程序的右上角小数字
    [[UIApplication sharedApplication] scheduleLocalNotification:reminder];
    
}


@end
