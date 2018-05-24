//
//  NewThemeNotificationTableViewController.m
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/24.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import "NewThemeNotificationTableViewController.h"
#import "NotificationsMethods.h"
#import "DatabaseMethods.h"

@interface NewThemeNotificationTableViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (nonatomic,strong) NSIndexPath *pickerPath;
@property (nonatomic,strong) NSMutableArray *pickerArr;
@property (nonatomic,strong) NSDateComponents *notificationTime;


@end

@implementation NewThemeNotificationTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [_notificationSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    //初始化记录时间的类
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    _notificationTime = [greCalendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate date]];
    
    //根据行获取放置TimePicker的NSIndexPath,启始为0，为隐藏方法提供路径
    _pickerPath =  [NSIndexPath indexPathForRow:1 inSection:0];
    _pickerArr = [[NSMutableArray alloc]init];
    [_pickerArr addObject:_pickerPath];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 开关变动方法
-(void)switchChanged:(id)sender{
    
    if(_notificationSwitch.isOn){
        [self.tableView reloadRowsAtIndexPaths:_pickerArr withRowAnimation:UITableViewRowAnimationBottom];
    }else{
        [self.tableView reloadRowsAtIndexPaths:_pickerArr withRowAnimation:UITableViewRowAnimationFade];
    }

}


- (IBAction)Done:(id)sender {
    
    //设置通知
    NSDate *date = _timePicker.date;
    NSDateFormatter *hh = [[NSDateFormatter alloc]init];
    NSDateFormatter *mm = [[NSDateFormatter alloc]init];
    [hh setDateFormat:@"HH"];
    [mm setDateFormat:@"mm"];
    _notificationTime.hour = [[hh stringFromDate:date] intValue];
    _notificationTime.minute = [[mm stringFromDate:date] intValue];
    
    if(_notificationSwitch.isOn){
        NotificationsMethods *notifiMethod = [[NotificationsMethods alloc]init];
        [notifiMethod setUserNotification:_questionStr withDate:_notificationTime andType:_questionType];
    }
    
    //写入数据
    DatabaseMethods *dbMethod =[[DatabaseMethods alloc]init];
    [dbMethod addQuestion:_questionStr andType:_questionType];
    
    //干掉视图
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


/*#pragma mark - Table view data source
 
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 return 1;
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
 return 2;
 }
 
*/



/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aaa" forIndexPath:indexPath];
    
    if(indexPath.row == 2){
        
    }
    return cell;
}*/


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
