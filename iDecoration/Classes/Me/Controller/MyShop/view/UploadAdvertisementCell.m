//
//  UploadAdvertisementCell.m
//  iDecoration
//
//  Created by zuxi li on 2017/7/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "UploadAdvertisementCell.h"

@implementation UploadAdvertisementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageV.contentMode = UIViewContentModeScaleAspectFill;
    self.imageV.clipsToBounds = YES;
    self.placeHolderTV.placeHolder = @"请输入网址链接";
    self.placeHolderTV.placeHolderColor = [UIColor lightGrayColor];
    self.placeHolderTV.font = [UIFont systemFontOfSize:16];
    self.placeHolderTV.delegate = self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"UploadAdvertisementCell";
    UploadAdvertisementCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UIAccessibilityTraitNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textViewDidChange:(UITextView *)textView {
    if (self.blockTextViewChanged) {
        self.blockTextViewChanged(textView.text);
    }
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    [self.imageV sd_cancelCurrentImageLoad];
}

@end
