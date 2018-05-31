//
//  ListTableViewController.h
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchLogTableViewController.h"



@interface ListTableViewController : UITableViewController<UITableViewDataSource>
//协议对象
-(void) refreshUI;
-(void) rightBtnClicked;

@end
