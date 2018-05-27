//
//  DatabaseMethods.m
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/14.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import "DatabaseMethods.h"
#import <FMDB.h>

@implementation DatabaseMethods


#pragma mark - 初始化操作

- (void) initDatabaseAction{
    //获取当前日期
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年MM月dd日"];
    NSString *nowDay = [dateFormatter stringFromDate:currentDate];
    
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
    if (![db tableExists:@"LoginTime"]) {
        
        [db executeUpdate:@"CREATE TABLE LoginTime (Day text, Value text)"];
        NSLog(@"Create table LoginTime succeed!");
    }
    //建立table
    if (![db tableExists:@"DataList"]) {
        
        [db executeUpdate:@"CREATE TABLE DataList (Question text, Type text, AnswerT text)"];
        NSLog(@"Creat table DataList succeed!");
    }
    //建立table
    if (![db tableExists:@"LogList"]) {
        
        [db executeUpdate:@"CREATE TABLE LogList (Question text, Time text, Answer text)"];
        NSLog(@"Creat table LogList succeed!");
    }
    
    
    //找地址
    NSString *today = [db stringForQuery:@"SELECT Value FROM LoginTime WHERE Day = ?",@"Day"];
//    NSLog(@"%@",today);
    
    NSMutableArray *arr = [NSMutableArray array];
    
    if (today) {
        if ([today isEqualToString:nowDay]) {
        }else{
            //更新
            [db executeUpdate:@"UPDATE LoginTime SET Value = ? WHERE Day = ?",nowDay,@"Day"];
            
            
            //删除
            FMResultSet *rs = [db executeQuery:@"select * from DataList;"];
            
            while ([rs next]) {
                
                NSString *question = [rs stringForColumn:@"Question"];
                NSString *type = [rs stringForColumn:@"Type"];
                
                //删除
                [db executeUpdate:@"DELETE FROM DataList WHERE Question = ?",question];
                
                NSDictionary *dict = [[NSDictionary alloc]init];
                dict = [NSDictionary dictionaryWithObjectsAndKeys:question,@"question" ,type,@"type",nil];
                
                [arr addObject:dict];
            }
            
            [rs close];
            
            for (NSDictionary *dict in arr)
            {
                NSString *question = [NSString stringWithString:[dict objectForKey:@"question"]];
                NSString *type = [NSString stringWithString:[dict objectForKey:@"type"]];
                
                //写入
                [db executeUpdate:@"INSERT INTO DataList (Question, Type) VALUES (?,?)",question, type];
            }
        }
        
    }else{
        //写入
        [db executeUpdate:@"INSERT INTO LoginTime (Day, Value) VALUES (?,?)",@"Day", nowDay];
    }
    [db close];
}


#pragma mark - 主题操作

-(void) addQuestion:(NSString *)question andType:(NSString *)type{
    
    // 建立资料库
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"JIDatabase.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }else
        NSLog(@"db opened");
    //建立table
    if (![db tableExists:@"DataList"]) {
        
        [db executeUpdate:@"CREATE TABLE DataList (Question text, Type text, AnswerT text)"];
        NSLog(@"Creat table DataList succeed!");
    }


    [db executeUpdate:@"INSERT INTO DataList (Question, Type) VALUES (?,?)",question,type];

    [db close];
    
}

-(void) deleteQuestion:(NSString *)question{
    // 建立资料库
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"JIDatabase.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath] ;
    db = [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }else
        NSLog(@"db opened");

    [db executeUpdate:@"DELETE FROM DataList WHERE Question = ?",question];
    [db executeUpdate:@"DELETE FROM LogList WHERE Question = ?",question];
    [db close];
}

- (BOOL)isQuestionRepeated:(NSString *)question{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"JIDatabase.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath] ;
    
    if (![db open]) {
        NSLog(@"Could not open db.");
        return true ;
    }else
        NSLog(@"db opened");
    //建立table
    if (![db tableExists:@"DataList"]) {
        
        [db executeUpdate:@"CREATE TABLE DataList (Question text, Type text, AnswerT text)"];
        NSLog(@"Creat table DataList succeed!");
    }
    //查找
    NSString *result = [db stringForQuery:@"SELECT Question FROM DataList WHERE Question = ?",question];
    if (result) {
        return true;
    }
    [db close];
    return false;
    
}


#pragma mark - 记录操作

-(void) addAnswer:(NSString *)answer WithQuestion:(NSString *)question {

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
    
    //获取当前日期
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年MM月dd日"];
    NSString *nowDay = [dateFormatter stringFromDate:currentDate];
    
    //更新首页的展示数据
    if (![db tableExists:@"DataList"]) {
        [db executeUpdate:@"CREATE TABLE DataList (Question text, Type text, AnswerT text)"];
    }
    [db executeUpdate:@"UPDATE DataList SET AnswerT = ? WHERE Question = ?",answer,question];
    
    //添加新的记录
    if (![db tableExists:@"LogList"]) {
        [db executeUpdate:@"CREATE TABLE LogList (Question text, Time text, Answer text)"];
    }
    [db executeUpdate:@"INSERT INTO LogList (Question,Time, Answer) VALUES (?,?,?)",question,nowDay,answer];

    [db close];
    
    }

#pragma mark - 密码操作

//数据库包含 密码：字符串，没有设置密码时字符串内容为“null”，是否打开生物验证，是否在首页进行验证



@end

