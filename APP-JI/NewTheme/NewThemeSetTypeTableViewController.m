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
@property (weak, nonatomic) IBOutlet UILabel *switchBG;
@property (weak, nonatomic) IBOutlet UILabel *switchLab;
@property (weak, nonatomic) IBOutlet UILabel *textBG;
@property (weak, nonatomic) IBOutlet UILabel *textLaB;
@property (weak, nonatomic) IBOutlet UILabel *photoLab;
@property (weak, nonatomic) IBOutlet UILabel *photoBG;
@property (weak, nonatomic) IBOutlet UILabel *videoLab;
@property (weak, nonatomic) IBOutlet UILabel *videoBG;
@property (strong, nonatomic) NSArray *describeLab;
@property (strong, nonatomic) NSArray *describeBG;
@property (strong, nonatomic) NSArray *describeBtn;


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
    
    _describeLab = [[NSArray alloc] initWithObjects:_switchLab,_textLaB,_photoLab,_videoLab,nil];
    _describeBG = [[NSArray alloc] initWithObjects:_switchBG,_textBG,_photoBG,_videoBG,nil];
    _describeBtn =[[NSArray alloc] initWithObjects:_switchType,_textType,_photoType,_videoType, nil];
    
    for (UILabel * obj in _describeBG){
        [obj.layer setCornerRadius:17];
        obj.layer.masksToBounds = YES;
    }
    
    _nextStep.enabled = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 列表中按钮的响应事件

-(void)BtnClicked:(UIButton *)button{

    for (UIButton *Btn in _describeBtn){
        Btn.selected = false;
        Btn.enabled = true;
    }
    
    for (UILabel *lab in _describeBG){
        lab.backgroundColor = [UIColor whiteColor];
    }
    
    for (UILabel *lab in _describeLab){
        lab.textColor = [UIColor blackColor];
    }
    
    button.selected = true;
    _nextStep.enabled =true;
    
    if(button == _textType){
        _typeStr = @"text";
        _textLaB.textColor = [UIColor whiteColor];
        _textBG.backgroundColor = [UIColor colorWithRed:168/255.0 green:135/255.0 blue:0 alpha:1];
    }
    if(button == _switchType){
        _typeStr = @"switch";
        _switchLab.textColor = [UIColor whiteColor];
        _switchBG.backgroundColor = [UIColor colorWithRed:168/255.0 green:135/255.0 blue:0 alpha:1];
    }
    if(button == _photoType){
        _typeStr = @"photo";
        _photoLab.textColor = [UIColor whiteColor];
        _photoBG.backgroundColor = [UIColor colorWithRed:168/255.0 green:135/255.0 blue:0 alpha:1];
    }
    if(button == _videoType){
        _typeStr = @"video";
        _videoLab.textColor = [UIColor whiteColor];
        _videoBG.backgroundColor = [UIColor colorWithRed:168/255.0 green:135/255.0 blue:0 alpha:1];
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
