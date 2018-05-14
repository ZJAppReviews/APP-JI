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
    
    if ([categoryIdentifier isEqualToString:@"JiNotifi"]) {//识别需要被处理的拓展
        
        if ([response.actionIdentifier isEqualToString:@"input text"]) {//识别用户点击的是哪个 action
            
            //假设点击了输入内容的 UNTextInputNotificationAction 把 response 强转类型
            UNTextInputNotificationResponse *textResponse = (UNTextInputNotificationResponse*)response;
            //获取输入内容
            NSString *userText = textResponse.userText;
            //发送 userText 给需要接收的方法
            //[NotificationsActionsMethods handleUserText: userText];
        }else{
            
        }
        
    }
    completionHandler();
}


//初始化数据库
- (void)initDatabaseAction{

}

//本地推送通知
/*- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler {
    
    
    if ([identifier isEqualToString:@"yes"]||[identifier isEqualToString:@"no"]) {
    
    //在非本App界面时收到本地消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮，notification为消息内容
    NSLog(@"%@",identifier);
    NSString *question = notification.category;
    
    // 建立资料库
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"JIDatabase.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath] ;
            if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }else
        NSLog(@"db opened");
    
    
    //建立table
    if (![db tableExists:@"DataList"]) {
        
        [db executeUpdate:@"CREATE TABLE DataList (Question text, Type text, AnswerT text)"];
    }
    //更新
    [db executeUpdate:@"UPDATE DataList SET AnswerT = ? WHERE Question = ?",identifier,question];
    
    //找地址
    NSString *answer = [db stringForQuery:@"SELECT AnswerT FROM DataList WHERE Question = ?",question];
    
    NSLog(@"appdelegate %@",answer);
    
    //建立table
    if (![db tableExists:@"LogList"]) {
        
        [db executeUpdate:@"CREATE TABLE LogList (Question text, Time text, Answer text)"];
    }
    //获取当前日期
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年MM月dd日"];
    NSString *nowDay = [dateFormatter stringFromDate:currentDate];
    
    //写入
    [db executeUpdate:@"INSERT INTO LogList (Question,Time, Answer) VALUES (?,?,?)",question,nowDay,identifier];
    
    [db close];
    
    completionHandler();//处理完消息，最后一定要调用这个代码块
    
    }
    else{

   
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QuickReplyGotTextNotification" object:[responseInfo objectForKey:UIUserNotificationActionResponseTypedTextKey] userInfo:nil];
    completionHandler(UIBackgroundFetchResultNoData);
    }

}*/

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
