//
//  LoginViewController.m
//  APP-JI
//
//  Created by 魏大同 on 16/4/5.
//  Copyright © 2016年 魏大同. All rights reserved.
//

#import "LoginViewController.h"
#import "NoDataViewController.h"
#import "ListTableViewController.h"
#import "FMDB.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    //获取当前日期
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年MM月dd日"];
    NSString *nowDay = [dateFormatter stringFromDate:currentDate];
    NSLog(@"当前日期:%@",nowDay);
    
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
    //NSString *today = @"2016年05月01日";
    NSLog(@"%@",today);
    
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
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginBtn addTarget:self action:@selector(loginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    loginBtn.frame = CGRectMake(150, 300, 80, 44);
//    [loginBtn setTitle:@"login" forState:UIControlStateNormal];
    
    UIImage *img = [UIImage imageNamed:@"ji.png"];
    UIImageView *noDataImgV = [[UIImageView alloc]initWithImage:img];
    noDataImgV.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
    [self.view addSubview:noDataImgV];
    
    [self performSelector:@selector(loginBtnClicked) withObject:nil afterDelay:2];
   
    
}

-(void)loginBtnClicked{
    ListTableViewController *listTVC = [[ListTableViewController alloc]init];
    NoDataViewController *noDataVC = [[NoDataViewController alloc]init];
    
    // 建立资料库
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"JIDatabase.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath] ;
    NSMutableArray *arr = [NSMutableArray array];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }else
        NSLog(@"db opened");
    
    
    //建立table
    if (![db tableExists:@"DataList"]) {
        
        [db executeUpdate:@"CREATE TABLE DataList (Question text, Type text, AnswerT text)"];
    }
    
    FMResultSet *resultSet = [db executeQuery:@"select * from DataList;"];
    while ([resultSet  next])
        
    {
        NSString *question = [resultSet stringForColumn:@"Question"];
        NSString *answerT = [resultSet stringForColumn:@"AnswerT"];
        
        NSDictionary *dict = [[NSDictionary alloc]init];
        dict = [NSDictionary dictionaryWithObjectsAndKeys:question,@"question",answerT,@"answerT" ,nil];
        
        [arr addObject:dict];
        
        
    }
    NSLog(@"%lu",(unsigned long)arr.count);
    [resultSet close];
    [db close];

    if (arr.count) {
        [self.navigationController pushViewController:listTVC animated:YES];
    }else{
        [self.navigationController pushViewController:noDataVC animated:YES];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
