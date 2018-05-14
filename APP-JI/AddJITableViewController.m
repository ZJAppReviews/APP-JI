//
//  AddJITableViewController.m
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import "AddJITableViewController.h"
#import "CellSettingItem.h"
#import "CellSwitchItem.h"
#import "CellArrowItem.h"
#import "JITableViewCell.h"
#import "CellTextItem.h"
#import "SingletonModel.h"
#import "ListTableViewController.h"
#import "FMDB.h"
#import "NotificationsMethods.h"
#import "Masonry.h"

@interface AddJITableViewController ()

@property (nonatomic,strong) NSMutableArray *cellData;
@property (nonatomic,strong) NSString *pickerStr;
@property (nonatomic,strong) NSString *pickerStr2;
@property (nonatomic,strong) FMDatabase *db;
@property (nonatomic,strong) SingletonModel *singletonModel;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) NSDateComponents *notificationTime;
@property (nonatomic) int hour;
@property (nonatomic) int minute;

@end

@implementation AddJITableViewController

-(NSMutableArray *)cellData
{
    if (!_cellData) {
        _cellData = [NSMutableArray array];
    }
    
    return _cellData;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //调整标题栏样式
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setPrefersLargeTitles:NO];
    }

    //更新导航栏
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(DoneBtnClicked)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(CancleBtnClicked)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.title = @"新建一个纪";
    
    //初始化模型
    _textItem = [[CellTextItem alloc]init];

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
    if (![_db tableExists:@"DataList"]) {
        
        [_db executeUpdate:@"CREATE TABLE DataList (Question text, Type text, AnswerT text)"];
    }
    //测试数据
    //写入
    [_db executeUpdate:@"INSERT INTO DataList (Question, Type, AnswerT) VALUES (?,?,?)",@"question", @"on", @"AnswerT"];

    //找地址
    NSString *answer = [_db stringForQuery:@"SELECT AnswerT FROM DataList WHERE Question = ?",@"question"];
    
    NSLog(@"%@",answer);
    //删除
    [_db executeUpdate:@"DELETE FROM DataList WHERE Question = ?",@"question"];
//    NSString *answer1 = [_db stringForQuery:@"SELECT AnswerT FROM DataList WHERE Question = ?",@"question"];
//    NSLog(@"%@",answer1);

    
    UIImage *backGC = [UIImage imageNamed:@"ViewBGC.png"];
    UIColor *imageColor = [UIColor colorWithPatternImage:backGC];       //根据图片生成颜色
    self.view.backgroundColor = imageColor;
    
    
    CellSwitchItem *item1 = [CellSwitchItem itemWithIcon:NULL andTitle:@"用选择来记录"];
    CellTextItem *item2 = [CellTextItem itemWithText:@"纪的内容(问题)"];
    NSArray *group1 = @[item1,item2];
    
    CellSwitchItem *item3 = [CellSwitchItem itemWithIcon:NULL andTitle:@"开启提醒"];
 //   CellSwitchItem *item4 = [CellSwitchItem itemWithIcon:NULL andTitle:@"在随机的时间提醒"];
   // CellArrowItem *item5 = [CellArrowItem itemWithIcon:NULL andTitle:@"提醒时间"];
  //  CellArrowItem *item6 = [CellArrowItem itemWithIcon:NULL andTitle:@"重复"];
    NSArray *group2 = @[item3];
    
    [self.cellData addObject:group1];
    [self.cellData addObject:group2];
    
    //给定开关
    UISwitch *switch1 = [[UISwitch alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width-80, 35, 100, 40)];
    [switch1 addTarget:self action:@selector(switch1Changed:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switch1];
    
    UISwitch *switch2 = [[UISwitch alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width-80,180, 100, 40)];
    [switch2 addTarget:self action:@selector(switch2Changed:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switch2];
    
    
    //提醒时间
    _datePicker = [[UIDatePicker alloc]init];
    _datePicker.frame = CGRectMake(70, 230, [[UIScreen mainScreen]bounds].size.width-140, 130);
    _datePicker.datePickerMode = UIDatePickerModeTime;
    [self.view addSubview:_datePicker];
    
    [_datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    _datePicker.hidden = YES;
    

    [_db close];
    
    //初始化记录时间的类notificationTime
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    _notificationTime = [greCalendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate date]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveQuickReply:) name:@"QuickReplyGotTextNotification" object:nil];
    
}


-(void)datePickerChanged:(id)sender{

    NSDate *date = _datePicker.date;
    NSDateFormatter *hh = [[NSDateFormatter alloc]init];
    NSDateFormatter *mm = [[NSDateFormatter alloc]init];
    [hh setDateFormat:@"HH"];
    [mm setDateFormat:@"mm"];
    _notificationTime.hour = [[hh stringFromDate:date] intValue];
    _notificationTime.minute = [[mm stringFromDate:date] intValue];


    
    _pickerStr = [[NSString alloc]init];
    _pickerStr2 = [[NSString alloc]init];
    _pickerStr = [hh stringFromDate:date];
    _pickerStr2 = [mm stringFromDate:date];
    
    _hour = [_pickerStr intValue];
    _minute = [_pickerStr2 intValue];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.cellData.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray *arr = self.cellData[section];
    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JITableViewCell *cell = [JITableViewCell initCellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *arr = self.cellData[indexPath.section];
    CellSettingItem *item = arr[indexPath.row];
    [cell setSettingItem:item];

    return cell;
}


#pragma mark - Header&FooterInSection
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @" ";
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectZero];
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ViewBGC.png"]];
    
    return headerView;
    
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return @" ";
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectZero];
    footerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ViewBGC.png"]];
    
    return footerView;
    
}

#pragma mark 给定选项开关
-(void)switch1Changed:(UISwitch *)sender{
    if (sender.isOn) {
        _textItem.type = 1;
    }else{
        _textItem.type = 0;
    }
}
-(void)switch2Changed:(UISwitch *)sender{
    if (sender.isOn) {
        _datePicker.hidden = NO;
        [UIView beginAnimations:@"a" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:_datePicker cache:YES];
        [UIView setAnimationDuration:0.5];
        [UIView commitAnimations];
        _textItem.notifi = 1;
    }else{
        _datePicker.hidden = YES;
        _textItem.notifi = 0;
    }
}


#pragma mark 储存
-(void)DoneBtnClicked{
    
    _singletonModel = [SingletonModel shareSingletonModel];
    NSString *question = _singletonModel.question;
    _singletonModel.question = @"";
    
    if (![_db open]) {
        NSLog(@"Could not open db.");
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"数据库打开失败，请重试" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }else
        NSLog(@"db opened");
    
    //判断问题是否为空
    if ([question  isEqual: @""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"文本不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    //判断问题是否重复
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
        NSLog(@"Creat table DataList succeed!");
    }
    //查找
    NSString *result = [db stringForQuery:@"SELECT Question FROM DataList WHERE Question = ?",question];
    if (result) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"这条纪已经存在哦" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    
    if (_textItem.type) {
        
        //写入
        [_db executeUpdate:@"INSERT INTO DataList (Question, Type) VALUES (?,?)",question, @"switch"];
    
        
    }else
    {
        //写入
        [_db executeUpdate:@"INSERT INTO DataList (Question,Type) VALUES (?,?)",question,@"text"];

    }
    [_db close];

    
    
    //判断通知
    if (_textItem.notifi) {
        NotificationsMethods *notifimethod = [[NotificationsMethods alloc]init];
        [notifimethod setUserNotification:question withDate:_notificationTime andType:_textItem.type];
    }

    //成功记录了问题和问题类型
    [self dismissViewControllerAnimated:YES completion:^{
        [self->_backTVC refreshUI];
    }];
    
}

#pragma mark 取消
-(void)CancleBtnClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark 通知中心方法

- (void)receiveQuickReply:(NSNotification *)notification {
    
    _singletonModel = [SingletonModel shareSingletonModel];
    NSString *question = _singletonModel.question;
    NSString *qrText = [notification object];
    
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
    [db executeUpdate:@"UPDATE DataList SET AnswerT = ? WHERE Question = ?",qrText,question];
    
    //建立table
    if (![db tableExists:@"LogList"]) {
        
        [db executeUpdate:@"CREATE TABLE LogList (Question text, Time text, Answer text)"];
    }
    //获取当前日期
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年MM月dd日"];
    NSString *nowDay = [dateFormatter stringFromDate:currentDate];
    NSLog(@"当前日期:%@",nowDay);
    //写入
    [db executeUpdate:@"INSERT INTO LogList (Question,Time, Answer) VALUES (?,?,?)",question,nowDay,qrText];

    
    [db close];
    
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
