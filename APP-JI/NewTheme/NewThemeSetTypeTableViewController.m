//
//  NewThemeSetTypeTableViewController.m
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/24.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import "NewThemeSetTypeTableViewController.h"
#import "NewThemeNotificationTableViewController.h"

@interface NewThemeSetTypeTableViewController ()
@property (weak, nonatomic) IBOutlet UIButton *textType;
@property (weak, nonatomic) IBOutlet UIButton *photoType;
@property (weak, nonatomic) IBOutlet UIButton *switchType;
@property (weak, nonatomic) IBOutlet UIButton *videoType;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextStep;
@property (nonatomic,strong) NSString *typeStr;

@end

@implementation NewThemeSetTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_textType addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_textType setImage:[UIImage imageNamed:@"textBtnSelected"] forState:UIControlStateSelected];

    [_switchType addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_switchType setImage:[UIImage imageNamed:@"switchBtnSelected"] forState:UIControlStateSelected];

    [_photoType addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_photoType setImage:[UIImage imageNamed:@"photoBtnSelected"] forState:UIControlStateSelected];
    
    [_videoType addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_videoType setImage:[UIImage imageNamed:@"videoBtnSelected"] forState:UIControlStateSelected];
    
    _nextStep.enabled = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 列表中按钮的响应事件

-(void)BtnClicked:(UIButton *)button{

    _textType.selected = false;
    _switchType.selected = false;
    _photoType.selected = false;
    _videoType.selected = false;
    
    button.selected = true;
    _nextStep.enabled =true;
    
    if(button == _textType){
        _typeStr = @"text";
    }
    if(button == _switchType){
        _typeStr = @"switch";
    }
    if(button == _photoType){
        _typeStr = @"photo";
    }
    if(button == _videoType){
        _typeStr = @"video";
    }
    
    return;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"type2notification"]){
        NewThemeNotificationTableViewController *notifiController = segue.destinationViewController;
        notifiController.questionStr = _questionStr;
        notifiController.questionType = _typeStr;
    }
}

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
