//
//  CommonMidCell.m
//  iDecoration
//
//  Created by Apple on 2017/5/4.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CommonMidCell.h"

@interface CommonMidCell ()
@property (nonatomic, strong) UILabel *schoolL;
@property (nonatomic, strong) UILabel *companyJob;
@property (nonatomic, strong) UILabel *comment;
@end

@implementation CommonMidCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *TextFieldCellID = @"commonMidCell";
    CommonMidCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFieldCellID];
    if (cell == nil) {
        cell =[[CommonMidCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextFieldCellID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.schoolL];
        [self addSubview:self.companyJob];
        [self addSubview:self.comment];
        self.backgroundColor = White_Color;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)configWith:(id)data{
    if ([data isKindOfClass:[NSMutableDictionary class]]) {
        NSMutableDictionary *dict = data;
//        [self.photoImg sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"photo"]] placeholderImage:[UIImage imageNamed:@"carousel"]];
        if ([dict objectForKey:@"school"] && ![[dict objectForKey:@"school"] isEqual: [NSNull null]]) {
            
            self.schoolL.text = [NSString stringWithFormat:@"毕业院校：%@",[dict objectForKey:@"school"]];
        } else {
            
            self.schoolL.text = [NSString stringWithFormat:@"毕业院校：%@",@""];
        }
        
        if ([dict objectForKey:@"job"] && ![[dict objectForKey:@"job"] isEqual: [NSNull null]]) {
            
            self.companyJob.text =  [NSString stringWithFormat:@"公司职位：%@",[dict objectForKey:@"job"]];
        } else {
            
            self.companyJob.text =  [NSString stringWithFormat:@"公司职位：%@",@""];
        }
        
        if ([dict objectForKey:@"commetnt"] && ![[dict objectForKey:@"commetnt"] isEqual: [NSNull null]]) {
            
            self.comment.text = [NSString stringWithFormat:@"职业格言：%@",[dict objectForKey:@"commetnt"]];
        } else {
            
            self.comment.text = [NSString stringWithFormat:@"职业格言：%@",@""];
        }
        
        CGSize size = [self.comment.text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-20*2, MAXFLOAT) withFont:[UIFont systemFontOfSize:14]];
        
        if (size.height > 20) {
            
            self.comment.frame = CGRectMake(self.schoolL.left, self.companyJob.bottom+5, self.schoolL.width, size.height);
        }
//        self.comment.height = size.height > 20 ? size.height : 20;
    }
}

-(UILabel *)schoolL{
    if (!_schoolL) {
        _schoolL = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, kSCREEN_WIDTH-20*2, 20)];
        _schoolL.textColor = COLOR_BLACK_CLASS_3;
        _schoolL.font = [UIFont systemFontOfSize
                            :14];
        //        companyJob.backgroundColor = Red_Color;
        _schoolL.textAlignment = NSTextAlignmentLeft;
    }
    return _schoolL;
}

-(UILabel *)companyJob{
    if (!_companyJob) {
        _companyJob = [[UILabel alloc]initWithFrame:CGRectMake(self.schoolL.left, self.schoolL.bottom+5, self.schoolL.width, 20)];
        _companyJob.textColor = COLOR_BLACK_CLASS_3;
        _companyJob.font = [UIFont systemFontOfSize
                           :14];
        //        companyJob.backgroundColor = Red_Color;
        _companyJob.textAlignment = NSTextAlignmentLeft;
    }
    return _companyJob;
}

-(UILabel *)comment{
    if (!_comment) {
        _comment = [[UILabel alloc]initWithFrame:CGRectMake(self.schoolL.left, self.companyJob.bottom+5, self.schoolL.width, 20)];
        _comment.textColor = COLOR_BLACK_CLASS_3;
        _comment.font = [UIFont systemFontOfSize
                            :14];
        _comment.numberOfLines = 0;
        //        companyJob.backgroundColor = Red_Color;
        _comment.textAlignment = NSTextAlignmentLeft;
    }
    return _comment;
}



@end
