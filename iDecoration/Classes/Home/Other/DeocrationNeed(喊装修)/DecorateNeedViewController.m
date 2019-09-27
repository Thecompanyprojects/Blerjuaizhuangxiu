//
//  DecorateNeedViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/10/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "DecorateNeedViewController.h"
#import "ClickTextView.h"
#import "DecorateNeedCell.h"
#import "NSObject+CompressImage.h"
#import "DecorateSpecificNeedViewController.h"
#import "ShopDecorateSpecificNeedViewController.h"

@interface DecorateNeedViewController ()<UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;

// 图片链接数组
@property (nonatomic, strong) NSMutableArray *imageURLArray;
// 图片数组
@property (nonatomic, strong) NSMutableArray *imageMulArray;
// 上传成功
@property (nonatomic, strong) UILabel *UploadSuccessLabel;
// 继续添加
@property (nonatomic, strong) UIButton *addButton;

@end

@implementation DecorateNeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 在线预约浏览量
    [NSObject needDecorationStatisticsWithConpanyId:self.companyID];
//    self.title = [self.companyType isEqualToString:@"1018"] ? @"在线预约" : @"在线预约";
    self.title = @"在线预约";
    self.view.backgroundColor = kBackgroundColor;
    
    self.imageURLArray = [NSMutableArray array];
    self.imageMulArray = [NSMutableArray array];
    
    [self tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




#pragma  mark - UITableViewDelegate/Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger imageCount = self.imageMulArray.count;
    if (imageCount > 0) {
        return imageCount;
    } else {
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DecorateNeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DecorateNeedCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    if (self.imageMulArray.count == 0) {
        
        cell.imageV.image = [UIImage imageNamed:@"huxingtu_add"];
        cell.imageHeight = (NSInteger)((kSCREEN_WIDTH - 20)/8.0 *5);
    } else {
        UIImage *image = self.imageMulArray[indexPath.row];
        cell.imageV.image = image;
        cell.imageHeight = (NSInteger)(image.size.height/image.size.width * (kSCREEN_WIDTH - 20));
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.imageMulArray.count == 0) {
        return (NSInteger)((kSCREEN_WIDTH - 20)/8.0 *5) + 20;
    } else {
        UIImage *image = self.imageMulArray[indexPath.row];
        CGFloat imageH = (NSInteger)(image.size.height/image.size.width * (kSCREEN_WIDTH - 20));
        return imageH + 20;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self selectImageAction];
}

#pragma mark - PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage*image = [self turnImageWithInfo:info];
    
    UIImage *cImage = [NSObject imageCompressFromImage:image];
    
    // 上传图片
    NSData *imageData = [NSObject imageData:image];
    if ([imageData length] >0) {
        imageData = [GTMBase64 encodeData:imageData];
    }
    NSString *imageStr = [[NSString alloc]initWithData:imageData encoding:NSUTF8StringEncoding];
    [self uploadImageWithBase64Str:imageStr andImage:cImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (UIImage *)turnImageWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    //类型为 UIImagePickerControllerOriginalImage 时调整图片角度
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImageOrientation imageOrientation=image.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp) {
            // 原始图片可以根据照相时的角度来显示，但 UIImage无法判定，于是出现获取的图片会向左转90度的现象。
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    return image;
    
}


-(void)uploadImageWithBase64Str:(NSString*)base64Str andImage:(UIImage *)image{
    [[UIApplication sharedApplication].keyWindow hudShow];
    UploadImageApi *uploadApi = [[UploadImageApi alloc]initWithImgStr:base64Str type:@"png"];
    
    MJWeakSelf;
    [uploadApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSDictionary *dic = request.responseJSONObject;
        NSString *code = [dic objectForKey:@"code"];
        
        if ([code isEqualToString:@"1000"]) {
            // 上传成功后返回的URL
            NSString *photoUrl = dic[@"imageUrl"];
            
            YSNLog(@"-------url: %@", photoUrl);
            [self.imageURLArray addObject:photoUrl];
            [self.imageMulArray addObject:image];
            
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            [[PublicTool defaultTool] publicToolsHUDStr:@"图片上传成功" controller:self sleep:1.5];
            [weakSelf.tableView reloadData];
            self.UploadSuccessLabel.hidden = NO;
            self.addButton.hidden = NO;
        } else {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            [[PublicTool defaultTool] publicToolsHUDStr:@"图片上传失败" controller:self sleep:1.5];
        }
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"图片上传失败" controller:self sleep:1.5];
    }];
}


#pragma mark - 下一步
- (void)nextStepAction {
    YSNLog(@"下一步%@", self.title);
    if (self.imageMulArray.count == 0) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请添加户型图"];
        return;
    }
    
    if ([self.companyType isEqualToString:@"1018"] || [self.companyType isEqualToString:@"1065"] || [self.companyType isEqualToString:@"1064"]) {
        DecorateSpecificNeedViewController *vc = [[DecorateSpecificNeedViewController alloc] init];
        vc.imageURLArray = self.imageURLArray;
        vc.companyID = self.companyID;
        vc.areaList = self.areaList;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ShopDecorateSpecificNeedViewController *vc = [[ShopDecorateSpecificNeedViewController alloc] init];
        vc.imageURLArray = self.imageURLArray;
        vc.companyID = self.companyID;
        vc.areaList = self.areaList;
        vc.companyType = self.companyType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark 跳过
- (void)skipNextAction {
    YSNLog(@"跳过%@", self.title);
    
    
    if ([self.companyType isEqualToString:@"1018"] || [self.companyType isEqualToString:@"1065"] || [self.companyType isEqualToString:@"1064"]) {
        DecorateSpecificNeedViewController *vc = [[DecorateSpecificNeedViewController alloc] init];
        vc.imageURLArray = nil;
        vc.companyID = self.companyID;
        vc.areaList = self.areaList;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ShopDecorateSpecificNeedViewController *vc = [[ShopDecorateSpecificNeedViewController alloc] init];
        vc.imageURLArray = nil;
        vc.companyID = self.companyID;
        vc.areaList = self.areaList;
        vc.companyType = self.companyType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark 选择图片
- (void)selectImageAction {
    MJWeakSelf;
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([TTHelper checkPhotoLibraryAuthorizationStatus]) {
            
            //初始化UIImagePickerController
            UIImagePickerController *pickerImageVC = [[UIImagePickerController alloc]init];
            // 获取方式1：通过相册（呈现全部相册) UIImagePickerControllerSourceTypePhotoLibrary
            // 获取方式2，通过相机              UIImagePickerControllerSourceTypeCamera
            // 获取方法3，通过相册（呈现全部图片）UIImagePickerControllerSourceTypeSavedPhotosAlbum
            pickerImageVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            // 允许编辑，即放大裁剪
            pickerImageVC.allowsEditing = NO;
            // 自代理
            pickerImageVC.delegate = weakSelf;
            // 页面跳转
            [weakSelf presentViewController:pickerImageVC animated:YES completion:nil];
        }
    }];
    UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([TTHelper checkCameraAuthorizationStatus]) {
            
            // 通过相机的方式
            UIImagePickerController *pickerImageVC = [[UIImagePickerController alloc] init];
            // 获取方式:通过相机
            pickerImageVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerImageVC.allowsEditing = NO;
            pickerImageVC.delegate = weakSelf;
            pickerImageVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [weakSelf presentViewController:pickerImageVC animated:YES completion:^{
                [pickerImageVC.view layoutIfNeeded];
            }];
            
        }
    }];
    UIAlertAction *alertAction3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:alertAction1];
    [alertC addAction:alertAction2];
    [alertC addAction:alertAction3];
    [self presentViewController:alertC animated:YES completion:nil];
}
#pragma mark - LazyMethod
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
//        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(74);
//            make.left.right.bottom.equalTo(0);
//        }];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[DecorateNeedCell class] forCellReuseIdentifier:@"DecorateNeedCell"];
    }
    return _tableView;
}


- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
        _headerView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [UILabel new];
        [_headerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(0);
        }];
        label.font = [UIFont systemFontOfSize:16];
        label.text = @"上传户型图";
        
        UIView *lineView = [UIView new];
        [_headerView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(1);
        }];
        lineView.backgroundColor = kBackgroundColor;
    
    }
    return _headerView;
}


- (UIView *)footerView {
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 260)];
        _footerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [UILabel new];
        self.UploadSuccessLabel = label;
        [_footerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(20);
            make.centerX.equalTo(-50);
            make.height.equalTo(20);
        }];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"户型图上传成功";
        label.hidden = YES;
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addButton = addButton;
        [_footerView addSubview:addButton];
        [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(label);
            make.centerX.equalTo(55);
            make.size.equalTo(CGSizeMake(90, 26));
        }];
        addButton.backgroundColor = [UIColor whiteColor];
        [addButton setTitle:@"继续添加" forState:UIControlStateNormal];
        [addButton setTitle:@"继续添加" forState:UIControlStateHighlighted];
        addButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [addButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [addButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        addButton.layer.cornerRadius = 13;
        addButton.layer.borderWidth = 1;
        addButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [addButton addTarget:self action:@selector(selectImageAction) forControlEvents:UIControlEventTouchUpInside];
        addButton.hidden = YES;
        
        ClickTextView *_clickTextView = nil;
        _clickTextView = [[ClickTextView alloc] initWithFrame:CGRectZero];
        [_footerView addSubview:_clickTextView];
        [_clickTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).equalTo(20);
            make.centerX.equalTo(0);
            make.height.equalTo(30);
        }];
        _clickTextView.font = [UIFont systemFontOfSize:14];
        _clickTextView.textColor = [UIColor lightGrayColor];
        _clickTextView.textAlignment = NSTextAlignmentCenter;
        _clickTextView.backgroundColor = [UIColor clearColor];
        
        NSString *content = @"暂无户型图？点此跳过>";
        // 设置文字
        _clickTextView.text = content;
        
        // 设置期中的一段文字有下划线，下划线的颜色为蓝色，点击下划线文字有相关的点击效果
        NSRange range1 = [content rangeOfString:@"点此跳过>"];
        MJWeakSelf;
        [_clickTextView setUnderlineTextWithRange:range1 withUnderlineColor:[UIColor blueColor] showUnderline:YES withClickCoverColor:[UIColor clearColor] withBlock:^(NSString *clickText) {
            // 文字点击事件
            [weakSelf skipNextAction];
        }];
        
        UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_footerView addSubview:nextButton];
        [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(_clickTextView.mas_bottom).equalTo(20);
            make.width.equalTo(kSCREEN_WIDTH/3.0 * 2);
            make.height.equalTo(40);
        }];
        [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [nextButton setTitle:@"下一步" forState:UIControlStateHighlighted];
        nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        nextButton.backgroundColor = kMainThemeColor;
        nextButton.layer.cornerRadius = 6;
        [nextButton addTarget:self action:@selector(nextStepAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        UILabel *propmtLabel = [UILabel new];
        [_footerView addSubview:propmtLabel];
        [propmtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(nextButton.mas_bottom).equalTo(10);
            make.size.equalTo(CGSizeMake(kSCREEN_WIDTH, 20));
        }];
        propmtLabel.textAlignment = NSTextAlignmentCenter;
        propmtLabel.textColor = [UIColor lightGrayColor];
        propmtLabel.font = [UIFont systemFontOfSize:12];
        propmtLabel.text = @"下一步：补充房屋信息、个人喜好，让方案更适合你";
    }
    return _footerView;
}
@end
