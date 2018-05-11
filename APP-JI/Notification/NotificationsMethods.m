//
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//


#import "NotificationsMethods.h"

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
