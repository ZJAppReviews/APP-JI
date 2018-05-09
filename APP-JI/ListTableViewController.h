//
//  ListTableViewController.h
//  APP-JI
//
//  Created by 魏大同 on 16/4/4.
//  Copyright © 2016年 魏大同. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextTableViewCell.h"
#import "SwitchTableViewCell.h"
#import "SwitchLogTableViewController.h"


@interface ListTableViewController : UITableViewController<UITableViewDataSource,SwitchCellDelegate,TextCellDelegate>
//协议对象

@end
