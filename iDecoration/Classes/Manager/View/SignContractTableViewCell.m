//
//  SignContractTableViewCell.m
//  iDecoration
//
//  Created by RealSeven on 2017/4/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SignContractTableViewCell.h"

@interface SignContractTableViewCell ()<SDWebImageManagerDelegate>
@property (nonatomic, strong) NSMutableArray *photoArray;
@end

@implementation SignContractTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path
{
     NSString *TextFieldCellID = [NSString stringWithFormat:@"SignContractTableViewCell%ld%ld",path.section,path.row];
    SignContractTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFieldCellID];
    
    if (cell == nil) {
        cell =[[SignContractTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextFieldCellID];
    }
    if (cell.cellHDict == nil) {
        
        cell.cellHDict = [NSMutableDictionary dictionary];
    }
    
    if (cell.MaincellHDict == nil) {
        cell.MaincellHDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(0),@"2",@(0),@"3",@(0),@"4",@(0),@"5",@(0),@"6",@(0),@"7",@(0),@"8",@(0),@"9",@(0),@"10",@(0),@"11",@(0),@"12", nil];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      
        [self addSubview:self.logo];
        [self addSubview:self.nameAndJob];
        [self addSubview:self.date];
        [self addSubview:self.lookDetailInfoBtn];
        [self addSubview:self.stateImage];
        [self addSubview:self.stateLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.contactImage];
        
        [self addSubview:self.discussBtn];
        [self addSubview:self.zanNumberLabel];
        [self addSubview:self.dianzan];
        [self addSubview:self.deletePointBtn];
        [self addSubview:self.lineV];
        [self addSubview:self.divView];
        
        [self addSubview:self.isSelfEditBtn];
        //        self.backgroundColor = COLOR_BLACK_CLASS_0;
        self.imgArray = [NSMutableArray array];
        self.photoArray = [NSMutableArray array];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}


-(void)configData:(id)data indexpath:(NSIndexPath *)path isComplete:(NSInteger)isComplete isLogin:(BOOL)isLogin isExit:(BOOL)isExit type:(NSInteger)type nodeName:(NSString *)nodeName{
    if ([data isKindOfClass:[NSDictionary class]]) {
        [self.imgArray removeAllObjects];
        [self.photoArray removeAllObjects];
        [self removeAllSubViews];
        
        [self addSubview:self.logo];
        [self addSubview:self.nameAndJob];
        [self addSubview:self.date];
        [self addSubview:self.lookDetailInfoBtn];
        [self addSubview:self.stateImage];
        [self addSubview:self.stateLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.contactImage];
        
        [self addSubview:self.discussBtn];
        [self addSubview:self.zanNumberLabel];
        [self addSubview:self.dianzan];
        [self addSubview:self.deletePointBtn];
        [self addSubview:self.lineV];
        [self addSubview:self.divView];
        
        [self addSubview:self.isSelfEditBtn];
        
        //CGFloat contentBottom = 100;
        NSDictionary *dict = data;
        
//        [self.contactImage removeAllSubViews];
        
    
        if (type==1) {
            NSDictionary *dic = [dict objectForKey:@"cblejJournalModel"];
            
            
            //填写人id
            NSInteger EditagencysId = [[dic objectForKey:@"agencysId"] integerValue];
            //只能修改自己的填写的节点
            UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
            if (EditagencysId == user.agencyId){
                if ((isComplete==2||isComplete==3)||(!isLogin)||(!isExit)){
                    self.isSelfEditBtn.hidden = YES;
                    self.deletePointBtn.hidden = YES;
                }else{
                    self.isSelfEditBtn.hidden = NO;
                    self.deletePointBtn.hidden = NO;
                }
                
            }else{
                self.isSelfEditBtn.hidden = YES;
                self.deletePointBtn.hidden = YES;
            }
            
            [self.logo sd_setImageWithURL:[dic objectForKey:@"photo"] placeholderImage:[UIImage imageNamed:DefaultIcon]];
            self.nameAndJob.text = [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"cJobTypeName"],[dic objectForKey:@"trueName"]];
            self.stateLabel.text = [dic objectForKey:@"crRoleName"];
            
            NSString *agencysId = [dic objectForKey:@"dzAgencysId"];//不为空则点过赞了
            if (!agencysId||agencysId.length<=0) {
                [self.dianzan setImage:[UIImage imageNamed:@"nosupport"] forState:UIControlStateNormal];
            }
            else{
                [self.dianzan setImage:[UIImage imageNamed:@"support"] forState:UIControlStateNormal];
            }
            
            NSString *str = [dic objectForKey:@"addTime"];
            NSString *timeStr = [self timeWithTimeIntervalString:str];
            self.date.text = timeStr;
            
            self.zanNumberLabel.text = [dic objectForKey:@"likeNum"];
            NSString *contentStr = [dic objectForKey:@"content"];
            self.contentLabel.text = contentStr;
            CGSize textSize = [contentStr boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-10*2, CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                       context:nil].size;
            if (contentStr.length<=0||textSize.height<50) {
                self.contentLabel.frame = CGRectMake(self.logo.left, self.logo.bottom+10, kSCREEN_WIDTH-10*2, 50);
            }
            else{
                self.contentLabel.frame = CGRectMake(self.logo.left, self.logo.bottom+10, kSCREEN_WIDTH-10*2, textSize.height+20);
            }
            
//            NSString *str3;
            NSArray *array = [dict objectForKey:@"imgList"];
            
            if (array.count<=0) {
//                str3 = @"";
                self.contactImage.hidden = YES;
                
                
                
                //已交工，未登录，不在工地 ，都不显示评论按钮
                
                if ((isComplete==2||isComplete==3)||(!isLogin)||(!isExit)){
                    self.discussBtn.hidden = YES;
                    self.zanNumberLabel.frame = CGRectMake(kSCREEN_WIDTH-40, self.contentLabel.bottom+10, 40, 15);
                    self.dianzan.frame = CGRectMake(self.zanNumberLabel.left-10-22, self.zanNumberLabel.top-3, 22, 22);
                    self.deletePointBtn.frame = CGRectMake(self.logo.left, self.dianzan.top,60,20);
                }
                else{
                    self.discussBtn.hidden = NO;
                    self.discussBtn.frame = CGRectMake(kSCREEN_WIDTH-22-15, self.contentLabel.bottom+10, 22, 20);
                    self.zanNumberLabel.frame = CGRectMake(self.discussBtn.left-20, self.discussBtn.top, 40, 15);
                    self.dianzan.frame = CGRectMake(self.zanNumberLabel.left-10-22, self.zanNumberLabel.top-3, 22, 22);
                    self.deletePointBtn.frame = CGRectMake(self.logo.left, self.dianzan.top,60,20);
                }
                
                self.lineV.frame = CGRectMake(0, self.dianzan.bottom+15, kSCREEN_WIDTH, 1);
                self.divView.frame = CGRectMake(0, self.zanNumberLabel.bottom+20, kSCREEN_WIDTH, 5);
                self.cellH = self.divView.bottom;
                
            }else{
                self.contactImage.hidden = YES;
                if (array.count == 1) {
                    
                    NSString *imgUrl = [array[0] objectForKey:@"picUrl"];
                    
                    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.contentLabel.bottom, kSCREEN_WIDTH/4*3, kSCREEN_WIDTH/4*3)];
                    imgView.contentMode = UIViewContentModeScaleAspectFill;
                    imgView.layer.masksToBounds = YES;
                    
                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
                    
                    NSString *key = [manager cacheKeyForURL:[NSURL URLWithString:imgUrl]];
                    SDImageCache *cache = [SDImageCache sharedImageCache];
                    UIImage *cachedImage = [cache imageFromDiskCacheForKey:key];
                    
                    if (cachedImage) {
                        imgView.image = cachedImage;
                        [imgView sizeToFit];
                        CGFloat orgialW = imgView.width;
                        CGFloat orgialH = imgView.height;
                        CGFloat nowW = orgialW;
                        CGFloat nowH = orgialH;
                        if (nowH>150) {
                            nowH = 150;
                            nowW = orgialW*nowH/orgialH;
                        }
                        
                        
                        if (nowW>(kSCREEN_WIDTH-20)) {
                            nowW = kSCREEN_WIDTH-20;
                            nowH = orgialH*nowW/orgialW;
                        }
                        
                        imgView.frame = CGRectMake(10, self.contentLabel.bottom+10, nowW,nowH);
                        
                        [self addSubview:imgView];
                        
                        
                        if ((isComplete==2||isComplete==3)||(!isLogin)||(!isExit)){
                            self.discussBtn.hidden = YES;
                            self.zanNumberLabel.frame = CGRectMake(kSCREEN_WIDTH-40, imgView.bottom+20, 40, 15);
                            self.dianzan.frame = CGRectMake(self.zanNumberLabel.left-10-22, self.zanNumberLabel.top-3, 22, 22);
                            self.deletePointBtn.frame = CGRectMake(self.logo.left, self.dianzan.top,60,20);
                        }
                        else{
                            self.discussBtn.hidden = NO;
                            self.discussBtn.frame = CGRectMake(kSCREEN_WIDTH-22-15, imgView.bottom+20, 22, 20);
                            self.zanNumberLabel.frame = CGRectMake(self.discussBtn.left-20, self.discussBtn.top, 40, 15);
                            self.dianzan.frame = CGRectMake(self.zanNumberLabel.left-10-22, self.zanNumberLabel.top-3, 22, 22);
                            self.deletePointBtn.frame = CGRectMake(self.logo.left, self.dianzan.top,60,20);
                        }
                        
                        
                        self.lineV.frame = CGRectMake(0, self.dianzan.bottom+15, kSCREEN_WIDTH, 1);
                        self.divView.frame = CGRectMake(0, self.zanNumberLabel.bottom+20, kSCREEN_WIDTH, 5);
                        self.cellH = self.divView.bottom;
                        //
                        [self.photoArray addObject:imgUrl];
                    }
                    
                    else{
                        
                        NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imgUrl]];
                        UIImage *image = [[UIImage alloc]initWithData:data];
                        if (!image) {
                            image = [UIImage imageNamed:@"default_icon"];
                        }
                        imgView.image = image;
                        [imgView sizeToFit];
                        CGFloat orgialW = imgView.width;
                        CGFloat orgialH = imgView.height;
                        CGFloat nowW = orgialW;
                        CGFloat nowH = orgialH;
                        if (nowH>150) {
                            nowH = 150;
                            nowW = orgialW*nowH/orgialH;
                        }
                        
                        
                        if (nowW>(kSCREEN_WIDTH-20)) {
                            nowW = kSCREEN_WIDTH-20;
                            nowH = orgialH*nowW/orgialW;
                        }
                        
                        imgView.frame = CGRectMake(10, self.contentLabel.bottom+10, nowW,nowH);
                        
                        [self addSubview:imgView];
                        
                        
                        if ((isComplete==2||isComplete==3)||(!isLogin)||(!isExit)){
                            self.discussBtn.hidden = YES;
                            self.zanNumberLabel.frame = CGRectMake(kSCREEN_WIDTH-40, imgView.bottom+20, 40, 15);
                            self.dianzan.frame = CGRectMake(self.zanNumberLabel.left-10-22, self.zanNumberLabel.top-3, 22, 22);
                            self.deletePointBtn.frame = CGRectMake(self.logo.left, self.dianzan.top,60,20);
                        }
                        else{
                            self.discussBtn.hidden = NO;
                            self.discussBtn.frame = CGRectMake(kSCREEN_WIDTH-22-15, imgView.bottom+20, 22, 20);
                            self.zanNumberLabel.frame = CGRectMake(self.discussBtn.left-20, self.discussBtn.top, 40, 15);
                            self.dianzan.frame = CGRectMake(self.zanNumberLabel.left-10-22, self.zanNumberLabel.top-3, 22, 22);
                            self.deletePointBtn.frame = CGRectMake(self.logo.left, self.dianzan.top,60,20);
                        }
                        
                        
                        self.lineV.frame = CGRectMake(0, self.dianzan.bottom+15, kSCREEN_WIDTH, 1);
                        self.divView.frame = CGRectMake(0, self.zanNumberLabel.bottom+20, kSCREEN_WIDTH, 5);
                        self.cellH = self.divView.bottom;
                        //
                        [self.photoArray addObject:imgUrl];
                        
                        [[SDImageCache sharedImageCache] storeImage:image forKey:key];
                        //                    [SDImageCache sharedImageCache] remove
                    }
                    
                    
                    
                    imgView.tag = 0;
                    imgView.userInteractionEnabled = YES;
                    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookWith:)];
                    [imgView addGestureRecognizer:ges];
                    
                }
                
                else if (array.count==4||array.count==2){
                    CGFloat w = (kSCREEN_WIDTH-30)/2;
                    CGFloat h = 0;
                    for (int i = 0; i<array.count; i++) {
                        NSString *imgUrl = [array[i] objectForKey:@"picUrl"];
                        NSInteger x = i/2;
                        NSInteger y = i%2;
                        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10+(w+10)*y,self.contentLabel.bottom+15+(w+10)*x, w,w)];
                        
                        imgView.contentMode = UIViewContentModeScaleAspectFill;
                        imgView.layer.masksToBounds = YES;
                        
                        
                        [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"default_icon"]];
                        //                    [self.imgArray addObject:image];
                        [self addSubview:imgView];
                        h = imgView.bottom;
                        
                        [self.photoArray addObject:imgUrl];
                        imgView.tag = i;
                        imgView.userInteractionEnabled = YES;
                        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookWith:)];
                        [imgView addGestureRecognizer:ges];
                    }
                    
                    if ((isComplete==2||isComplete==3)||(!isLogin)||(!isExit)){
                        self.discussBtn.hidden = YES;
                        self.zanNumberLabel.frame = CGRectMake(kSCREEN_WIDTH-40, h+20, 40, 15);
                        self.dianzan.frame = CGRectMake(self.zanNumberLabel.left-10-22, self.zanNumberLabel.top-3, 22, 22);
                        self.deletePointBtn.frame = CGRectMake(self.logo.left, self.dianzan.top,60,20);
                    }
                    else{
                        self.discussBtn.hidden = NO;
                        self.discussBtn.frame = CGRectMake(kSCREEN_WIDTH-22-15, h+20, 22, 20);
                        self.zanNumberLabel.frame = CGRectMake(self.discussBtn.left-20, self.discussBtn.top, 40, 15);
                        self.dianzan.frame = CGRectMake(self.zanNumberLabel.left-10-22, self.zanNumberLabel.top-3, 22, 22);
                        self.deletePointBtn.frame = CGRectMake(self.logo.left, self.dianzan.top,60,20);
                    }
                    
                    
                    self.lineV.frame = CGRectMake(0, self.dianzan.bottom+15, kSCREEN_WIDTH, 1);
                    self.divView.frame = CGRectMake(0, self.zanNumberLabel.bottom+20, kSCREEN_WIDTH, 5);
                    self.cellH = self.divView.bottom;
                    //                self.cellH = h+36;
                }
                else{
                    CGFloat w = (kSCREEN_WIDTH-40)/3;
                    CGFloat h = 0;
                    
                    if (array.count<=9) {
                        for (int i = 0; i<array.count; i++) {
                            NSString *imgUrl = [array[i] objectForKey:@"picUrl"];
                            NSInteger x = i/3;
                            NSInteger y = i%3;
                            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10+(w+10)*y,self.contentLabel.bottom+15+(w+10)*x, w,w)];
                            
                            imgView.contentMode = UIViewContentModeScaleAspectFill;
                            imgView.layer.masksToBounds = YES;
                            
                            [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"default_icon"]];
                            //                    [self.imgArray addObject:image];
                            [self addSubview:imgView];
                            h = imgView.bottom;
                            
                            [self.photoArray addObject:imgUrl];
                            imgView.tag = i;
                            imgView.userInteractionEnabled = YES;
                            UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookWith:)];
                            [imgView addGestureRecognizer:ges];
                        }
                    }
                    else{
                        for (int i = 0; i<array.count; i++) {
                            if (i<8) {
                                NSString *imgUrl = [array[i] objectForKey:@"picUrl"];
                                NSInteger x = i/3;
                                NSInteger y = i%3;
                                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10+(w+10)*y,self.contentLabel.bottom+15+(w+10)*x, w,w)];
                                
                                imgView.contentMode = UIViewContentModeScaleAspectFill;
                                imgView.layer.masksToBounds = YES;
                                
                                [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"default_icon"]];
                                //                    [self.imgArray addObject:image];
                                [self addSubview:imgView];
                                h = imgView.bottom;
                                
                                [self.photoArray addObject:imgUrl];
                                imgView.tag = i;
                                imgView.userInteractionEnabled = YES;
                                UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookWith:)];
                                [imgView addGestureRecognizer:ges];
                            }
                            else if (i==8){
                                NSString *imgUrl = [array[i] objectForKey:@"picUrl"];
                                NSInteger x = i/3;
                                NSInteger y = i%3;
                                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10+(w+10)*y,self.contentLabel.bottom+15+(w+10)*x, w,w)];
                                
                                imgView.contentMode = UIViewContentModeScaleAspectFill;
                                imgView.layer.masksToBounds = YES;
                                
                                [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"default_icon"]];
                                //                    [self.imgArray addObject:image];
                                [self addSubview:imgView];
                                
                                UIView *shoderV = [[UIView alloc]initWithFrame:imgView.frame];
                                shoderV.backgroundColor = Black_Color;
                                shoderV.alpha = 0.5;
                                [self addSubview:shoderV];
                                
                                UILabel *imgNumL = [[UILabel alloc]initWithFrame:CGRectMake(imgView.left, imgView.top+(imgView.height/2-20), imgView.width, 40)];
                                NSInteger chaNum = array.count-9;
                                imgNumL.text = [NSString stringWithFormat:@"+%ld",(long)chaNum];
                                imgNumL.textColor = White_Color;
                                imgNumL.font =  [UIFont systemFontOfSize:35];
                                imgNumL.textAlignment = NSTextAlignmentCenter;
                                [self addSubview:imgNumL];
                                
                                h = imgView.bottom;
                                
                                
                                [self.photoArray addObject:imgUrl];
                                imgView.tag = i;
                                imgView.userInteractionEnabled = YES;
                                
                                shoderV.tag = i;
                                shoderV.userInteractionEnabled = YES;
                                
                                imgNumL.tag = i;
                                imgNumL.userInteractionEnabled = YES;
                                UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookWith:)];
                                
                                [imgView addGestureRecognizer:ges];
                                [shoderV addGestureRecognizer:ges];
                                [imgNumL addGestureRecognizer:ges];
                            }
                            else{
                                NSString *imgUrl = [array[i] objectForKey:@"picUrl"];
                                [self.photoArray addObject:imgUrl];
                            }
                            
                        }
                    }
                    
                    
                    if ((isComplete==2||isComplete==3)||(!isLogin)||(!isExit)){
                        self.discussBtn.hidden = YES;
                        self.zanNumberLabel.frame = CGRectMake(kSCREEN_WIDTH-40, h+20, 40, 15);
                        self.dianzan.frame = CGRectMake(self.zanNumberLabel.left-10-22, self.zanNumberLabel.top-3, 22, 22);
                        self.deletePointBtn.frame = CGRectMake(self.logo.left, self.dianzan.top,60,20);
                    }
                    else{
                        self.discussBtn.hidden = NO;
                        self.discussBtn.frame = CGRectMake(kSCREEN_WIDTH-22-15, h+20, 22, 20);
                        self.zanNumberLabel.frame = CGRectMake(self.discussBtn.left-20, self.discussBtn.top, 40, 15);
                        self.dianzan.frame = CGRectMake(self.zanNumberLabel.left-10-22, self.zanNumberLabel.top-3, 22, 22);
                        self.deletePointBtn.frame = CGRectMake(self.logo.left, self.dianzan.top,60,20);
                    }
                    
                    
                    self.lineV.frame = CGRectMake(0, self.dianzan.bottom+15, kSCREEN_WIDTH, 1);
                    self.divView.frame = CGRectMake(0, self.zanNumberLabel.bottom+20, kSCREEN_WIDTH, 5);
                    self.cellH = self.divView.bottom;
                    //                self.cellH = h+36;
                }
            }
            
            NSArray *commentArray = [data objectForKey:@"commentList"];
            if (commentArray.count<=0) {
                self.lineV.hidden = YES;
            }
            else{
                self.lineV.hidden = NO;
                CGFloat h = self.divView.bottom+5;
                //UILabel *tmplabel = nil;
                for (int i = 0; i<commentArray.count; i++) {
                    NSDictionary *dict = commentArray[i];
                    NSString *job = [dict objectForKey:@"cJobTypeName"];
                    NSString *name = [dict objectForKey:@"trueName"];
                    NSString *content = [dict objectForKey:@"content"];
                    NSInteger tagInt = [[dict objectForKey:@"commentId"] integerValue];
                    UILabel *commentL = [[UILabel alloc]initWithFrame:CGRectMake(10, h, kSCREEN_WIDTH-10*2, 20)];
                    commentL.textColor = COLOR_BLACK_CLASS_3;
                    commentL.font = [UIFont systemFontOfSize
                                     :14];
                    NSString *temStr = [NSString stringWithFormat:@"%@-%@:%@",job,name,content];
                    commentL.text = temStr;
                    commentL.numberOfLines = 0;
                    commentL.textAlignment = NSTextAlignmentLeft;
                    
                    CGSize textSize = [temStr boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-10*2, CGFLOAT_MAX)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                           context:nil].size;
                    
                    commentL.frame = CGRectMake(10, h, kSCREEN_WIDTH-10*2, textSize.height);
                    
                    [self addSubview:commentL];
                    
                    commentL.tag = tagInt;
                    commentL.userInteractionEnabled = YES;

                    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
                    longPressGR.minimumPressDuration = 1.0f;
                    [commentL addGestureRecognizer:longPressGR];
                    h = h +textSize.height+5;
                    
                }
                self.divView.frame = CGRectMake(0, h+5, kSCREEN_WIDTH, 5);
                self.cellH = self.divView.bottom;
                
                //            self.cellH = h + 10;
            }
        }
        
        else{
            

                //填写人id
                NSInteger EditagencysId = [[dict objectForKey:@"agencysId"] integerValue];
                //只能修改自己的填写的节点
                UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
                if (EditagencysId == user.agencyId){
                    if ((isComplete==2||isComplete==3)||(!isLogin)||(!isExit)){
                        self.isSelfEditBtn.hidden = YES;
                        self.deletePointBtn.hidden = YES;
                    }else{
                        self.isSelfEditBtn.hidden = NO;
                        self.deletePointBtn.hidden = NO;
                    }
                    
                }else{
                    self.isSelfEditBtn.hidden = YES;
                    self.deletePointBtn.hidden = YES;
                }
                
                [self.logo sd_setImageWithURL:[dict objectForKey:@"photo"] placeholderImage:[UIImage imageNamed:DefaultIcon]];
                self.nameAndJob.text = [NSString stringWithFormat:@"%@-%@",[dict objectForKey:@"cJobTypeName"],[dict objectForKey:@"trueName"]];
                self.stateLabel.text = nodeName;
                
                NSInteger agencysId = [[dict objectForKey:@"dzAgencysId"]integerValue];//不为空则点过赞了
                if (!agencysId) {
                    [self.dianzan setImage:[UIImage imageNamed:@"nosupport"] forState:UIControlStateNormal];
                }
                else{
                    if (agencysId>0) {
                        [self.dianzan setImage:[UIImage imageNamed:@"support"] forState:UIControlStateNormal];
                    }
                    else{
                        [self.dianzan setImage:[UIImage imageNamed:@"nosupport"] forState:UIControlStateNormal];
                    }
                }
                
                NSString *str = [dict objectForKey:@"addTime"];
                NSString *timeStr = [self timeWithTimeIntervalString:str];
                self.date.text = timeStr;
                
            self.zanNumberLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"likeNum"]];
                NSString *contentStr = [dict objectForKey:@"content"];
                self.contentLabel.text = contentStr;
                CGSize textSize = [contentStr boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-10*2, CGFLOAT_MAX)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                           context:nil].size;
                if (contentStr.length<=0||textSize.height<50) {
                    self.contentLabel.frame = CGRectMake(self.logo.left, self.logo.bottom+10, kSCREEN_WIDTH-10*2, 50);
                }
                else{
                    self.contentLabel.frame = CGRectMake(self.logo.left, self.logo.bottom+10, kSCREEN_WIDTH-10*2, textSize.height+20);
                }
                
//                NSString *str3;
                NSArray *array = [dict objectForKey:@"imgList"];
                
                if (array.count<=0) {
//                    str3 = @"";
                    self.contactImage.hidden = YES;
                    
                    
                    
                    //已交工，未登录，不在工地 ，都不显示评论按钮
                    
                    if ((isComplete==2||isComplete==3)||(!isLogin)||(!isExit)){
                        self.discussBtn.hidden = YES;
                        self.zanNumberLabel.frame = CGRectMake(kSCREEN_WIDTH-40, self.contentLabel.bottom+10, 40, 15);
                        self.dianzan.frame = CGRectMake(self.zanNumberLabel.left-10-22, self.zanNumberLabel.top-3, 22, 22);
                        self.deletePointBtn.frame = CGRectMake(self.logo.left, self.dianzan.top,60,20);
                    }
                    else{
                        self.discussBtn.hidden = NO;
                        self.discussBtn.frame = CGRectMake(kSCREEN_WIDTH-22-15, self.contentLabel.bottom+10, 22, 20);
                        self.zanNumberLabel.frame = CGRectMake(self.discussBtn.left-20, self.discussBtn.top, 40, 15);
                        self.dianzan.frame = CGRectMake(self.zanNumberLabel.left-10-22, self.zanNumberLabel.top-3, 22, 22);
                        self.deletePointBtn.frame = CGRectMake(self.logo.left, self.dianzan.top,60,20);
                    }
                    
                    self.lineV.frame = CGRectMake(0, self.dianzan.bottom+15, kSCREEN_WIDTH, 1);
                    self.divView.frame = CGRectMake(0, self.zanNumberLabel.bottom+20, kSCREEN_WIDTH, 5);
                    self.cellH = self.divView.bottom;
                    
                }else{
                    self.contactImage.hidden = YES;
                    if (array.count == 1) {
                        
                        NSString *imgUrl = [array[0] objectForKey:@"picUrl"];
                        
                        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.contentLabel.bottom, kSCREEN_WIDTH/4*3, kSCREEN_WIDTH/4*3)];
                        imgView.contentMode = UIViewContentModeScaleAspectFill;
                        imgView.layer.masksToBounds = YES;
                        
                        SDWebImageManager *manager = [SDWebImageManager sharedManager];
                        
                        NSString *key = [manager cacheKeyForURL:[NSURL URLWithString:imgUrl]];
                        SDImageCache *cache = [SDImageCache sharedImageCache];
                        UIImage *cachedImage = [cache imageFromDiskCacheForKey:key];
                        
                        if (cachedImage) {
                            imgView.image = cachedImage;
                            [imgView sizeToFit];
                            CGFloat orgialW = imgView.width;
                            CGFloat orgialH = imgView.height;
                            CGFloat nowW = orgialW;
                            CGFloat nowH = orgialH;
                            if (nowH>150) {
                                nowH = 150;
                                nowW = orgialW*nowH/orgialH;
                            }
                            
                            
                            if (nowW>(kSCREEN_WIDTH-20)) {
                                nowW = kSCREEN_WIDTH-20;
                                nowH = orgialH*nowW/orgialW;
                            }
                            
                            imgView.frame = CGRectMake(10, self.contentLabel.bottom+10, nowW,nowH);
                            
                            [self addSubview:imgView];
                            
                            
                            if ((isComplete==2||isComplete==3)||(!isLogin)||(!isExit)){
                                self.discussBtn.hidden = YES;
                                self.zanNumberLabel.frame = CGRectMake(kSCREEN_WIDTH-40, imgView.bottom+20, 40, 15);
                                self.dianzan.frame = CGRectMake(self.zanNumberLabel.left-10-22, self.zanNumberLabel.top-3, 22, 22);
                                self.deletePointBtn.frame = CGRectMake(self.logo.left, self.dianzan.top,60,20);
                            }
                            else{
                                self.discussBtn.hidden = NO;
                                self.discussBtn.frame = CGRectMake(kSCREEN_WIDTH-22-15, imgView.bottom+20, 22, 20);
                                self.zanNumberLabel.frame = CGRectMake(self.discussBtn.left-20, self.discussBtn.top, 40, 15);
                                self.dianzan.frame = CGRectMake(self.zanNumberLabel.left-10-22, self.zanNumberLabel.top-3, 22, 22);
                                self.deletePointBtn.frame = CGRectMake(self.logo.left, self.dianzan.top,60,20);
                            }
                            
                            
                            self.lineV.frame = CGRectMake(0, self.dianzan.bottom+15, kSCREEN_WIDTH, 1);
                            self.divView.frame = CGRectMake(0, self.zanNumberLabel.bottom+20, kSCREEN_WIDTH, 5);
                            self.cellH = self.divView.bottom;
                            //
                            [self.photoArray addObject:imgUrl];
                        }
                        
                        else{
                            
                            NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imgUrl]];
                            UIImage *image = [[UIImage alloc]initWithData:data];
                            if (!image) {
                                image = [UIImage imageNamed:@"default_icon"];
                            }
                            imgView.image = image;
                            [imgView sizeToFit];
                            CGFloat orgialW = imgView.width;
                            CGFloat orgialH = imgView.height;
                            CGFloat nowW = orgialW;
                            CGFloat nowH = orgialH;
                            if (nowH>150) {
                                nowH = 150;
                                nowW = orgialW*nowH/orgialH;
                            }
                            
                            
                            if (nowW>(kSCREEN_WIDTH-20)) {
                                nowW = kSCREEN_WIDTH-20;
                                nowH = orgialH*nowW/orgialW;
                            }
                            
                            imgView.frame = CGRectMake(10, self.contentLabel.bottom+10, nowW,nowH);
                            
                            [self addSubview:imgView];
                            
                            
                            if ((isComplete==2||isComplete==3)||(!isLogin)||(!isExit)){
                                self.discussBtn.hidden = YES;
                                self.zanNumberLabel.frame = CGRectMake(kSCREEN_WIDTH-40, imgView.bottom+20, 40, 15);
                                self.dianzan.frame = CGRectMake(self.zanNumberLabel.left-10-22, self.zanNumberLabel.top-3, 22, 22);
                                self.deletePointBtn.frame = CGRectMake(self.logo.left, self.dianzan.top,60,20);
                            }
                            else{
                                self.discussBtn.hidden = NO;
                                self.discussBtn.frame = CGRectMake(kSCREEN_WIDTH-22-15, imgView.bottom+20, 22, 20);
                                self.zanNumberLabel.frame = CGRectMake(self.discussBtn.left-20, self.discussBtn.top, 40, 15);
                                self.dianzan.frame = CGRectMake(self.zanNumberLabel.left-10-22, self.zanNumberLabel.top-3, 22, 22);
                                self.deletePointBtn.frame = CGRectMake(self.logo.left, self.dianzan.top,60,20);
                            }
                            
                            
                            self.lineV.frame = CGRectMake(0, self.dianzan.bottom+15, kSCREEN_WIDTH, 1);
                            self.divView.frame = CGRectMake(0, self.zanNumberLabel.bottom+20, kSCREEN_WIDTH, 5);
                            self.cellH = self.divView.bottom;
                            //
                            [self.photoArray addObject:imgUrl];
                            
                            [[SDImageCache sharedImageCache] storeImage:image forKey:key];
                            //                    [SDImageCache sharedImageCache] remove
                        }
                        
                        
                        
                        imgView.tag = 0;
                        imgView.userInteractionEnabled = YES;
                        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookWith:)];
                        [imgView addGestureRecognizer:ges];
                        
                    }
                    
                    else if (array.count==4||array.count==2){
                        CGFloat w = (kSCREEN_WIDTH-30)/2;
                        CGFloat h = 0;
                        for (int i = 0; i<array.count; i++) {
                            NSString *imgUrl = [array[i] objectForKey:@"picUrl"];
                            NSInteger x = i/2;
                            NSInteger y = i%2;
                            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10+(w+10)*y,self.contentLabel.bottom+15+(w+10)*x, w,w)];
                            
                            imgView.contentMode = UIViewContentModeScaleAspectFill;
                            imgView.layer.masksToBounds = YES;
             
                            
                            [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"default_icon"]];
                            //                    [self.imgArray addObject:image];
                            [self addSubview:imgView];
                            h = imgView.bottom;
                            
                            [self.photoArray addObject:imgUrl];
                            imgView.tag = i;
                            imgView.userInteractionEnabled = YES;
                            UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookWith:)];
                            [imgView addGestureRecognizer:ges];
                        }
                        
                        if ((isComplete==2||isComplete==3)||(!isLogin)||(!isExit)){
                            self.discussBtn.hidden = YES;
                            self.zanNumberLabel.frame = CGRectMake(kSCREEN_WIDTH-40, h+20, 40, 15);
                            self.dianzan.frame = CGRectMake(self.zanNumberLabel.left-10-22, self.zanNumberLabel.top-3, 22, 22);
                            self.deletePointBtn.frame = CGRectMake(self.logo.left, self.dianzan.top,60,20);
                        }
                        else{
                            self.discussBtn.hidden = NO;
                            self.discussBtn.frame = CGRectMake(kSCREEN_WIDTH-22-15, h+20, 22, 20);
                            self.zanNumberLabel.frame = CGRectMake(self.discussBtn.left-20, self.discussBtn.top, 40, 15);
                            self.dianzan.frame = CGRectMake(self.zanNumberLabel.left-10-22, self.zanNumberLabel.top-3, 22, 22);
                            self.deletePointBtn.frame = CGRectMake(self.logo.left, self.dianzan.top,60,20);
                        }
                        
                        
                        self.lineV.frame = CGRectMake(0, self.dianzan.bottom+15, kSCREEN_WIDTH, 1);
                        self.divView.frame = CGRectMake(0, self.zanNumberLabel.bottom+20, kSCREEN_WIDTH, 5);
                        self.cellH = self.divView.bottom;
                        //                self.cellH = h+36;
                    }
                    else{
                        CGFloat w = (kSCREEN_WIDTH-40)/3;
                        CGFloat h = 0;
                        
                        if (array.count<=9) {
                            for (int i = 0; i<array.count; i++) {
                                NSString *imgUrl = [array[i] objectForKey:@"picUrl"];
                                NSInteger x = i/3;
                                NSInteger y = i%3;
                                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10+(w+10)*y,self.contentLabel.bottom+15+(w+10)*x, w,w)];
                                
                                imgView.contentMode = UIViewContentModeScaleAspectFill;
                                imgView.layer.masksToBounds = YES;
                                
                                [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"default_icon"]];
                                //                    [self.imgArray addObject:image];
                                [self addSubview:imgView];
                                h = imgView.bottom;
                                
                                [self.photoArray addObject:imgUrl];
                                imgView.tag = i;
                                imgView.userInteractionEnabled = YES;
                                UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookWith:)];
                                [imgView addGestureRecognizer:ges];
                            }
                        }
                        else{
                            for (int i = 0; i<array.count; i++) {
                                if (i<8) {
                                    NSString *imgUrl = [array[i] objectForKey:@"picUrl"];
                                    NSInteger x = i/3;
                                    NSInteger y = i%3;
                                    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10+(w+10)*y,self.contentLabel.bottom+15+(w+10)*x, w,w)];
                                    
                                    imgView.contentMode = UIViewContentModeScaleAspectFill;
                                    imgView.layer.masksToBounds = YES;
                                    
                                    [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"default_icon"]];
                                    //                    [self.imgArray addObject:image];
                                    [self addSubview:imgView];
                                    h = imgView.bottom;
                                    
                                    [self.photoArray addObject:imgUrl];
                                    imgView.tag = i;
                                    imgView.userInteractionEnabled = YES;
                                    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookWith:)];
                                    [imgView addGestureRecognizer:ges];
                                }
                                else if (i==8){
                                    NSString *imgUrl = [array[i] objectForKey:@"picUrl"];
                                    NSInteger x = i/3;
                                    NSInteger y = i%3;
                                    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10+(w+10)*y,self.contentLabel.bottom+15+(w+10)*x, w,w)];
                                    
                                    imgView.contentMode = UIViewContentModeScaleAspectFill;
                                    imgView.layer.masksToBounds = YES;
                                    
                                    [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"default_icon"]];
                                    //                    [self.imgArray addObject:image];
                                    [self addSubview:imgView];
                                    
                                    UIView *shoderV = [[UIView alloc]initWithFrame:imgView.frame];
                                    shoderV.backgroundColor = Black_Color;
                                    shoderV.alpha = 0.5;
                                    [self addSubview:shoderV];
                                    
                                    UILabel *imgNumL = [[UILabel alloc]initWithFrame:CGRectMake(imgView.left, imgView.top+(imgView.height/2-20), imgView.width, 40)];
                                    NSInteger chaNum = array.count-9;
                                    imgNumL.text = [NSString stringWithFormat:@"+%ld",(long)chaNum];
                                    imgNumL.textColor = White_Color;
                                    imgNumL.font =  [UIFont systemFontOfSize:35];
                                    imgNumL.textAlignment = NSTextAlignmentCenter;
                                    [self addSubview:imgNumL];
                                    
                                    h = imgView.bottom;
                                    
                                    
                                    [self.photoArray addObject:imgUrl];
                                    imgView.tag = i;
                                    imgView.userInteractionEnabled = YES;
                                    
                                    shoderV.tag = i;
                                    shoderV.userInteractionEnabled = YES;
                                    
                                    imgNumL.tag = i;
                                    imgNumL.userInteractionEnabled = YES;
                                    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookWith:)];
                                    
                                    [imgView addGestureRecognizer:ges];
                                    [shoderV addGestureRecognizer:ges];
                                    [imgNumL addGestureRecognizer:ges];
                                }
                                else{
                                    NSString *imgUrl = [array[i] objectForKey:@"picUrl"];
                                    [self.photoArray addObject:imgUrl];
                                }
                                
                            }
                        }
                        
                        
                        if ((isComplete==2||isComplete==3)||(!isLogin)||(!isExit)){
                            self.discussBtn.hidden = YES;
                            self.zanNumberLabel.frame = CGRectMake(kSCREEN_WIDTH-40, h+20, 40, 15);
                            self.dianzan.frame = CGRectMake(self.zanNumberLabel.left-10-22, self.zanNumberLabel.top-3, 22, 22);
                            self.deletePointBtn.frame = CGRectMake(self.logo.left, self.dianzan.top,60,20);
                        }
                        else{
                            self.discussBtn.hidden = NO;
                            self.discussBtn.frame = CGRectMake(kSCREEN_WIDTH-22-15, h+20, 22, 20);
                            self.zanNumberLabel.frame = CGRectMake(self.discussBtn.left-20, self.discussBtn.top, 40, 15);
                            self.dianzan.frame = CGRectMake(self.zanNumberLabel.left-10-22, self.zanNumberLabel.top-3, 22, 22);
                            self.deletePointBtn.frame = CGRectMake(self.logo.left, self.dianzan.top,60,20);
                        }
                        
                        
                        self.lineV.frame = CGRectMake(0, self.dianzan.bottom+15, kSCREEN_WIDTH, 1);
                        self.divView.frame = CGRectMake(0, self.zanNumberLabel.bottom+20, kSCREEN_WIDTH, 5);
                        self.cellH = self.divView.bottom;
                    }
                }
                
                NSArray *commentArray = [data objectForKey:@"commentList"];
                if (commentArray.count<=0) {
                    self.lineV.hidden = YES;
                }
                else{
                    self.lineV.hidden = NO;
                    CGFloat h = self.divView.bottom+5;
                    UILabel *tmplabel = nil;
                    for (int i = 0; i<commentArray.count; i++) {
                        NSDictionary *dict = commentArray[i];
                        NSString *job = [dict objectForKey:@"cJobTypeName"];
                        NSString *name = [dict objectForKey:@"trueName"];
                        NSString *content = [dict objectForKey:@"content"];
                        NSInteger tagInt = [[dict objectForKey:@"commentId"] integerValue];
                        UILabel *commentL = [[UILabel alloc]initWithFrame:CGRectMake(10, h, kSCREEN_WIDTH-10*2, 20)];
                        commentL.textColor = COLOR_BLACK_CLASS_3;
                        commentL.font = [UIFont systemFontOfSize
                                         :14];
                        NSString *temStr = [NSString stringWithFormat:@"%@-%@:%@",job,name,content];
                        commentL.text = temStr;
                        commentL.numberOfLines = 0;
                        commentL.textAlignment = NSTextAlignmentLeft;
                        
                        CGSize textSize = [temStr boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-10*2, CGFLOAT_MAX)
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                               context:nil].size;
                        
                        commentL.frame = CGRectMake(10, h, kSCREEN_WIDTH-10*2, textSize.height);
                        
                        [self addSubview:commentL];
                        
                        commentL.tag = tagInt;
                        commentL.userInteractionEnabled = YES;
//                        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                        //                [commentL addGestureRecognizer:tapGR];
                        
                        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
                        longPressGR.minimumPressDuration = 1.0f;
                        [commentL addGestureRecognizer:longPressGR];
                        h = h +textSize.height+5;
                        
                    }
                    self.divView.frame = CGRectMake(0, h+5, kSCREEN_WIDTH, 5);
                    self.cellH = self.divView.bottom;
                    
                    //            self.cellH = h + 10;
                }
            
        }
        
        }
    
        
        
}


- (void)tapAction:(UITapGestureRecognizer *)tapGR {
    YSNLog(@"点击评论");

}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPressGR {
    YSNLog(@"删除评论");
    UILabel *label = (UILabel *)longPressGR.view;
    if ([self.delegate respondsToSelector:@selector(longPressCommentLabel:indexPath:)]) {
        [self.delegate longPressCommentLabel:label indexPath:self.path];
    }
}

#pragma mark - setter

-(UIImageView *)logo{
    if (!_logo) {
        _logo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        _logo.layer.masksToBounds = YES;
        _logo.layer.cornerRadius = 20;
    }
    return _logo;
}

-(UILabel *)nameAndJob{
    if (!_nameAndJob) {
        _nameAndJob = [[UILabel alloc]initWithFrame:CGRectMake(self.logo.right+10, 10, 200, 20)];
        _nameAndJob.textColor = COLOR_BLACK_CLASS_3;
        _nameAndJob.font = [UIFont systemFontOfSize
                         :14];
        //        companyJob.backgroundColor = Red_Color;
        _nameAndJob.textAlignment = NSTextAlignmentLeft;
    }
    return _nameAndJob;
}


-(UILabel *)date{
    if (!_date) {
        _date = [[UILabel alloc]initWithFrame:CGRectMake(self.nameAndJob.left, self.nameAndJob.bottom, 100, 20)];
        _date.textColor = COLOR_BLACK_CLASS_3;
        _date.font = [UIFont systemFontOfSize
                         :12];
        //        companyJob.backgroundColor = Red_Color;
        _date.textAlignment = NSTextAlignmentLeft;
    }
    return _date;
}

-(UIButton *)lookDetailInfoBtn{
    if (!_lookDetailInfoBtn) {
        _lookDetailInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lookDetailInfoBtn.frame = CGRectMake(self.logo.left, self.logo.top, self.date.right, self.date.bottom);
        [_lookDetailInfoBtn addTarget:self action:@selector(lookDetailInfoBtnClik:) forControlEvents:UIControlEventTouchUpInside];
        _lookDetailInfoBtn.backgroundColor = Clear_Color;
    }
    return _lookDetailInfoBtn;
}

-(UIImageView *)stateImage{
    if (!_stateImage) {
        _stateImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.date.right, self.date.top+5, 10, 10)];
        _stateImage.image = [UIImage imageNamed:@"ty_red"];
    }
    return _stateImage;
}

-(UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.stateImage.right,self.date.top,100,20)];
        _stateLabel.textColor = Red_Color;
        _stateLabel.font = [UIFont systemFontOfSize
                         :12];
//                companyJob.backgroundColor = Red_Color;
        _stateLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _stateLabel;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.logo.left, self.logo.bottom, kSCREEN_WIDTH-10*2, 40)];
        _contentLabel.textColor = COLOR_BLACK_CLASS_3;
        _contentLabel.font = [UIFont systemFontOfSize
                         :14];
        _contentLabel.numberOfLines = 0;
        //        companyJob.backgroundColor = Red_Color;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentClick)];
        _contentLabel.userInteractionEnabled = YES;
        [_contentLabel addGestureRecognizer:ges];
    }
    return _contentLabel;
}

-(UIImageView *)contactImage{
    if (!_contactImage) {
        _contactImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.logo.left, self.contentLabel.bottom, kSCREEN_WIDTH/4*3, kSCREEN_WIDTH/4*3)];
    }
    return _contactImage;
}

-(UIButton *)discussBtn{
    if (!_discussBtn) {
        _discussBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _discussBtn.frame = CGRectMake(kSCREEN_WIDTH-22-15, self.contactImage.bottom, 22, 20);
        [_discussBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [_discussBtn addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _discussBtn;
}

-(UILabel *)zanNumberLabel{
    if (!_zanNumberLabel) {
        _zanNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.discussBtn.left-10-40, self.discussBtn.top, 40, 15)];
        _zanNumberLabel.textColor = COLOR_BLACK_CLASS_3;
        _zanNumberLabel.font = [UIFont systemFontOfSize
                         :14];
        //        companyJob.backgroundColor = Red_Color;
        _zanNumberLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _zanNumberLabel;
}

-(UIButton *)dianzan{
    if (!_dianzan) {
        _dianzan = [UIButton buttonWithType:UIButtonTypeCustom];
        _dianzan.frame = CGRectMake(self.zanNumberLabel.left-10-22, self.zanNumberLabel.top-3, 22, 22);
        //            _addressBtn.backgroundColor = Red_Color;
        [_dianzan setImage:[UIImage imageNamed:@"nosupport"] forState:UIControlStateNormal];
        [_dianzan addTarget:self action:@selector(dianzanClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dianzan;
}

-(UIButton *)deletePointBtn{
    if (!_deletePointBtn) {
        _deletePointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deletePointBtn.frame = CGRectMake(self.logo.left, self.dianzan.top,60,25);
        //            _addressBtn.backgroundColor = Red_Color;
        [_deletePointBtn setTitle:@"删 除" forState:UIControlStateNormal];
        [_deletePointBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
        _deletePointBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _deletePointBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        [_deletePointBtn addTarget:self action:@selector(deletePoinClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deletePointBtn;
}

-(UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 80, kSCREEN_WIDTH, 1)];
        _lineV.backgroundColor = RGB(230, 230, 230);
    }
    return _lineV;
}

-(UIView *)divView{
    if (!_divView) {
        _divView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, kSCREEN_WIDTH, 10)];
//        _divView.backgroundColor = RGB(230, 230, 230);
        _divView.backgroundColor = Bottom_Color;
    }
    return _divView;
}

-(UIButton *)isSelfEditBtn{
    if (!_isSelfEditBtn) {
        _isSelfEditBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _isSelfEditBtn.frame = CGRectMake(kSCREEN_WIDTH-25-15, self.nameAndJob.bottom-5, 25, 25);
        //            _addressBtn.backgroundColor = Red_Color;
        [_isSelfEditBtn setImage:[UIImage imageNamed:@"editDiary"] forState:UIControlStateNormal];
//        _isSelfEditBtn.backgroundColor = Red_Color;
        [_isSelfEditBtn addTarget:self action:@selector(contentClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _isSelfEditBtn;
}

-(void)dianzanClick{
    if ([self.delegate respondsToSelector:@selector(zanWith:)]) {
        [self.delegate zanWith:self.path];
    }
}

-(void)commentClick{
    if ([self.delegate respondsToSelector:@selector(commentWith:)]) {
        [self.delegate commentWith:self.path];
    }
}

-(void)contentClick{
    if ([self.delegate respondsToSelector:@selector(editWith:)]) {
        [self.delegate editWith:self.path];
    }
}

-(void)deletePoinClick{
    if ([self.delegate respondsToSelector:@selector(deletePointWith:)]) {
        [self.delegate deletePointWith:self.path];
    }
}

-(void)lookDetailInfoBtnClik:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(lookInfoWith:)]) {
        [self.delegate lookInfoWith:self.path];
    }
}

-(void)lookWith:(UITapGestureRecognizer *)ges{
    NSInteger gesTag = ges.view.tag;
    NSArray *temArray = [self.photoArray copy];
    if ([self.delegate respondsToSelector:@selector(lookPhoto:imgArray:)]) {
        [self.delegate lookPhoto:gesTag imgArray:temArray];
    }
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
