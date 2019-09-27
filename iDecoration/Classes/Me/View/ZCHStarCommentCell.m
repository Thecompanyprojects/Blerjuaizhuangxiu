//
//  ZCHStarCommentCell.m
//  iDecoration
//
//  Created by 赵春浩 on 17/6/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHStarCommentCell.h"
#import "ZCHConstructionCommentModel.h"

@interface ZCHStarCommentCell ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *pHLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourthBtn;
@property (weak, nonatomic) IBOutlet UIButton *fifthBtn;

@end

@implementation ZCHStarCommentCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.iconView.layer.cornerRadius = self.iconView.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textView.delegate = self;
    self.textView.backgroundColor = RGB(246, 246, 246);
    
}
- (IBAction)didClickStarBtn:(UIButton *)sender {
    
    sender.selected = YES;
    for (int i = 777; i < sender.tag; i ++) {
        
        UIButton *btn = [self viewWithTag:i];
        btn.selected = YES;
    }
    
    for (int i = 781; i > sender.tag; i --) {
        
        UIButton *btn = [self viewWithTag:i];
        btn.selected = NO;
    }
    if ([self.delegate respondsToSelector:@selector(finishEditCommentWithObject:andIndex:)]) {
        
        [self.delegate finishEditCommentWithObject:[NSNumber numberWithInteger:sender.tag - 776] andIndex:self.indexPath];
    }
}

- (void)setModel:(ZCHConstructionCommentModel *)model {
    
    _model = model;
    
    if (self.isNewComment) {
        
        self.nameLabel.text = [NSString stringWithFormat:@"%@-%@", model.JobTypeName, model.trueName];
    } else {
        
        self.nameLabel.text = [NSString stringWithFormat:@"%@-%@", model.roleTypeName, model.trueName];
        self.textView.text = model.content;
        if (![model.content isEqualToString:@""]) {
            self.pHLabel.hidden = YES;
        }
        UIButton *btn = [self viewWithTag:[model.grade integerValue] + 776];
        [self didClickStarBtn:btn];
    }
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:nil];
}

- (void)setDic:(NSDictionary *)dic {
    
    _dic = dic;
    self.textView.text = dic[@"content"];
    if (![dic[@"grade"] isEqualToString:@"0"]) {
        
        NSInteger index = [dic[@"grade"] integerValue];
        
        for (int i = 777; i < 777 + index; i ++) {
            
            UIButton *btn = [self viewWithTag:i];
            
            btn.selected = YES;
        }
        
        for (int i = 781; i > 781 - (5 - index); i --) {
            
            UIButton *btn = [self viewWithTag:i];
            
            btn.selected = NO;
        }
    } else {
        
        for (int i = 777; i < 782; i ++) {
            
            UIButton *btn = [self viewWithTag:i];
            
            btn.selected = NO;
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length) {
        
        self.pHLabel.hidden = YES;
    } else {
        
        self.pHLabel.hidden = NO;
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    if ([self.delegate respondsToSelector:@selector(finishEditCommentWithObject:andIndex:)]) {
        
        [self.delegate finishEditCommentWithObject:textView.text andIndex:self.indexPath];
    }
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
