//
//  AddDesignFullLook.m
//  iDecoration
//
//  Created by sty on 2017/9/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "AddVideoLinkViewController.h"
#import "labelView.h"
#import "NSObject+CompressImage.h"
#import "PlaceHolderTextView.h"
#import "ZCHPublicWebViewController.h"

@interface AddVideoLinkViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UIScrollView *scrView;
@property (nonatomic, strong) UIButton *successBtn;

@property (nonatomic, strong) UIImageView *upPhotoImg;
@property (nonatomic, strong) UIImageView *holderImageVew;
@property (nonatomic, strong) UIView *lineOneV;
@property(nonatomic,strong)labelView *firstView;
@property (nonatomic, strong) UIView *lineTwoV;
@property(nonatomic,strong)labelView *secondView;
@property (nonatomic, strong) UIView *lineThreeV;


@property (nonatomic, assign) BOOL ishaveImage;

@end

@implementation AddVideoLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加视频链接";
    self.view.backgroundColor = White_Color;
    
    _ishaveImage = NO;
    
    [self setUI];
    [self setRightBtn];
    [self setData];
    
    [self addSuspendedButton];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
}

-(void)setUI{
    [self scrView];
    self.scrView.contentSize = self.scrView.bounds.size;
}

-(void)setData{
    [self.upPhotoImg sd_setImageWithURL:[NSURL URLWithString:self.coverImgStr] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            self.holderImageVew.hidden = NO;
            _ishaveImage = NO;
        } else {
            self.holderImageVew.hidden = YES;
            _ishaveImage = YES;
        }
    }];

    if (self.linkUrl != nil && self.linkUrl.length > 0) {
        self.firstView.detailTextField.text = self.linkUrl;
    }
    if (self.unionURL != nil && self.unionURL.length > 0) {
        self.secondView.detailTextField.text = self.unionURL;
    }
}

-(void)setRightBtn{
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"完成" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    self.successBtn = editBtn;
    [self.successBtn addTarget:self action:@selector(successBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.successBtn];
}


#pragma  mark - UITextViewDelegate

-(void)textViewDidEndEditing:(PlaceHolderTextView *)textView{
    if (textView == self.firstView.detailTextField) {
        self.linkUrl = textView.text;
    }
    if (textView == self.secondView.detailTextField) {
        self.unionURL = [textView.text ew_removeSpaces];
    }
}

#pragma mark - 提交数据
-(void)successBtnClick:(UIButton *)btn{
    [self.view endEditing:YES];
    if (!_ishaveImage) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请上传封面图" controller:self sleep:1.0];
        return;
    }
    
    NSString *firstStr = [self.firstView.detailTextField.text ew_removeSpaces];
    NSString *secondStr  = [self.secondView.detailTextField.text ew_removeSpaces];
    
    
    if ([firstStr isEqualToString:@""] && [secondStr isEqualToString:@""]) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入视频链接或通用地址" controller:self sleep:1.0];
        return;
    }
    
    
    if (firstStr.length >0 && ![self.firstView.detailTextField.text ew_isUrlString]) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请正确的视频链接" controller:self sleep:1.0];
        return;
    }
//    <iframe frameborder="0" width="640" height="498" src="https://v.qq.com/iframe/player.html?vid=b0559hya5rj&tiny=0&auto=0" allowfullscreen></iframe>
    
    
    if (secondStr.length >0 && ![secondStr hasPrefix:@"<iframe"]) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请正确的通用地址" controller:self sleep:1.0];
        return;
    }
    
    
    
    [self saveImage:self.upPhotoImg.image];
    
    
}

#pragma mark - alertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==100) {
        if (buttonIndex==1) {
            [self SuspendedButtonDisapper];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)isButtonTouched{
    ZCHPublicWebViewController *VC = [[ZCHPublicWebViewController alloc] init];
    VC.titleStr = @"使用说明";
    VC.webUrl = @"http://api.bilinerju.com/api/designs/5175/10094.htm";
    VC.isAddBaseUrl = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - action

-(void)back{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否退出编辑？"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.tag = 100;
    [alertView show];
}



//判断是否含有非法字符 yes 有  no没有
- (BOOL)JudgeTheillegalCharacter:(NSString *)content{
    //提示 标签不能输入特殊字符（除中文 字母 数字  标点符号）
    NSString *str =@"^[A-Za-z0-9\\u4e00-\u9fa5\\u3000-\u301e\ufe10-\ufe19\ufe30-\ufe44\ufe50-\ufe6b\uff01-\uffee\\s]+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if (![emailTest evaluateWithObject:content]) {
        return YES;
    }
    return NO;
}


-(void)changePhoto:(UITapGestureRecognizer *)ges{
    [self updataimage];
}

#pragma mark 选择图片的来源
-(void)updataimage{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //选择相册
        [self getPhotoFromAlbumOrCamera:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //选择相机
        [self getPhotoFromAlbumOrCamera:UIImagePickerControllerSourceTypeCamera];
    }];
    [alert addAction:action];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

//#pragma mark  调用相册或相机
-(void)getPhotoFromAlbumOrCamera:(UIImagePickerControllerSourceType)type{
    
    if ([UIImagePickerController isSourceTypeAvailable:type]) {
        
        UIImagePickerController *imagePick = [[UIImagePickerController alloc]init];
        
        imagePick.sourceType = type;
        
        imagePick.delegate = self;
        
        imagePick.allowsEditing = NO;
        
        
        [self presentViewController:imagePick animated:YES completion:nil];
    }
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

//图片选择完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    UIImage*image = [self turnImageWithInfo:info];
    
    self.upPhotoImg.image = image;
    _ishaveImage = YES;
    [self.upPhotoImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.left.equalTo(10);
        make.size.equalTo(CGSizeMake(kSCREEN_WIDTH - 20, (kSCREEN_WIDTH-20) * image.size.height/(image.size.width*1.0)));
    }];
    self.holderImageVew.hidden = YES;
    self.scrView.contentSize = CGSizeMake(kSCREEN_WIDTH, (kSCREEN_WIDTH-20) * image.size.height/(image.size.width*1.0) + 100);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark  上传图片到服务器
-(void)saveImage:(UIImage *)image{
    
    //    NSData *data = UIImageJPEGRepresentation(image, PHOTO_COMPRESS);
    NSData *data = [NSObject imageData:image];
    
    NSString *str = [BASEURL stringByAppendingString:@"file/uploadFiles.do"];
    
    // 可以在上传时使用当前的系统事件作为文件名
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    //获取上传图片的时间
    NSString *str1 = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", str1];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer  serializer]];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    __weak typeof(self)  weakSelf = self;
    [manager POST:str parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YSNLog(@"上传成功:%@ %@",str,responseObject);
        if ([responseObject[@"code"] integerValue] == 1000) {
            NSArray *array = responseObject[@"imgList"];
            NSString *imageURL = array[0][@"imgUrl"];
            if (weakSelf.AddLinkCompletionBlock) {
                weakSelf.AddLinkCompletionBlock(imageURL, weakSelf.upPhotoImg.image, weakSelf.linkUrl, weakSelf.unionURL);
            }
            [self SuspendedButtonDisapper];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YSNLog(@"%@",error);
    }];

}

#pragma mark -lazy

-(UIScrollView *)scrView{
    if (!_scrView) {
        _scrView = [[UIScrollView alloc]init];
        [self.view addSubview:_scrView];
        [_scrView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(64);
            make.height.equalTo(kSCREEN_HEIGHT - 64);
        }];
        [self upPhotoImg];
        [self lineOneV];
        [self firstView];
        [self lineTwoV];
        [self secondView];
        [self lineThreeV];
    }
    return _scrView;
}


-(UIImageView *)upPhotoImg{
    if (!_upPhotoImg) {
        _upPhotoImg = [[UIImageView alloc]init];
        [self.scrView addSubview:_upPhotoImg];
        [_upPhotoImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(10);
            make.left.equalTo(10);
            make.size.equalTo(CGSizeMake(kSCREEN_WIDTH - 20, (kSCREEN_WIDTH-20)/3.0*2));
        }];
        _holderImageVew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addVideo_upload_image"]];
        [_upPhotoImg addSubview:_holderImageVew];
        [_holderImageVew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(0);
            make.size.equalTo(CGSizeMake(150, 100));
        }];
        
        _upPhotoImg.layer.masksToBounds = YES;
        _upPhotoImg.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePhoto:)];
        _upPhotoImg.userInteractionEnabled = YES;
        [_upPhotoImg addGestureRecognizer:ges];
    }
    return _upPhotoImg;
}

-(UIView *)lineOneV{
    if (!_lineOneV) {
        _lineOneV = [[UIView alloc]init];
        [self.scrView addSubview:_lineOneV];
        [_lineOneV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(self.upPhotoImg.mas_bottom).equalTo(10);
            make.size.equalTo(CGSizeMake(kSCREEN_WIDTH, 1));
        }];
        _lineOneV.backgroundColor = COLOR_BLACK_CLASS_0;
    }
    return _lineOneV;
}

-(labelView *)firstView{
    if (!_firstView) {
        _firstView = [[labelView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
        [self.scrView addSubview:_firstView];
        [_firstView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(self.lineOneV.mas_bottom).equalTo(0);
            make.height.equalTo(40);
            make.size.equalTo(CGSizeMake(kSCREEN_WIDTH, 40));
        }];
        _firstView.detailTextField.delegate = self;
        _firstView.titleLabel.text = @"视频链接";
        _firstView.detailTextField.tag = 1000;
        _firstView.detailTextField.textColor = COLOR_BLACK_CLASS_3;
        _firstView.detailTextField.placeHolder = @"请输入视频链接";
        _firstView.detailTextField.placeHolderColor = [UIColor lightGrayColor];
//        if (!self.linkUrl || self.linkUrl.length <= 0) {
//        }else{
//            _firstView.detailTextField.text = self.linkUrl;
//        }

    }
    return _firstView;
}

-(UIView *)lineTwoV{
    if (!_lineTwoV) {
        _lineTwoV = [[UIView alloc]init];
        [self.scrView addSubview:_lineTwoV];
        [_lineTwoV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(self.firstView.mas_bottom);
            make.size.equalTo(CGSizeMake(kSCREEN_WIDTH, 1));
        }];
        _lineTwoV.backgroundColor = COLOR_BLACK_CLASS_0;
    }
    return _lineTwoV;
}

-(labelView *)secondView{
    if (!_secondView) {
        _secondView = [[labelView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
        [self.scrView addSubview:_secondView];
        [_secondView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(self.lineTwoV.mas_bottom).equalTo(0);
            make.height.equalTo(40);
            make.size.equalTo(CGSizeMake(kSCREEN_WIDTH, 40));
        }];
        _secondView.detailTextField.delegate = self;
        _secondView.titleLabel.text = @"通用地址";
        _secondView.detailTextField.tag = 2000;
        _secondView.detailTextField.textColor = COLOR_BLACK_CLASS_3;
        _secondView.detailTextField.placeHolder = @"请输入通用地址";
        _secondView.detailTextField.placeHolderColor = [UIColor lightGrayColor];
        
//        if (!self.unionURL || self.unionURL.length <= 0) {
//        }else{
//            _secondView.detailTextField.text = self.unionURL;
//        }
        
    }
    return _secondView;
}

-(UIView *)lineThreeV{
    if (!_lineThreeV) {
        _lineThreeV = [[UIView alloc]init];
        [self.scrView addSubview:_lineThreeV];
        [_lineThreeV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(self.secondView.mas_bottom);
            make.size.equalTo(CGSizeMake(kSCREEN_WIDTH, 1));
        }];
        _lineThreeV.backgroundColor = COLOR_BLACK_CLASS_0;
    }
    return _lineThreeV;
}

@end

