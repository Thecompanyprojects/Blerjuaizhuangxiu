//
//  EditShopDetailController.m
//  iDecoration
//
//  Created by Apple on 2017/5/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "EditShopDetailController.h"
#import "ZCHEditGoodsCell.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "NSObject+CompressImage.h"

static NSString *reuseIdentifier = @"ZCHEditGoodsCell";
@interface EditShopDetailController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, ZCHEditGoodsCellDelegate>

@property (weak, nonatomic) IBOutlet UIButton *topImageBtn;
@property (weak, nonatomic) IBOutlet UITextField *productNameTF;
@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (assign, nonatomic) NSInteger cellCount;

@property (strong, nonatomic) UIButton *isClickedImageBtn;
@property (assign, nonatomic) NSInteger isClickedImageIndex;
@property (strong, nonatomic) NSMutableArray *listArr;
@property (strong, nonatomic) UIImage *isSelectedImage;
@property (strong, nonatomic) NSMutableString *topImageURL;

@property (strong, nonatomic) NSMutableArray *paramArr;

@end

@implementation EditShopDetailController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"编辑商品";
    self.view.backgroundColor = kBackgroundColor;
    self.paramArr = [NSMutableArray array];
    if (self.topDic) {
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
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZCHEditGoodsCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    [self setUpUI];
}

- (void)setUpUI {
    
    self.topImageBtn.layer.borderWidth = 2;
    self.topImageBtn.layer.borderColor = kBackgroundColor.CGColor;
    if (self.topDic) {
        self.topImageURL = self.topDic[@"display"];
        [self.topImageBtn sd_setImageWithURL:self.topDic[@"display"] forState:UIControlStateNormal];
        self.productNameTF.text = self.topDic[@"name"];
        self.priceTF.text = self.topDic[@"price"];
    }
    
    
    // 添加底部视图
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 150)];
    bottomView.backgroundColor = White_Color;

    UIButton *continueAddBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth - 100, 60, 100, 40)];
    [continueAddBtn setTitleColor:Black_Color forState:UIControlStateNormal];
    [continueAddBtn setTitle:@"继续添加" forState:UIControlStateNormal];
    [continueAddBtn addTarget:self action:@selector(didClickContinueBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:continueAddBtn];
    self.tableView.tableFooterView = bottomView;
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 4) {
        return self.cellCount;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 4) {
        
        ZCHEditGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        if (self.topDic) {
            
            cell.dic = self.dataArr[indexPath.row];
        }
        
        cell.delegate = self;
        cell.rowIndex = indexPath.row;
        return cell;
    } else {
        
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

// 静态动态cell混用 此方法必须实现
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 4) {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    } else {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 4) {
        
        return 170;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}

#pragma mark - 获取图片
- (void)getPhoto {
    
    // 先结束页面的编辑状态
    [self.view endEditing:YES];
//    TTActionSheet *actionSheet = [[TTActionSheet alloc] initWithTitles:[NSArray arrayWithObjects:@"从相册选择", @"拍照", @"取消", nil]];
//    actionSheet.destructiveButtonIndex = -1;
//    
//    // 下边的代码相当于原来的代理方法(UIActionSheetDelegate)
//    NSUInteger index = [actionSheet showInView:self.view];
    if ([TTHelper checkPhotoLibraryAuthorizationStatus]) {
        
        //初始化UIImagePickerController
        UIImagePickerController *pickerImageVC = [[UIImagePickerController alloc]init];
        // 获取方式1：通过相册（呈现全部相册) UIImagePickerControllerSourceTypePhotoLibrary
        // 获取方式2，通过相机              UIImagePickerControllerSourceTypeCamera
        // 获取方法3，通过相册（呈现全部图片）UIImagePickerControllerSourceTypeSavedPhotosAlbum
        pickerImageVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 允许编辑，即放大裁剪
        pickerImageVC.allowsEditing = YES;
        // 自代理
        pickerImageVC.delegate = self;
        // 页面跳转
        [self presentViewController:pickerImageVC animated:YES completion:nil];
    }
//    else if (index == 1 && [TTHelper checkCameraAuthorizationStatus]) {
//
//        // 通过相机的方式
//        UIImagePickerController *pickerImageVC = [[UIImagePickerController alloc] init];
//        // 获取方式:通过相机
//        pickerImageVC.sourceType = UIImagePickerControllerSourceTypeCamera;
//        pickerImageVC.allowsEditing = YES;
//        pickerImageVC.delegate = self;
//        pickerImageVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//        [self presentViewController:pickerImageVC animated:YES completion:^{
//            
//            [pickerImageVC.view layoutIfNeeded];
//        }];
//        
//    } else {
//        
//        // 添加一个这个空条件语句点击屏幕的空余部分actionSheet也会消失
//    }
}

#pragma mark - PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    //获取我们选择的图片
    UIImage *backPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.isSelectedImage = backPhoto;
//    NSData *imageData = UIImageJPEGRepresentation(backPhoto, PHOTO_COMPRESS);
    NSData *imageData = [NSObject imageData:backPhoto];
    
    if ([imageData length] >0) {
        imageData = [GTMBase64 encodeData:imageData];
    }
    NSString *imageStr = [[NSString alloc]initWithData:imageData encoding:NSUTF8StringEncoding];
    [self uploadImageWithBase64Str:imageStr];
    //    self.headerView.image = backPhoto;
    
    // 保存图片到本地相册
    //    UIImage *image = [info
    //                      objectForKey:@"UIImagePickerControllerOriginalImage"];
    //    // Save the image to the album
    //    UIImageWriteToSavedPhotosAlbum(image, self,
    //                                   @selector(image:didFinishSavingWithError:contextInfo:), nil);
    //
    //    [self dismissViewControllerAnimated:YES completion:nil];
    // 上传并保存图片
    //    [self uploadImage:backPhoto];
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
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.view textHUDHiddle];
    }];
}

#pragma mark - 顶部图片的点击事件
- (IBAction)didClickTopImageBtn:(UIButton *)sender {
    
    self.isClickedImageBtn = sender;
    [self getPhoto];
}

#pragma mark - 底部继续添加按钮的点击事件
- (void)didClickContinueBtn:(UIButton *)btn {
    
    self.cellCount ++;
    if (self.topDic) {
        
        [self.dataArr addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"content" : @"", @"imgUrl" : @"", @"instructionId" : @"0", @"merchandiesId" : self.topDic[@"id"], @"operation" : @"0", }]];
    } else {
        
        [self.listArr addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"content" : @"", @"imgUrl" : @""}]];
    }
    [self.tableView reloadData];
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
        
        NSDictionary *paramDic = @{@"merchantId" : self.merchantNo,
                                   @"name" : self.productNameTF.text,
                                   @"price" : self.priceTF.text,
                                   @"display" : self.topImageURL,
                                   @"listStr" : arrStr
                                   };
        [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
            
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
        }];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
