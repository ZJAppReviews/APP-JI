//
//  NewThemeSetTitleTableViewController.m
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/23.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import "NewThemeSetTitleTableViewController.h"
#import "DatabaseMethods.h"

@interface NewThemeSetTitleTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *questionTF;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Done;

@end

@implementation NewThemeSetTitleTableViewController

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
    NSString *questionStr = [_questionTF text];
    if([questionStr isEqualToString:@""]){
        [self aleartWithError:@"请填写主题"];
        return;
    }
    DatabaseMethods *dbmethod = [[DatabaseMethods alloc]init];
    if([dbmethod isQuestionRepeated:questionStr]){
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



@end
