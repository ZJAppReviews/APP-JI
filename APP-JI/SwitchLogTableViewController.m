//
//  SwitchLogTableViewController.m
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import "LogSwitchCellModel.h"
#import "LogSwitchTableViewCell.h"
#import "SwitchLogTableViewController.h"
#import "ListTableViewController.h"
#import "ListLogSM.h"
#import "FMDB.h"

@interface SwitchLogTableViewController ()

@property (nonatomic,strong) NSMutableArray *arr;
@property (nonatomic,strong) NSMutableArray *arr2;
@property (nonatomic,strong) LogSwitchCellModel *logmoedl;
@property (nonatomic,strong) LogSwitchTableViewCell *logCell;
@property (nonatomic,strong) FMDatabase *db;


@end

@implementation SwitchLogTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    ListLogSM *sm = [ListLogSM shareSingletonModel];
    _question = sm.question;
    
    NSLog(@"TextLogTVC");
    NSLog(@"%@",_question);
    
    _arr = [NSMutableArray array];
    _arr2 = [NSMutableArray array];
    
    [self clearExtraLine:self.tableView];
    self.title = _question;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ViewBGC.png"]];
    
//    UIButton *backBtn = [[UIButton alloc]init];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    
//    [backBtn addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.rightBarButtonItem = item;

    
//    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClicked)];
//    self.navigationItem.leftBarButtonItem = leftBtn;
    
    // 建立资料库
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"JIDatabase.db"];
    _db = [FMDatabase databaseWithPath:dbPath] ;
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return ;
    }else
        NSLog(@"db opened");
    //建立table
    if (![_db tableExists:@"LogList"]) {
        
        [_db executeUpdate:@"CREATE TABLE LogList (Question text , Time text, Answet text)"];
    }
    
    FMResultSet *resultSet = [_db executeQuery:@"select * from LogList;"];
    while ([resultSet  next])
        
    {
        
        NSString *question = [resultSet stringForColumn:@"Question"];
        
        if ([question isEqualToString:_question]) {
            
            NSString *time = [resultSet stringForColumn:@"Time"];
            NSString *answer = [resultSet stringForColumn:@"Answer"];
            
            NSDictionary *dict = [[NSDictionary alloc]init];
            dict = [NSDictionary dictionaryWithObjectsAndKeys:time,@"time",answer,@"answer",nil];
            [_arr addObject:dict];
        }
        
    }
    
    [resultSet close];
    [_db close];
    
    for (NSDictionary *dict in _arr)
    {
        _logmoedl = [[LogSwitchCellModel alloc]init];
        _logmoedl = [LogSwitchCellModel LogWithDict:dict];
        [_arr2 addObject:_logmoedl];
    }
    
    [self.tableView registerClass:[LogSwitchTableViewCell class] forCellReuseIdentifier:[LogSwitchTableViewCell ID]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.arr2.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _logCell = [tableView dequeueReusableCellWithIdentifier:[LogSwitchTableViewCell ID]];
    _logCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    UIImage *backGC = [UIImage imageNamed:@"CellBGC2.png"];
    UIColor *imageColor = [UIColor colorWithPatternImage:backGC];       //根据图片生成颜色
    _logCell.contentView.backgroundColor = imageColor;
    
    
    _logCell.logswitchModel = _arr2[indexPath.row];
    
    [_logCell settingText];
    
    return _logCell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

-(void)leftBtnClicked{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 去掉多余的线
-(void)clearExtraLine: (UITableView *)tableView{
    UIView *view= [[UIView alloc]init];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.tableView setTableFooterView:view];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
