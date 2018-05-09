//
//  SwitchTableViewCell.h
//  APP-JI
//
//  Created by 魏大同 on 16/4/24.
//  Copyright © 2016年 魏大同. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextCellModel.h"

@protocol SwitchCellDelegate <NSObject>

-(void)pushtoSwitchLog2:(id)sender;

@end



@interface SwitchTableViewCell : UITableViewCell

@property (nonatomic,strong) TextCellModel *switchModel;
@property (nonatomic,assign,readonly) CGFloat cellHeight;
@property (nonatomic,strong) NSString *questionStr;
@property (nonatomic,assign) id<SwitchCellDelegate>sDelegate;

-(void)pushtoSwitchLog:(UIButton *)sender;
+(NSString *)ID;
-(void)settingText;

@end
