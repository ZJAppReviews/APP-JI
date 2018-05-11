//
//  JITableViewCell.m
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import "JITableViewCell.h"
#import "CellSettingItem.h"
#import "CellSwitchItem.h"
#import "CellArrowItem.h"
#import "CellTextItem.h"
#import "SingletonModel.h"
#import "FMDB.h"

@implementation JITableViewCell

+(instancetype)initCellWithTableView:(UITableView *)tableView
{
    NSString *identify = @"cell";
    JITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[JITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    return cell;
}

#pragma mark cell的实现方法
-(void)setSettingItem:(CellSettingItem *)settingItem{
    _settingItem = settingItem;
    
    if ([settingItem isKindOfClass:[CellArrowItem class]]) {
        self.textLabel.text = settingItem.title;
        self.imageView.image = [UIImage imageNamed:settingItem.icon];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;   //显示最右边的箭头
        
    }else if ([settingItem isKindOfClass:[CellSwitchItem class]]){
        
        self.textLabel.text = settingItem.title;
        self.imageView.image = [UIImage imageNamed:settingItem.icon];
//      self.accessoryView = [[UISwitch alloc]init];
        
    }else if ([settingItem isKindOfClass:[CellTextItem class]]){
        
        CGRect fieldRect = CGRectMake(10, 0,[[UIScreen mainScreen]bounds].size.width-20, 44);
        _field =[[UITextField alloc]init];
        _field.frame = fieldRect;
        _field.placeholder = @"纪的内容(问题)";
        //_field.keyboardType = UIKeyboardAppearanceDefault;
        _field.returnKeyType = UIReturnKeyDone;
        _field.delegate = self;
        
        //field中每次string的改变都会调用textFieldEditChanged:方法将问题记录
        [_field addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:_field];
    }
}
#pragma mark 键盘&textfield的方法

//键盘回收事件
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark 记录问题题目
- (void)textFieldEditChanged:(UITextField *)textField

{
    CellTextItem *textItem = [[CellTextItem alloc]init];
    textItem.question = textField.text;
    SingletonModel *singModel = [SingletonModel shareSingletonModel];
    singModel.question = textField.text;


}
@end
