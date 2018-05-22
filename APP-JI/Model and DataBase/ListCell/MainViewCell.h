//
//  MainViewCell.h
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/15.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TextCellModel.h"


@interface MainViewCell : UITableViewCell

@property (nonatomic,assign,readonly) CGFloat cellHeight;//行高，在首页设置行高的方法中调用
@property (nonatomic,strong) TextCellModel *mainModel;//存储问题标签和内容的类，在初始化时被调用
@property (nonatomic,strong) NSString *questionStr;
//@property (nonatomic,assign) id<SwitchCellDelegate>sDelegate;



@end
