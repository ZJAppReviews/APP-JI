//
//  AddJITableViewController.h
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellSettingItem.h"
#import "CellSwitchItem.h"
#import "CellArrowItem.h"
#import "JITableViewCell.h"
#import "CellTextItem.h"
#import "ListTableViewController.h"


@interface AddJITableViewController : UITableViewController

@property (nonatomic,strong) JITableViewCell *jiTVCell;
@property (nonatomic,strong) CellTextItem *textItem;
@property (nonatomic,strong) ListTableViewController *backTVC;


@end
