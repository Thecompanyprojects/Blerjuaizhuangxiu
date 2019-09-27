//
//  ZCHSimpleSettingCell.m
//  iDecoration
//
//  Created by 赵春浩 on 17/7/5.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHSimpleSettingCell.h"
#import "ZCHTapGestureRecognizer.h"
#import "ZCHSimpleSettingRoomDetailModel.h"

@implementation ZCHSimpleSettingCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)settingCellWithData:(NSArray *)arr {
    
    for (UIView *view in self.contentView.subviews) {
        
        if ([view isKindOfClass:[UILabel class]]) {
            
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIButton class]]) {
            
            [view removeFromSuperview];
        }
    }
    CGFloat labelWidth = (BLEJWidth - 40) * 1 / 3;
    CGFloat labelHeight = 30;
    CGFloat margin = 10;
    for (int i = 0; i < arr.count; i ++) {
        
        ZCHSimpleSettingRoomDetailModel *model = arr[i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((i % 3 + 1) * margin + i % 3 * labelWidth, (i / 3 + 1) * margin + i / 3 * labelHeight, labelWidth, labelHeight)];
        label.userInteractionEnabled = YES;
//        ZCHTapGestureRecognizer *tap = [[ZCHTapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickLabel:)];
//        tap.index = i + 6666;
//        [label addGestureRecognizer:tap];
        
        label.text = model.name;
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.layer.borderColor = [UIColor lightGrayColor].CGColor;
        label.layer.borderWidth = 0.5;
        [self.contentView addSubview:label];
        
        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(label.right - 20, label.top, 20, 20)];
        deleteBtn.tag = 6666 + i;
        [deleteBtn setImage:[UIImage imageNamed:@"deleteWhite"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(didClickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:deleteBtn];
        if (self.isShowMinusBtn) {
            
            deleteBtn.hidden = NO;
        } else {
            
            deleteBtn.hidden = YES;
        }
    }
}

- (void)didClickDeleteBtn:(UIButton *)btn {
    
    NSLog(@"didClickDeleteBtn");
    if ([self.delegate respondsToSelector:@selector(didClickDeleteBtnWithIndexpath:andIndex:)]) {
        
        [self.delegate didClickDeleteBtnWithIndexpath:self.indexpath andIndex:btn.tag - 6666];
    }
}


//- (void)didClickLabel:(ZCHTapGestureRecognizer *)tap {
//    
//    UILabel *label = [self viewWithTag:tap.index];
//    CGRect buttonFrame = label.frame;
////    buttonFrame.size.height -= 5;
//    
//    // 自定义UIMenuController(删除按钮)
//    UIMenuController *menuController = [UIMenuController sharedMenuController];
//    UIMenuItem *resetMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(didDeleteBtn:)];
//    NSAssert([self becomeFirstResponder], @"Sorry, UIMenuController will not work with %@ since it cannot become first responder", self);
//    [menuController setMenuItems:[NSArray arrayWithObject:resetMenuItem]];
//    [menuController setTargetRect:buttonFrame inView:self];
//    [menuController setMenuVisible:YES animated:YES];
//}
//
//- (void)didDeleteBtn:(UIMenuItem *)menuItem {
//    
//    NSLog(@"33333");
//}
//
//
//
//- (BOOL)canPerformAction:(SEL)selector withSender:(id)sender {
//    
//    if (selector == @selector(didDeleteBtn:)) {
//        return YES;
//    }
//    return NO;
//}
//
//- (BOOL)canBecomeFirstResponder {
//    
//    return YES;
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
