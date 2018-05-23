//
//  ListTableViewController.m
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//


#import "ListTableViewController.h"
#import "TextCellModel.h"
#import "AddJITableViewController.h"
#import "TextLogTableViewController.h"
#import "SwitchLogTableViewController.h"
#import "FMDB.h"
#import "EditTableViewController.h"
#import "NotificationsMethods.h"
#import "DatabaseMethods.h"
#import <LocalAuthentication/LocalAuthentication.h>

#import "AuthenticMethods.h"
#import "MainViewCell.h"

@interface ListTableViewController ()

@property (nonatomic,strong) NSMutableArray *arr;
@property (nonatomic,strong) NSMutableArray *arr2;
@property (nonatomic,strong) TextCellModel *textCellModel;
@property (nonatomic,strong) MainViewCell *mainCell;
@property (nonatomic,strong) FMDatabase *db;
@property (nonatomic,strong) UIButton *addJIBtn;
@property (nonatomic,strong) UIImageView *noDataImgV;
@property (nonatomic) BOOL unAuthented;

@end


@implementation ListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _unAuthented=1;
    
    self.tableView.dataSource = self;
    
    self.title = @"壹日壹纪";
    self.view.backgroundColor = [UIColor colorWithRed:254/255.0 green:226/255.0 blue:122/255.0 alpha:1];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //添加按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClicked)];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:nil];
    leftBtn.enabled = NO;
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    //注册Cell类，从而使在出队cell的时候若复用池子中没有Cell可以直接新建

    [self.tableView registerClass:[MainViewCell class] forCellReuseIdentifier:[MainViewCell ID]];
    [self refreshUI];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshUI {

    _arr = [[NSMutableArray array]init];
    _arr2 = [[NSMutableArray array]init];
    
    // 建立资料库
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"JIDatabase.db"];
    _db = [FMDatabase databaseWithPath:dbPath] ;
    if (![_db open]) {
        //        NSLog(@"Could not open db.");
        return ;
    }else
        //        NSLog(@"db opened");
        
        //建立table
        if (![_db tableExists:@"DataList"]) {
            
            [_db executeUpdate:@"CREATE TABLE DataList (Question text, Type text, AnswerT text)"];
        }
    
    
    FMResultSet *resultSet = [_db executeQuery:@"select * from DataList;"];
    while ([resultSet  next])
        
    {
        NSString *question = [resultSet stringForColumn:@"Question"];
        NSString *answerT = [resultSet stringForColumn:@"AnswerT"];
        NSString *type = [resultSet stringForColumn:@"Type"];
        
        NSDictionary *dict = [[NSDictionary alloc]init];
        dict = [NSDictionary dictionaryWithObjectsAndKeys:question,@"question" ,type,@"type",answerT,@"answerT",nil];
        [_arr addObject:dict];
    }
    
    [resultSet close];
    [_db close];
    
    if (_arr.count == 0) {
        
        _noDataImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"NoDataVC.png"]];
        _noDataImgV.frame = CGRectMake(0, 145, [[UIScreen mainScreen]bounds].size.width, 240);
        [self.view addSubview:_noDataImgV];
        
        _addJIBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _addJIBtn.frame = CGRectMake([[UIScreen mainScreen]bounds].size.width/2-80, 400, 160, 50);
        [_addJIBtn setBackgroundImage:[UIImage imageNamed:@"AddNewJI.png"] forState:UIControlStateNormal];
        [_addJIBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_addJIBtn];
        
    }else {
        
        //生成文字纪的Cell
        for (NSDictionary *dict in _arr)
        {
            _textCellModel = [[TextCellModel alloc]init];
            _textCellModel = [TextCellModel JIWithDict:dict];
            [_arr2 addObject:_textCellModel];
        }
        [_noDataImgV setHidden:YES];
        [_addJIBtn setHidden:YES];
        
        [self.tableView reloadData];
        [self.tableView reloadInputViews];
    }


    }


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.arr.count;
}

//分类初始化列表元件
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    _mainCell = [tableView dequeueReusableCellWithIdentifier:[MainViewCell ID]];
    _mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _mainCell.contentView.backgroundColor = [UIColor colorWithRed:254/255.0 green:226/255.0 blue:122/255.0 alpha:1];
    _mainCell.mainModel = _arr2[indexPath.row];
    _mainCell.Delegate = self;
    [_mainCell settingText];
    return _mainCell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    _mainCell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return _mainCell.cellHeight;
}

#pragma makr 观察者模式

-(void)receivedNotif:(NSNotification *)notification {
    
    [self.tableView reloadData];
    [self.tableView reloadInputViews];
    
}

#pragma mark 行左划删除方法&编辑方法

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    //删除
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action,NSIndexPath *indexPath){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"这个操作将会删除该类目下的所有记录" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction *action) {
            
            NSString *question = [NSString stringWithString:[self->_arr[indexPath.row] objectForKey:@"question"]];
            
            //删除数组
            [self.arr removeObjectAtIndex:indexPath.row];
            [self.arr2 removeObjectAtIndex:indexPath.row];
            
            //删除数据
            DatabaseMethods *dbmethod = [[DatabaseMethods alloc]init];
            [dbmethod deleteQuestion:question];
            
            //刷新表示图
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            // 取消某个特定的本地通知,这个地方最好加上一个判断
            NotificationsMethods *notifimethod = [[NotificationsMethods alloc]init];
            [notifimethod cancelNotification:question];
            
//            [self refreshUI];
            
            
            
        }];
        // 取消按钮
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
            
           // return ;
        }];
        
        // 添加按钮 将按钮添加到UIAlertController对象上
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        
        // 将UIAlertController模态出来 相当于UIAlertView show 的方法
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    
    
    //编辑
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction *action,NSIndexPath *indexPath){
        
        EditTableViewController *editTVC = [[EditTableViewController alloc]init];
        editTVC.backTVC = self;
        UINavigationController *editNavController = [[UINavigationController alloc] initWithRootViewController:editTVC];
        editNavController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:editNavController animated:YES completion:nil];
    
    }];
    editAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //editAction.backgroundColor = [UIColor blueColor];
    
    return @[deleteAction,editAction];
}

#pragma mark - 导航栏上新建Button事件
-(void)rightBtnClicked{
    AddJITableViewController *addTVC = [[AddJITableViewController alloc]init];
    addTVC.backTVC = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addTVC];
        navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:navController animated:YES completion:nil];

}



#pragma mark - Text&Switch CellDelegate
- (void)pushClickedWithQuestion:(NSString *)question andType:(NSString *)type
{
    AuthenticMethods *authMethod = [[AuthenticMethods alloc]init];
    authMethod.aDelegate = self;
    [authMethod authenticWithQuestion:question andType:type];
}

-(void) pushDetailViewWithQuestion:(NSString *)question andType:(NSString *)type{

    if([type  isEqual: @"switch"]){
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            SwitchLogTableViewController *switchLogTVC = [[SwitchLogTableViewController alloc]init];
            switchLogTVC.question = question;
            [self.navigationController pushViewController:switchLogTVC animated:YES];
        }];
    }else if ([type  isEqual: @"text"]){
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            TextLogTableViewController *textLogTVC = [[TextLogTableViewController alloc]init];
            textLogTVC.question = question;
            [self.navigationController pushViewController:textLogTVC animated:YES];
        }];
    }

}


-(void)reloadCell:(id)sender{
    
    [self.tableView reloadData];
    
}

@end
