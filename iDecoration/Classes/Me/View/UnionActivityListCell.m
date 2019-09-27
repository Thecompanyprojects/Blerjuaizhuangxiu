//
//  UnionActivityListCell.m
//  iDecoration
//
//  Created by sty on 2017/10/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "UnionActivityListCell.h"
#import "UnionActivityListModel.h"


@implementation UnionActivityListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.activityBtn.layer.masksToBounds = YES;
    self.activityBtn.layer.cornerRadius = 5;
    self.activityBtn.layer.borderColor = RGB(45, 123, 246).CGColor;
    self.activityBtn.layer.borderWidth = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)stateBtnClick:(UIButton *)sender {
    if (self.stateBtnBlock) {
        self.stateBtnBlock(sender.tag);
    }
}

- (void)setBeautyModel:(BeautifulArtListModel *)beautyModel {
    
    _beautyModel = beautyModel;
    self.activityNameL.text = beautyModel.designTitle;
    [self.activityBtn setTitle:@"美文" forState:UIControlStateNormal];
}

-(void)configData:(id)data isLeader:(BOOL)isLeader{
    if ([data isKindOfClass:[UnionActivityListModel class]]) {
        UnionActivityListModel *model = data;
        self.activityNameL.text = model.designTitle;
        NSString *temStart = [self timeWithTimeIntervalString:model.startTime];
        self.beginL.text = [NSString stringWithFormat:@"%@开始",temStart];
        NSString *temEnd = [self timeWithTimeIntervalString:model.endTime];
        self.endL.text = [NSString stringWithFormat:@"%@结束",temEnd];
                
        NSMutableAttributedString *shopAttrStringOne = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",model.personNum] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: RGB(45, 123, 246)}];
        
        NSMutableAttributedString *shopAttrStringTwo = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"/%@",model.activityPerson] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: COLOR_BLACK_CLASS_9} ];
        
        NSMutableAttributedString *shopAttrStringThree = [[NSMutableAttributedString alloc] initWithString:@"/不限制人数" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: COLOR_BLACK_CLASS_9} ];
        if([model.activityPerson integerValue]==0){
            //不限制人数
            [shopAttrStringOne appendAttributedString:shopAttrStringThree];
        }
        else{
            [shopAttrStringOne appendAttributedString:shopAttrStringTwo];
        }
        self.personNumL.attributedText = shopAttrStringOne;
        
        //活动状态（（0：报名中，1：待审核，3：活动结束，4：活动进行中，5：审核不通过，6：停止报名，7：报名人数达到上限）
        self.stateBtn.userInteractionEnabled = NO;
        [self.stateBtn setTitleColor:Gray_Color forState:UIControlStateNormal];
        NSInteger state = [model.activityStatus integerValue];
        if (state==0) {
            [self.stateBtn setTitle:@"报名中" forState:UIControlStateNormal];
            [self.stateBtn setTitleColor:Blue_Color forState:UIControlStateNormal];
        }
        else if (state==1) {
            if (isLeader) {
//                [self.stateBtn setTitle:@"审 核" forState:UIControlStateNormal];
                [self.stateBtn setTitle:@"待审核" forState:UIControlStateNormal];
                self.stateBtn.userInteractionEnabled = YES;
            }
            else{
                self.stateBtn.userInteractionEnabled = NO;
//                [self.stateBtn setTitle:@"待审核" forState:UIControlStateNormal];
                [self.stateBtn setTitle:@"盟主审核中" forState:UIControlStateNormal];
            }
            [self.stateBtn setTitleColor:Red_Color forState:UIControlStateNormal];
        }
//        else if (state==2) {
//            [self.stateBtn setTitle:@"审核通过" forState:UIControlStateNormal];
//        }
        else if (state==3) {
            [self.stateBtn setTitle:@"活动结束" forState:UIControlStateNormal];
        }
        
        else if (state==4) {
            [self.stateBtn setTitle:@"活动进行中" forState:UIControlStateNormal];
            [self.stateBtn setTitleColor:Blue_Color forState:UIControlStateNormal];
        }
        else if (state==5) {
            [self.stateBtn setTitle:@"审核不通过" forState:UIControlStateNormal];
        }
        else if (state==6) {
            [self.stateBtn setTitle:@"停止报名" forState:UIControlStateNormal];
        }
        else if (state==7) {
            [self.stateBtn setTitle:@"报名人数达到上限" forState:UIControlStateNormal];
        }
        
        else {
            [self.stateBtn setTitle:@"活动进行中" forState:UIControlStateNormal];
        }
    }
    
    if ([data isKindOfClass:[BeautifulArtListModel class]]) {
        BeautifulArtListModel *model = data;
        
        NSString * designTitle = model.designTitle;
        designTitle = [designTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
        designTitle = [designTitle stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        designTitle = [designTitle stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        model.designTitle = designTitle;
        
        self.activityNameL.text = model.designTitle;
        if (model.startTime&&model.startTime.length>2) {
            
            //是活动
//            NSString *temStart = [self timeWithTimeIntervalString:model.startTime];
            
//            [self.activityBtn setTitle:@"活动" forState:UIControlStateNormal];
            
            //类型（1：联盟活动，3：新闻活动）
            if (model.type==1) {
                [self.activityBtn setTitle:@"团购活动" forState:UIControlStateNormal];
                self.activityBtnCont.constant = 55;
            }
            if (model.type==3) {
                [self.activityBtn setTitle:@"活动" forState:UIControlStateNormal];
                self.activityBtnCont.constant = 34;
            }
            self.beginL.text = [NSString stringWithFormat:@"%@开始",model.startTime];
//            NSString *temEnd = [self timeWithTimeIntervalString:model.endTime];
            self.endL.text = [NSString stringWithFormat:@"%@结束",model.endTime];
            
            NSMutableAttributedString *shopAttrStringOne = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",model.personNum] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: RGB(45, 123, 246)}];
            
            NSMutableAttributedString *shopAttrStringTwo = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"/%@",model.activityPerson] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: COLOR_BLACK_CLASS_9} ];
            
            NSMutableAttributedString *shopAttrStringThree = [[NSMutableAttributedString alloc] initWithString:@"/不限制人数" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: COLOR_BLACK_CLASS_9} ];
            if([model.activityPerson integerValue]==0){
                //不限制人数
                [shopAttrStringOne appendAttributedString:shopAttrStringThree];
            }
            else{
                [shopAttrStringOne appendAttributedString:shopAttrStringTwo];
            }
            self.personNumL.attributedText = shopAttrStringOne;
            
            //活动状态状态（0：报名中，3：活动结束，4：活动进行中，6：停止报名，7：报名人数达到上限8:活动不存在）
            self.stateBtn.userInteractionEnabled = NO;
            [self.stateBtn setTitleColor:Gray_Color forState:UIControlStateNormal];
            NSInteger state = [model.activityStatus integerValue];
            if (state==0) {
                [self.stateBtn setTitle:@"报名中" forState:UIControlStateNormal];
                [self.stateBtn setTitleColor:Blue_Color forState:UIControlStateNormal];
            }
            else if (state==1) {
                if (isLeader) {
                    //                [self.stateBtn setTitle:@"审 核" forState:UIControlStateNormal];
                    [self.stateBtn setTitle:@"待审核" forState:UIControlStateNormal];
                    self.stateBtn.userInteractionEnabled = YES;
                }
                else{
                    self.stateBtn.userInteractionEnabled = NO;
                    //                [self.stateBtn setTitle:@"待审核" forState:UIControlStateNormal];
                    [self.stateBtn setTitle:@"经理审核中" forState:UIControlStateNormal];
                }
                [self.stateBtn setTitleColor:Red_Color forState:UIControlStateNormal];
            }
                    else if (state==2) {
                        [self.stateBtn setTitle:@"审核通过" forState:UIControlStateNormal];
                    }
            else if (state==3) {
                [self.stateBtn setTitle:@"活动结束" forState:UIControlStateNormal];
            }
            
            else if (state==4) {
                [self.stateBtn setTitle:@"活动进行中" forState:UIControlStateNormal];
                [self.stateBtn setTitleColor:Blue_Color forState:UIControlStateNormal];
            }
            else if (state==5) {
                [self.stateBtn setTitle:@"审核不通过" forState:UIControlStateNormal];
            }
            else if (state==6) {
                [self.stateBtn setTitle:@"停止报名" forState:UIControlStateNormal];
            }
            else if (state==7) {
                [self.stateBtn setTitle:@"报名人数达到上限" forState:UIControlStateNormal];
            }
            else if (state==8) {
                [self.stateBtn setTitle:@"活动不存在" forState:UIControlStateNormal];
            }
            else {
                [self.stateBtn setTitle:@"" forState:UIControlStateNormal];
            }
        }
        else{
            [self.activityBtn setTitle:@"美文" forState:UIControlStateNormal];
        }
        
    }
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
@end
