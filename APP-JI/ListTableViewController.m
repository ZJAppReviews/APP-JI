//
//  ListTableViewController.m
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//


#import "ListTableViewController.h"
#import "TextCellModel.h"
#import "TextLogTableViewController.h"
#import "SwitchLogTableViewController.h"
#import "FMDB.h"
#import "EditTableViewController.h"
#import "NotificationsMethods.h"
#import "DatabaseMethods.h"
#import "DailyLog-Swift.h"

@interface ListTableViewController () <PasswordTableViewDelegate,MainTableViewCellDelegate>

@property (nonatomic,strong) NSMutableArray *arr;
@property (nonatomic,strong) NSMutableArray *arr2;
@property (nonatomic,strong) TextCellModel *textCellModel;
@property (nonatomic,strong) MainTableViewCell *mainCell;
@property (nonatomic,strong) FMDatabase *db;
@property (nonatomic,strong) UIButton *addJIBtn;
@property (nonatomic,strong) NSString *questionClicked;


@end


@implementation ListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    
    //设置页面样式
    self.title = @"壹日壹纪";
    self.view.backgroundColor = [UIColor colorWithRed:254/255.0 green:226/255.0 blue:122/255.0 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClicked)];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setBtnClicked)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.rightBarButtonItem = rightBtn;
    _addJIBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _addJIBtn.frame = CGRectMake([[UIScreen mainScreen]bounds].size.width/2-136.5, 150, 273, 174);
    [_addJIBtn setBackgroundImage:[UIImage imageNamed:@"MainView_NoDataButton"] forState:UIControlStateNormal];
    [_addJIBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addJIBtn];

    //注册Cell类，从而使在出队cell的时候若复用池子中没有Cell可以直接新建
    [self.tableView registerClass:[MainTableViewTextCell class] forCellReuseIdentifier:@"text"];
    [self.tableView registerClass:[MainTableViewSwitchCell class] forCellReuseIdentifier:@"switch"];
    
    
    //如果打开了在首页验证，在这里推出验证视图
    if ([NSUserDefaults.standardUserDefaults boolForKey:@"PasswordEnabled"]&&[NSUserDefaults.standardUserDefaults boolForKey:@"FirstAuthEnabled"]&&![NSUserDefaults.standardUserDefaults boolForKey:@"Authed"]){
        
        UIStoryboard *authView = [UIStoryboard storyboardWithName:@"PasswordView" bundle:nil];
        UINavigationController *authNavController = [authView instantiateViewControllerWithIdentifier:@"inputPassword"];
        PasswordViewController *passwordViewController = (PasswordViewController *) authNavController.topViewController;
        void(^passBlock)(void) = ^(){
            [passwordViewController setModeWithMode:@"firstAuth"];
            return;
        };
        [self presentViewController:authNavController animated:true completion:passBlock];
    }

}

-(void)viewDidAppear:(BOOL)animated{
    [self refreshUI];
    return;
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
        
        _addJIBtn.hidden = false;
        
    }else {
        
        //生成文字纪的Cell
        for (NSDictionary *dict in _arr)
        {
            _textCellModel = [[TextCellModel alloc]init];
            _textCellModel = [TextCellModel JIWithDict:dict];
            [_arr2 addObject:_textCellModel];
        }
        
        _addJIBtn.hidden = true;
        
        [self.tableView reloadData];
        //[self.tableView reloadInputViews];
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
    
    TextCellModel *current = _arr2[indexPath.row];
    
    _mainCell = [tableView dequeueReusableCellWithIdentifier:current.type];
    _mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _mainCell.contentView.backgroundColor = [UIColor colorWithRed:254/255.0 green:226/255.0 blue:122/255.0 alpha:1];
    _mainCell.mainModel = _arr2[indexPath.row];
    _mainCell.delegate = self;
    [_mainCell settingText];
    return _mainCell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
            
            if (self->_arr.count == 0) {
                self->_addJIBtn.hidden = false;
            }
            
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

    UIStoryboard *story = [UIStoryboard storyboardWithName:@"NewTheme" bundle:[NSBundle mainBundle]];
    UIViewController *newThemeView = [story instantiateViewControllerWithIdentifier:@"newTheme"];
    [self presentViewController:newThemeView animated:YES completion:nil];

}

-(void)setBtnClicked{
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Setting" bundle:[NSBundle mainBundle]];
    UIViewController *newThemeView = [story instantiateViewControllerWithIdentifier:@"SettingNavigationController"];
    [self presentViewController:newThemeView animated:YES completion:nil];
    
}


#pragma mark - Cell进入记录详情页面的代理方法
- (void)pushClickedWithQuestion:(NSString *)question
{
    _questionClicked = question;

    //如果开启密码且关闭了再启动时验证且本次启动时未经过验证时调用验证方法,否则直接进入
    if ([NSUserDefaults.standardUserDefaults boolForKey:@"PasswordEnabled"]&&![NSUserDefaults.standardUserDefaults boolForKey:@"FirstAuthEnabled"]&&![NSUserDefaults.standardUserDefaults boolForKey:@"Authed"]){
        
        UIStoryboard *authView = [UIStoryboard storyboardWithName:@"PasswordView" bundle:nil];
        UINavigationController *authNavController = [authView instantiateViewControllerWithIdentifier:@"inputPassword"];
        PasswordViewController *passwordViewController = (PasswordViewController *) authNavController.topViewController;
        void(^passBlock)(void) = ^(){
            [passwordViewController setModeWithMode:@"auth"];
            [passwordViewController setDelegateView:self];
            return;
        };
        [self presentViewController:authNavController animated:true completion:passBlock];
    }else{
        [self pushDetailView];
    }
}

- (void)reloadCell {
    
    [self.tableView reloadData];

}




-(void) pushDetailView{
    
    NSString *type = [[NSString alloc]init];
    DatabaseMethods *dbmethod = [[DatabaseMethods alloc]init];
    type = [dbmethod getTypeOfQuestion:_questionClicked];
    
    if([type  isEqual: @"switch"]){
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            SwitchLogTableViewController *switchLogTVC = [[SwitchLogTableViewController alloc]init];
            switchLogTVC.question = self->_questionClicked;
            [self.navigationController pushViewController:switchLogTVC animated:YES];
        }];
    }else if ([type  isEqual: @"text"]){
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            TextLogTableViewController *textLogTVC = [[TextLogTableViewController alloc]init];
            textLogTVC.question = self->_questionClicked;
            [self.navigationController pushViewController:textLogTVC animated:YES];
        }];
    }
    
}


-(void)reloadCell:(id)sender{
    
    [self.tableView reloadData];
    
}


@end
