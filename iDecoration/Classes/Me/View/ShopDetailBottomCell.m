//
//  ShopDetailBottomCell.m
//  iDecoration
//
//  Created by Apple on 2017/5/10.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ShopDetailBottomCell.h"
#import "CompanyPeopleInfoModel.h"
#import "QueryPeopleListModel.h"
#import "JoinCompanyModel.h"
#import "MemberSelectModel.h"
#import "CaseMaterialModel.h"
#import "MainMemberSelectModel.h"

@interface ShopDetailBottomCell()
@property (nonatomic,strong) UIImageView *chooseimg;
@end

@implementation ShopDetailBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameL.font = [UIFont systemFontOfSize:16];
    self.jobL.font = [UIFont systemFontOfSize:16];
    
    [self.contentView addSubview:self.chooseimg];
    [self.chooseimg setHidden:YES];
    [self setupUI];
}

-(void)setupUI
{
    [self.chooseimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameL.mas_right).with.offset(6);
        make.centerY.equalTo(self);
        make.width.mas_offset(18);
        make.height.mas_offset(18);
    }];
}

-(void)setImg:(id)imgchoose
{
    if ([imgchoose isEqualToString:@"1"]) {
        [self.chooseimg setHidden:NO];
    }
    else
    {
        [self.chooseimg setHidden:YES];
    }
}

-(UIImageView *)chooseimg
{
    if(!_chooseimg)
    {
        _chooseimg = [[UIImageView alloc] init];
        _chooseimg.image = [UIImage imageNamed:@"icon_zhixingjingli"];
    }
    return _chooseimg;
}





-(void)configData:(id)data{
    self.lookBtn.hidden = YES;
    if ([data isKindOfClass:[CompanyPeopleInfoModel class]]) {
        self.lookBtn.hidden = NO;
        CompanyPeopleInfoModel *model = data;
        self.nameL.text = model.agencysName;
        self.jobL.text = model.jobName;
        
        
        [self modefyJobBtn];
        [self deleteBtn];
        
        self.deleteBtn.hidden = YES;
        
        
        [self.photoImg sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:DefaultManPic]];
    }
    if ([data isKindOfClass:[QueryPeopleListModel class]]) {
        QueryPeopleListModel *model = data;
        self.nameL.text = model.trueName;
        self.jobL.hidden = YES;
        [self addSubview:self.addBtn];
        [self.addBtn setTitle:@"选择职位" forState:UIControlStateNormal];
        self.addBtn.centerY = self.contentView.centerY;
        [self.photoImg sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:DefaultManPic]];
    }
    if ([data isKindOfClass:[JoinCompanyModel class]]) {
        JoinCompanyModel *model = data;
        self.nameL.text = model.companyName;
//        self.nameL.frame = CGRectMake(100, 0, 200, 44);
        self.jobL.hidden = YES;
        [self addSubview:self.addBtn];
        [self.addBtn setTitle:@"选择职位" forState:UIControlStateNormal];
        self.addBtn.centerY = self.contentView.centerY;
        [self.photoImg sd_setImageWithURL:[NSURL URLWithString:model.companyLogo] placeholderImage:[UIImage imageNamed:DefaultManPic]];
    }
    
    if ([data isKindOfClass:[MemberSelectModel class]]) {
        MemberSelectModel *model = data;
        self.nameL.text = model.cJobTypeName;
        //        self.nameL.frame = CGRectMake(100, 0, 200, 44);
        self.jobL.hidden = YES;
        [self addSubview:self.addBtn];
        [self.addBtn setTitle:@"添加" forState:UIControlStateNormal];
        self.addBtn.frame = CGRectMake(kSCREEN_WIDTH-30-10, 7, 30, 30);
        self.addBtn.centerY = self.contentView.centerY;
        self.addBtn.backgroundColor = White_Color;
        self.photoImg.image = [UIImage imageNamed:@"jia"];
        self.photoImg.layer.borderWidth = 1;
        self.photoImg.layer.borderColor = COLOR_BLACK_CLASS_9.CGColor;
    }
    
    if ([data isKindOfClass:[MainMemberSelectModel class]]) {
        MainMemberSelectModel *model = data;
        self.nameL.text = model.cJobTYpeName;
        //        self.nameL.frame = CGRectMake(100, 0, 200, 44);
        self.jobL.hidden = YES;
        [self addSubview:self.addBtn];
        [self.addBtn setTitle:@"添加" forState:UIControlStateNormal];
        self.addBtn.frame = CGRectMake(kSCREEN_WIDTH-30-10, 7, 30, 30);
        self.addBtn.backgroundColor = White_Color;
        self.addBtn.centerY = self.contentView.centerY;
        self.photoImg.image = [UIImage imageNamed:@"jia"];
        self.photoImg.layer.borderWidth = 1;
        self.photoImg.layer.borderColor = COLOR_BLACK_CLASS_9.CGColor;
    }
    
    if ([data isKindOfClass:[NSDictionary class]]) {
        self.jobL.hidden = YES;
        NSDictionary *dic = data;
        NSString *photoStr = [dic objectForKey:@"photo"];
        [self.photoImg sd_setImageWithURL:[NSURL URLWithString:photoStr] placeholderImage:[UIImage imageNamed:DefaultManPic]];
        self.nameL.text = [dic objectForKey:@"trueName"];
    }
    
    if ([data isKindOfClass:[CaseMaterialModel class]]) {
        CaseMaterialModel *model = data;
        self.nameL.text = model.ccBuilder;
        //        self.nameL.frame = CGRectMake(100, 0, 200, 44);
        self.jobL.hidden = YES;
//        [self addSubview:self.addBtn];
//        [self.addBtn setTitle:@"添加" forState:UIControlStateNormal];
//        self.addBtn.frame = CGRectMake(kSCREEN_WIDTH-30-10, 7, 30, 30);
//        self.addBtn.backgroundColor = White_Color;
        [self.photoImg sd_setImageWithURL:[NSURL URLWithString:model.cdPicTure] placeholderImage:[UIImage imageNamed:DefaultManPic]];
//        self.photoImg.image = [UIImage imageNamed:@"jia"];
//        self.photoImg.layer.borderWidth = 1;
//        self.photoImg.layer.borderColor = COLOR_BLACK_CLASS_9.CGColor;
    }
}



- (IBAction)detailInfoClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(lookDetailInfo:)]) {
        [self.delegate lookDetailInfo:self.tag];
    }
}

-(UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(kSCREEN_WIDTH-80, 7, 80, 30);
        [_addBtn setTitle:@"选择职位" forState:UIControlStateNormal];
        _addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_addBtn setTitleColor:COLOR_BLACK_CLASS_9 forState:UIControlStateNormal];
        _addBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        _addBtn.layer.cornerRadius = 5;
        _addBtn.layer.masksToBounds = YES;
        _addBtn.backgroundColor = White_Color;
        [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        //                [_addressBtn setImage:[UIImage imageNamed:@"account"] forState:UIControlStateNormal];
    }
    return _addBtn;
}

-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(kSCREEN_WIDTH-55, 0, 55, 44);
        [self.contentView addSubview:_deleteBtn];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(0);
            make.right.equalTo(0);
            make.width.equalTo(55);
        }];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        _deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_deleteBtn setTitleColor:White_Color forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = NB_FONTSEIZ_NOR;
//        _deleteBtn.layer.cornerRadius = 5;
//        _deleteBtn.layer.masksToBounds = YES;
        _deleteBtn.backgroundColor = Red_Color;
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        //                [_addressBtn setImage:[UIImage imageNamed:@"account"] forState:UIControlStateNormal];
    }
    return _deleteBtn;
}

-(UIButton *)modefyJobBtn{
    if (!_modefyJobBtn) {
        _modefyJobBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _modefyJobBtn.frame = CGRectMake(kSCREEN_WIDTH-45, 7, 40, 40);
        [self.contentView addSubview:_modefyJobBtn];
        [_modefyJobBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.right.mas_equalTo(-15);
            make.size.equalTo(CGSizeMake(30, 30));
        }];
//        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
//        _deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        [_deleteBtn setTitleColor:White_Color forState:UIControlStateNormal];
//        _deleteBtn.titleLabel.font = NB_FONTSEIZ_NOR;
//        //        _deleteBtn.layer.cornerRadius = 5;
//        //        _deleteBtn.layer.masksToBounds = YES;
//        _deleteBtn.backgroundColor = Red_Color;
        [_modefyJobBtn addTarget:self action:@selector(modefyJobBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_modefyJobBtn setImage:[UIImage imageNamed:@"bianji-0"] forState:UIControlStateNormal];
    }
    return _modefyJobBtn;
}

-(void)addBtnClick{
    if ([self.delegate respondsToSelector:@selector(addPeopleWith:)]) {
        [self.delegate addPeopleWith:self.tag];
    }
}

-(void)deleteBtnClick{
    if ([self.delegate respondsToSelector:@selector(deletePeopleWith:)]) {
        [self.delegate deletePeopleWith:self.tag];
    }
}

-(void)modefyJobBtnClick{
    if ([self.delegate respondsToSelector:@selector(modifyJobWith:)]) {
        [self.delegate modifyJobWith:self.tag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
