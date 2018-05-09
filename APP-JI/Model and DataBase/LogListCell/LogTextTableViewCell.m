//
//  LogTextTableViewCell.m
//  APP-JI
//
//  Created by 魏大同 on 16/4/28.
//  Copyright © 2016年 魏大同. All rights reserved.
//

#import "LogTextTableViewCell.h"
#import "Masonry.h"

@interface LogTextTableViewCell()

//@property (nonatomic,strong) UILabel *questionLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *answerLab;
@property (nonatomic,strong) UITextView *bgTV;

@end

@implementation LogTextTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _bgTV = [[UITextView alloc]init];
        [_bgTV.layer setCornerRadius:4];
        _bgTV.layer.borderWidth = 0;
        _bgTV.layer.contents = (id)[UIImage imageNamed:@"CellBGC.png"].CGImage; //给图层添加背景图片
        _bgTV.editable = NO;
        [self.contentView addSubview:_bgTV];

        
        _timeLab = [[UILabel alloc]init];
        _timeLab.frame = CGRectMake(30, 10, 180, 44);
        _timeLab.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CellBGC.png"]];
        _timeLab.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
        [self.contentView addSubview:_timeLab];
        
    
        _answerLab = [[UILabel alloc]init];
        _answerLab.frame = CGRectMake(30, CGRectGetMaxY(_timeLab.frame)+10, [[UIScreen mainScreen]bounds].size.width-60, 80);
        _answerLab.font = [UIFont systemFontOfSize:25];
        _answerLab.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_answerLab];
        
        _answerLab.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CellBGC.png"]];
        _timeLab.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

+(NSString *)ID{
    return @"LogText";
}
-(void)settingText{

    _timeLab.text = _logtextModel.time;
    _answerLab.text = _logtextModel.answer;
    
    CGSize answerSize = [_logtextModel.answer boundingRectWithSize:CGSizeMake([[UIScreen mainScreen]bounds].size.width-60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25]} context:nil].size;
    
    _answerLab.numberOfLines = 0;
    
    _answerLab.frame = CGRectMake(30, CGRectGetMaxY(_timeLab.frame)+10, [[UIScreen mainScreen]bounds].size.width-60, answerSize.height);
    
    _cellHeight = CGRectGetMaxY(_answerLab.frame)+20;
    
    _bgTV.frame = CGRectMake(25, CGRectGetMaxY(_timeLab.frame)+5, [[UIScreen mainScreen]bounds].size.width-50, CGRectGetHeight(_answerLab.frame)+10);

    
}
@end
