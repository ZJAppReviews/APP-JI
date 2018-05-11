//
//  TextTableViewCell.h
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
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
