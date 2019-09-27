//
//  IntroductionToMemberPackagesCollectionViewCell.m
//  iDecoration
//
//  Created by 张毅成 on 2018/8/31.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "IntroductionToMemberPackagesCollectionViewCell.h"

@implementation IntroductionToMemberPackagesCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.arrayLabel enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 0) {
            UILabel *label = obj;
            label.userInteractionEnabled = true;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchLabel:)];
            [label addGestureRecognizer:tap];
        }
    }];
}

- (void)setModel:(IntroductionToMemberPackagesModel *)model {
    _model = model;
    [self.arrayLabel enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = obj;
        label.text = model.arrayData[idx]?:@"暂无";
    }];
}

- (void)didTouchLabel:(UITapGestureRecognizer *)sender {
    UILabel *label = (UILabel *)sender.view;
    if (label.tag == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.model.adviserPhone]]];
    }else{//加到粘贴板
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:self.model.arrayData[label.tag]];
    }
}
@end
