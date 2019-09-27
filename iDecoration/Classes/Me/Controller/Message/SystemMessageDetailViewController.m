//
//  SystemMessageDetailViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/6/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SystemMessageDetailViewController.h"
#import "YPImagePreviewController.h"

@interface SystemMessageDetailViewController ()

@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSString *detailString;

@property (nonatomic, strong) NSMutableArray *imageArray; // 图片地址数组
@property (nonatomic, strong) NSMutableArray *trueImageArray; // 图片视图数组
@property (nonatomic, strong) UILabel *sourceLabel;
@end

@implementation SystemMessageDetailViewController
#pragma mark - LifeMethod
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - NormalMethod

-(void)createUI{
    self.title = @"投诉详情";
   
    [self createBottomView];
    [self typeLabel];
    [self scrollView];
    
    
}

- (void)getData {
    [self.view hudShow];
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }

    NSString *agencyIdStr = [NSString stringWithFormat:@"%ld", (long)agencyid];
    NSString *messageId = [NSString stringWithFormat:@"%ld", (long)self.messageId];
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"complain/getDetail.do"];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    // 测试数据
//    [paramDic setObject:@"10003" forKeyedSubscript:@"agencyId"];
//    [paramDic setObject:@"309" forKeyedSubscript:@"id"];
    
    [paramDic setObject:agencyIdStr forKeyedSubscript:@"agencyId"];
    [paramDic setObject:messageId forKeyedSubscript:@"id"];
    
    [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.view hiddleHud];
        // 加载成功
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        
        if (code == 1000) {
            NSString *typeStr = [responseObj objectForKey:@"bean"][@"complainType"];
            self.typeLabel.text =[NSString stringWithFormat:@"投诉类型：%@", typeStr];
            self.detailString = [responseObj objectForKey:@"bean"][@"detail"];
            self.sourceLabel.text = [NSString stringWithFormat:@"来源于：%@",  [responseObj objectForKey:@"construction"][@"ccAreaName"]];
            
            NSArray *imageArray = [responseObj objectForKey:@"imgList"];
            for (NSDictionary *dic in imageArray) {
                [self.imageArray addObject:dic[@"picUrl"]];
            }
            
            UILabel *label = [self.scrollView viewWithTag:100];
            label.text = self.detailString;
            
            for (int i = 0; i < self.imageArray.count; i ++) {
                UIImageView *imageView = [self.scrollView viewWithTag:(1000+ i)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[i]]];
                imageView.hidden = NO;
                [self.trueImageArray addObject:imageView];

            }
            
            if (self.trueImageArray.count) {
                [self.trueImageArray enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL * _Nonnull stop) {
                    imageView.userInteractionEnabled = YES;
                    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                    [imageView addGestureRecognizer:tapGR];
                }];

            }
        
            
            CGSize size=[label.text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 36, MAXFLOAT) withFont:[UIFont systemFontOfSize:kSize(14)]];
            CGFloat height = 0;
            if (self.imageArray.count > 0) {
                UIImageView *imageView = [self.scrollView viewWithTag:1000];
                height += (imageView.frame.size.height + 18) * (self.imageArray.count / 3) + 18;
            }
            
            self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, size.height + height);
            
        } else {
            [self.view showHudFailed:@"没有内容"];
        }
        
    } failed:^(NSString *errorMsg) {
        [self.view hiddleHud];
        [self.view hudShowWithText:NETERROR];
        YSNLog(@"%@", NETERROR);
    }];
    
    
}

#pragma  mark - 点击图片方法
- (void)tapAction:(UITapGestureRecognizer *)tapGR {
    UIImageView *imageView = (UIImageView *)tapGR.view;
    NSInteger index = imageView.tag - 1000;
    [self lookPhoto:index imgArray:self.imageArray];
}

-(void)lookPhoto:(NSInteger)index imgArray:(NSArray *)imgArray{
    __weak YPImagePreviewController *weakSelf=self;
    YPImagePreviewController *yvc = [[YPImagePreviewController alloc]init];
    yvc.images = imgArray ;
    yvc.index = index ;
    UINavigationController *uvc = [[UINavigationController alloc]initWithRootViewController:yvc];
    [weakSelf presentViewController:uvc animated:YES completion:nil];
}

#pragma mark - LaxyMethod

- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}



- (NSMutableArray *)trueImageArray {
    if (_trueImageArray == nil) {
        _trueImageArray = [NSMutableArray array];
    }
    return _trueImageArray;
}
- (UILabel *)typeLabel {
    if (_typeLabel == nil) {
        _typeLabel = [[UILabel alloc] init];
        [self.view addSubview:_typeLabel];
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18 + 64);
            make.left.mas_equalTo(18);
            make.right.mas_equalTo(-18);
        }];
        _typeLabel.numberOfLines = 0;
        _typeLabel.font = [UIFont systemFontOfSize:kSize(16)];
        _typeLabel.text = @"";
    }
    return _typeLabel;
}

- (void)createBottomView {
    UILabel *bottomLabel = [[UILabel alloc] init];
    [self.view addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.right.bottom.equalTo(-18);
    }];
    bottomLabel.textColor = [UIColor lightGrayColor];
    bottomLabel.font = [UIFont systemFontOfSize:kSize(14)];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.numberOfLines = 0;
    bottomLabel.text = @"收到投诉信息，可能限制使用或封号，请尽快改正不符合项，以确保账号正常使用！";
    
    UIView *lineView = [UIView new];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(bottomLabel.mas_top).mas_equalTo(-18);
        make.height.mas_equalTo(1);
    }];
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *sourceLabel = [UILabel new];
    self.sourceLabel = sourceLabel;
    [self.view addSubview:sourceLabel];
    [sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.bottom.mas_equalTo(lineView.mas_top).mas_equalTo(-18);
    }];
    sourceLabel.textColor = [UIColor lightGrayColor];
    sourceLabel.font = [UIFont systemFontOfSize:kSize(14)];
    sourceLabel.text = @"来源于工地";
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.typeLabel.mas_bottom).mas_equalTo(18);
            make.bottom.mas_equalTo(self.sourceLabel.mas_top).mas_equalTo(-18);
            make.left.right.mas_equalTo(0);
        }];
        _scrollView.showsVerticalScrollIndicator = NO;
        
        UILabel *detailLabel = [UILabel new];
        [_scrollView addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.width.mas_equalTo(kSCREEN_WIDTH - 36);
            make.top.mas_equalTo(0);
        }];
        detailLabel.textColor = [UIColor lightGrayColor];
        detailLabel.font = [UIFont systemFontOfSize:kSize(14)];
        detailLabel.numberOfLines = 0;
        detailLabel.textAlignment = NSTextAlignmentLeft;
        detailLabel.tag = 100;
        
        
        // 图片外边距
        CGFloat margin = 18;
        // 图片内边距
        CGFloat padding = 9;
        // 图片款
        CGFloat width = (kSCREEN_WIDTH - 2 * margin  - 2 * padding) / 3.0;
        
        
        for (int i = 0; i < 30; i ++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [_scrollView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(detailLabel.mas_bottom).mas_equalTo(margin + (i / 3) * (width + padding));
                make.left.mas_equalTo(margin + (i % 3) * (width + padding));
                make.width.height.mas_equalTo(width);
            }];
            imageView.hidden = YES;
            imageView.tag = 1000 + i;
            
            
        }
        
        
        
    }
    return _scrollView;
}


@end
