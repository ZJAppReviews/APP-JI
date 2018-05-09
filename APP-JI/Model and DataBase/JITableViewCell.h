//
//  JITableViewCell.h
//  APP-JI
//
//  Created by 魏大同 on 16/4/4.
//  Copyright © 2016年 魏大同. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellSettingItem;

@interface JITableViewCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic,strong) CellSettingItem *settingItem;
@property (nonatomic,strong) UITextField *field;

+(instancetype)initCellWithTableView:(UITableView *)tableView;

@end
