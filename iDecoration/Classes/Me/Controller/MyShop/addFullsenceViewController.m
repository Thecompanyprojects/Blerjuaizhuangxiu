//
//  addFullsenceViewController.m
//  iDecoration
//
//  Created by 涂晓雨 on 2017/7/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "addFullsenceViewController.h"
#import "headerView.h"
#import "labelView.h"
#import "NSObject+CompressImage.h"
#import "HKImageClipperViewController.h"
@interface addFullsenceViewController ()<upDataImageDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
@property(nonatomic,strong)headerView *headView;

@property(nonatomic,strong)labelView *firstView;


@property(nonatomic,strong)labelView *secondView;


@property(nonatomic,copy)NSString *imageUrl;

@end

@implementation addFullsenceViewController


-(void)loadView{

    [super loadView];
    
    
    //头部视图
    self.headView = [[headerView alloc]initWithFrame:CGRectMake(10, 74, kSCREEN_WIDTH - 20, 230 * hightScale)];
    
    self.headView.delegate = self;
    [self.view addSubview:self.headView];
    
        UIView  *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame) + 10, kSCREEN_WIDTH, 1)];
    line2.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    [self.view addSubview:line2];

    //展厅名称的view
    self.firstView = [[labelView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line2.frame), kSCREEN_WIDTH, 40)];
    self.firstView.detailTextField.delegate = self;
    self.firstView.titleLabel.text = @"展厅名称";
    self.firstView.detailTextField.text = @"请输入展厅名称";
    self.firstView.detailTextField.tag = 1000;
    if ([self.firstView.detailTextField.text isEqualToString:@"请输入展厅名称"]) {
        self.firstView.detailTextField.textColor = [UIColor lightGrayColor];
    }
    [self.view addSubview:self.firstView];
    
    
    UIView  *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.firstView.frame), kSCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    [self.view addSubview:line];
    
    
    //全景李连接的view
    self.secondView = [[labelView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), kSCREEN_WIDTH, 40)];
    self.secondView.detailTextField.delegate = self;
    self.secondView.titleLabel.text = @"全景链接";
    self.secondView.detailTextField.text = @"请输入全景链接";
    self.secondView.detailTextField.tag = 2000;
    if ([self.secondView.detailTextField.text isEqualToString:@"请输入全景链接"]) {
        self.secondView.detailTextField.textColor = [UIColor lightGrayColor];
    }
    
    [self.view addSubview:self.secondView];
    
    UIView  *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.secondView.frame), kSCREEN_WIDTH, 1)];
    line1.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    [self.view addSubview:line1];
    
    
    if (self.model) {
        [self.headView.headImage sd_setImageWithURL:[NSURL URLWithString:self.model.picUrl]];
        
        self.firstView.detailTextField.text = self.model.picTitle;
        
        self.secondView.detailTextField.text = self.model.picHref;
        
        self.secondView.detailTextField.textColor = [UIColor blackColor];
        self.firstView.detailTextField.textColor = [UIColor blackColor];
    }

}



- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"添加全景";
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    
    
    [self.navigationItem.rightBarButtonItem  setTintColor:[UIColor whiteColor]];
    


    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tui2"] style:UIBarButtonItemStylePlain target:self action:@selector((exitEditor))];

}


#pragma mark 退出编辑
-(void)exitEditor{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出编辑？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:action];
    [alert addAction:action2];
    
    [self  presentViewController:alert animated:YES completion:nil];

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
                
                [weakSelf.headView.headImage sd_setImageWithURL:[NSURL URLWithString:dic[@"imgUrl"]]];
                weakSelf.imageUrl = dic[@"imgUrl"];
            }
        }
    
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YSNLog(@"%@",error);
    }];
    
 


}

//图片选择完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //自定义裁剪方式
    UIImage*image = [self turnImageWithInfo:info];
    CGSize tempSize = CGSizeMake( kSCREEN_WIDTH, kSCREEN_WIDTH *3.0/5);
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

//取消选择图片
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark - 装修新工地提交数据

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

//完成封面上传
-(void)finish{
    
    if (self.model) {
        //编辑全景
        
        [self editorSence];
        
    }else{
    
    
        [self addFullsenceData];
        
    
    }

}


#pragma mark   添加全景
-(void)addFullsenceData{
   
    if (self.imageUrl.length == 0) {
         [[PublicTool defaultTool] publicToolsHUDStr:@"未上传封面图" controller:self sleep:1.0];
        return;
    }
    
    if (self.firstView.detailTextField.text.length == 0 || [self.firstView.detailTextField.text isEqualToString:@"请输入展厅名称"]) {
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"未输入展厅名称" controller:self sleep:1.0];
        return;
    }
    
    if ([self JudgeTheillegalCharacter:self.firstView.detailTextField.text] == YES) {
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"展厅名称含有非法字符" controller:self sleep:1.0];
        return;
    }
    
    if (self.secondView.detailTextField.text.length == 0 || [self.secondView.detailTextField.text isEqualToString:@"请输入全景链接"]) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"未输入全景链接" controller:self sleep:1.0];
        return;
    }
    

    NSDictionary *dic;
    if (self.fromTag==2000) {
       //添加工地的全景
        dic = @{@"picTitle":self.firstView.detailTextField.text,@"picUrl":self.imageUrl,@"picHref":self.secondView.detailTextField.text,@"relId":self.shopid,@"type":@(17)};
    }
    else{
        //添加公司的全景
        
        dic = @{@"picTitle":self.firstView.detailTextField.text,@"picUrl":self.imageUrl,@"picHref":self.secondView.detailTextField.text,@"relId":self.shopid};
    }
    
    
    NSString *url = [BASEURL stringByAppendingString:@"img/save.do"];
    
    
    [NetManager afPostRequest:url parms:dic finished:^(id responseObj) {
        
        YSNLog(@"%@",responseObj);
        if ([responseObj[@"code"] integerValue] == 1000) {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"创建成功" controller:self sleep:1];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
         [[PublicTool defaultTool] publicToolsHUDStr:@"输入的名称或链接错误" controller:self sleep:1];
        
        }
    } failed:^(NSString *errorMsg) {
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1];
        YSNLog(@"%@",errorMsg);
    }];

}



-(void)editorSence{

    if (self.imageUrl.length == 0) {
        self.imageUrl = self.model.picUrl;
    }
    
    if (self.imageUrl.length == 0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"未上传封面图" controller:self sleep:1.0];
        return;
    }
    
    if (self.firstView.detailTextField.text.length == 0 || [self.firstView.detailTextField.text isEqualToString:@"请输入展厅名称"]) {
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"未输入展厅名称" controller:self sleep:1.0];
        return;
    }
    
    if ([self  JudgeTheillegalCharacter:self.firstView.detailTextField.text] == YES) {
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"展厅名称含有非法字符" controller:self sleep:1.0];
        return;
    }
    
    if (self.secondView.detailTextField.text.length == 0 || [self.secondView.detailTextField.text isEqualToString:@"请输入全景链接"]) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"未输入全景链接" controller:self sleep:1.0];
        return;
    }
    
    
    NSDictionary *dic = @{@"picId":self.model.picId,@"picTitle":self.firstView.detailTextField.text,@"picUrl":self.imageUrl,@"picHref":self.secondView.detailTextField.text};
    
    NSString *url = [BASEURL stringByAppendingString:@"img/update.do"];
    
    
    [NetManager afPostRequest:url parms:dic finished:^(id responseObj) {
        
        YSNLog(@"%@",responseObj);
        if ([responseObj[@"code"] integerValue] == 1000) {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"编辑成功" controller:self sleep:1];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
        
            [[PublicTool defaultTool] publicToolsHUDStr:@"输入的名称或链接错误" controller:self sleep:1];
        }
        
    } failed:^(NSString *errorMsg) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"网络出错" controller:self sleep:1];
        YSNLog(@"%@",errorMsg);
    }];

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



#pragma mark delegate


-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:@"请输入展厅名称"] || [textView.text isEqualToString:@"请输入全景链接"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
}


-(void)textViewDidEndEditing:(UITextView *)textView{
//
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   

}






@end
