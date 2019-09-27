//
//  XianHuaJinQiGuanzhuCell.m
//  iDecoration
//
//  Created by john wall on 2018/10/7.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "XianHuaJinQiGuanzhuCell.h"

@implementation XianHuaJinQiGuanzhuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.foucsNumber adjustsFontSizeToFitWidth];
    [self.flowerNumber adjustsFontSizeToFitWidth];
    [self.jinQiNumber adjustsFontSizeToFitWidth];
   
}

//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//
//    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        NSArray *nibArray = [[NSBundle mainBundle]loadNibNamed:@"DataTableViewCell" owner:nil options:nil];
//        self = [nibArray lastObject];
//    }
//    return self;
//}
-(void)setData:(NSDictionary *)dic{
   
    if (dic ==nil || dic[@"likeNumbers"] ==nil ) {
        
    }else{
    self.foucsNumber.text = [NSString stringWithFormat:@"%@%@",@"关注:",dic[@"likeNumbers"]];;
    self.flowerNumber.text =[NSString stringWithFormat:@"%@%@",@"鲜花:",dic[@"flowerNumber"]];
    self.jinQiNumber.text =[NSString stringWithFormat:@"%@%@",@"锦旗:",dic[@"pennantNumber"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
