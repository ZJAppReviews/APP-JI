//
//  JITableViewCell.h
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellSettingItem;

@interface JITableViewCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic,strong) CellSettingItem *settingItem;
@property (nonatomic,strong) UITextField *field;

+(instancetype)initCellWithTableView:(UITableView *)tableView;

@end
