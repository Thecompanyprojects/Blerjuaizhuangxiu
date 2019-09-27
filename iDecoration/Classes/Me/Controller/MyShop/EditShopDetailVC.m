//
//  EditShopDetailVC.m
//  iDecoration
//
//  Created by zuxi li on 2017/7/10.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "EditShopDetailVC.h"
#import "ZCHEditGoodsCell.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "NSObject+CompressImage.h"
#import "CanSeeSelectedView.h"

static NSString *reuseIdentifier = @"ZCHEditGoodsCell";

@interface EditShopDetailVC ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ZCHEditGoodsCellDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) UIButton *topImageBtn; // 顶部图片按钮
@property (strong, nonatomic) UITextField *productNameTF; // 名称TextField
@property (strong, nonatomic) UITextField *priceTF; // 价格textField
@property (assign, nonatomic) NSInteger cellCount;

@property (strong, nonatomic) UIButton *isClickedImageBtn;
@property (assign, nonatomic) NSInteger isClickedImageIndex;
@property (strong, nonatomic) NSMutableArray *listArr;
@property (strong, nonatomic) UIImage *isSelectedImage;
@property (strong, nonatomic) NSMutableString *topImageURL;

@property (strong, nonatomic) NSMutableArray *paramArr;

@property (nonatomic, strong) NSString *productNameStr;
@property (nonatomic, strong) NSString *priceStr;
//@property (nonatomic, strong) NSString *topURlStr;

// 原始图片选择
@property (strong, nonatomic) UIView *imageBgView;
@property (copy, nonatomic) NSString *imageStr;

@property (nonatomic, strong) CanSeeSelectedView *selectedView; // 选择什么网可见
@property (nonatomic, strong) UILabel *canSeeLabel; // 什么网可见
@property (nonatomic, assign) NSInteger isDispaly; // 什么网可见接口返回数据

@end

@implementation EditShopDetailVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"编辑商品";
    self.view.backgroundColor = kBackgroundColor;
    self.paramArr = [NSMutableArray array];
    // 单独处理这里的返回按钮(因为需要返回到根控制器)
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
    if (self.topDic) {
        
        self.topImageURL = [NSMutableString stringWithString:self.topDic[@"display"]];
        self.productNameStr = self.topDic[@"name"];
        self.priceStr = self.topDic[@"price"];
        
        self.cellCount = self.dataArr.count;
        for (int i = 0; i < self.dataArr.count; i ++) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArr[i]];
            // 2 表示删除  0 表示新增
            [dic setObject:@"2" forKey:@"operation"];
            [self.paramArr addObject:dic];
        }
        
        for (int i = 0; i < self.dataArr.count; i ++) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArr[i]];
            // 2 表示删除  0 表示新增
            [dic setObject:@"0" forKey:@"operation"];
            [dic setObject:self.topDic[@"id"] forKey:@"merchandiesId"];
            [dic setObject:@"0" forKey:@"instructionId"];
            [self.dataArr replaceObjectAtIndex:i withObject:dic];
        }
    } else {
        
        self.listArr = [NSMutableArray array];
        [self.listArr addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"content" : @"", @"imgUrl" : @""}]];
        self.cellCount = 1;
    }
    
    
    
    [self setUpUI];
    [self tableView];
    [self setUpSelectedView];
    
}

- (void)setUpSelectedView {
    self.canSeeLabel = [[UILabel alloc] init];
    self.canSeeLabel.text = @"内外网全部显示";
    self.isDispaly = 2;
    
    self.selectedView = [[NSBundle mainBundle] loadNibNamed:@"CanSeeSelectedView" owner:self options:nil].lastObject;
    [self.view addSubview:self.selectedView];
    self.selectedView.frame = self.view.frame;
    self.selectedView.hidden = YES;
    
    if (self.isEditVC) {
        // 添加商品 默认可以不用设置  如果编辑商品需要设置selectedIndex和caSeeLabel.text
        // self.topDic[@"isDisplay"]  取值为0 1 2
        NSInteger index = [self.topDic[@"isDisplay"] integerValue] + 1;
        self.selectedView.selectedIndex = index;
        switch (index) {
            case 1:
                self.canSeeLabel.text = @"只显示在内网";
                self.isDispaly = 0;
                break;
            case 2:
                self.canSeeLabel.text = @"只显示在外网";
                self.isDispaly = 1;
                break;
            case 3:
                self.canSeeLabel.text = @"内外网全部显示";
                self.isDispaly = 2;
                break;
            default:
                break;
        }
    }
    
    MJWeakSelf;
    self.selectedView.selectedBlock = ^(NSString *str, NSInteger index) {
        if (str.length > 0) {
            weakSelf.canSeeLabel.text = str;
            weakSelf.isDispaly = index - 1;
        }
    };
}
- (void)back {
    
    TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"是否退出编辑？" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)setUpUI {
    
    // 添加底部视图
//    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 150)];
//    bottomView.backgroundColor = White_Color;
//    
//    UIButton *continueAddBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth - 100, 60, 100, 40)];
//    [continueAddBtn setTitleColor:Black_Color forState:UIControlStateNormal];
//    [continueAddBtn setTitle:@"继续添加" forState:UIControlStateNormal];
//    [continueAddBtn addTarget:self action:@selector(didClickContinueBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomView addSubview:continueAddBtn];
//    self.tableView.tableFooterView = bottomView;
    
    // 设置导航栏最右侧的按钮
    UIButton *completeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    completeBtn.frame = CGRectMake(0, 0, 44, 44);
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    completeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    completeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    completeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    completeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [completeBtn addTarget:self action:@selector(didClickCompleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:completeBtn];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 7;  // 显示选择内外网可见 需要返回7个section
//    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 4) {
        return self.cellCount;
    }else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            UILabel *label = [[UILabel alloc] init];
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(20);
                make.centerX.equalTo(0);
            }];
            label.font = [UIFont systemFontOfSize:16];
            label.text = @"上传封面";
            
            self.topImageBtn = [[UIButton alloc] init];
            [self.topImageBtn setBackgroundImage:[UIImage imageNamed:@"jia_kuang"] forState:UIControlStateNormal];
//            self.topImageBtn.backgroundColor = kBackgroundColor;
            [cell.contentView addSubview:self.topImageBtn];
            [self.topImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(CGSizeMake(150, 150));
                make.top.equalTo(label.mas_bottom).equalTo(10);
                make.centerX.equalTo(0);
                make.bottom.equalTo(-10);
            }];
//            self.topImageBtn.layer.borderWidth = 2;
//            self.topImageBtn.layer.borderColor = kBackgroundColor.CGColor;
            [self.topImageBtn addTarget:self action:@selector(didClickTopImageBtn:) forControlEvents:UIControlEventTouchUpInside];
            self.topImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
//            if (self.topDic) {
//                self.topImageURL = self.topDic[@"display"];
//                [self.topImageBtn sd_setImageWithURL:self.topDic[@"display"] forState:UIControlStateNormal];
//                self.productNameTF.text = self.topDic[@"name"];
//                self.priceTF.text = self.topDic[@"price"];
//            } else {
            if (self.topImageURL != nil && ![self.topImageURL isEqualToString:@""]) {
                
                [self.topImageBtn sd_setImageWithURL:[NSURL URLWithString:self.topImageURL] forState:UIControlStateNormal];
            }
//            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        return [UITableViewCell new];
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            UILabel *label = [[UILabel alloc] init];
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(20);
                make.centerY.equalTo(0);
            }];
            label.font = [UIFont systemFontOfSize:16];
            label.text = @"产品名称";
            self.productNameTF = [[UITextField alloc] init];
            [cell.contentView addSubview:self.productNameTF];
            [self.productNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(100);
                make.right.equalTo(-10);
                make.height.equalTo(30);
                make.centerY.equalTo(0);
            }];
            self.productNameTF.delegate = self;
            self.productNameTF.tag = 1001;
            self.productNameTF.font = [UIFont systemFontOfSize:16];
            self.productNameTF.placeholder = @"请输入产品名称/型号";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            if (self.topDic) {
//                self.productNameTF.text = self.topDic[@"name"];
//            } else {
                self.productNameTF.text = self.productNameStr;
//            }
            return cell;
        }
        return [UITableViewCell new];
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            UILabel *label = [[UILabel alloc] init];
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(20);
                make.centerY.equalTo(0);
            }];
            label.font = [UIFont systemFontOfSize:16];
            label.text = @"价格";
            self.priceTF = [[UITextField alloc] init];
            [cell.contentView addSubview:self.priceTF];
            [self.priceTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(100);
                make.right.equalTo(-10);
                make.height.equalTo(30);
                make.centerY.equalTo(0);
            }];
            self.priceTF.delegate = self;
            self.priceTF.tag = 1002;
            self.priceTF.font = [UIFont systemFontOfSize:16];
            self.priceTF.placeholder = @"请填写价格";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            if (self.topDic) {
//                self.priceTF.text = self.topDic[@"price"];
//            } else {
                self.priceTF.text = self.priceStr;
//            }
            return cell;
        }
        return [UITableViewCell new];
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            UILabel *label = [[UILabel alloc] init];
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(20);
                make.centerY.equalTo(0);
            }];
            label.font = [UIFont systemFontOfSize:16];
            label.text = @"产品说明";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        return [UITableViewCell new];
    }
    if (indexPath.section == 4) {
        
        ZCHEditGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        if (self.topDic) {
            
            cell.dic = self.dataArr[indexPath.row];
            cell.tableView = tableView;
            cell.placeHolderLabel.hidden = cell.introTV.text.length > 0;
            
        } else {
            cell.dic = self.listArr[indexPath.row];
            cell.tableView = tableView;
            cell.placeHolderLabel.hidden = cell.introTV.text.length > 0;
        }
        
        cell.delegate = self;
        cell.rowIndex = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak typeof(self) weakSelf = self;
        cell.clickDeleteBlock = ^(NSInteger cellItem) {
            
            if (cellItem != -1) {
                
                [weakSelf deleteProductWithIndex:cellItem];
            }
        };
        return cell;
    }
    if (indexPath.section == 5) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = White_Color;
        [cell.contentView addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(BLEJWidth, 150));
            make.top.equalTo(0);
            make.centerX.equalTo(0);
            make.bottom.equalTo(0);
        }];
        
        UIButton *continueAddBtn = [[UIButton alloc] init];
        [continueAddBtn setTitleColor:Black_Color forState:UIControlStateNormal];
        [continueAddBtn setTitle:@"继续添加" forState:UIControlStateNormal];
        [continueAddBtn addTarget:self action:@selector(didClickContinueBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:continueAddBtn];
        
        [continueAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(BLEJWidth - 100);
            make.top.equalTo(60);
            make.height.equalTo(40);
            make.width.equalTo(100);
        }];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 6) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UIView *footerview = [UIView new];
        [cell.contentView addSubview:footerview];
        [footerview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(0);
            make.height.equalTo(60);
        }];
        
        UILabel *leftL = [[UILabel alloc]init];
        leftL.textColor = COLOR_BLACK_CLASS_3;
        leftL.font = [UIFont systemFontOfSize:14];
        leftL.textAlignment = NSTextAlignmentLeft;
        leftL.text = @"谁能看见";
        [footerview addSubview:leftL];
        [leftL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.centerY.equalTo(0);
        }];
        
        UIImageView *arrowImageView = [UIImageView new];
        arrowImageView.image = [UIImage imageNamed:@"common_arrow_btn"];
        [footerview addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.right.equalTo(-16);
            make.size.equalTo(CGSizeMake(10, 14));
        }];
        
        self.canSeeLabel.textColor = COLOR_BLACK_CLASS_3;
        self.canSeeLabel.font = [UIFont systemFontOfSize:14];
        [footerview addSubview:self.canSeeLabel];
        [self.canSeeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.right.equalTo(arrowImageView.mas_left).equalTo(-12);
        }];
        
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"world"];
        [footerview addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.right.equalTo(self.canSeeLabel.mas_left).equalTo(-12);
            make.size.equalTo(CGSizeMake(20, 20));
        }];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 6) {
        self.selectedView.hidden = NO;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
//    return 1;
    if (section == 5) {
        return 0.000001;
    } else {
        return  1;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section

{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}
#pragma mark - 获取图片
- (void)getPhoto {
    
    // 先结束页面的编辑状态
    [self.view endEditing:YES];
    if ([TTHelper checkPhotoLibraryAuthorizationStatus]) {
        
        //初始化UIImagePickerController
        UIImagePickerController *pickerImageVC = [[UIImagePickerController alloc]init];
        // 获取方式1：通过相册（呈现全部相册) UIImagePickerControllerSourceTypePhotoLibrary
        // 获取方式2，通过相机              UIImagePickerControllerSourceTypeCamera
        // 获取方法3，通过相册（呈现全部图片）UIImagePickerControllerSourceTypeSavedPhotosAlbum
        pickerImageVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        if (self.isClickedImageBtn == self.topImageBtn) {
            // 允许编辑，即放大裁剪
            pickerImageVC.allowsEditing = YES;
        } else {
            // 允许编辑，即放大裁剪
            pickerImageVC.allowsEditing = NO;
        }
        
        // 自代理
        pickerImageVC.delegate = self;
        // 页面跳转
        [self presentViewController:pickerImageVC animated:YES completion:nil];
    }
}


#pragma mark - PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    if (self.isClickedImageBtn == self.topImageBtn) {
        
        //获取我们选择的图片
        UIImage *backPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        self.isSelectedImage = backPhoto;
        
        NSData *imageData = [NSObject imageData:backPhoto];
        if ([imageData length] >0) {
            imageData = [GTMBase64 encodeData:imageData];
        }
        NSString *imageStr = [[NSString alloc]initWithData:imageData encoding:NSUTF8StringEncoding];
        [self uploadImageWithBase64Str:imageStr];
    } else {
        
        //    获取我们选择的图片
        UIImage *backPhoto = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.isSelectedImage = backPhoto;
        
        NSData *imageData = [NSObject imageData:backPhoto];
        if ([imageData length] >0) {
            imageData = [GTMBase64 encodeData:imageData];
        }
        
        NSString *imageStr = [[NSString alloc]initWithData:imageData encoding:NSUTF8StringEncoding];
        self.imageStr = imageStr;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
        view.backgroundColor = Black_Color;
        [picker.view addSubview:view];
        UIImageView *iconView = [[UIImageView alloc] initWithImage:backPhoto];
        CGSize size = [self calculateImageSizeWithSize:backPhoto.size andType:2];
        iconView.size = CGSizeMake(size.width, size.height);
        iconView.center = view.center;
        self.imageBgView = view;
        [view addSubview:iconView];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight - 50, BLEJWidth, 50)];
        bottomView.backgroundColor = [Black_Color colorWithAlphaComponent:0.3];
        [view addSubview:bottomView];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        [cancelBtn setBackgroundColor:[UIColor clearColor]];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.textColor = White_Color;
        [cancelBtn addTarget:self action:@selector(didClickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:cancelBtn];
        
        UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth - 100, 0, 100, 50)];
        [confirmBtn setBackgroundColor:[UIColor clearColor]];
        [confirmBtn setTitle:@"使用照片" forState:UIControlStateNormal];
        confirmBtn.titleLabel.textColor = White_Color;
        [confirmBtn addTarget:self action:@selector(didClickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:confirmBtn];
    }
}


#pragma mark - 选择完照片之后的确定与取消
- (void)didClickCancelBtn:(UIButton *)btn {// 取消
    
    [self.imageBgView removeFromSuperview];
}

- (void)didClickConfirmBtn:(UIButton *)btn {// 确定
    
    [self uploadImageWithBase64Str:self.imageStr];
}
    

    

//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
//    // Handle the end of the image write process
//    if (!error)
//        [self.view showHudSuccess:@"Image written to photo album"];
//    else
//        [self.view showHudSuccess:[NSString  stringWithFormat:@"Error writing to photo album: %@",
//                                   [error localizedDescription]]];
//}

#pragma mark - 上传图片
- (void)uploadImageWithBase64Str:(NSString*)base64Str {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    UploadImageApi *uploadApi = [[UploadImageApi alloc]initWithImgStr:base64Str type:@"jpg"];
    [self.view hudShow:@"上传图片中..."];
    [uploadApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSDictionary *dic = request.responseJSONObject;
        NSString *code = [dic objectForKey:@"code"];
        
        if ([code isEqualToString:@"1000"]) {
            if (self.isClickedImageBtn == self.topImageBtn) {
                
                self.topImageURL = [dic objectForKey:@"imageUrl"];
                [self.topImageBtn sd_setImageWithURL:[NSURL URLWithString:self.topImageURL] forState:UIControlStateNormal];
//                self.topURlStr = [dic objectForKey:@"imageUrl"];
            } else {
                
                if (self.topDic) {
                    
                    [self.dataArr[self.isClickedImageIndex] setValue:[dic objectForKey:@"imageUrl"] forKey:@"imgUrl"];
                } else {
                    
                    [self.listArr[self.isClickedImageIndex] setValue:[dic objectForKey:@"imageUrl"] forKey:@"imgUrl"];
                }
                [self.isClickedImageBtn setBackgroundImage:self.isSelectedImage forState:UIControlStateNormal];
            }
        }
        [self.view textHUDHiddle];
        [self.tableView reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.view textHUDHiddle];
    }];
}

#pragma mark - 顶部图片的点击事件
- (void)didClickTopImageBtn:(UIButton *)sender {
    
    self.isClickedImageBtn = sender;
    [self getPhoto];
}

#pragma mark - 底部继续添加按钮的点击事件
- (void)didClickContinueBtn:(UIButton *)btn {
    
    NSDictionary *dic;
    if (self.topDic) {
        
        dic = self.dataArr.lastObject;
    } else {
        
        dic = self.listArr.lastObject;
    }
    
    if ([dic[@"content"] isEqualToString:@""] && [dic[@"imgUrl"] isEqualToString:@""]) {
        return;
    }
    
    self.cellCount ++;
    if (self.topDic) {
        
        [self.dataArr addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"content" : @"", @"imgUrl" : @"", @"instructionId" : @"0", @"merchandiesId" : self.topDic[@"id"], @"operation" : @"0", }]];
    } else {
        
        [self.listArr addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"content" : @"", @"imgUrl" : @""}]];
    }
//    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.cellCount - 1 inSection:4]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:5] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height) animated:NO];
}

#pragma mark - cell中图片的点击事件(代理)
- (void)didClickIconBtn:(UIButton *)btn andCellRow:(NSInteger)rowIndex andIntroText:(NSString *)introText {
    
    self.isClickedImageIndex = rowIndex;
    if (btn == nil) {
        
        if (self.topDic) {
            
            [self.dataArr[rowIndex] setObject:introText forKey:@"content"];

        } else {
            
            [self.listArr[rowIndex] setObject:introText forKey:@"content"];
        }
    } else {
        
        self.isClickedImageBtn = btn;
        [self getPhoto];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag == 1001) {
        self.productNameStr = textField.text;
    }
    if (textField.tag == 1002) {
        self.priceStr = textField.text;
    }
}
#pragma mark - 完成按钮的点击事件
- (void)didClickCompleteBtn:(UIButton *)btn {
    
    if (!self.topImageURL) {
        [self.view hudShowWithText:@"请上传封面"];
        return;
    }
    
    if ([self.productNameTF.text isEqualToString:@""]) {
        [self.view hudShowWithText:self.productNameTF.placeholder];
        return;
    }
    
    if ([self.priceTF.text isEqualToString:@""]) {
        [self.view hudShowWithText:self.priceTF.placeholder];
        return;
    }
    
    if (self.topDic) {
        
        for (int i = 0; i < self.dataArr.count; i ++) {
            NSDictionary *dic = self.dataArr[i];
            if ([dic[@"content"] isEqualToString:@""] && [dic[@"imgUrl"] isEqualToString:@""]) {
                [self.dataArr removeObjectAtIndex:i];
                i --;
            }
        }
        
        if (self.dataArr.count == 0) {
            [self.view hudShowWithText:@"请至少填写一条产品说明"];
            for (int i = 0; i < self.cellCount; i ++) {
                [self.dataArr addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"content" : @"", @"imgUrl" : @"", @"instructionId" : @"0", @"merchandiesId" : self.topDic[@"id"], @"operation" : @"0", }]];
            }
            return;
        }
    } else {
        
        for (int i = 0; i < self.listArr.count; i ++) {
            NSDictionary *dic = self.listArr[i];
            if ([dic[@"content"] isEqualToString:@""] && [dic[@"imgUrl"] isEqualToString:@""]) {
                [self.listArr removeObjectAtIndex:i];
                i --;
            }
        }
        
        if (self.listArr.count == 0) {
            [self.view hudShowWithText:@"请至少填写一条产品说明"];
            for (int i = 0; i < self.cellCount; i ++) {
                [self.listArr addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"content" : @"", @"imgUrl" : @""}]];
            }
            return;
        }
    }
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    if (!self.topDic) {
        NSString *defaultApi = [BASEURL stringByAppendingString:@"merchandies/save.do"];
        NSData *data = [NSJSONSerialization dataWithJSONObject:self.listArr options:NSJSONWritingPrettyPrinted error:nil];
        NSString *arrStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSDictionary *paramDic = @{@"merchantId" : @(self.merchantNo.integerValue),
                                   @"name" : self.productNameTF.text,
                                   @"price" : self.priceTF.text,
                                   @"display" : self.topImageURL,
                                   @"listStr" : arrStr,
                                   @"isDisplay": @(self.isDispaly)
                                   };
        YSNLog(@"param: %@", paramDic);
        [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
            
            if (responseObj) {
                if ([responseObj[@"code"] integerValue] == 1000) {
                    
                    //                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                    self.finishBlock();
                    //                    });
                } else {
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"创建失败"];
                }
            }
            [[UIApplication sharedApplication].keyWindow hiddleHud];
        } failed:^(NSString *errorMsg) {
            
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
        }];
    } else {
        
        self.topDic[@"display"] = self.topImageURL;
        self.topDic[@"name"] = self.productNameTF.text;
        self.topDic[@"price"] = self.priceTF.text;
        
        
        //        NSDictionary *dic = @{@"createDate" : self.topDic[@"createDate"]};
        
        //        {
        //            "instructionId": "76",--删除和修改时不能为空
        //            "imgUrl": null，
        //            "content": "123456",
        //            "merchandiesId": 55,
        //            "operation": "1"–0:新增，1：修改，2：删除
        //        }
        //
        NSString *defaultApi = [BASEURL stringByAppendingString:@"merchandies/update.do"];
        [self.paramArr addObjectsFromArray:self.dataArr];
        NSData *data = [NSJSONSerialization dataWithJSONObject:self.paramArr options:NSJSONWritingPrettyPrinted error:nil];
        NSString *arrStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self.topDic removeObjectForKey:@"createDate"];
        [self.topDic setObject:arrStr forKey:@"listStr"];
        [self.topDic setObject:@(self.isDispaly) forKey:@"isDisplay"];
        YSNLog(@"%@", self.topDic);
        [NetManager afPostRequest:defaultApi parms:self.topDic finished:^(id responseObj) {
            
            if (responseObj) {
                if ([responseObj[@"code"] integerValue] == 1000) {
                    
                    //                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                    self.finishBlock();
                    //                    });
                }
            }
            [[UIApplication sharedApplication].keyWindow hiddleHud];
        } failed:^(NSString *errorMsg) {
            
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
        }];
    }
}

#pragma mark - 删除某一张图片
- (void)deleteProductWithIndex:(NSInteger)index {
    
    if (self.topDic) {
        
        [self.dataArr[index] setValue:@"" forKey:@"imgUrl"];
        if ([[self.dataArr[index] objectForKey:@"content"] isEqualToString:@""] && index != self.dataArr.count - 1) {
            
            [self.dataArr removeObjectAtIndex:index];
            self.cellCount--;
        }
    } else {
        
        [self.listArr[index] setValue:@"" forKey:@"imgUrl"];
        if ([[self.listArr[index] objectForKey:@"content"] isEqualToString:@""] && index != self.listArr.count - 1) {
            
            [self.listArr removeObjectAtIndex:index];
            self.cellCount--;
        }
    }
    [self.tableView reloadData];
//    [self.tableView reloadTableViewWithRow:index andSection:4];
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:4] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

#pragma mark - 计算图片按照比例显示
- (CGSize)calculateImageSizeWithSize:(CGSize)size andType:(NSInteger)type {
    
    CGSize finalSize;
    
    if (type == 1) {
        
        finalSize.width = BLEJWidth;
        finalSize.height = size.height * BLEJWidth / size.width;
    } else {
        
        if (size.width / BLEJWidth > size.height / BLEJHeight) {
            
            finalSize.width = size.width * BLEJWidth / size.width;
            finalSize.height = size.height * BLEJWidth / size.width;
        } else {
            
            finalSize.width = size.width * BLEJHeight / size.height;
            finalSize.height = size.height * BLEJHeight / size.height;
        }
    }
    return finalSize;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"ZCHEditGoodsCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
