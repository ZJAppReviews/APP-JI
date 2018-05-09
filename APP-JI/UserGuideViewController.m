//
//  UserGuideViewController.m
//  APP-JI
//
//  Created by 魏大同 on 16/5/20.
//  Copyright © 2016年 魏大同. All rights reserved.
//

#import "UserGuideViewController.h"
#import "LoginViewController.h"

@interface UserGuideViewController ()

@property (nonatomic,strong) UIPageViewController *pageVC;
@property (nonatomic,strong) NSArray *arr;

@end

@implementation UserGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
//    // 实例化UIPageViewController对象，根据给定的属性
//    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
//                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
//                                                                        options: options];
//    // 设置UIPageViewController对象的代理
//    _pageVC.dataSource = self;
//    // 定义“这本书”的尺寸
//    [[_pageVC view] setFrame:[[self view] bounds]];
//    
//    // 让UIPageViewController对象，显示相应的页数据。
//    // UIPageViewController对象要显示的页数据封装成为一个NSArray。
//    // 因为我们定义UIPageViewController对象显示样式为显示一页（options参数指定）。
//    // 如果要显示2页，NSArray中，应该有2个相应页数据。
//    UIImageView *firstView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"firstin"]];// 得到第一页
//    NSArray *viewControllers =[NSArray arrayWithObject:initialViewController];
//    [_pageVC setViewControllers:viewControllers
//                              direction:UIPageViewControllerNavigationDirectionForward
//                               animated:NO
//                             completion:nil];
//
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
