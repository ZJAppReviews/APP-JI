//
//  ListTableViewController.m
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//


#import "ListTableViewController.h"
#import "TextCellModel.h"
#import "TextTableViewCell.h"
#import "SwitchTableViewCell.h"
#import "AddJITableViewController.h"
#import "TextLogTableViewController.h"
#import "SwitchLogTableViewController.h"
#import "FMDB.h"
#import "EditTableViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>


@interface ListTableViewController ()

@property (nonatomic,strong) NSMutableArray *arr;
@property (nonatomic,strong) NSMutableArray *arr2;
@property (nonatomic,strong) TextCellModel *textCellModel;
@property (nonatomic,strong) TextTableViewCell *textCell;
@property (nonatomic,strong) SwitchTableViewCell *switchCell;
@property (nonatomic,strong) FMDatabase *db;
@property (nonatomic) BOOL unAuthented;

@end


@implementation ListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _unAuthented=1;
   
    //更新导航栏样式
    [self.navigationController setNavigationBarHidden:NO];
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setPrefersLargeTitles:YES];
    }
    
    _arr = [NSMutableArray array];
    _arr2 = [NSMutableArray array];
    self.tableView.dataSource = self;
    
    [self clearExtraLine:self.tableView];
    self.title = @"壹日壹纪";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ViewBGC.png"]];
    
    
    //添加按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClicked)];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:nil];
    leftBtn.enabled = NO;
    
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.rightBarButtonItem = rightBtn;
                                 
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
    
    for (NSDictionary *dict in _arr)
    {
        _textCellModel = [[TextCellModel alloc]init];
        _textCellModel = [TextCellModel JIWithDict:dict];
        [_arr2 addObject:_textCellModel];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotif:) name:@"ReloadView" object:nil];

    [self.tableView registerClass:[SwitchTableViewCell class] forCellReuseIdentifier:[SwitchTableViewCell ID]];
    [self.tableView registerClass:[TextTableViewCell class] forCellReuseIdentifier:[TextTableViewCell ID]];
    
    //添加首页无内容默认背景
    if (_arr.count == 0) {
        UIImage *noDataImg = [UIImage imageNamed:@"NoDataVC.png"];
        UIImageView *noDataImgV = [[UIImageView alloc]initWithImage:noDataImg];
        noDataImgV.frame = CGRectMake(0, 145, [[UIScreen mainScreen]bounds].size.width, 240);
        [self.view addSubview:noDataImgV];
        
        UIImage *backGC = [UIImage imageNamed:@"ViewBGC.png"];
        UIColor *imageColor = [UIColor colorWithPatternImage:backGC];       //根据图片生成颜色
        self.view.backgroundColor = imageColor;
        
        UIButton *newJIBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        newJIBtn.frame = CGRectMake([[UIScreen mainScreen]bounds].size.width/2-80, 400, 160, 50);
        [newJIBtn setBackgroundImage:[UIImage imageNamed:@"AddNewJI.png"] forState:UIControlStateNormal];
        [newJIBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:newJIBtn];
    }
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

    return self.arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    _textCell = [tableView dequeueReusableCellWithIdentifier:[TextTableViewCell ID]];
    _textCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _switchCell = [tableView dequeueReusableCellWithIdentifier:[SwitchTableViewCell ID]];
    _switchCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    UIImage *backGC = [UIImage imageNamed:@"ViewBGC.png"];
    UIColor *imageColor = [UIColor colorWithPatternImage:backGC];       //根据图片生成颜色
    _textCell.contentView.backgroundColor = imageColor;
    _switchCell.contentView.backgroundColor = imageColor;
    
    NSString *type = [[NSString alloc]init];
    type = [_arr[indexPath.row] objectForKey:@"type"];
    
    if ([type isEqualToString:@"switch"]) {
        _switchCell.switchModel = _arr2[indexPath.row];
        
        [_switchCell settingText];
        
        _switchCell.sDelegate = self;           //cell的代理方法
        
        return _switchCell;
        
    }
    
    _textCell.textModel = _arr2[indexPath.row];
    
    [_textCell settingText];
    
    _textCell.tDelegate = self;         //cell的代理方法
    
    return _textCell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *type = [[NSString alloc]init];
    type = [_arr[indexPath.row] objectForKey:@"type"];
    
    if ([type isEqualToString:@"switch"]) {
        return _switchCell.cellHeight;
    }
    
    _textCell.textModel = _arr2[indexPath.row];
    [_textCell settingText];
    
    return _textCell.cellHeight;
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
        
        // 初始化一个一个UIAlertController
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"这个操作将会删除该类目下的所有记录" preferredStyle:(UIAlertControllerStyleAlert)];
        
        // 确认按钮
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            
            NSString *question = [NSString stringWithString:[_arr[indexPath.row] objectForKey:@"question"]];
            
            // 删除数组
            [self.arr removeObjectAtIndex:indexPath.row];
            [self.arr2 removeObjectAtIndex:indexPath.row];
            
            // 建立资料库
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [paths objectAtIndex:0];
            NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"JIDatabase.db"];
            self->_db = [FMDatabase databaseWithPath:dbPath] ;
            if (![self->_db open]) {
                NSLog(@"Could not open db.");
                return ;
            }else
                NSLog(@"db opened");
            //删除
            [self->_db executeUpdate:@"DELETE FROM DataList WHERE Question = ?",question];
            [self->_db executeUpdate:@"DELETE FROM LogList WHERE Question = ?",question];
            [self->_db close];
            //刷新表示图
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            
            
            //        //取消通知
            //        [[UIApplication sharedApplication] cancelAllLocalNotifications];
            
            // 取消某个特定的本地通知
            for (UILocalNotification *noti in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
                NSString *notiID = noti.category;
                NSString *receiveNotiID = question;
                if ([notiID isEqualToString:receiveNotiID]) {
                    [[UIApplication sharedApplication] cancelLocalNotification:noti];
                }
            }
            
            
            if (_arr.count == 0) {
                
                UIImage *noDataImg = [UIImage imageNamed:@"NoDataVC.png"];
                UIImageView *noDataImgV = [[UIImageView alloc]initWithImage:noDataImg];
                noDataImgV.frame = CGRectMake(0, 145, [[UIScreen mainScreen]bounds].size.width, 240);
                [self.view addSubview:noDataImgV];
                
                UIImage *backGC = [UIImage imageNamed:@"ViewBGC.png"];
                UIColor *imageColor = [UIColor colorWithPatternImage:backGC];       //根据图片生成颜色
                self.view.backgroundColor = imageColor;
                
                UIButton *newJIBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                newJIBtn.frame = CGRectMake([[UIScreen mainScreen]bounds].size.width/2-80, 400, 160, 50);
                [newJIBtn setBackgroundImage:[UIImage imageNamed:@"AddNewJI.png"] forState:UIControlStateNormal];
                [newJIBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:newJIBtn];
                
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
        editTVC.question = [NSString stringWithString:[_arr[indexPath.row] objectForKey:@"question"]];
        [self.navigationController pushViewController:editTVC animated:YES];
        
        
               
    }];
    editAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //editAction.backgroundColor = [UIColor blueColor];
    
    return @[deleteAction,editAction];
}

#pragma mark - 导航栏上新建Button事件
-(void)rightBtnClicked{
    AddJITableViewController *addTVC = [[AddJITableViewController alloc]init];
    [self.navigationController pushViewController:addTVC animated:YES];

}

#pragma mark - 去掉多余的线
-(void)clearExtraLine: (UITableView *)tableView{
    UIView *view= [[UIView alloc]init];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.tableView setTableFooterView:view];
}

#pragma mark - Text&Switch CellDelegate
//点击文字类型纪的时候，开始验证
- (void)pushBtnClicked2:(id)sender
{
    if(_unAuthented){
    LAContext *LAContent = [[LAContext alloc]init];
    [LAContent evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请完成验证以查看内容" reply:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            self->_unAuthented = NO;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                TextLogTableViewController *textLogTVC = [[TextLogTableViewController alloc]init];
                [self.navigationController pushViewController:textLogTVC animated:YES];
            }];
        } else {
            NSLog(@"身份验证失败！ \nerrorCode : %ld, errorMsg : %@",(long)error.code, error.localizedDescription);
        }
    }];
    }
    else{
        TextLogTableViewController *textLogTVC = [[TextLogTableViewController alloc]init];
        [self.navigationController pushViewController:textLogTVC animated:YES];
    }
}

//点击选择类型纪的时候，开始验证
-(void)pushtoSwitchLog2:(id)sender{
    if(_unAuthented){
        LAContext *LAContent = [[LAContext alloc]init];
        [LAContent evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请完成验证以查看内容" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                self->_unAuthented = NO;
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    SwitchLogTableViewController *switchLogTVC = [[SwitchLogTableViewController alloc]init];
                    [self.navigationController pushViewController:switchLogTVC animated:YES];
                }];
            } else {
                NSLog(@"身份验证失败！ \nerrorCode : %ld, errorMsg : %@",(long)error.code, error.localizedDescription);
                }
        }];
    }
    else{
        TextLogTableViewController *textLogTVC = [[TextLogTableViewController alloc]init];
        [self.navigationController pushViewController:textLogTVC animated:YES];
    }
}

-(void)reloadCell:(id)sender{
    
    [self.tableView reloadData];
}
//-(void)reloadCell2:(id)sender{
//    [self.tableView reloadData];
//}
//
//-(void)reloadDatas{
//    [self.tableView reloadData];
//    [self.tableView reloadInputViews];
//}

//-(void)viewDidAppear:(BOOL)animated{
//    [self.tableView reloadData];
//}
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
