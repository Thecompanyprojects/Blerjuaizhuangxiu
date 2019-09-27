//
//  BLEJBrickChooseCommodityCell.m
//  iDecoration
//
//  Created by john wall on 2018/8/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "BLEJBrickChooseCommodityCell.h"
#import "UIImage+ClipperExtends.h"
@implementation BLEJBrickChooseCommodityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
   _imageIcon =[[UIImageView alloc]initWithFrame:CGRectMake(10, self.frame.size.height/2-15, 30, 30)];
    _imageIcon.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _imageIcon.layer.borderWidth=1;
    _imageIcon.layer.cornerRadius= _imageIcon.width/2;
    _imageIcon.contentMode=UIViewContentModeScaleToFill;
    [self addSubview:_imageIcon];
    _imageIcon.hidden=YES;
  
   

    
    
    
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"checkBluecommodity" ofType:@"png"];
//
//        NSData *gifData = [NSData dataWithContentsOfFile:path];
//       self.ShowSelectIcon.contentMode=UIViewContentModeScaleToFill;
//         [self.ShowSelectIcon setImage:[UIImage imageWithData:gifData] forState:UIControlStateSelected];
 //   [self.ShowSelectIcon addTarget:self action:@selector(dosomeTap:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setGoodModel:(GoodsListModel *)goodModel{
    _goodModel =goodModel;
    self.imageIcon.contentMode=UIViewContentModeScaleToFill;
    self.imageV.contentMode=UIViewContentModeScaleToFill;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:goodModel.display] placeholderImage:nil];//[UIImage imageNamed:@"shareDefaultIcon"]
    self.nameLA.text=goodModel.name;
    self.DesciptionLA.text =goodModel.price;
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
