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

@protocol MainCellDelegate <NSObject>

-(void)pushClickedWithQuestion:(NSString *)question;
-(void)reloadCell:(id)sender;
-(void)refreshUI;

@end

@interface MainViewCell : UITableViewCell <UITextViewDelegate>

@property (nonatomic,assign,readonly) CGFloat cellHeight;//行高，在首页设置行高的方法中调用
@property (nonatomic,strong) TextCellModel *mainModel;//存储问题标签和内容的类，在初始化时被调用
@property (nonatomic,assign) id<MainCellDelegate>Delegate;

+(NSString *)ID;
-(void)settingText;



@end
