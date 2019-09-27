//
//  GetConstructsTableViewCell.m
//  iDecoration
//
//  Created by RealSeven on 17/3/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GetConstructsTableViewCell.h"

@interface GetConstructsTableViewCell()
@property (nonatomic,copy) NSString *companyId;
@end

@implementation GetConstructsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.toviewBtn = [UIButton new];
    self.toviewBtn.layer.masksToBounds = YES;
    self.toviewBtn.layer.borderWidth = 1;
    self.toviewBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.toviewBtn.layer.cornerRadius = 8;
    [self.toviewBtn setTitleColor:[UIColor redColor] forState:normal];
    self.toviewBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.toviewBtn.frame = CGRectMake(143, self.phoneNumberLabel.top, 35, 20);
    [self.toviewBtn setTitle:@"查看" forState:normal];
    [self.toviewBtn addTarget:self action:@selector(toviewbtnclick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.toviewBtn];
}

-(NSMutableArray*)phoneArray{
    
    if (!_phoneArray) {
        _phoneArray = [NSMutableArray array];
    }
    return _phoneArray;
}

//拨打电话
- (IBAction)contactClick:(id)sender {
    
    if (self.contactBlock) {
        self.contactBlock(self.phoneArray);
    }
}

-(void)setHanModel:(HanZXModel *)hanModel{
    [self.phoneArray removeAllObjects];
    self.companyId = [NSString stringWithFormat:@"%ld",hanModel.companyId];
    NSString *timeStr = hanModel.dingdate.length > 0? hanModel.dingdate: hanModel.addTime;
    self.orderTimeLabel.text = [NSString stringWithFormat:@"订单时间：%@",timeStr];
    self.requirementTitleLabel.text = [NSString stringWithFormat:@"%@  %@",hanModel.name.length> 0? hanModel.name: hanModel.fullName, hanModel.houseType.length > 0? hanModel.houseType : @""];
    self.remarkLabel.text = @"请您在合适的时间尽快联系ta";
    self.phoneNumberLabel.text = [NSString stringWithFormat:@"电话：%@ %@",hanModel.phone,hanModel.elephone.length>0?hanModel.elephone:@""];
    
    if (hanModel.isRead == 1) {
        
        self.deleteBtn.hidden = YES;
    }else{
        [self.deleteBtn setTitle:@"未读" forState:UIControlStateNormal];
        self.deleteBtn.hidden = NO;
    }
    
    if (hanModel.phone.length != 0) {
        [self.phoneArray addObject:hanModel.phone];
    }
    
    if (hanModel.elephone.length != 0) {
        [self.phoneArray addObject:hanModel.elephone];
    }
    if ([hanModel.phone containsString:@"****"]&&(hanModel.recommendVip==1)) {
        self.fromLab.text = @"来源：同城收单";
        [self.toviewBtn setHidden:NO];
    }
    else
    {
        self.fromLab.text = @"";
        [self.toviewBtn setHidden:YES];
    }
    self.companyLabel.text = [NSString stringWithFormat:@"接单公司：%@", hanModel.companyName];
    NSString *proType = @"装修";
    switch (hanModel.proType) {
        case 0:
            proType = @"量房";
            break;
        case 1:
            proType = @"设计";
            break;
        case 2:
            proType = @"施工";
            break;
        case 3:
            proType = @"维修";
            break;
        case 4:
            proType = @"其他";
            break;
        default:
            proType = @"其他";
            break;
    }
    self.typeLabel.text = proType;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)toviewbtnclick
{
    if (self.toviewBlock) {
        self.toviewBlock(self.companyId);
    }
}

@end
