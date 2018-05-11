//
//  LogSwitchTableViewCell.m
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/11.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

#import "LogSwitchTableViewCell.h"
#import "Masonry.h"
@interface LogSwitchTableViewCell()

@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *answerLab;

@end

@implementation LogSwitchTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        _timeLab = [[UILabel alloc]init];
        [self.contentView addSubview:_timeLab];
        [_timeLab mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.contentView).with.offset(10);
            make.left.equalTo(self.contentView).with.offset(10);
            make.width.mas_equalTo(@180);
            make.height.mas_equalTo(@60);
        }];
        
        _answerLab = [[UILabel alloc]init];
        [self.contentView addSubview:_answerLab];
        [_answerLab mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.contentView).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.width.mas_equalTo(@80);
            make.height.mas_equalTo(@60);
        
        }];
        
        _timeLab.backgroundColor = [UIColor clearColor];
        _answerLab.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)settingText{
    if ([_logswitchModel.answer isEqualToString:@"yes"]) {
        
        _answerLab.text = @"有";
    }else{
        _answerLab.text = @"没有";
    }
    _answerLab.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CellBGC.png"]];
    _answerLab.font = [UIFont systemFontOfSize:25 weight:UIFontWeightBlack];
    _answerLab.textAlignment = NSTextAlignmentCenter;
    
    _timeLab.text = _logswitchModel.time;
    _timeLab.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CellBGC.png"]];
    _timeLab.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBlack];
    _timeLab.textAlignment = NSTextAlignmentCenter;

}
+(NSString *)ID{
    return @"LogSwitch";
}
@end
