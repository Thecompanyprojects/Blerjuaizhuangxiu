//
//  MyCashCouponDetailOneController.m
//  iDecoration
//
//  Created by sty on 2018/3/15.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "MyCashCouponDetailOneController.h"
#import "STYProductCouponDetailController.h"
#import "CodeView.h"

@interface MyCashCouponDetailOneController ()
@property (nonatomic, strong) UIImageView *bigImgV;
@property (nonatomic, strong) UILabel *messageL;
@property (nonatomic, strong) UIImageView *qrImgV;
@property (nonatomic, strong) UILabel *lookDetailL;
@property (nonatomic, strong) UILabel *tipL;
@end

@implementation MyCashCouponDetailOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"详情";
    
    [self setUI];
    [self initData];
}

-(void)setUI{
    [self.view addSubview:self.bigImgV];
    [self.view addSubview:self.messageL];
    [self.view addSubview:self.qrImgV];
    
    [self.view addSubview:self.tipL];
    [self.view addSubview:self.lookDetailL];
}

-(void)initData{
    NSMutableAttributedString *tempAttrStringOne = [[NSMutableAttributedString alloc] initWithString:@"恭喜您获得\n" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30], NSForegroundColorAttributeName: Yellow_Color} ];
    
    NSMutableAttributedString *tempAttrStringTwo = [[NSMutableAttributedString alloc] initWithString:self.model.companyName attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName: White_Color} ];
    [tempAttrStringOne appendAttributedString:tempAttrStringTwo];
    NSMutableAttributedString *tempAttrStringThree = [[NSMutableAttributedString alloc] initWithString:@"的红包\n" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName: Yellow_Color} ];
    [tempAttrStringOne appendAttributedString:tempAttrStringThree];
    
    NSString *strOne = @"兑换码：";
    strOne = [strOne stringByAppendingString:self.model.receiveCode];
    NSMutableAttributedString *tempAttrStringFour = [[NSMutableAttributedString alloc] initWithString:strOne attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:White_Color } ];
    [tempAttrStringOne appendAttributedString:tempAttrStringFour];
    
    self.messageL.attributedText = tempAttrStringOne;
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *shareURL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"cblejcouponcustomer/%@.do", self.model.receiveCode]];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *img = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:nil logoScaleToSuperView:0.3];
            self.qrImgV.image = img;
        });
    });
}


#pragma mark - 查看详情
-(void)lookDetail{
    STYProductCouponDetailController *vc = [[STYProductCouponDetailController alloc]init];
    if ([self.model.type integerValue]!=2) {
        vc.couponType = 1;
    }
    else{
        vc.couponType = 2;
        vc.giftId = self.model.giftId;
    }
    vc.couponAddress = self.model.exchangeAddress;
    vc.couponCode = self.model.receiveCode;
    vc.startTime = self.model.startDate;
    vc.endTime = self.model.endDate;
    vc.remark = self.model.remark;
    vc.isChangeTime = YES;
    vc.companyLogo = self.model.companyLogo;
    vc.companyName = self.model.companyName;
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIImageView *)bigImgV{
    if (!_bigImgV) {
        _bigImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.navigationController.navigationBar.bottom)];
        
        _bigImgV.image = [UIImage imageNamed:@"redpacket_bg_Two"];
        [_bigImgV sizeToFit];
        CGFloat height = kSCREEN_WIDTH*_bigImgV.height/_bigImgV.width;
        _bigImgV.frame = CGRectMake(0, (kSCREEN_HEIGHT-self.navigationController.navigationBar.bottom-height)/2, kSCREEN_WIDTH, height);
    }
    return _bigImgV;
}

-(UILabel *)messageL{
    if (!_messageL) {
        _messageL = [[UILabel alloc]initWithFrame:CGRectMake(30, self.bigImgV.top+20, kSCREEN_WIDTH-60, 80)];
//        _messageL.text = @"恭喜您获得";
//        _messageL.textColor = COLOR_BLACK_CLASS_3;
//        _messageL.font = NB_FONTSEIZ_NOR;
        _messageL.textAlignment = NSTextAlignmentCenter;
        _messageL.numberOfLines = 0;
    }
    return _messageL;
}

-(UIImageView *)qrImgV{
    if (!_qrImgV) {
        CGFloat ww = kSCREEN_WIDTH/8*3;
        _qrImgV = [[UIImageView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/2-ww/2, self.bigImgV.top+(self.bigImgV.height/2-ww/2), ww, ww)];
        _qrImgV.image = [UIImage imageNamed:DefaultIcon];
    }
    return _qrImgV;
}

-(UILabel *)tipL{
    if (!_tipL) {
        _tipL = [[UILabel alloc]initWithFrame:CGRectMake(20, self.bigImgV.bottom-80-30, kSCREEN_WIDTH-40, 80)];
        NSString *str = @"截图保存二维码\n请到发放红包的商家使用";
        _tipL.text = str;
        _tipL.textColor = COLOR_BLACK_CLASS_3;
        _tipL.font = NB_FONTSEIZ_NOR;
        _tipL.textAlignment = NSTextAlignmentCenter;
        _tipL.numberOfLines = 0;
        
        
        NSDictionary *attribute = @{NSFontAttributeName: NB_FONTSEIZ_NOR};
        CGSize retSize = [str boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-40, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        _tipL.frame = CGRectMake(20, self.bigImgV.height-retSize.height, kSCREEN_WIDTH-40, retSize.height);
        
    }
    return _tipL;
}

-(UILabel *)lookDetailL{
    if (!_lookDetailL) {
        _lookDetailL = [[UILabel alloc]initWithFrame:CGRectMake(20, self.tipL.top-20-10, kSCREEN_WIDTH-40, 20)];
        _lookDetailL.textColor = White_Color;
        _lookDetailL.font = NB_FONTSEIZ_NOR;
        _lookDetailL.textAlignment = NSTextAlignmentCenter;
        
        NSString *textStr = @"点击查看详情"; // 下划线
        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic]; //赋值
        
        [_lookDetailL setAttributedText:attribtStr];
        
        _lookDetailL.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookDetail)];
        [_lookDetailL addGestureRecognizer:ges];
    }
    return _lookDetailL;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
