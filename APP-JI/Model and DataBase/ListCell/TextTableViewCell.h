//
//  TextTableViewCell.h
//  APP-JI
//
//  Created by 魏大同 on 16/4/24.
//  Copyright © 2016年 魏大同. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextCellModel.h"

@protocol TextCellDelegate <NSObject>

-(void)pushBtnClicked2:(id)sender;
-(void)reloadCell:(id)sender;

@end

@interface TextTableViewCell : UITableViewCell <UITextViewDelegate>

@property (nonatomic,assign,readonly) CGFloat cellHeight;
@property (nonatomic,strong) TextCellModel *textModel;
@property (nonatomic,copy) NSString *questionStr;
@property (nonatomic,assign) id<TextCellDelegate>tDelegate;

-(void)pushBtnClicked:(UIButton *)sender;
+(NSString *)ID;
-(void)settingText;

@end
