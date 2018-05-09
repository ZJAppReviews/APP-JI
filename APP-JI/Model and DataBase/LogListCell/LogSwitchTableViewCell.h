//
//  LogSwitchTableViewCell.h
//  APP-JI
//
//  Created by 魏大同 on 16/4/28.
//  Copyright © 2016年 魏大同. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogSwitchCellModel.h"

@interface LogSwitchTableViewCell : UITableViewCell

@property (nonatomic,strong) LogSwitchCellModel *logswitchModel;
@property (nonatomic,assign,readonly) CGFloat cellHeight;

+(NSString *)ID;
-(void)settingText;

@end
