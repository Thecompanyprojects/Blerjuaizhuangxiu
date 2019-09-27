//
//  CustomNoticeCell.m
//  RollingNotice
//
//  Created by qm on 2017/12/8.
//  Copyright © 2017年 qm. All rights reserved.
//

#import "CustomNoticeCell.h"

@interface CustomNoticeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *trailIconImgView;

@property (weak, nonatomic) IBOutlet UILabel *tagLab0;
@property (weak, nonatomic) IBOutlet UILabel *titleLab0;

@property (weak, nonatomic) IBOutlet UILabel *tagLab1;
@property (weak, nonatomic) IBOutlet UILabel *titleLab1;

@property (nonatomic,strong) NSMutableArray *data0;
@property (nonatomic,strong) NSMutableArray *data1;
@end
@implementation CustomNoticeCell


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _tagLab0.layer.borderColor = [UIColor orangeColor].CGColor;
    _tagLab0.layer.borderWidth = 0.5;
    _tagLab0.layer.cornerRadius = 3;
    
    _tagLab1.layer.borderColor = [UIColor orangeColor].CGColor;
    _tagLab1.layer.borderWidth = 0.5;
    _tagLab1.layer.cornerRadius = 3;
}

- (void)noticeCellWithArr:(NSArray *)arr forIndex:(NSUInteger)index
{

    _tagLab0.text = @"热点";
    _tagLab1.text = @"热点";
    [self.data0 removeAllObjects];
    [self.data1 removeAllObjects];
    if (arr.count!=0) {
        
        self.data0 = [NSMutableArray array];
        self.data1 = [NSMutableArray array];
        
        for (int i = 0; i<arr.count; i++) {
            if (i%2==0) {
                NSMutableAttributedString * obj = arr[i];
               // _titleLab0.text = obj;
                [self.data0 addObject:obj];
            }
            else
            {
                NSMutableAttributedString * obj = arr[i];
               // _titleLab1.text = obj;
                [self.data1 addObject:obj];
            }
        }
        if (self.data0.count!=0) {
            self.titleLab0.attributedText = self.data0[index];
        }
        if (self.data1.count!=0) {
            self.titleLab1.attributedText = self.data1[index];
        }
        //_titleLab1.attributedText = obj;
    }
    
}


@end
