//
//  AddDesignFullLook.m
//  iDecoration
//
//  Created by sty on 2017/9/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "AddDesignFullLook.h"
#import "headerView.h"
#import "labelView.h"
#import "NSObject+CompressImage.h"
#import "HKImageClipperViewController.h"
#import "PlaceHolderTextView.h"

@interface AddDesignFullLook ()<upDataImageDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UIScrollView *scrView;
@property (nonatomic, strong) UIButton *successBtn;

@property (nonatomic, strong) UILabel *upPhotoLabel;
@property (nonatomic, strong) UIImageView *upPhotoImg;

@property (nonatomic, strong) UIView *lineOneV;

@property(nonatomic,strong)labelView *firstView;




@property (nonatomic, strong) UIView *lineTwoV;
@property(nonatomic,strong)labelView *secondView;

@property (nonatomic, strong) UIView *lineThreeV;

@end

@implementation AddDesignFullLook

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加全景";
    
    self.view.backgroundColor = White_Color;
    
    [self setUI];
    [self setRightBtn];
    [self setData];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
}

-(void)setUI{
    [self.view addSubview:self.scrView];
    [self.scrView addSubview:self.upPhotoLabel];
    [self.scrView addSubview:self.upPhotoImg];
    [self.scrView addSubview:self.lineOneV];
    [self.scrView addSubview:self.firstView];


    
    [self.scrView addSubview:self.lineTwoV];
    [self.scrView addSubview:self.secondView];
    
    [self.scrView addSubview:self.lineThreeV];
    self.scrView.contentSize = CGSizeMake(kSCREEN_WIDTH, kSCREEN_HEIGHT-64+1);
}

-(void)setData{
    [self.upPhotoImg sd_setImageWithURL:[NSURL URLWithString:self.coverImgStr] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            self.upPhotoImg.image = [UIImage imageNamed:@"jia-kong"];
        }
    }];
    if (!self.nameStr||self.nameStr.length<=0) {
        self.nameStr = @"请输入展厅名称";
    }
    self.firstView.detailTextField.text = self.nameStr;
    if ([self.firstView.detailTextField.text isEqualToString:@"请输入展厅名称"]) {
        self.firstView.detailTextField.textColor = [UIColor lightGrayColor];
    }
    if (!self.linkUrl||self.linkUrl.length<=0) {
        self.linkUrl = @"请输入全景链接";
    }
    self.secondView.detailTextField.text = self.linkUrl;
    if ([self.secondView.detailTextField.text isEqualToString:@"请输入全景链接"]) {
        self.secondView.detailTextField.textColor = [UIColor lightGrayColor];
    }
}

-(void)setRightBtn{
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"完成" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    self.successBtn = editBtn;
    [self.successBtn addTarget:self action:@selector(successBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.successBtn];
}

-(void)textViewDidChange:(UITextView *)textView{


}


-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:@"请输入展厅名称"] || [textView.text isEqualToString:@"请输入全景链接"]) {
        textView.text = @"";
        textView.textColor = COLOR_BLACK_CLASS_3;
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        if (textView.tag == 1000) {
            textView.text = @"请输入展厅名称";
        }
        if (textView.tag == 2000) {
            textView.text = @"请输入全景链接";
        }
        textView.textColor = [UIColor lightGrayColor];
    }
}

#pragma mark - 提交数据
-(void)successBtnClick:(UIButton *)btn{
    [self.view endEditing:YES];
    if (self.coverImgStr.length == 0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请上传封面图" controller:self sleep:1.0];
        return;
    }
    
    self.firstView.detailTextField.text = [self.firstView.detailTextField.text ew_removeSpaces];
    if (self.firstView.detailTextField.text.length == 0 || [self.firstView.detailTextField.text isEqualToString:@"请输入展厅名称"]) {
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入展厅名称" controller:self sleep:1.0];
        return;
    }
    
    if ([self JudgeTheillegalCharacter:self.firstView.detailTextField.text] == YES) {
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"展厅名称含有非法字符" controller:self sleep:1.0];
        return;
    }
    
    self.secondView.detailTextField.text = [self.secondView.detailTextField.text ew_removeSpaces];
    if (self.secondView.detailTextField.text.length == 0 || [self.secondView.detailTextField.text isEqualToString:@"请输入全景链接"]) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入全景链接" controller:self sleep:1.0];
        return;
    }
    self.nameStr = self.firstView.detailTextField.text;
    self.linkUrl = self.secondView.detailTextField.text;
    
    if (self.FullBlock) {
        self.FullBlock(self.coverImgStr, self.nameStr, self.linkUrl);
    }
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - alertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==100) {
        if (buttonIndex==1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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
    
    //自定义裁剪方式
    UIImage*image = [self turnImageWithInfo:info];
    CGSize tempSize = CGSizeMake( 300 * widthScale, 200 *hightScale);
    HKImageClipperViewController *clipperVC = [[HKImageClipperViewController alloc]initWithBaseImg:image
                                                                                     resultImgSize:tempSize clipperType:ClipperTypeImgMove];
    
    __weak typeof(self)weakSelf = self;
    clipperVC.cancelClippedHandler = ^(){
        [picker dismissViewControllerAnimated:YES completion:nil];
    };
    clipperVC.successClippedHandler = ^(UIImage *clippedImage){
        __strong typeof(self)strongSelf = weakSelf;
        
        [strongSelf saveImage:clippedImage];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    };
    
    [picker pushViewController:clipperVC animated:YES];
    
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
            
            for (NSDictionary *dic in responseObject[@"imgList"]) {
                
                [weakSelf.upPhotoImg sd_setImageWithURL:[NSURL URLWithString:dic[@"imgUrl"]]];
                weakSelf.coverImgStr = dic[@"imgUrl"];
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YSNLog(@"%@",error);
    }];
    
    
    
    
}

#pragma mark -lazy

-(UIScrollView *)scrView{
    if (!_scrView) {
        _scrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64)];
        _scrView.backgroundColor = White_Color;
    }
    return _scrView;
}

-(UILabel *)upPhotoLabel{
    if (!_upPhotoLabel) {
        _upPhotoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 16, kSCREEN_WIDTH, 30)];
        _upPhotoLabel.textAlignment = NSTextAlignmentCenter;
        _upPhotoLabel.text = @"上传封面";
        _upPhotoLabel.textColor = COLOR_BLACK_CLASS_3;
        _upPhotoLabel.font = NB_FONTSEIZ_NOR;
    }
    return _upPhotoLabel;
}

-(UIImageView *)upPhotoImg{
    if (!_upPhotoImg) {
        _upPhotoImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.upPhotoLabel.bottom+15, kSCREEN_WIDTH-20, (kSCREEN_WIDTH-20)/3*2)];
        _upPhotoImg.image = [UIImage imageNamed:@"jia-kong"];
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
        _lineOneV = [[UIView alloc]initWithFrame:CGRectMake(0, self.upPhotoImg.bottom+10, kSCREEN_WIDTH, 1)];
        _lineOneV.backgroundColor = COLOR_BLACK_CLASS_0;
    }
    return _lineOneV;
}




-(labelView *)firstView{
    if (!_firstView) {
        _firstView = [[labelView alloc]initWithFrame:CGRectMake(0, self.lineOneV.bottom, kSCREEN_WIDTH, 40)];
        _firstView.detailTextField.delegate = self;
        _firstView.titleLabel.text = @"展厅名称";
        _firstView.detailTextField.tag = 1000;
        _firstView.detailTextField.textColor = COLOR_BLACK_CLASS_3;
//        if ([_firstView.detailTextField.text isEqualToString:@"请输入展厅名称"]) {
//            _firstView.detailTextField.textColor = [UIColor lightGrayColor];
//        }
    }
    return _firstView;
}

-(UIView *)lineTwoV{
    if (!_lineTwoV) {
        _lineTwoV = [[UIView alloc]initWithFrame:CGRectMake(0, self.firstView.bottom, kSCREEN_WIDTH, 1)];
        _lineTwoV.backgroundColor = COLOR_BLACK_CLASS_0;
    }
    return _lineTwoV;
}


-(labelView *)secondView{
    if (!_secondView) {
        _secondView = [[labelView alloc]initWithFrame:CGRectMake(0, self.lineTwoV.bottom, kSCREEN_WIDTH, self.firstView.height)];
        _secondView.detailTextField.delegate = self;
        _secondView.titleLabel.text = @"全景链接";
//        _secondView.detailTextField.text = @"请输入全景链接";
        _secondView.detailTextField.tag = 2000;
        _secondView.detailTextField.textColor = COLOR_BLACK_CLASS_3;
//        if ([_secondView.detailTextField.text isEqualToString:@"请输入全景链接"]) {
//            _secondView.detailTextField.textColor = [UIColor lightGrayColor];
//        }
    }
    return _secondView;
}

-(UIView *)lineThreeV{
    if (!_lineThreeV) {
        _lineThreeV = [[UIView alloc]initWithFrame:CGRectMake(0, self.secondView.bottom, kSCREEN_WIDTH, 1)];
        _lineThreeV.backgroundColor = COLOR_BLACK_CLASS_0;
    }
    return _lineThreeV;
}



@end
