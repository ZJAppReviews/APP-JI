//
//  EditTableViewController.h
//  APP-JI
//
//  Created by 魏大同 on 16/7/22.
//  Copyright © 2016年 魏大同. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellSettingItem.h"
#import "CellSwitchItem.h"
#import "CellArrowItem.h"
#import "JITableViewCell.h"
#import "CellTextItem.h"

@interface EditTableViewController : UITableViewController

@property (nonatomic,strong) JITableViewCell *jiTVCell;
@property (nonatomic,strong) CellTextItem *textItem;
@property (nonatomic,strong) NSString *question;

@end
