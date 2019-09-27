//
//  SearchCompanyCell.m
//  iDecoration
//
//  Created by Apple on 2017/6/3.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SearchCompanyCell.h"

@implementation SearchCompanyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger m = indexPath.section;
    NSInteger n = indexPath.row;
    NSString *TextFieldCellID = [NSString stringWithFormat:@"SearchCompanyCell%ld%ld",(long)m,(long)n];
    SearchCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFieldCellID];
    if (cell == nil) {
        cell =[[SearchCompanyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextFieldCellID];
    }
    cell.path = indexPath;
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //        [self addSubview:self.topV];
        [self addSubview:self.titleL];
        [self addSubview:self.contentF];
        [self addSubview:self.lineV];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)configWith:(id)data{

}

-(UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]initWithFrame:CGRectMake(15,0,80,50)];
        _titleL.textColor = COLOR_BLACK_CLASS_3;
        _titleL.font = NB_FONTSEIZ_BIG;
        _titleL.textAlignment = NSTextAlignmentLeft;
//        _titleL.text = @"";
    }
    return _titleL;
}

-(UITextField *)contentF{
    if (!_contentF) {
        _contentF = [[UITextField alloc]initWithFrame:CGRectMake(self.titleL.right+15,0,kSCREEN_WIDTH-self.titleL.right-15-15,self.titleL.height)];
        _contentF.textColor = COLOR_BLACK_CLASS_3;
        _contentF.font = NB_FONTSEIZ_NOR;
        [_contentF setValue: COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
        [_contentF setValue:NB_FONTSEIZ_NOR forKeyPath:@"_placeholderLabel.font"];
        _contentF.textAlignment = NSTextAlignmentLeft;
//        _contentF.text = @"";
    }
    return _contentF;
}

-(UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 49, kSCREEN_WIDTH, 1)];
        _lineV.backgroundColor = COLOR_BLACK_CLASS_0;
    }
    return _lineV;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
