//
//  ComplainViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/7/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ComplainViewController.h"
#import "NSObject+CompressImage.h"
#import "SinglePickerView.h"

@interface ComplainViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;

@property (weak, nonatomic) IBOutlet UITextView *contentTV;

@property (weak, nonatomic) IBOutlet UILabel *contentPlaceHolerLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightCon;
@property (weak, nonatomic) IBOutlet UIView *imageContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageContainerViewHeightCon;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (nonatomic, assign) NSInteger contentCellHeight;
@property (nonatomic, assign) NSInteger imageCellHeight;
// 图片视图数组
@property (nonatomic, strong) NSMutableArray *imageViewArray;
// 图片数组
@property (nonatomic, strong) NSMutableArray *imageMulArray;
// 图片地址数组
@property (nonatomic, strong) NSMutableArray *imageUrlMultiArray;
// 要删除的图片
@property (nonatomic, strong) UIImageView *delImageView;
// 投诉类型
@property (nonatomic, strong) SinglePickerView *singlePickerView;

@property (weak, nonatomic) IBOutlet UIButton *complainTypeBtn;

@end

@implementation ComplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投诉";
    // 要添加的图片宽 间距是16
    CGFloat imageWidth = (kSCREEN_WIDTH - 16 * 4)/3.0;
    self.imageContainerViewHeightCon.constant = imageWidth;
    _imageCellHeight = 168 + imageWidth;
    _contentCellHeight = 52 + 80;
    self.submitBtn.backgroundColor = kMainThemeColor;
    self.submitBtn.layer.cornerRadius = 6;
    self.submitBtn.layer.masksToBounds = YES;
    self.contentTV.layer.borderWidth = 1;
    self.contentTV.layer.cornerRadius = 6;
    self.contentTV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self imageViewArray];
    self.imageMulArray = [NSMutableArray array];
    self.imageUrlMultiArray = [NSMutableArray array];
    
    [self.complainTypeBtn setTitle:@"请选择投诉类型" forState:UIControlStateNormal];
    [self.complainTypeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.complainTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self singlePickerView];

//    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
}

- (void)loadView {
    [super loadView];
    [self separateViewAndTableView];
}
// 通过分离tableviewController的self.view和self.tableview来实现 显示pickerView位置不随tableView的位置改变
- (void)separateViewAndTableView{
    UITableView *tablieView = (UITableView *)self.view;
    self.view = [[UIView alloc] init];
    tablieView.frame = self.view.bounds;
    self.tableView = tablieView;
}
// 重写tableView的setter和getter方法实现self.tableview和self.view分离
- (void)setTableView:(UITableView *)tableView {
    [self.tableView removeFromSuperview];
    [self.view addSubview:tableView];
}
- (UITableView *)tableView {
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITableView class]]) {
            return (UITableView *)view;
        }
    }
    return [UITableView new];
}


- (IBAction)complainTypeBtnClicked:(id)sender {
    [self.view endEditing:YES];
    self.singlePickerView.hidden = NO;
    
    // 投诉类型和投诉描述是必填的   新加手机号判断
}

- (IBAction)submitBtnClicked:(id)sender {
 
    if ([self.complainTypeBtn.titleLabel.text isEqualToString:@"请选择投诉类型"]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请选择投诉类型"];
        return;
    }
    
    if ([self.phoneNumTF.text isEqualToString:@""] || ![self.phoneNumTF.text ew_justCheckPhone]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入正确的手机号码"];
        return;
    }
    
    if ([self.contentTV.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入描述内容"];
        return;
    }
    
    NSString *requestString = [BASEURL stringByAppendingString:@"complaint/save.do"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.complainTypeBtn.titleLabel.text forKey:@"complainType"];
    [param setObject:self.contentTV.text forKey:@"complainDescribe"];
    [param setObject:@(self.companyID) forKey:@"companyId"];
    NSInteger complainF = self.complainFrom > 0 ? self.complainFrom : 0;
    [param setObject:@(complainF) forKey:@"complainFrom"];
    
    if (self.phoneNumTF.text.length > 0) {
        [param setObject:self.phoneNumTF.text forKey:@"phone"];
    }
    
    NSString *imgurlsStr = [self.imageUrlMultiArray componentsJoinedByString:@","];
    [param setObject:imgurlsStr forKey:@"imgUrls"];
    
    YSNLog(@"param: %@", param);
    [NetManager afGetRequest:requestString parms:param finished:^(id responseObj) {
        YSNLog(@"%@",responseObj);
        if ([responseObj[@"code"] isEqualToString:@"1000"]) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"投诉成功"];
            [self performSelector:@selector(back) withObject:nil afterDelay:1.0];
            
        }else{
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"投诉失败"];
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:errorMsg];
    }];
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.singlePickerView.hidden = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.singlePickerView.hidden = YES;
}
#pragma mark - TextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.singlePickerView.hidden = YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    self.contentPlaceHolerLb.hidden = textView.text.length > 0;
    // textview中文字距离左边的距离是5
    CGFloat height = [textView.text boundingRectWithSize:CGSizeMake(textView.frame.size.width - 10, MAXFLOAT) withFont:[UIFont systemFontOfSize:16]].height;
    if (height > (80 - 18)) {   // 18为textview中文字拒上下边距离的二倍
        [self.tableView beginUpdates];
        self.contentHeightCon.constant = height + 18;
        _contentCellHeight = 52 + height + 18;
        [self.tableView endUpdates];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        return _imageCellHeight;
    } else if(indexPath.row == 2) {
        return _contentCellHeight;
    } else {
        return 44;
    }
}


// 点击事件
- (void)imageViewTapAction:(UITapGestureRecognizer *)tapGR {
    
    UIImageView *imageView = (UIImageView *)tapGR.view;
    [[NSUserDefaults standardUserDefaults] setInteger:imageView.tag forKey:@"copmlainImageViewTap"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
            pickerImageVC.delegate = self;
            // 页面跳转
            [self presentViewController:pickerImageVC animated:YES completion:nil];
        }
    }];
    [alertC addAction:action];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([TTHelper checkCameraAuthorizationStatus]) {
            
            // 通过相机的方式
            UIImagePickerController *pickerImageVC = [[UIImagePickerController alloc] init];
            // 获取方式:通过相机
            pickerImageVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerImageVC.allowsEditing = NO;
            pickerImageVC.delegate = self;
            pickerImageVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:pickerImageVC animated:YES completion:^{
                
                [pickerImageVC.view layoutIfNeeded];
            }];
            
        }
    }];
    [alertC addAction:action2];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:action3];
    
    [self.navigationController presentViewController:alertC animated:YES completion:nil];
    
}
// 长按事件
- (void)imageViewLongPressAction:(UIGestureRecognizer *)longPressGR {
    UIImageView *imageView = (UIImageView *)longPressGR.view;
    // 加好的长安手势没效果
    NSInteger index = [self.imageViewArray indexOfObject:imageView];
    if ((index + 1) > self.imageMulArray.count || self.imageMulArray.count == 0) {
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"删除提示" message:@"是否删除该图片？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:cancleAction];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        [self.imageMulArray removeObjectAtIndex:index];
        // 删除图片地址
        [self.imageUrlMultiArray removeObjectAtIndex:index];
        
        for (int i = 0; i < 9; i ++) {
            if (i < self.imageMulArray.count) {
                ((UIImageView *)self.imageViewArray[i]).image = self.imageMulArray[i];
            }
            if (i > self.imageMulArray.count) {
                ((UIImageView *)self.imageViewArray[i]).hidden = YES;
            }
            if (i == self.imageMulArray.count) {
                ((UIImageView *)self.imageViewArray[i]).image = [UIImage imageNamed:@"jia_kuang"];
            }
        }
        
        
     
        CGFloat imageWidth = (kSCREEN_WIDTH - 16 * 4)/3.0;
        if (self.imageMulArray.count == 2) {
            self.imageContainerViewHeightCon.constant = imageWidth * 2 + 16;
            self.imageCellHeight = imageWidth * 1 + 16 + 168;
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
        }
        if (self.imageMulArray.count == 5) {
            self.imageContainerViewHeightCon.constant = imageWidth * 3 + 32;
            self.imageCellHeight = imageWidth * 2 + 32 + 168;
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
        }
       
    }];
    [alertC addAction:sureAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage*image = [self turnImageWithInfo:info];
    
    UIImage *cImage = [NSObject imageCompressFromImage:image];
    [self.imageMulArray addObject:cImage];
    
    // 上传图片
    NSData *imageData = [NSObject imageData:image];
    if ([imageData length] >0) {
        imageData = [GTMBase64 encodeData:imageData];
    }
    NSString *imageStr = [[NSString alloc]initWithData:imageData encoding:NSUTF8StringEncoding];
    [self uploadImageWithBase64Str:imageStr];
    
    
    
    NSInteger imageViewTag = [[NSUserDefaults standardUserDefaults] integerForKey:@"copmlainImageViewTap"];
    UIImageView *imageView = self.imageViewArray[imageViewTag];
    imageView.image = image;
    
    CGFloat imageWidth = (kSCREEN_WIDTH - 16 * 4)/3.0;
    if (imageViewTag != 8) { // 显示下一个按钮
        UIImageView * addImageView = self.imageViewArray[imageViewTag + 1];
        if (addImageView.isHidden) {
            addImageView.hidden = NO;
            addImageView.image = [UIImage imageNamed:@"jia_kuang"];
            if (imageViewTag == 2) {
                self.imageContainerViewHeightCon.constant = imageWidth * 2 + 16;
                self.imageCellHeight = imageWidth * 2 + 16 + 168;
                [self.tableView beginUpdates];
                [self.tableView endUpdates];
            }
            if (imageViewTag == 5) {
                self.imageContainerViewHeightCon.constant = imageWidth * 3 + 32;
                self.imageCellHeight = imageWidth * 3 + 32 + 168;
                [self.tableView beginUpdates];
                [self.tableView endUpdates];
            }
        }
        
        
    }
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


-(void)uploadImageWithBase64Str:(NSString*)base64Str{
    [[UIApplication sharedApplication].keyWindow hudShow];
    UploadImageApi *uploadApi = [[UploadImageApi alloc]initWithImgStr:base64Str type:@"png"];
    
    [uploadApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSDictionary *dic = request.responseJSONObject;
        NSString *code = [dic objectForKey:@"code"];
        
        if ([code isEqualToString:@"1000"]) {
            // 上传成功后返回的URL
            NSString *photoUrl = dic[@"imageUrl"];
            
            YSNLog(@"-------url: %@", photoUrl);
            [self.imageUrlMultiArray addObject:photoUrl];
           
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            [[PublicTool defaultTool] publicToolsHUDStr:@"图片上传成功" controller:self sleep:1.5];
        } else {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            [[PublicTool defaultTool] publicToolsHUDStr:@"图片上传失败" controller:self sleep:1.5];
        }
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"图片上传失败" controller:self sleep:1.5];
    }];
}


#pragma mark - lazy
- (NSMutableArray *)imageViewArray {
    if (_imageViewArray == nil) {
        _imageViewArray = [NSMutableArray array];
        CGFloat imageWidth = (kSCREEN_WIDTH - 16 * 4)/3.0;
        for (int i = 0; i < 9; i ++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [_imageViewArray addObject:imageView];
            imageView.tag = i;
            [self.imageContainerView addSubview:imageView];
            imageView.frame = CGRectMake(i%3 * (imageWidth + 16), i/3 * (imageWidth + 16), imageWidth, imageWidth);
            if (i == 0) {
                imageView.image = [UIImage imageNamed:@"jia_kuang"];
            }
            imageView.hidden = (i!=0);
            
            UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapAction:)];
            [imageView addGestureRecognizer:tapGR];
            // 添加长按手势
            UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewLongPressAction:)];
            [imageView addGestureRecognizer:longPressGR];
        }
    }
    return _imageViewArray;
}

- (SinglePickerView *)singlePickerView {
    MJWeakSelf;
    if (!_singlePickerView) {
        _singlePickerView = [[SinglePickerView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-305 + 44, kSCREEN_WIDTH, 305)];
        [self.view addSubview:_singlePickerView];
        _singlePickerView.dataArray = @[@"发布不适当内容对我造成骚扰",
                                         @"存在欺诈骗钱行为",
                                         @"此账号可能被盗用了",
                                         @"存在侵权行为",
                                         @"发布仿冒品信息"];;
        _singlePickerView.closeBtn.hidden = NO;
        _singlePickerView.hidden = YES;
        _singlePickerView.backgroundColor = [White_Color colorWithAlphaComponent:0];
        _singlePickerView.selectBlock = ^(NSInteger index) {
            [weakSelf.complainTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [weakSelf.complainTypeBtn setTitle:@[@"发布不适当内容对我造成骚扰",
                                               @"存在欺诈骗钱行为",
                                               @"此账号可能被盗用了",
                                               @"存在侵权行为",
                                               @"发布仿冒品信息"][index] forState:UIControlStateNormal];
        };
    }
    return _singlePickerView;
}

@end
