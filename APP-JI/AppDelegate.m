//
//  AppDelegate.m
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import "AppDelegate.h"
#import "NotificationsMethods.h"
#import <UserNotifications/UserNotifications.h>
#import "DailyLog-Swift.h"

@interface AppDelegate () <UNUserNotificationCenterDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //根据登陆时间判断是否需要刷新首页的视图
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年MM月dd日"];
    NSString *nowDay = [dateFormatter stringFromDate:date];
    if (![[NSUserDefaults.standardUserDefaults stringForKey:@"LoginTime"] isEqualToString:nowDay]){
        [NSUserDefaults.standardUserDefaults setValue:nowDay forKey:@"LoginTime"];
        CoreDataMethods *datamethod = [[CoreDataMethods alloc] init];
        [datamethod refreshTodayContent];
    }
    
    //设置全局外观
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.tintColor = [UIColor blackColor];
    
    //设置首页的视图
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    UIStoryboard *mainView = [UIStoryboard storyboardWithName:@"MainView" bundle:nil];
    UINavigationController *mainViewNav = [mainView instantiateViewControllerWithIdentifier:@"mainViewNav"];
    self.window.rootViewController = mainViewNav;

    //设置相应推送通知的代理
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    //判断是否需要验证密码
    if (![NSUserDefaults.standardUserDefaults stringForKey:@"Password"])
    {
        [NSUserDefaults.standardUserDefaults setValue:@"none" forKey:@"Password"];
        [NSUserDefaults.standardUserDefaults setBool:false forKey:@"PasswordEnabled"];
        [NSUserDefaults.standardUserDefaults setBool:false forKey:@"FirstAuthEnabled"];
        [NSUserDefaults.standardUserDefaults setBool:false forKey:@"TouchIDEnabled"];
    }
    [NSUserDefaults.standardUserDefaults setBool:false forKey:@"Authed"];
    return YES;
}


//3D Touch 快捷方式
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"NewTheme" bundle:[NSBundle mainBundle]];
    UIViewController *newThemeView = [story instantiateViewControllerWithIdentifier:@"newTheme"];
    [self.window.rootViewController presentViewController:newThemeView animated:YES completion:nil];
}

//响应通知
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    
    NSString *categoryIdentifier = response.notification.request.content.categoryIdentifier;

    NSString *answer;
    if ([response.actionIdentifier  isEqual: @"answerText"]) {
        UNTextInputNotificationResponse *textResponse = (UNTextInputNotificationResponse*)response;
        answer = textResponse.userText;
    }else {
        answer = response.actionIdentifier;
    }
    
    CoreDataMethods *dataMethod = [[CoreDataMethods alloc]init];
    [dataMethod addLogWithTitle:categoryIdentifier content:answer];
    
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
#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"DataModel"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
