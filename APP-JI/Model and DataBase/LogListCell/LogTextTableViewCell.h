//
//  LogTextTableViewCell.h
//  APP-JI
//
//  Created by 魏大同 on 16/4/28.
//  Copyright © 2016年 魏大同. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogTextCellModel.h"

@interface LogTextTableViewCell : UITableViewCell

@property (nonatomic,strong) LogTextCellModel *logtextModel;
@property (nonatomic,assign,readonly) CGFloat cellHeight;

+(NSString *)ID;
-(void)settingText;
@end
