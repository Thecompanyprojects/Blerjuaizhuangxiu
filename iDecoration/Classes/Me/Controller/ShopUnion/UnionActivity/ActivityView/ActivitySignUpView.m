//
//  ActivitySignUpView.m
//  iDecoration
//
//  Created by zuxi li on 2018/4/12.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "ActivitySignUpView.h"

@interface ActivitySignUpView()

@end

@implementation ActivitySignUpView

- (instancetype)initWithCustomItem:(NSArray *)itemArray costName:(NSString *)costName andPrice:(NSString *)price {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        self.backgroundColor = [UIColor whiteColor];//  COLOR_BLACK_CLASS_9;
//        self.alpha = 0.5;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shadowDismiss)];
        [self addGestureRecognizer:ges];
        
        [self buildUIWithCustomItem:itemArray costName:costName andPrice:price];
    }
    return self;
}

- (void)buildUIWithCustomItem:(NSArray *)itemArray costName:(NSString *)costName andPrice:(NSString *)price {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapAction)];
    [scrollView addGestureRecognizer:tapGR];
    // 边界15  item高度 40
    
    // 没有自定义项 没有费用
    CGFloat height = 4 * 40 + 5 * 15 + 30;
    // 没有自定义项 有费用
    if (itemArray.count == 0 && price.doubleValue > 0) {
        height = 6 * 40 + 7 * 15 + 30;
    }
    // 有自定义项 没有费用
    if (price.doubleValue == 0 && itemArray.count >0) {
        height = (4 + itemArray.count) * 55 + 15 + 30;
    }
    // 有自定义项 有费用
    if (price.doubleValue > 0 && itemArray.count > 0) {
        height = (6 + itemArray.count) * 55 + 15 + 30;
    }
    height += 55;
    CGFloat scrollViewHeight = height > kSCREEN_HEIGHT *2.0/3.0 ? kSCREEN_HEIGHT *2.0/3.0 : height;
    scrollView.frame = CGRectMake(10, (kSCREEN_HEIGHT - scrollViewHeight)/2.0, kSCREEN_WIDTH - 20, scrollViewHeight);
    scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH - 20, height);
    scrollView.layer.cornerRadius = 8;
    scrollView.layer.masksToBounds = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:scrollView];
    
    NSMutableArray *itemNameArray = [NSMutableArray array];
    [itemNameArray addObject:@"姓名"];
    [itemNameArray addObjectsFromArray:itemArray];
    [itemNameArray addObject:@"手机号"];
//    [itemNameArray addObject:@"图形验证码"];
    [itemNameArray addObject:@"验证码"];
    if (price.doubleValue > 0) {
        [itemNameArray addObject:costName];
        [itemNameArray addObject:@"实付金额"];
    }
    
    for (int i = 0; i < itemNameArray.count; i ++) {
        UITextField *tF = [[UITextField alloc] initWithFrame:CGRectMake(15, 15 +i *55 , kSCREEN_WIDTH - 20 - 30, 40)];
        tF.font = [UIFont systemFontOfSize:16];
        tF.borderStyle = UITextBorderStyleRoundedRect;
        [scrollView addSubview:tF];
        tF.tag = 99 + i;  // 自定义项的tag值一次是 100  101   102 。。。
        if ([itemNameArray[i] isEqualToString:@"手机号"]) {
            tF.tag = 999; // 手机号码的tag值
            tF.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (i == 0) {
            tF.tag = 888; // 姓名的tag值
        }
        tF.placeholder = [NSString stringWithFormat:@"请输入%@", itemNameArray[i]];
        
        if ([itemNameArray[i] isEqualToString:@"实付金额"]) {
            tF.text = @"实付金额";
            tF.userInteractionEnabled = NO;
            UILabel *label = [UILabel new];
            [tF addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(-8);
                make.top.bottom.equalTo(0);
            }];
            label.backgroundColor = [UIColor clearColor];
            label.text = [NSString stringWithFormat:@"￥%@", price];
            label.textColor = kCustomColor(235, 163, 87);
        }
        
        if ([itemNameArray[i] isEqualToString:costName]) {
            
            tF.text = costName;
            tF.userInteractionEnabled = NO;
            UILabel *label = [UILabel new];
            [tF addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(-8);
                make.top.bottom.equalTo(0);
            }];
            label.backgroundColor = [UIColor clearColor];
            label.text = [NSString stringWithFormat:@"￥%@", price];
            label.textColor = kCustomColor(235, 163, 87);
            
            
        }
        
        if ([itemNameArray[i] isEqualToString:@"验证码"]) {
            tF.tag = 777;
            tF.keyboardType = UIKeyboardTypeNumberPad;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"发送验证码" forState:UIControlStateNormal];
            [tF addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.bottom.equalTo(0);
                make.width.equalTo(100);
            }];
            btn.layer.cornerRadius = 4;
            btn.layer.masksToBounds = YES;
            [btn setBackgroundColor:kMainThemeColor];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            [btn addTarget:self action:@selector(codeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }

        #warning 后台拖后腿 后续版本增加该功能 暂时注释
//        if ([itemNameArray[i] isEqualToString:@"图形验证码"]) {
//            UIImageView *imageVerificationCode = [UIImageView new];
//            [tF addSubview:imageVerificationCode];
//            tF.tag = 666; // 图形验证码的tag值
//            [imageVerificationCode mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.right.bottom.equalTo(0);
//                make.width.equalTo(100);
//            }];
//            [GetImageVerificationCode setImageVerificationCodeToImageView:imageVerificationCode];
//        }

        if (i == itemNameArray.count - 1) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [scrollView addSubview:btn];
            btn.frame = CGRectMake(15, 15 + (i + 1) *55 , kSCREEN_WIDTH- 50, 40);
            
            btn.layer.cornerRadius = 4;
            btn.layer.masksToBounds = YES;
            [btn setBackgroundColor:kMainThemeColor];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            if (price.doubleValue == 0 || [costName isEqualToString:@""]) {
                [btn setTitle:@"报    名" forState:UIControlStateNormal];
                btn.tag = 2;
            } else {
                [btn setTitle:@"支    付" forState:UIControlStateNormal];
                btn.tag = 1;
            }
            [btn addTarget:self action:@selector(finishAction:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tipBtn.frame = CGRectMake(scrollView.width-210,btn.bottom+15,200,30);
            tipBtn.backgroundColor = White_Color;
            [tipBtn setTitle:@"报名后可凭验证码参加活动" forState:UIControlStateNormal];
            tipBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [tipBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
            tipBtn.titleLabel.font = NB_FONTSEIZ_SMALL;
            [scrollView addSubview:tipBtn];
        }
    }
    
    
}


-(void)shadowDismiss{
    self.hidden = YES;
    [self endEditing:YES];
    [self removeFromSuperview];
}
- (void)scrollViewTapAction {
    
}
-(void)codeBtnClick:(UIButton *)btn{
    [self endEditing:YES];
    if (self.sendCodeBlock) {
        self.sendCodeBlock(btn);
    }
}

- (void)finishAction:(UIButton *)sender {
    if (self.finishBtnBlock) {
        self.finishBtnBlock(sender.tag);
    }
}
@end
