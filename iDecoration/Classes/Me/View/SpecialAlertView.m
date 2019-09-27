//
//  SpecialAlertView.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/23.
//  Copyright © 2018年 RealSeven. All rights reserved.
//
#define ALERTVIEW_HEIGHT 157
#define ALERTVIEW_WIDTH  271
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH  [UIScreen mainScreen].bounds.size.width

#define MARGIN  20
#import "SpecialAlertView.h"

@interface SpecialAlertView()

@property(nonatomic,strong)UIView *alertView;

@end

@implementation SpecialAlertView


-(instancetype) initWithTime:(NSString *)timestr messageTitle:(NSString *)titleStr messageString:(NSString *)contentStr sureBtnTitle:(NSString *)titleString sureBtnColor:(UIColor *)BtnColor{
    
    self = [super init];
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.alertView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH/2-271/2, HEIGHT/2-ALERTVIEW_HEIGHT/2, 271, ALERTVIEW_HEIGHT+40)];
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius=5.0;
        self.alertView.layer.masksToBounds=YES;
        self.alertView.userInteractionEnabled=YES;
        [self addSubview:self.alertView];

        if (titleStr) {
            UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(MARGIN, 20, self.alertView.frame.size.width-40, 30)];
            titleLab.text = titleStr;
            titleLab.font = [UIFont systemFontOfSize:17];
            titleLab.textAlignment = NSTextAlignmentLeft;
            [self.alertView addSubview:titleLab];
        }
        if (contentStr) {
            UILabel *contentLab = [[UILabel alloc]initWithFrame:CGRectMake(MARGIN, 57, self.alertView.frame.size.width-40, 70)];

            NSString *str1 = @"您的会员将于";
            NSString *str2 = timestr;
            NSString *str3 = @"到期：到时无法享受会员特权，请您及时续费。";
            NSString *newstr = [NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:newstr];
            [AttributedStr addAttribute:NSForegroundColorAttributeName
                                  value:[UIColor blackColor]
                                  range:NSMakeRange(0, str1.length)];
            [AttributedStr addAttribute:NSForegroundColorAttributeName
                                  value:[UIColor redColor]
                                  range:NSMakeRange(str1.length, str2.length)];
            [AttributedStr addAttribute:NSForegroundColorAttributeName
                                  value:[UIColor blackColor]
                                  range:NSMakeRange(str1.length+str2.length, str3.length)];
            contentLab.attributedText = AttributedStr;
            contentLab.font = [UIFont systemFontOfSize:14];
            contentLab.numberOfLines = 0;
            contentLab.textAlignment = NSTextAlignmentLeft;
           
            [self.alertView addSubview:contentLab];
        }
        if (titleString) {
            UIButton *sureBtn= [[UIButton alloc]initWithFrame:CGRectMake(65, ALERTVIEW_HEIGHT-15, 140, 33)];
            [sureBtn setTitle:titleString forState:UIControlStateNormal];
            [sureBtn setBackgroundColor:Main_Color];
            sureBtn.layer.cornerRadius=13.0;
            sureBtn.layer.masksToBounds=YES;
            [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sureBtn addTarget:self action:@selector(SureClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:sureBtn];
        }
    }
    [self showAnimation];
    return self;
}

-(void)showAnimation{
    
    self.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    
    self.alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.2,0.2);
    self.alertView.alpha = 0;
    [UIView animateWithDuration:0.2 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4f];
        self.alertView.transform = transform;
        self.alertView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)SureClick:(UIButton *)sender{
    
    if (self.sureClick) {
        self.sureClick(nil);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
    }];
}

-(void)withSureClick:(sureBlock)block{
    _sureClick = block;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
    }];
    
}

@end
