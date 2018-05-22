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

@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UITextView *contentTV;
@property (nonatomic,strong) UIButton *pushBtn;//首页的文字类型纪输入完之后引导进入记录详情页的按钮




@end


@implementation MainViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
      if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
          
      }
    return self;
}

-(void)settingText{
    
    NSLog(@"%@,%@,%@",_mainModel.type,_mainModel.question,_mainModel.answer);
    
    //设置元件的背景
    _bgLab = [[UILabel alloc]init];
    _bgLab.backgroundColor = [UIColor colorWithRed:249/255.0 green:204/255.0 blue:60/255.0 alpha:1.0];
    [_bgLab.layer setCornerRadius:10];
    _bgLab.layer.masksToBounds = YES;
    [self.contentView addSubview:_bgLab];
    
    //设置标题
    _titleLab = [[UILabel alloc]init];
    _titleLab.font = [UIFont boldSystemFontOfSize:21];
    _titleLab.frame = CGRectMake(28, 23, [[UIScreen mainScreen]bounds].size.width-56, 26);
    _titleLab.numberOfLines = 1;
    _titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleLab.textColor = [UIColor blackColor];
    [self.contentView addSubview:_titleLab];
    _titleLab.text = _mainModel.question;

    
    if([_mainModel.type isEqualToString:@"switch"]){

        _yesBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.contentView addSubview:_yesBtn];
        [_yesBtn addTarget:self action:@selector(yesBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_yesBtn setTitle:@"是" forState:UIControlStateNormal];
        _yesBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _yesBtn.titleLabel.font = [UIFont systemFontOfSize:53 weight:UIFontWeightBold];
        [_yesBtn.layer setCornerRadius:7];

        
        _noBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.contentView addSubview:_noBtn];
        [_noBtn addTarget:self action:@selector(noBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_noBtn setTitle:@"不是" forState:UIControlStateNormal];
        _noBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _noBtn.titleLabel.font = [UIFont systemFontOfSize:53 weight:UIFontWeightBold];
        [_noBtn.layer setCornerRadius:7];
        
        _cellHeight = 242;


        if(_mainModel.answer){

            if ([_mainModel.answer  isEqualToString:@"yes"]) {

                _noBtn.hidden = YES;
                _yesBtn.frame = CGRectMake(28,57,([[UIScreen mainScreen]bounds].size.width)/2-56,162);
                [_yesBtn setBackgroundColor:[UIColor colorWithRed:167/255.0 green:134/255.0 blue:27/255.0 alpha:1.0]];
                [_yesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
            }else if ([_mainModel.answer isEqualToString:@"no"]){

                _yesBtn.hidden = YES;
                _noBtn.frame = CGRectMake(28,57,([[UIScreen mainScreen]bounds].size.width)/2-56,162);
                [_noBtn setBackgroundColor:[UIColor colorWithRed:167/255.0 green:134/255.0 blue:27/255.0 alpha:1.0]];
                [_noBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
            }
            
        }else{

            _yesBtn.frame = CGRectMake(28,57,([[UIScreen mainScreen]bounds].size.width)/2-33.5,162);
            [_yesBtn setBackgroundColor:[UIColor colorWithRed:254/255.0 green:226/255.0 blue:122/255.0 alpha:1.0]];
            [_yesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _noBtn.frame = CGRectMake(([[UIScreen mainScreen]bounds].size.width)/2+5.5,57,([[UIScreen mainScreen]bounds].size.width)/2-33.5,162);
            [_noBtn setBackgroundColor:[UIColor colorWithRed:254/255.0 green:226/255.0 blue:122/255.0 alpha:1.0]];
            [_noBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];


            
        }

    }else if ([_mainModel.type isEqualToString:@"text"]){

        if(_mainModel.answer){

            _contentLab = [[UILabel alloc]init];
            [_contentLab setBackgroundColor:[UIColor colorWithRed:167/255.0 green:134/255.0 blue:27/255.0 alpha:1.0]];
            [_contentLab.layer setCornerRadius:7];
            [self.contentView addSubview:_contentLab];
            
            //计算文本需要占用的物理尺寸
            CGSize answerSize = [_mainModel.answer boundingRectWithSize:CGSizeMake([[UIScreen mainScreen]bounds].size.width-56, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
            _contentLab.frame = CGRectMake(28,57,[[UIScreen mainScreen]bounds].size.width-56, answerSize.height);
            
            _contentLab.text = _mainModel.answer;
            _contentLab.numberOfLines = 0;
            _contentLab.font = [UIFont systemFontOfSize:17];
            _contentLab.textColor = [UIColor whiteColor];

            _cellHeight = CGRectGetMaxY(_contentLab.frame)+80;

            _pushBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            _pushBtn.frame = CGRectMake(10, 10, [[UIScreen mainScreen]bounds].size.width-20, _cellHeight-20);
            [_pushBtn addTarget:self action:@selector(pushBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            _pushBtn.hidden = YES;
            _pushBtn.enabled = NO;
            [self.contentView addSubview:_pushBtn];
            
            
            
        }else{
            
            _contentTV = [[UITextView alloc]init];
            _contentTV.font = [UIFont systemFontOfSize:17];
            _contentTV.frame = CGRectMake(28, 57, [[UIScreen mainScreen]bounds].size.width-56, 162);
            [_contentTV.layer setCornerRadius:7];
            [_contentTV setBackgroundColor:[UIColor colorWithRed:254/255.0 green:226/255.0 blue:122/255.0 alpha:1.0]];
//            _contentTV.delegate = self;
            
            UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
            keyboardDoneButtonView.barStyle = UIBarStyleDefault;
            keyboardDoneButtonView.tintColor = [UIColor clearColor];
            keyboardDoneButtonView.translucent = YES;
            [keyboardDoneButtonView sizeToFit];
            UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(pickerCancelClicked)];
            cancelButton.tintColor = [UIColor redColor];
            UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];// 让完成按钮显示在右侧
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(pickerDoneClicked)];
            doneButton.tintColor = [UIColor colorWithRed:0.098 green:0.512 blue:0.99 alpha:1.0];
            [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:cancelButton, spaceButton ,doneButton, nil]];
            _contentTV.inputAccessoryView = keyboardDoneButtonView;
            [self.contentView addSubview:_contentTV];
            
            _cellHeight = 242;
            
        }
    }
    
    _bgLab.frame = CGRectMake(16, 10, [[UIScreen mainScreen]bounds].size.width-32, _cellHeight-20);

}


+(NSString *)ID{
    return @"Main";
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
