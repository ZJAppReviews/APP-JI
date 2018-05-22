//
//  AppDelegate.m
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import "AppDelegate.h"
#import "ListTableViewController.h"
#import "NotificationsMethods.h"
#import "NoDataViewController.h"
#import "AddJITableViewController.h"
#import "DatabaseMethods.h"
#import <UserNotifications/UserNotifications.h>
#import <FMDB.h>

@interface AppDelegate () <UNUserNotificationCenterDelegate>
@property (nonatomic,strong) ListTableViewController *listTVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    DatabaseMethods *dbmethod = [[DatabaseMethods alloc]init];
    [dbmethod initDatabaseAction];
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ViewBGC.png"]];
    _listTVC = [[ListTableViewController alloc]init];
    _nav = [[UINavigationController alloc]init];
    self.window.rootViewController = _nav;
    [self setNav];
    
    [_nav pushViewController:_listTVC animated:YES];

    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    return YES;
}



- (void)setNav

{
    UINavigationBar *bar = [UINavigationBar appearance];

    bar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CellBGC2.png"]];
    bar.tintColor = [UIColor blackColor];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    if (@available(iOS 11.0, *)) {
        [bar setPrefersLargeTitles:true];
    }
}

//3D Touch 快捷方式
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    [_listTVC rightBtnClicked];
}

//响应通知
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    
    NSString *categoryIdentifier = response.notification.request.content.categoryIdentifier;
    DatabaseMethods *dbmethod = [[DatabaseMethods alloc]init];
    [dbmethod initDatabaseAction];
    
    NSString *answer;
    if ([response.actionIdentifier  isEqual: @"answerText"]) {
        UNTextInputNotificationResponse *textResponse = (UNTextInputNotificationResponse*)response;
        answer = textResponse.userText;
    }else {
        answer = response.actionIdentifier;
    }
    
    [dbmethod addAnswer:answer WithQuestion:categoryIdentifier];
    
    if (_listTVC) {
        [_listTVC refreshUI];
    }
    
    //completionHandler();
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
