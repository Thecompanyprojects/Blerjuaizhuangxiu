//
//  Nalabel.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/3/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "Nalabel.h"
#import <CoreText/CoreText.h>
@implementation Nalabel

- (void)changeAlignmentRightandLeft {
    
    
    
    CGRect textSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.font} context:nil];
    
    
    
    CGFloat margin = (self.frame.size.width - textSize.size.width) / (self.text.length - 1);
    
    
    
    NSNumber *number = [NSNumber numberWithFloat:margin];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:self.text];
    
    [attributeString addAttribute:(id)kCTKernAttributeName value:number range:NSMakeRange(0, self.text.length - 1)];
    
    self.attributedText = attributeString;
    
    
    
}

- (void)setAlightLeftAndRightWithWidth:(CGFloat)labelWidth {
    
    CGSize testSize = [self.text boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName :self.font} context:nil].size;
    
    CGFloat margin = (labelWidth - testSize.width)/(self.text.length - 1);
    NSNumber *number = [NSNumber numberWithFloat:margin];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    [attribute addAttribute: NSKernAttributeName value:number range:NSMakeRange(0, self.text.length - 1 )];
    self.attributedText = attribute;
}

@end
