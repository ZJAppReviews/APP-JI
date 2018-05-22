//
//  ListTableViewController.h
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextTableViewCell.h"
#import "SwitchTableViewCell.h"
#import "SwitchLogTableViewController.h"
#import "MainViewCell.h"


@interface ListTableViewController : UITableViewController<UITableViewDataSource,MainCellDelegate>
//协议对象
-(void) refreshUI;
-(void) rightBtnClicked;

@end
