//
//  TextTableViewCell.m
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import "TextTableViewCell.h"
#import "TextLogTableViewController.h"
#import "ListTableViewController.h"
#import "ListLogSM.h"
#import "FMDB.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


@interface TextTableViewCell()

@property (nonatomic,strong) UILabel *questionLab;//问题的标签，左对齐22点
@property (nonatomic,strong) UITextView *answerTV;//答案的输入框（棕色背景），左对齐20点
@property (nonatomic,strong) UILabel *answerLab;//有答案时的答案内容，左对齐30点
@property (nonatomic,strong) UIButton *pushBtn;//首页的文字类型纪输入完之后引导进入记录详情页的按钮
@property (nonatomic,strong) NSMutableArray *quesArr;
@property (nonatomic,strong) UILabel *bgLab;//首页的文字类型纪的背景，左对齐10点


@end

@implementation TextTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _bgLab = [[UILabel alloc]init];
//        _bgLab.layer.borderWidth = 1.5;

//        _bgLab.layer.borderColor = [[UIColor colorWithRed:0.01 green:0.01 blue:0.01 alpha:0.9] CGColor];

        _bgLab.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CellBGC2.png" ]];
        [_bgLab.layer setCornerRadius:10];
        _bgLab.layer.masksToBounds = YES;

        _bgLab.enabled = NO;
        [self.contentView addSubview:_bgLab];

        
        _questionLab = [[UILabel alloc]init];
        _questionLab.font = [UIFont boldSystemFontOfSize:21];
        _questionLab.frame = CGRectMake(28, 23, [[UIScreen mainScreen]bounds].size.width-56, 26);
        _questionLab.numberOfLines = 1;
        _questionLab.lineBreakMode = NSLineBreakByTruncatingTail;

        [self.contentView addSubview:_questionLab];
        
        _answerTV = [[UITextView alloc]init];
        _answerTV.font = [UIFont systemFontOfSize:17];
        _answerTV.frame = CGRectMake(28, 57, [[UIScreen mainScreen]bounds].size.width-56, 162);
        _answerTV.tag = 1001;
        [_answerTV.layer setCornerRadius:7];
        _answerTV.layer.contents = (id)[UIImage imageNamed:@"TextViewBGC.png"].CGImage; //给图层添加背景图片
       
        _answerTV.delegate = self;
        
        // 键盘上方附加一个toolbar，toolbar上有个完成按钮
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        keyboardDoneButtonView.barStyle = UIBarStyleDefault;
        keyboardDoneButtonView.tintColor = [UIColor clearColor];
        keyboardDoneButtonView.translucent = YES;
        [keyboardDoneButtonView sizeToFit];

        // toolbar上的2个按钮
        UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(pickerCancelClicked)];
        cancelButton.tintColor = [UIColor redColor];
        UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];// 让完成按钮显示在右侧
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(pickerDoneClicked)];
        doneButton.tintColor = [UIColor colorWithRed:0.098 green:0.512 blue:0.99 alpha:1.0];
        
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:cancelButton, spaceButton ,doneButton, nil]];
        _answerTV.inputAccessoryView = keyboardDoneButtonView;
        
        [self.contentView addSubview:_answerTV];
        
        _answerLab = [[UILabel alloc]init];
        _answerLab.font = [UIFont systemFontOfSize:17];
        _answerLab.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_answerLab];
        
        _cellHeight = CGRectGetMaxY(_answerTV.frame)+30;

        
        _pushBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //这里是设置隐形触发区域大小的地方
        _pushBtn.frame = CGRectMake(10, 10, [[UIScreen mainScreen]bounds].size.width-20, _cellHeight-20);
        [_pushBtn addTarget:self action:@selector(pushBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _pushBtn.hidden = YES;
        _pushBtn.enabled = NO;
        [self.contentView addSubview:_pushBtn];
        
        _bgLab.frame = CGRectMake(10, 10, [[UIScreen mainScreen]bounds].size.width-20, _cellHeight-20);
        
    }

    return self;
}
#pragma mark Delegate方法

-(void)pushBtnClicked:(UIButton *)sender{
    
    ListLogSM *sm = [ListLogSM shareSingletonModel];
    sm.question = _questionStr;
    [self.tDelegate pushBtnClicked2:self];
}

-(void)reloadCell{
    [self.tDelegate reloadCell:self];
}

// 键盘上方附加的完成按钮触发函数
-(void)pickerDoneClicked
{
    UITextView* view = (UITextView *)[self.contentView viewWithTag:1001];
    [view resignFirstResponder];
    
    NSLog(@"Done %@",_questionStr);
    
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
    [db executeUpdate:@"UPDATE DataList SET AnswerT = ? WHERE Question = ?",view.text,_questionStr];
    
    
    //建立table
    if (![db tableExists:@"LogList"]) {
        
        [db executeUpdate:@"CREATE TABLE LogList (Question text, Time text, Answer text)"];
    }
    
    //写入
    [db executeUpdate:@"INSERT INTO LogList (Question,Time, Answer) VALUES (?,?,?)",_questionStr,nowDay,view.text];

    
    _answerLab.text = _textModel.answer;
    _answerTV.layer.contents = (id)[UIImage imageNamed:@"CellBGC.png"].CGImage; //给图层添加背景图片
    
    
    //根据文本生成输入框的尺寸并且调整尺寸
    CGSize answerSize = [_textModel.answer boundingRectWithSize:CGSizeMake([[UIScreen mainScreen]bounds].size.width-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25]} context:nil].size;
    _answerLab.frame = CGRectMake(30,CGRectGetMaxY(_questionLab.frame)+20, [[UIScreen mainScreen]bounds].size.width-60, answerSize.height+10);
    _answerTV.frame = CGRectMake(20, CGRectGetMaxY(_questionLab.frame)+10, [[UIScreen mainScreen]bounds].size.width-40, answerSize.height+20);
    
    _cellHeight = CGRectGetMaxY(_answerLab.frame)+30;
    
    [view setText:@""];
    
    _bgLab.frame = CGRectMake(10, 10, [[UIScreen mainScreen]bounds].size.width-20, _cellHeight-20);

    [db close];
    
    _pushBtn.hidden = NO;
    _pushBtn.enabled = YES;
    
    [self reloadCell];
}

// 在首页弹出记录键盘后点击取消，重新绘制点击框。
-(void)pickerCancelClicked{
    UITextView* view = (UITextView *)[self.contentView viewWithTag:1001];
    [view resignFirstResponder];
    [view setText:@""];
    _answerTV.layer.contents = (id)[UIImage imageNamed:@"TextViewBGC.png"].CGImage; //给图层添加背景图片
    _cellHeight = CGRectGetMaxY(_answerTV.frame)+30;
    _bgLab.frame = CGRectMake(10, 10, [[UIScreen mainScreen]bounds].size.width-20, _cellHeight-20);

}

-(void)settingText{
    _questionLab.text = _textModel.question;
    _questionStr = _textModel.question;

//    CGSize questionSize = [_textModel.question boundingRectWithSize:CGSizeMake([[UIScreen mainScreen]bounds].size.width-60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25]} context:nil].size;
    
//    _questionLab.numberOfLines = 1;
    
//    _questionLab.frame = CGRectMake(22, 20, [[UIScreen mainScreen]bounds].size.width-44, questionSize.height+10);
    
//    _answerTV.frame = CGRectMake(28, 57, [[UIScreen mainScreen]bounds].size.width-40, 120);
    
//    _cellHeight = CGRectGetMaxY(_answerTV.frame)+30;
    
//    _bgLab.frame = CGRectMake(10, 10, [[UIScreen mainScreen]bounds].size.width-20, _cellHeight-20);
    
    if (_textModel.answer) {
        _answerLab.text = _textModel.answer;
        _answerTV.editable = NO;
        _answerTV.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor clearColor]);
        _answerTV.layer.contents = (id)[UIImage imageNamed:@"CellBGC.png"].CGImage; //给图层添加背景图片

        
        CGSize answerSize = [_textModel.answer boundingRectWithSize:CGSizeMake([[UIScreen mainScreen]bounds].size.width-50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25]} context:nil].size;
        
        _answerLab.numberOfLines = 0;
        
        _answerLab.frame = CGRectMake(30,CGRectGetMaxY(_questionLab.frame)+20,[[UIScreen mainScreen]bounds].size.width-60, answerSize.height);
        
        _answerTV.frame = CGRectMake(20, CGRectGetMaxY(_questionLab.frame)+10, [[UIScreen mainScreen]bounds].size.width-40, answerSize.height+20);
        
        _cellHeight = CGRectGetMaxY(_answerLab.frame)+30;
        
        _pushBtn.frame = CGRectMake(10, 0, [[UIScreen mainScreen]bounds].size.width-20, _cellHeight);
        _pushBtn.hidden = NO;
        _pushBtn.enabled = YES;
        
        _bgLab.frame = CGRectMake(10, 10, [[UIScreen mainScreen]bounds].size.width-20, _cellHeight-20);
        
    }
}
+(NSString *)ID{
    return @"Text";
}

#pragma mark - TextViewDelegateMethod


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"Begin Edting");
    _answerTV.layer.borderWidth = 0;
    _answerTV.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor clearColor]);
    _answerTV.layer.contents = (id)[UIImage imageNamed:@"ViewBGC.png"].CGImage; //给图层添加背景图片
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"End Edting");
    
    _textModel.answer = textView.text;
   
}

@end



