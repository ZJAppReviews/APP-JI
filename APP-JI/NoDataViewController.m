//
//  NoDataViewController.m
//  APP-JI
//
//  Created by 魏大同 on 16/3/28.
//  Copyright © 2016年 魏大同. All rights reserved.
//

#import "NoDataViewController.h"
#import "AddJITableViewController.h"
#import "CellTextItem.h"

@interface NoDataViewController ()

@end

@implementation NoDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self.navigationController setNavigationBarHidden:NO];
    
    self.title = @"纪";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightBtnClicked)];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    leftBtn.enabled = NO;
    self.navigationItem.rightBarButtonItem = rightBtn;
    self.navigationItem.leftBarButtonItem = leftBtn;
//    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"NavBGC.png"]];
//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    
    UIImage *noDataImg = [UIImage imageNamed:@"NoDataVC.png"];
    UIImageView *noDataImgV = [[UIImageView alloc]initWithImage:noDataImg];
    noDataImgV.frame = CGRectMake(0, 185, [[UIScreen mainScreen]bounds].size.width, 240);
    [self.view addSubview:noDataImgV];
    
    UIImage *backGC = [UIImage imageNamed:@"ViewBGC.png"];
    UIColor *imageColor = [UIColor colorWithPatternImage:backGC];       //根据图片生成颜色
    self.view.backgroundColor = imageColor;
    
    //新建一个纪
    UIButton *newJIBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    newJIBtn.frame = CGRectMake([[UIScreen mainScreen]bounds].size.width/2-80, 440, 160, 50);
    [newJIBtn setBackgroundImage:[UIImage imageNamed:@"AddNewJI.png"] forState:UIControlStateNormal];
    [newJIBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];//监听
    [self.view addSubview:newJIBtn];
}

-(void)rightBtnClicked
{
    AddJITableViewController *addTVC = [[AddJITableViewController alloc]init];
    [self.navigationController pushViewController:addTVC animated:NO];//调用自己的视图控制器把新建的视图推出来

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
