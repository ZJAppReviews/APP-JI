//
//  LogTextTableViewCell.h
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogTextCellModel.h"

@interface LogTextTableViewCell : UITableViewCell

@property (nonatomic,strong) LogTextCellModel *logtextModel;
@property (nonatomic,assign,readonly) CGFloat cellHeight;

+(NSString *)ID;
-(void)settingText;
@end
