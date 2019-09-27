//
//  RemarkTableViewCell.m
//  iDecoration
//
//  Created by RealSeven on 17/2/11.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "RemarkTableViewCell.h"

@implementation RemarkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.remarkTextView.delegate = self;
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length >0) {
        self.remarkLabel.hidden = YES;
    }else{
        self.remarkLabel.hidden = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"] == YES)
    {
        [textView resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
