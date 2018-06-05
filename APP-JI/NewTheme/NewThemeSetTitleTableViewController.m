//
//  NewThemeSetTitleTableViewController.m
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/23.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import "NewThemeSetTitleTableViewController.h"
#import "NewThemeSetTypeTableViewController.h"
#import "DailyLog-Swift.h"


@interface NewThemeSetTitleTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *questionTF;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Done;
@property (nonatomic,strong) NSString *questionStr;

@end

@implementation NewThemeSetTitleTableViewController

- (IBAction)baganEditing:(id)sender {
    _Done.enabled = true;
}

-(void)viewDidLoad{

    _questionTF.delegate = self;
    [_Done setAction:@selector(doneTyping)];
    
}

- (IBAction)Cancel:(UIBarButtonItem *)sender {
        [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self doneTyping];
    return YES;
}


-(void)doneTyping{
    _questionStr = [_questionTF text];
    if([_questionStr isEqualToString:@""]){
        [self aleartWithError:@"请填写主题"];
        return;
    }
    CoreDataMethods *dataMethod = [[CoreDataMethods alloc] init];
    if([dataMethod isThemeRepeatedWithTitle:_questionStr]){
        [self aleartWithError:@"已存在同名称主题，请修改后重试。"];
        return;
    }
    [self performSegueWithIdentifier:@"Theme2Type" sender:self];
    return;
}


-(void)aleartWithError:(NSString *)error{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:error preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    return;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"Theme2Type"]){
        NewThemeSetTypeTableViewController *setTypeController = segue.destinationViewController;
        setTypeController.questionStr = _questionStr;
    }
}

@end
