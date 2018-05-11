//
//  SwitchTableViewCell.m
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import "SwitchTableViewCell.h"
#import "ListLogSM.h"
#import "Masonry.h"
#import "FMDB.h"
#import <UIKit/UIKit.h>

@interface SwitchTableViewCell()

@property (nonatomic,strong) UILabel *questionLab;
@property (nonatomic,strong) UIButton *yesBtn;
@property (nonatomic,strong) UIButton *noBtn;
@property (nonatomic,strong) UIButton *pushBtn;
@property (nonatomic,strong) UILabel *answerLab;

@end


@implementation SwitchTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _cellHeight = 180;
        
        UILabel *bgLab = [[UILabel alloc]init];
        bgLab.frame = CGRectMake(10, 10, [[UIScreen mainScreen]bounds].size.width-20, _cellHeight-20);
        bgLab.layer.borderWidth = 1.5;
        bgLab.layer.borderColor = [[UIColor colorWithRed:0.01 green:0.01 blue:0.01 alpha:0.9] CGColor];
        bgLab.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CellBGC2.png" ]];
        bgLab.enabled = NO;
        [self.contentView addSubview:bgLab];
        
        _questionLab = [[UILabel alloc]init];
        _questionLab.frame = CGRectMake(22, 20, [[UIScreen mainScreen]bounds].size.width-60, 50);
        [self.contentView addSubview:_questionLab];
        
        
        _yesBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.contentView addSubview:_yesBtn];
        [_yesBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self->_questionLab).with.offset(50);
            make.left.equalTo(self.contentView).with.offset(20);
            make.width.mas_equalTo(([[UIScreen mainScreen]bounds].size.width)/2-30);
            make.height.mas_equalTo(@80);
        }];
        [_yesBtn addTarget:self action:@selector(yesBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_yesBtn setBackgroundImage:[UIImage imageNamed:@"ViewBGC.png"] forState:UIControlStateNormal];
        [_yesBtn setTitle:@"有!" forState:UIControlStateNormal];
        _yesBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_yesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _yesBtn.titleLabel.font = [UIFont systemFontOfSize:25 weight:UIFontWeightBold];
        
        
        _noBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.contentView addSubview:_noBtn];
        [_noBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self->_questionLab).with.offset(50);
            make.right.equalTo(self.contentView).with.offset(-20);
            make.width.mas_equalTo(([[UIScreen mainScreen]bounds].size.width)/2-30);
            make.height.mas_equalTo(@80);
        }];
        [_noBtn addTarget:self action:@selector(noBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_noBtn setTitle:@"没有!" forState:UIControlStateNormal];
        [_noBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _noBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_noBtn setBackgroundImage:[UIImage imageNamed:@"ViewBGC.png"] forState:UIControlStateNormal];
        _noBtn.titleLabel.font = [UIFont systemFontOfSize:25 weight:UIFontWeightBold];
        
        
        _answerLab = [[UILabel alloc]init];
        _answerLab.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CellBGC.png"]];
        [self.contentView addSubview:_answerLab];
        _answerLab.hidden = YES;
    
        
        _pushBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _pushBtn.frame = CGRectMake(10, 0, [[UIScreen mainScreen]bounds].size.width-110, _cellHeight);
        [_pushBtn addTarget:self action:@selector(pushtoSwitchLog:) forControlEvents:UIControlEventTouchUpInside];
        
        _pushBtn.hidden = YES;
        _pushBtn.enabled = NO;
        [self.contentView addSubview:_pushBtn];
    }
    
    return self;
}

-(void)pushtoSwitchLog:(UIButton *)sender{
    
    
    ListLogSM *sm = [ListLogSM shareSingletonModel];
    sm.question = _questionStr;
    
    [self.sDelegate pushtoSwitchLog2:self];
}


-(void)settingText{
    _questionLab.text = _switchModel.question;
    _questionStr = _switchModel.question;
    _questionLab.font = [UIFont systemFontOfSize:25];
    
    CGSize questionSize = [_switchModel.question boundingRectWithSize:CGSizeMake([[UIScreen mainScreen]bounds].size.width-60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size;
    
    _questionLab.frame = CGRectMake(20, 20, [[UIScreen mainScreen]bounds].size.width-60, questionSize.height+5);
    _questionLab.numberOfLines = 0;
    _answerLab.frame = CGRectMake(20, CGRectGetMaxY(_questionLab.frame)+10, [[UIScreen mainScreen]bounds].size.width-40, 100);
    
    
    //设置是否两个按钮的大小
    [_yesBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self->_questionLab).with.offset(50);
        make.left.equalTo(self.contentView).with.offset(20);
        make.width.mas_equalTo(([[UIScreen mainScreen]bounds].size.width)/2-30);
        make.height.mas_equalTo(@80);
    }];
    [_noBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self->_questionLab).with.offset(50);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.width.mas_equalTo(([[UIScreen mainScreen]bounds].size.width)/2-30);
        make.height.mas_equalTo(@80);
    }];

    if (_switchModel.answer) {
        if ([_switchModel.answer  isEqualToString:@"yes"]) {
            _yesBtn.enabled = NO;
            _noBtn.enabled = NO;
            _yesBtn.hidden = YES;
            _noBtn.hidden = YES;
            _answerLab.hidden = NO;
            _answerLab.text = @"有!";
            _answerLab.textAlignment = NSTextAlignmentCenter;
            _answerLab.textColor = [UIColor whiteColor];
            _answerLab.font = [UIFont systemFontOfSize:55 weight:UIFontWeightBold];

            
        }else if ([_switchModel.answer isEqualToString:@"no"]){
            _yesBtn.enabled = NO;
            _noBtn.enabled = NO;
            _yesBtn.hidden = YES;
            _noBtn.hidden = YES;
            _answerLab.hidden = NO;
            _answerLab.text = @"没有!";
            _answerLab.textAlignment = NSTextAlignmentCenter;
            _answerLab.textColor = [UIColor whiteColor];
            _answerLab.font = [UIFont systemFontOfSize:55 weight:UIFontWeightBold];
        }
        _pushBtn.enabled = YES;
        _pushBtn.hidden = NO;
        
    }
}

-(void)yesBtnClicked{
    _yesBtn.enabled = NO;
    _noBtn.enabled = NO;
    _yesBtn.hidden = YES;
    _noBtn.hidden = YES;
    _answerLab.hidden = NO;
    _answerLab.text = @"有!";
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
    [db executeUpdate:@"UPDATE DataList SET AnswerT = ? WHERE Question = ?",@"yes",_questionStr];
    
    //找地址
    NSString *answer = [db stringForQuery:@"SELECT AnswerT FROM DataList WHERE Question = ?",_questionStr];
    
    NSLog(@"switch %@",answer);
    
    //建立table
    if (![db tableExists:@"LogList"]) {
        
        [db executeUpdate:@"CREATE TABLE LogList (Question text, Time text, Answer text)"];
    }
    
    //写入
    [db executeUpdate:@"INSERT INTO LogList (Question,Time, Answer) VALUES (?,?,?)",_questionStr,nowDay,@"yes"];


    [db close];
    
    _pushBtn.enabled = YES;
    _pushBtn.hidden = NO;

   // [self reloadCell];

}

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
    NSString *answer = [db stringForQuery:@"SELECT AnswerT FROM DataList WHERE Question = ?",_questionStr];
    
    NSLog(@"switch %@",answer);
    
    //建立table
    if (![db tableExists:@"LogList"]) {
        
        [db executeUpdate:@"CREATE TABLE LogList (Question text, Time text, Answer text)"];
    }
    
    //写入
    [db executeUpdate:@"INSERT INTO LogList (Question,Time, Answer) VALUES (?,?,?)",_questionStr,nowDay,@"no"];
    
    [db close];
    _pushBtn.enabled = YES;
    _pushBtn.hidden = NO;

//    [self reloadCell];
//    [self settingText];
    
}

+(NSString *)ID{
    return @"Switch";
}
@end
