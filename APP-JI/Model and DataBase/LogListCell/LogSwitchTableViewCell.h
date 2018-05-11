//
//  LogSwitchTableViewCell.h
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogSwitchCellModel.h"

@interface LogSwitchTableViewCell : UITableViewCell

@property (nonatomic,strong) LogSwitchCellModel *logswitchModel;
@property (nonatomic,assign,readonly) CGFloat cellHeight;

+(NSString *)ID;
-(void)settingText;

@end
