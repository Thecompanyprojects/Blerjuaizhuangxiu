//
//  showresuleCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/10.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "showresuleCell.h"


@interface showresuleCell()


@end

@implementation showresuleCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.roundView = [[UIView alloc]init];
        self.roundView.backgroundColor = [UIColor hexStringToColor:@"32DB7B"];
        self.roundView.layer.masksToBounds = YES;
        self.roundView.layer.cornerRadius = 19/2;
        [self.contentView addSubview:self.roundView];
        [self.roundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(27);
            make.left.mas_equalTo(self.mas_left).offset(70);
            make.size.mas_equalTo(CGSizeMake(19, 19));
        }];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(27);
            make.left.mas_equalTo(self.roundView.mas_right).offset(20);
            make.size.mas_equalTo(CGSizeMake(200, 20));
        }];
        
        _onLine = [[UILabel alloc]init];
        _onLine.backgroundColor = [UIColor hexStringToColor:@"32DB7B"];
        [self.contentView addSubview:_onLine];
        [_onLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(79);
            make.size.mas_equalTo(CGSizeMake(1, 30));
            
        }];
        
        _downLine = [[UILabel alloc]init];
        _downLine.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:_downLine];
        
        [_downLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.roundView.mas_bottom);
            make.left.mas_equalTo(self.mas_left).offset(79);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.width.mas_equalTo(@1);
        }];
    }
    return self;
}



@end
