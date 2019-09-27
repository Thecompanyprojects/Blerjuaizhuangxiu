//
//  DecorateNeedDetailViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/10/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "DecorateNeedDetailViewController.h"
#import "DecorateNeedDetailTopView.h"
#import "DecorateNeedCell.h"


@interface DecorateNeedDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) DecorateNeedDetailTopView *topView;
@property (nonatomic, strong) UIView *footerView;

// 图片URL数组
@property (nonatomic, strong) NSMutableArray *imageURLArray;
//图片数组
@property (nonatomic, strong)  NSMutableArray *imageArray;
@end

@implementation DecorateNeedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.view.backgroundColor = kBackgroundColor;
    
    self.imageURLArray = [@[] mutableCopy];
    self.imageArray = [@[] mutableCopy];
    for (int i = 0; i < self.model.imgList.count; i ++) {
        ImageObject *imageO = self.model.imgList[i];
        [self.imageURLArray addObject:imageO.picUrl];
        YSNLog(@"-----%@", imageO.picUrl);
    }
    [self tableView];
    
    
    [self setIsReadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - method
// 将已读
- (void)setIsReadData {
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"callDecoration/upRead.do"];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:@(self.model.decorationId) forKeyedSubscript:@"decorationId"];
    
    [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        // 加载成功
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        
        if (code == 1000) {
            YSNLog(@"------read");
        } else {
            YSNLog(@"------read");
        }
        
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma  mark - UITableViewDelegate/Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imageURLArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DecorateNeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DecorateNeedCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = kBackgroundColor;
    
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURLArray[indexPath.row]]]];
//    cell.imageHeight = image.size.height/image.size.width * (kSCREEN_WIDTH - 20);
//    cell.imageV.image = image;
    
    NSURL *url = [NSURL URLWithString:self.imageURLArray[indexPath.row]];
    [cell.imageV sd_setImageWithURL:url];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    BOOL existBool = [manager diskImageExistsForURL:url];//判断是否有缓存
    UIImage * image;
    if (existBool) {
        image = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
        [self.imageArray addObject:image];
    }else{
        NSData *data = [NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:data];
        [self.imageArray addObject:image];
    }
    if (image.size.width) {
        cell.imageHeight = image.size.height/image.size.width * (kSCREEN_WIDTH - 20);
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - LazyMethod
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        _tableView.backgroundColor = kBackgroundColor;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(74);
            make.left.right.bottom.equalTo(0);
        }];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
        if (self.imageURLArray.count > 0) {
            _tableView.tableFooterView = self.footerView;
        } else {
            _tableView.tableFooterView = [UIView new];
        }
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[DecorateNeedCell class] forCellReuseIdentifier:@"DecorateNeedCell"];
    }
    return _tableView;
}

- (UIView *)headerView {
    
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 10)];
        _headerView.backgroundColor = kBackgroundColor;
        
        DecorateNeedDetailTopView *topView;
        if ([self.model.area isEqualToString:@""] || [self.model.area isEqual:[NSNull null]] || !self.model.area) {

            topView = [[NSBundle mainBundle] loadNibNamed:@"DecorateNeedDetailTopView" owner:nil options:nil].lastObject;

            topView.backgroundColor = kBackgroundColor;
            topView.nameLabel.textColor = kMainThemeColor;
            topView.nameLabel.text = self.model.fullName;
            topView.phoneLabel.text = [NSString stringWithFormat:@"电话：%@", self.model.phone];
            topView.sourceLabel.text = self.model.source.length>0? self.model.source : @"爱装修";
            topView.decorateCompanyLabel.text = [NSString stringWithFormat:@"%@", self.model.companyName.length>0 ? self.model.companyName : @""];
        } else {
        
            topView = [[NSBundle mainBundle] loadNibNamed:@"DecorateNeedDetailTopView" owner:nil options:nil].firstObject;
            topView.backgroundColor = kBackgroundColor;
            topView.nameLabel.textColor = kMainThemeColor;
            topView.nameLabel.text = self.model.fullName;
            topView.phoneLabel.text = [NSString stringWithFormat:@"电话：%@", self.model.phone];
            topView.sourceLabel.text = self.model.source.length>0? self.model.source : @"爱装修";
            topView.decorateCompanyLabel.text = [NSString stringWithFormat:@"%@", self.model.companyName.length>0 ? self.model.companyName : @""];
            
            topView.peopleLabel.text = [NSString stringWithFormat:@"家庭人口情况：%@", self.model.familyStructure];
            topView.areaLabel.text = [NSString stringWithFormat:@"房屋面积：%@", self.model.area];
            topView.decorateAreaLabel.text = [NSString stringWithFormat:@"装修地区：%@", self.model.cityName.length>0 ? self.model.cityName : @""];
            if (!(self.model.cityName.length>0)) {
                [topView.decorateAreaLabel removeFromSuperview];
                [topView.budgeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(10);
                    make.right.equalTo(10);
                    make.height.equalTo(18);
                    make.top.equalTo(topView.areaLabel.mas_bottom).equalTo(4);
                }];
            }
            
            topView.budgeLabel.text = [NSString stringWithFormat:@"装修预算：%@", self.model.budget];
            topView.styleLabel.text = self.model.style;
            topView.colorLabel.text = self.model.tone;
            topView.specialNeedLabel.text = self.model.individualization;
            if (self.model.individualization.length <= 0) {
                [topView.specialNeedLabel removeFromSuperview];
                [topView.specialNeedNameLabel removeFromSuperview];
                [topView.colorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(topView.styleLabel.mas_bottom).equalTo(4);
                    make.left.equalTo(topView.colorNameLabel.mas_right).equalTo(0);
                    make.right.equalTo(10);
                    make.height.greaterThanOrEqualTo(18);
                    make.bottom.equalTo(-10);
                }];
            }
        }
        
        self.topView = topView;
        [_headerView addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return _headerView;
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    CGFloat height = self.topView.topView.frame.size.height + self.topView.bottomView.frame.size.height + 20;
    CGRect frame = self.headerView.frame;
    frame.size.height = height;
    self.headerView.frame = frame;
    
    
}

- (UIView *)footerView {
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 150)];
        _footerView.backgroundColor = kBackgroundColor;
        
        UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_footerView addSubview:nextButton];
        [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(0);
            make.width.equalTo(kSCREEN_WIDTH/3.0 * 2);
            make.height.equalTo(40);
        }];
        [nextButton setTitle:@"下载图片" forState:UIControlStateNormal];
        [nextButton setTitle:@"下载图片" forState:UIControlStateHighlighted];
        nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        nextButton.backgroundColor = kMainThemeColor;
        nextButton.layer.cornerRadius = 6;
        [nextButton addTarget:self action:@selector(downloadImageAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _footerView;
}

#pragma mark - 下载图片
- (void)downloadImageAction {
    for (int i = 0; i < self.imageArray.count; i ++) {
        [self loadImageFinished:self.imageArray[i]];
    }
}

- (void)loadImageFinished:(UIImage *)image{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    YSNLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    if (!error) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"图片已保存到相册"];
    } else {
        // 写入忙会出现error
    }
}

@end
