//
//  DecorateSpecificNeedCell.m
//  iDecoration
//
//  Created by zuxi li on 2017/10/10.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "DecorateSpecificNeedCell.h"
#import "UIButton+FillColor.h"


@interface DecorateSpecificNeedCell ()
// 按钮数组
@property (nonatomic, strong) NSMutableArray *btnArray;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation DecorateSpecificNeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.btnArray = [NSMutableArray array];
        self.selectedBtnTitleMulArray = [NSMutableArray array];
        
        [self setUI];
    }
    return self;
}

- (void)setUI {
    UILabel *nameLabel = [UILabel new];
    self.nameLabel = nameLabel;
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.height.equalTo(20);
        make.top.equalTo(10);
    }];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = [UIColor blackColor];
    
    UIView *lineView = [UIView new];
    self.lineView = lineView;
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(1);
        make.top.equalTo(nameLabel.mas_bottom).equalTo(10);
    }];
    lineView.backgroundColor = kBackgroundColor;
    
    UIView *view = [UIView new];
    self.bgView  = view;
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(1);
    }];
    
    
}

- (void)setTitleName:(NSString *)titleName {
    _titleName = titleName;
    self.nameLabel.text = titleName;
}

- (void)setButtonTitleArray:(NSArray *)buttonTitleArray {
    _buttonTitleArray = buttonTitleArray;
    
    CGFloat marginX = 20;
    CGFloat marginY = 15;
    CGFloat buttonNormalWidth = (kSCREEN_WIDTH - marginX * 5) / 4.0;
    CGFloat buttonHeight = 26;
    
    UIButton *lastButton = nil;
    for (int i = 0; i < self.buttonTitleArray.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.cornerRadius = 13; // 按钮的边框弧度
        btn.clipsToBounds = YES;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 1;

        btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:kMainThemeColor forState:UIControlStateSelected];
        
        if (self.isSingleSelected) {
            [btn addTarget:self action:@selector(chooseMark:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [btn addTarget:self action:@selector(multiChooseButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [btn setTitle:self.buttonTitleArray[i] forState:UIControlStateNormal];
        btn.tag = i;
        [self.btnArray addObject:btn];
        
        [self.bgView addSubview:btn];
        
        NSString *title = self.buttonTitleArray[i];
        CGFloat width = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) withFont:[UIFont systemFontOfSize:14]].width + 6;
        
        CGFloat buttonWidth = buttonNormalWidth > width ? buttonNormalWidth : width;
        
        if (i == 0) {
            btn.frame = CGRectMake(marginX, marginY, buttonWidth, buttonHeight);
        } else {
            CGFloat x;
            CGFloat y;
            if (kSCREEN_WIDTH - CGRectGetMaxX(lastButton.frame) - (marginX * 2) - buttonWidth >= 0) {
                y = CGRectGetMinY(lastButton.frame);
                x = CGRectGetMaxX(lastButton.frame) + marginX;
            } else {
                y = CGRectGetMaxY(lastButton.frame) + marginY;
                x = marginX;
            }
            btn.frame = CGRectMake(x, y, buttonWidth, buttonHeight);
        }
        
        if (i == self.btnArray.count - 1) {
            CGFloat height = CGRectGetMaxY(btn.frame) + marginY;
            
            [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.lineView.mas_bottom);
                make.left.right.bottom.equalTo(0);
                make.height.equalTo(height);
            }];
        }
        if ([self.selectedBtnTitleMulArray containsObject:btn.titleLabel.text]){
            btn.selected = YES;
        }
        
        lastButton = btn;
    
    }
}

#pragma  mark - 单选
- (void)chooseMark:(UIButton *)sender {
    YSNLog(@"点击了%@", sender.titleLabel.text);
    self.selectedBtn = sender;
    sender.selected = YES;
    
    [self.selectedBtnTitleMulArray removeAllObjects];
    [self.selectedBtnTitleMulArray addObject:sender.titleLabel.text];
    self.selectedBlock(self.selectedBtnTitleMulArray);
    for (int i = 0; i < self.btnArray.count; i ++) {
        if (i == sender.tag) {
            
        } else {
            UIButton *btn = self.btnArray[i];
            btn.selected = NO;
        }
    }
 
}

#pragma  mark - 多选
- (void)multiChooseButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        [self.selectedBtnTitleMulArray addObject:sender.titleLabel.text];
    } else {
        [self.selectedBtnTitleMulArray removeObject:sender.titleLabel.text];
    }
    self.selectedBlock(self.selectedBtnTitleMulArray);
}











@end
