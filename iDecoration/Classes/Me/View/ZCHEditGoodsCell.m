//
//  ZCHEditGoodsCell.m
//  iDecoration
//
//  Created by 赵春浩 on 17/5/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHEditGoodsCell.h"
#import <SDWebImage/UIButton+WebCache.h>


@interface ZCHEditGoodsCell ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *iconView;
//@property (weak, nonatomic) IBOutlet UITextField *introTF;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;



@end


@implementation ZCHEditGoodsCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
//    self.iconView.layer.borderColor = kBackgroundColor.CGColor;
//    self.iconView.layer.borderWidth = 2;
    self.introTV.delegate = self;
    self.introTV.scrollEnabled = NO;
    self.iconView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.introTV.font = [UIFont systemFontOfSize:16];
//    self.introTV.placeHolder = @"说点产品的事吧";
//    self.introTV.placeHolderColor = [UIColor blackColor];
    
    self.placeHolderLabel.hidden = self.introTV.text.length > 0;
//    self.iconView.backgroundColor = kBackgroundColor;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didClickIconView:)];
    longPress.minimumPressDuration = 1.0;
    [self.iconView addGestureRecognizer:longPress];
    
}


- (void)didClickIconView:(UILongPressGestureRecognizer *)longPress {
    
    NSData *data1 = UIImagePNGRepresentation(self.iconView.currentBackgroundImage);
    NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"jia_kuang"]);
    if ([data isEqual:data1]) {
        return;
    }
    // 长按手势必须处理这两种状态(不然这个方法会被调用两次)
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        self.deleteBtn.hidden = NO;
        if (self.clickDeleteBlock) {
            
            self.clickDeleteBlock(-1);
        }
    }else if (longPress.state == UIGestureRecognizerStateEnded){
        
    }
}



//- (IBAction)didClickDeleteBtn:(UIButton *)sender {
//    
//    if (self.clickDeleteBlock) {
//        
//        self.clickDeleteBlock(self.rowIndex);
//    }
//}



- (void)setDic:(NSDictionary *)dic {
    
    _dic = dic;
    self.deleteBtn.hidden = YES;
    self.introTV.text = dic[@"content"];
    CGSize size = [self.introTV.text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 50, CGFLOAT_MAX) withFont:[UIFont systemFontOfSize:16]];
    self.introTVHeightCon.constant = size.height + 15 > 40 ? size.height + 15 : 40;
    
    if ([dic[@"imgUrl"] isEqualToString:@""]) {
        
        [self.iconView sd_setImageWithURL:nil forState:UIControlStateNormal];
        [self.iconView setBackgroundImage:[UIImage imageNamed:@"jia_kuang"] forState:UIControlStateNormal];
    } else {
        
        [self.iconView setBackgroundImage:nil forState:UIControlStateNormal];
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:dic[@"imgUrl"]] forState:UIControlStateNormal];
//        [self.iconView sd_setBackgroundImageWithURL:[NSURL URLWithString:dic[@"imgUrl"]] forState:UIControlStateNormal];
    }
}

- (IBAction)didClickIconBtn:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickIconBtn:andCellRow:andIntroText:)]) {
        
        [self.delegate didClickIconBtn:sender andCellRow:self.rowIndex andIntroText:self.introTV.text];
    }
    
}

- (IBAction)didClickDeleteBtn:(UIButton *)sender {
    
    if (self.clickDeleteBlock) {
        
        self.clickDeleteBlock(self.rowIndex);
    }
}



- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    [self didClickIconBtn:nil];
    return  YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    [self didClickIconBtn:nil];
    self.placeHolderLabel.hidden = textView.text.length > 0;
    
    CGFloat nowHeight = textView.height;
    CGSize size = [self.introTV.text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 50, CGFLOAT_MAX) withFont:[UIFont systemFontOfSize:16]];
    CGFloat willHeight = size.height + 15 > 40 ? size.height + 15 : 40;
    
    if (nowHeight - willHeight > 3 || willHeight - nowHeight > 3) {
        
        self.introTVHeightCon.constant = willHeight;
        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
