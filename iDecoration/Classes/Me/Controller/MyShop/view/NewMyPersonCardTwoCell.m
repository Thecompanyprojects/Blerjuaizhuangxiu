//
//  NewMyPersonCardTwoCell.m
//  iDecoration
//
//  Created by sty on 2018/1/19.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "NewMyPersonCardTwoCell.h"
#import "PersonCardModel.h"

@implementation NewMyPersonCardTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = kSepLineColor;
    self.buttonSendMessage.hidden = DELETEHUANXIN;
    self.buttonMessageWidth.constant = Width_Layout(self.buttonMessageWidth.constant);
    self.buttonMessageHeight.constant = Height_Layout(self.buttonMessageHeight.constant);
    
    UITapGestureRecognizer *gesOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(careVGes:)];
    self.careV.userInteractionEnabled = YES;
    [self.careV addGestureRecognizer:gesOne];
    
    UITapGestureRecognizer *gesTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(flowerVGes:)];
    self.flowerV.userInteractionEnabled = YES;
    [self.flowerV addGestureRecognizer:gesTwo];
    
    UITapGestureRecognizer *gesThree = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(flagVGes:)];
    self.flagV.userInteractionEnabled = YES;
    [self.flagV addGestureRecognizer:gesThree];
    
    
    UITapGestureRecognizer *telePhoneGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(PhoneGes:)];
    self.telPhoneLineL.userInteractionEnabled = YES;
    [self.telPhoneLineL addGestureRecognizer:telePhoneGes];
    
    UITapGestureRecognizer *compGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(companyGes:)];
    self.companyNameL.userInteractionEnabled = YES;
    [self.companyNameL addGestureRecognizer:compGes];
    self.telPhoneLineL.textColor = HEX_COLOR(0x7D7DFF);
    self.companyNameL.textColor = HEX_COLOR(0x7D7DFF);
}

-(void)configData:(id)data{
    if([data isKindOfClass:[PersonCardModel class]]){
        PersonCardModel *model = data;
        self.trueNameL.text = model.trueName;
        [self.userPhotoImgV sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:DefaultManPic]];
        
        self.telPhoneLineL.text = model.phone;
        self.companyNameL.text = model.companyName;
        self.jobNameL.text = model.companyJob;
        [self.weXinQrImgV sd_setImageWithURL:[NSURL URLWithString:model.wxQrcode] placeholderImage:[UIImage imageNamed:DefaultIcon]];
        self.winXinL.text = model.weixin;
        self.emilL.text = model.email;
        self.addressL.text = model.companyAddress;
        [self.imageViewIcon setImage:[UIImage imageNamed:model.gender?@"man":@"woman"]];
        self.personAddressL.text = model.detailAddress;
        self.adageL.text = model.comment;
        
        self.flowerNumberLabel.text = [NSString stringWithFormat:@"鲜花：%@", model.flower];
        self.bannerNumberLabel.text = [NSString stringWithFormat:@"锦旗：%@", model.banner];
//        self.likeNumberLabel.text = [NSString stringWithFormat:@"关注：%@", model.likeNumbers];
        self.labelJobNameRight.text = model.jobName;
        model.companyAddress = [model.companyAddress ew_removeSpacesAndLineBreaks];
        if (model.companyAddress.length<=0||[model.clongitude integerValue]<=0||[model.clatitude integerValue]<=0) {
            //隐藏按钮
            self.companyAddressBtn.hidden = YES;
        }
        
        model.detailAddress = [model.detailAddress ew_removeSpacesAndLineBreaks];
        if (model.detailAddress.length<=0||[model.longitude integerValue]<=0||[model.latitude integerValue]<=0) {
            //隐藏按钮
            self.personAddressBtn.hidden = YES;
        }
        
    }
}

-(void)careVGes:(UITapGestureRecognizer *)ges{
    if ([self.delegate respondsToSelector:@selector(careSomeThing:)]) {
        [self.delegate careSomeThing:self];
    }
}

-(void)flowerVGes:(UITapGestureRecognizer *)ges{
    if ([self.delegate respondsToSelector:@selector(flowerSomeThing:)]) {
        [self.delegate flowerSomeThing:self];
    }
}

-(void)flagVGes:(UITapGestureRecognizer *)ges{
    if ([self.delegate respondsToSelector:@selector(flagSomeThing:)]) {
        [self.delegate flagSomeThing:self];
    }
}

-(void)PhoneGes:(UITapGestureRecognizer *)ges{
    if ([self.delegate respondsToSelector:@selector(callPhone)]) {
        [self.delegate callPhone];
    }
}

-(void)companyGes:(UITapGestureRecognizer *)ges{
    if ([self.delegate respondsToSelector:@selector(goCompanyYellowVc)]) {
        [self.delegate goCompanyYellowVc];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)comAddressClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(goCompanyAddress)]) {
        [self.delegate goCompanyAddress];
    }
}

- (IBAction)didTouchButtonMessage:(UIButton *)sender {
    if (self.blockDidTouchButtonMessage) {
        self.blockDidTouchButtonMessage();
    }
}

- (IBAction)perAddressClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(goPersonAddress)]) {
        [self.delegate goPersonAddress];
    }
}
@end
