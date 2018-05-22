//
//  MainViewCell.m
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/15.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import "MainViewCell.h"
#import "Masonry.h"
#import "FMDB.h"
#import <UIKit/UIKit.h>

@interface MainViewCell ()

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *bgLab;

@property (nonatomic,strong) UIButton *yesBtn;
@property (nonatomic,strong) UIButton *noBtn;

@property (nonatomic,strong) UILabel *answerLab;


@end


@implementation MainViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
      if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
          
          //设置元件的背景
          _bgLab = [[UILabel alloc]init];
          _bgLab.backgroundColor = [UIColor colorWithRed:249/255.0 green:204/255.0 blue:60/255.0 alpha:1.0];
          [_bgLab.layer setCornerRadius:10];
          _bgLab.layer.masksToBounds = YES;
          //_bgLab.enabled = NO;
          [self.contentView addSubview:_bgLab];
          
          //设置标题
          _titleLab = [[UILabel alloc]init];
          _titleLab.font = [UIFont boldSystemFontOfSize:21];
          _titleLab.frame = CGRectMake(28, 23, [[UIScreen mainScreen]bounds].size.width-56, 30);
          _titleLab.numberOfLines = 1;
          [self.contentView addSubview:_titleLab];
          
      }
    return 0;
}

-(void)settingText{
    
    if([_mainModel.type isEqualToString:@"switch"]){

        _yesBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.contentView addSubview:_yesBtn];
        
        if(_mainModel.answer){
//接下来应该尝试把这边改成btn
//            _yesBtn.enabled = NO;
//            _noBtn.enabled = NO;
//            _yesBtn.hidden = YES;
//            _noBtn.hidden = YES;
            _answerLab.hidden = NO;
            _answerLab.textAlignment = NSTextAlignmentCenter;
            _answerLab.textColor = [UIColor whiteColor];
            _answerLab.font = [UIFont systemFontOfSize:53 weight:UIFontWeightBold];
            
            if ([_mainModel.answer  isEqualToString:@"yes"]) {

                _answerLab.text = @"有!";
                
            }else if ([_mainModel.answer isEqualToString:@"no"]){

                _answerLab.text = @"没有!";
                
            }
            
        }else{

            _yesBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [self.contentView addSubview:_yesBtn];
/*            [_yesBtn mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.equalTo(self.contentView).with.offset(57);
                make.left.equalTo(self.contentView).with.offset(28);
                make.width.mas_equalTo(([[UIScreen mainScreen]bounds].size.width)/2-33.5);
                make.height.mas_equalTo(@162);
            }];*/
            _yesBtn.frame = CGRectMake(28, 57, 162,([[UIScreen mainScreen]bounds].size.width)/2-33.5);
            [_yesBtn setBackgroundColor:[UIColor colorWithRed:254/255.0 green:226/255.0 blue:122/255.0 alpha:1.0]];
            [_yesBtn addTarget:self action:@selector(yesBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [_yesBtn setTitle:@"是" forState:UIControlStateNormal];
            _yesBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            _yesBtn.titleLabel.font = [UIFont systemFontOfSize:53 weight:UIFontWeightBold];
            [_yesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            _noBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [self.contentView addSubview:_noBtn];
/*            [_noBtn mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.equalTo(self->_titleLab).with.offset(57);
                make.right.equalTo(self.contentView).with.offset(-28);
                make.width.mas_equalTo(([[UIScreen mainScreen]bounds].size.width)/2-33.5);
                make.height.mas_equalTo(@162);
            }];*/
            _yesBtn.frame = CGRectMake(([[UIScreen mainScreen]bounds].size.width)/2+5.5, 57, 162,([[UIScreen mainScreen]bounds].size.width)/2-33.5);
            [_noBtn setBackgroundColor:[UIColor colorWithRed:254/255.0 green:226/255.0 blue:122/255.0 alpha:1.0]];
            [_noBtn addTarget:self action:@selector(noBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [_noBtn setTitle:@"不是" forState:UIControlStateNormal];
            _noBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            _noBtn.titleLabel.font = [UIFont systemFontOfSize:53 weight:UIFontWeightBold];
            [_noBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

            
        }

    }
    
}
/*
-(void)noBtnClicked{
        _yesBtn.enabled = NO;
        _noBtn.enabled = NO;
        _yesBtn.hidden = YES;
        _noBtn.hidden = YES;
        _answerLab.hidden = NO;
        _answerLab.text = @"没有!";
        _answerLab.textAlignment = NSTextAlignmentCenter;
        _answerLab.textColor = [UIColor whiteColor];
        _answerLab.font = [UIFont systemFontOfSize:55 weight:UIFontWeightBold];
        _answerLab.frame = CGRectMake(20, CGRectGetMaxY(_questionLab.frame)+10, [[UIScreen mainScreen]bounds].size.width-60, 100);
        //获取当前日期
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY年MM月dd日"];
        NSString *nowDay = [dateFormatter stringFromDate:currentDate];
        NSLog(@"当前日期:%@",nowDay);
        
        // 建立资料库
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"JIDatabase.db"];
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath] ;
        if (![db open]) {
            NSLog(@"Could not open db.");
            return ;
        }else
            NSLog(@"db opened");
        
        //写入
        [db executeUpdate:@"UPDATE DataList SET AnswerT = ? WHERE Question = ?",@"no",_questionStr];
        
        //找地址
        //   [db stringForQuery:@"SELECT AnswerT FROM DataList WHERE Question = ?",_questionStr];
        
        //建立table
        if (![db tableExists:@"LogList"]) {
            [db executeUpdate:@"CREATE TABLE LogList (Question text, Time text, Answer text)"];
        }
        
        //写入
        [db executeUpdate:@"INSERT INTO LogList (Question,Time, Answer) VALUES (?,?,?)",_questionStr,nowDay,@"no"];
        
        [db close];
        _pushBtn.enabled = YES;
        _pushBtn.hidden = NO;
        
        
        
    }*/

    
/*    _titleLab.text = _switchModel.question;
    _questionStr = _switchModel.question;
    _questionLab.font = [UIFont systemFontOfSize:25];
    
    CGSize questionSize = [_switchModel.question boundingRectWithSize:CGSizeMake([[UIScreen mainScreen]bounds].size.width-60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size;
    
    _questionLab.frame = CGRectMake(20, 20, [[UIScreen mainScreen]bounds].size.width-60, questionSize.height+5);
    _questionLab.numberOfLines = 0;
    _answerLab.frame = CGRectMake(20, CGRectGetMaxY(_questionLab.frame)+10, [[UIScreen mainScreen]bounds].size.width-40, 100);
    
    
    //设置是否两个按钮的大小*/




@end
