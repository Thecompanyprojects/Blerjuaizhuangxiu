//
//  draftboxCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/20.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "draftboxCell.h"
#import <SDAutoLayout.h>
#import <UIButton+LXMImagePosition.h>
#import "draftboxModel.h"
#import "Timestr.h"


@interface draftboxCell()
@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UIButton *pushBtn;
@end


@implementation draftboxCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftImg];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.pushBtn];
        
    }
    return self;
}

-(void)setdata:(draftboxModel *)model
{
    //self.timeLab.text = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:model.addTime];
    
    self.timeLab.text = [Timestr newdatetime:model.addTime];
    
    NSDictionary *dict = [self dictionaryWithJsonString:model.draftContent];
    NSDictionary *design = [dict objectForKey:@"design"];
    NSString *coverTitle = [design objectForKey:@"designTitle"];
    //NSString *coverTitleTwo = [design objectForKey:@"designSubtitle"];
    NSString *coverImgUrl = [design objectForKey:@"coverMap"];
    
    NSArray *details = [dict objectForKey:@"details"];
    if (details.count!=0) {
        NSDictionary *obj = [details firstObject];
        NSString *content = [obj objectForKey:@"content"];
        if (IsNilString(content)) {
            self.contentLab.text = @"无内容";
        }
        else
        {
            self.contentLab.text = content;
        }
    }
    else
    {
        self.contentLab.text = @"无内容";
    }
    
   
    
    self.nameLab.text = coverTitle;
    
    if (coverImgUrl.length==0) {
        [self superlayout2];
    }
    else
    {
        [self superlayout];
        [self.leftImg sd_setImageWithURL:[NSURL URLWithString:coverImgUrl]];
    }
}

-(void)superlayout
{
    __weak typeof (self) weakSelf = self;
    weakSelf.leftImg
    .sd_layout
    .leftSpaceToView(weakSelf.contentView, 12)
    .topSpaceToView(weakSelf.contentView, 10)
    .widthIs(96)
    .heightIs(85);
    
    weakSelf.nameLab
    .sd_layout
    .leftSpaceToView(weakSelf.leftImg, 11)
    .topEqualToView(weakSelf.leftImg)
    .autoHeightRatio(0)
    .rightSpaceToView(weakSelf.contentView, 12);
    
    weakSelf.contentLab
    .sd_layout
    .leftEqualToView(weakSelf.nameLab)
    .rightEqualToView(weakSelf.nameLab)
    .topSpaceToView(weakSelf.nameLab, 10)
    .heightIs(15);
    
    weakSelf.pushBtn
    .sd_layout
    .rightSpaceToView(weakSelf.contentView, 12)
    .topSpaceToView(weakSelf.contentLab, 23)
    .widthIs(60)
    .heightIs(20);
    
    weakSelf.timeLab
    .sd_layout
    .leftSpaceToView(weakSelf.leftImg, 10)
    .rightSpaceToView(weakSelf.pushBtn, 10)
    .topEqualToView(weakSelf.pushBtn)
    .heightIs(20);
    
    [self setupAutoHeightWithBottomView:weakSelf.timeLab bottomMargin:12];

}

-(void)superlayout2
{
    
    __weak typeof (self) weakSelf = self;
    
    weakSelf.nameLab
    .sd_layout
    .leftSpaceToView(weakSelf.contentView, 14)
    .topSpaceToView(weakSelf.contentView, 12)
    .autoHeightRatio(0)
    .rightSpaceToView(weakSelf.contentView, 12);
    
    weakSelf.contentLab
    .sd_layout
    .leftEqualToView(weakSelf.nameLab)
    .rightEqualToView(weakSelf.nameLab)
    .topSpaceToView(weakSelf.nameLab, 10)
    .heightIs(15);
    
    weakSelf.pushBtn
    .sd_layout
    .rightSpaceToView(weakSelf.contentView, 12)
    .topSpaceToView(weakSelf.contentLab, 10)
    .widthIs(60)
    .heightIs(20);
    
    weakSelf.timeLab
    .sd_layout
    .leftSpaceToView(weakSelf.contentView, 10)
    .rightSpaceToView(weakSelf.pushBtn, 10)
    .topEqualToView(weakSelf.pushBtn)
    .heightIs(20);
    
    [self setupAutoHeightWithBottomView:weakSelf.timeLab bottomMargin:12];
}

#pragma mark - getters


-(UIImageView *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIImageView alloc] init];
        _leftImg.layer.masksToBounds = YES;
        _leftImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _leftImg;
}

-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textColor = [UIColor hexStringToColor:@"2b2b2b"];
        _nameLab.font = [UIFont systemFontOfSize:15];
        _nameLab.text = @"(新闻资讯)";
    }
    return _nameLab;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textColor = [UIColor hexStringToColor:@"73777a"];
        _contentLab.font = [UIFont systemFontOfSize:14];
        _contentLab.text = @"内容部分的一些文字敌伪军哦";
    }
    return _contentLab;
}

-(UILabel *)timeLab
{
    if(!_timeLab)
    {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = [UIColor hexStringToColor:@"74787B"];
        _timeLab.font = [UIFont systemFontOfSize:14];
        _timeLab.text = @"一分钟前";
        _timeLab.textAlignment = NSTextAlignmentRight;
    }
    return _timeLab;
}

-(UIButton *)pushBtn
{
    if(!_pushBtn)
    {
        _pushBtn = [[UIButton alloc] init];
        [_pushBtn setTitle:@"推送" forState:normal];
        [_pushBtn setImage:[UIImage imageNamed:@"emi纸飞机拷贝"] forState:normal];
        [_pushBtn setTitleColor:[UIColor hexStringToColor:@"6F6F6F"] forState:normal];
        _pushBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_pushBtn setImagePosition:LXMImagePositionLeft spacing:5];
        [_pushBtn addTarget:self action:@selector(pushbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushBtn;
}


-(void)pushbtnclick
{
    [self.delegate myTabVClick:self];
}


-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
