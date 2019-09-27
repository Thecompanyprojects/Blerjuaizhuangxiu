//
//  CreateConstructionViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/3/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CreateConstructionViewController.h"
#import "WWPickerView.h"
#import "SSPopup.h"
#import "RegionView.h"
#import "PModel.h"
#import "CModel.h"
#import "DModel.h"
#import "PlaceHolderTextView.h"
#import "HKImageClipperViewController.h"
#import "NSObject+CompressImage.h"
#import "selectsitetagsVC.h"
#import "localcommunityVC.h"

@interface CreateConstructionViewController ()<UITextFieldDelegate,SSPopupDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UITextViewDelegate,myTabVdelegate>
{
    NSInteger _companyOrShop;
//    NSInteger _companyTpye;
    BOOL isHavePhoto;
    
    NSInteger _indextext;//分享标题长度
}
@property (nonatomic, strong) UIScrollView *srcV;

@property (nonatomic, strong) UIImageView *coverImgV;//封面图

@property (nonatomic, strong) UIImageView *placeHolderImgV;//默认的展位图
@property (nonatomic, strong) UIButton *addressBtn;
@property (nonatomic, strong) UIButton *signTimeBtn;
@property (nonatomic, strong) UIButton *beginTimeBtn;
@property (nonatomic, strong) UIButton *endTimeBtn;

@property (nonatomic, copy) NSString *userName;//户主
@property (nonatomic, copy) NSString *addressStr;//地址
@property (nonatomic, assign) CGFloat aPid;//省
@property (nonatomic, assign) CGFloat aCid;//市
@property (nonatomic, assign) CGFloat aDid;//区
@property (nonatomic, copy) NSString *socialName;//小区名称
@property (nonatomic, copy) NSString *shareTitle;//分享标题
@property (nonatomic, copy) NSString *ConstructionName;//施工单位

@property (nonatomic, copy) NSString *signStr;//签约日期
@property (nonatomic, copy) NSString *beginStr;//开工日期
@property (nonatomic, copy) NSString *endStr;//竣工日期
@property (nonatomic, copy)NSString *coverStr;//封面图地址

@property (nonatomic, copy) NSString *style;
@property (nonatomic, copy) NSString *area;

@property (nonnull, strong) UIButton *typeBtn;

@property (nonatomic, strong) RegionView *regionView;
@property (nonatomic, strong) PModel *pmodel;
@property (nonatomic, strong) CModel *cmodel;
@property (nonatomic, strong) DModel *dmodel;

@property (nonatomic, copy) NSString *label;//标签
@property (nonatomic, strong) UIButton *successBtn;

@property (nonatomic, strong) UIButton *chooseBtn;
@property (nonatomic, strong) PlaceHolderTextView *shareTitleTv;


@end

@implementation CreateConstructionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setPopview];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
}
     
-(void)back{
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出编辑"
                                                         message:@"是否确定退出编辑？"
                                                        delegate:self
                                               cancelButtonTitle:@"否"
                                               otherButtonTitles:@"是",nil];
         alert.tag = 2000;
         [alert show];
         
         
     }


#pragma  mark - action

-(void)setPopview{
    
        if ([self.constructionType isEqualToString:@"0"]) {
            _companyOrShop = 1; //公司
        }
        else{
            _companyOrShop = 2;
        }
        [self createUI];
}
     


-(void)createUI{
    
    self.view.backgroundColor = White_Color;
    
    [self.view addSubview:self.srcV];
    [self.srcV addSubview:self.coverImgV];
    [self.coverImgV addSubview:self.placeHolderImgV];
    CGFloat h = self.coverImgV.bottom;
    
    if (_companyOrShop==1) {
        
        self.title = @"装修新工地";
        //company
        for (int i = 0; i<7; i++) {
            NSArray *leftArray = @[@"户主",@"地址",@"标签",@"选择小区",@"分享标题",@"施工单位",@"房屋面积"];
            NSArray *rightArray = @[@"请输入真实姓名",@"请仔细填写至区县",@"请选择标签(必填)",@"请输入小区名称",@"这是分享出去后的标题",@"",@""];
            
            UILabel *leftL = [[UILabel alloc]initWithFrame:CGRectMake(15, h, 60, 40)];
            leftL.text = leftArray[i];
            leftL.textColor = COLOR_BLACK_CLASS_3;
            leftL.font = [UIFont systemFontOfSize
                          :14];
            //        companyJob.backgroundColor = Red_Color;
            leftL.textAlignment = NSTextAlignmentLeft;
            
            
            UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(leftL.right+20, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height)];
            textF.textColor = COLOR_BLACK_CLASS_3;
            textF.placeholder = rightArray[i];
            textF.font = NB_FONTSEIZ_NOR;
            [textF setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
            [textF setValue:NB_FONTSEIZ_NOR forKeyPath:@"_placeholderLabel.font"];
            textF.delegate = self;
            [textF addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
            [textF addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventAllEvents];
            textF.tag = i;
            
            if (i == 4) {
                //            textF.text = @"三文鱼装饰";
                textF.text = self.companyName;
                self.ConstructionName = textF.text;
                textF.userInteractionEnabled = NO;
            }
            
            if (i == 6) {
                textF.frame = CGRectMake(leftL.right+20, leftL.top, 60, leftL.height);
                textF.keyboardType = UIKeyboardTypeNumberPad;
                UILabel *areaL = [[UILabel alloc]initWithFrame:CGRectMake(textF.right, leftL.top+10, 20, 20)];
                areaL.text = @"㎡";
                areaL.textColor = COLOR_BLACK_CLASS_3;
                areaL.font = [UIFont systemFontOfSize
                              :14];
                //            areaL.backgroundColor = Red_Color;
                areaL.textAlignment = NSTextAlignmentLeft;
                [self.srcV addSubview:areaL];
            }
            
        
            
            
            
            
            if (i == 1) {
                textF.hidden = YES;
                //            if (!_addressBtn) {
                _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _addressBtn.frame = textF.frame;
                [_addressBtn setTitle:@"请仔细填写至区县" forState:UIControlStateNormal];
                _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [_addressBtn setTitleColor:COLOR_BLACK_CLASS_9 forState:UIControlStateNormal];
                _addressBtn.titleLabel.font = NB_FONTSEIZ_NOR;
                
                [_addressBtn addTarget:self action:@selector(changeAddress) forControlEvents:UIControlEventTouchUpInside];
                //            _addressBtn.backgroundColor = Red_Color;
                //                [_addressBtn setImage:[UIImage imageNamed:@"account"] forState:UIControlStateNormal];
                //            }
                [self.srcV addSubview:self.addressBtn];
            }
            if (i==2) {
                textF.hidden = YES;
                self.typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                self.typeBtn.frame = CGRectMake(leftL.right+20, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height);
                [self.typeBtn setTitle:@"选择标签" forState:normal];
                self.typeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [self.typeBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                self.typeBtn.titleLabel.font = NB_FONTSEIZ_NOR;
                self.typeBtn.tag = i;
                [self.typeBtn addTarget:self action:@selector(tagviewclick) forControlEvents:UIControlEventTouchUpInside];
                [self.srcV addSubview:self.typeBtn];
            }
            
            if (i==3) {
                textF.hidden = YES;
                self.chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                self.chooseBtn.frame = CGRectMake(leftL.right+20, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height);
                [self.chooseBtn setTitle:@"选择小区" forState:normal];
                self.chooseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [self.chooseBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                self.chooseBtn.titleLabel.font = NB_FONTSEIZ_NOR;
                self.chooseBtn.tag = i;
                [self.chooseBtn addTarget:self action:@selector(choosebtnclick) forControlEvents:UIControlEventTouchUpInside];
                [self.srcV addSubview:self.chooseBtn];
            }
            
            if (i==4) {
                textF.hidden = YES;
                if (!_shareTitleTv) {
                    
                    _shareTitleTv = [[PlaceHolderTextView alloc]initWithFrame:CGRectMake(15+60+20, h+5, kSCREEN_WIDTH-15-60-20, 25)];
                    _shareTitleTv.placeHolder = @"这是分享出去后的标题";
                    _shareTitleTv.placeHolderColor = [UIColor lightGrayColor];
                    //                companyNameTextView.placeHolderFont = [UIFont systemFontOfSize:16];
                    
                    _shareTitleTv.font = [UIFont systemFontOfSize:14];
                    _shareTitleTv.textColor = COLOR_BLACK_CLASS_3;
                    _shareTitleTv.tag = i;
                    _shareTitleTv.delegate = self;
 
            }
                [self.srcV addSubview:leftL];
                [self.srcV addSubview:self.shareTitleTv];
  
            
        }
            else{
                [self.srcV addSubview:leftL];
                [self.srcV addSubview:textF];
                
            }
            
            
            UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, leftL.bottom-1, kSCREEN_WIDTH, 1)];
            lineV.backgroundColor = COLOR_BLACK_CLASS_0;
            
            [self.srcV addSubview:lineV];
            
            h = h +40;

        
    }
        
    }
    else{
        self.title = @"主材新工地";
        //shop
        for (int i = 0; i<6; i++) {
            NSArray *leftArray = @[@"户主",@"地址",@"标签",@"选择小区",@"分享标题",@"施工单位",@"房屋面积"];
            NSArray *rightArray = @[@"请输入真实姓名",@"请仔细填写至区县",@"请选择标签",@"请输入小区名称",@"这是分享出去后的标题",@"",@""];
            
            UILabel *leftL = [[UILabel alloc]initWithFrame:CGRectMake(15, h, 60, 40)];
            leftL.text = leftArray[i];
            leftL.textColor = COLOR_BLACK_CLASS_3;
            leftL.font = [UIFont systemFontOfSize
                          :14];
            leftL.textAlignment = NSTextAlignmentLeft;
            
            UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(leftL.right+20, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height)];
            textF.textColor = COLOR_BLACK_CLASS_3;
            textF.placeholder = rightArray[i];
            textF.font = NB_FONTSEIZ_NOR;
            [textF setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
            [textF setValue:NB_FONTSEIZ_NOR forKeyPath:@"_placeholderLabel.font"];
            textF.tag = 2002;
            [textF addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
            [textF addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventAllEvents];
            textF.tag = i;
            
            if (i == 4) {
                //            textF.text = @"三文鱼装饰";
                
                textF.text = self.companyName;
                self.ConstructionName = textF.text;
                textF.userInteractionEnabled = NO;
            }
            
            
            
            
            
            
            
            
            
            if (i == 1) {
                textF.hidden = YES;
                //            if (!_addressBtn) {
                _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _addressBtn.frame = textF.frame;
                [_addressBtn setTitle:@"请仔细填写至区县" forState:UIControlStateNormal];
                _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [_addressBtn setTitleColor:COLOR_BLACK_CLASS_9 forState:UIControlStateNormal];
                _addressBtn.titleLabel.font = NB_FONTSEIZ_NOR;
                
                [_addressBtn addTarget:self action:@selector(changeAddress) forControlEvents:UIControlEventTouchUpInside];
         
                [self.srcV addSubview:self.addressBtn];
            }
            if (i==2) {
                textF.hidden = YES;
                self.typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                self.typeBtn.frame = CGRectMake(leftL.right+20, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height);
                
                [self.typeBtn setTitle:@"选择标签" forState:normal];
                self.typeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [self.typeBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                self.typeBtn.titleLabel.font = NB_FONTSEIZ_NOR;
                self.typeBtn.tag = i;
                [self.typeBtn addTarget:self action:@selector(tagviewclick) forControlEvents:UIControlEventTouchUpInside];
                [self.srcV addSubview:self.typeBtn];
            }
            
            if (i==3) {
                textF.hidden = YES;
                self.chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                self.chooseBtn.frame = CGRectMake(leftL.right+20, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height);
                [self.chooseBtn setTitle:@"选择小区" forState:normal];
                self.chooseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [self.chooseBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                self.chooseBtn.titleLabel.font = NB_FONTSEIZ_NOR;
                self.chooseBtn.tag = i;
                [self.chooseBtn addTarget:self action:@selector(choosebtnclick) forControlEvents:UIControlEventTouchUpInside];
                [self.srcV addSubview:self.chooseBtn];
            }
            
            
            if (i==4) {
                textF.hidden = YES;
                if (!_shareTitleTv) {
                    
                    _shareTitleTv = [[PlaceHolderTextView alloc]initWithFrame:CGRectMake(15+60+20, h+5, kSCREEN_WIDTH-15-60-20, 25)];
                    _shareTitleTv.placeHolder = @"这是分享出去后的标题";
                    _shareTitleTv.placeHolderColor = [UIColor lightGrayColor];
 
                    _shareTitleTv.font = [UIFont systemFontOfSize:14];
                    _shareTitleTv.textColor = COLOR_BLACK_CLASS_3;
                    _shareTitleTv.tag = i;
                    _shareTitleTv.delegate = self;
                    
                }
                [self.srcV addSubview:leftL];
                [self.srcV addSubview:self.shareTitleTv];
            }
            
            if (i == 5) {
                textF.frame = CGRectMake(leftL.right+20, leftL.top, 60, leftL.height);
                textF.keyboardType = UIKeyboardTypeNumberPad;
                UILabel *areaL = [[UILabel alloc]initWithFrame:CGRectMake(textF.right, leftL.top+10, 20, 20)];
                areaL.text = @"㎡";
                areaL.textColor = COLOR_BLACK_CLASS_3;
                areaL.font = [UIFont systemFontOfSize
                              :14];
                //            areaL.backgroundColor = Red_Color;
                areaL.textAlignment = NSTextAlignmentLeft;
                [self.srcV addSubview:leftL];
                [self.srcV addSubview:textF];
                [self.srcV addSubview:areaL];
            }
            else{
                [self.srcV addSubview:leftL];
                [self.srcV addSubview:textF];
            }
            
            UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, leftL.bottom-1, kSCREEN_WIDTH, 1)];
            lineV.backgroundColor = COLOR_BLACK_CLASS_0;
            [self.srcV addSubview:lineV];
            h = h +40;
            
        }
    }
    
    //创建3个时间选择控件
    for (int i = 0; i<3; i++) {
        NSArray *leftArray = @[@"签约日期",@"开工日期",@"竣工日期"];
        NSArray *leftArrayTwo = @[@"测量日期",@"下单日期",@"安装日期"];
        UILabel *leftL = [[UILabel alloc]initWithFrame:CGRectMake(15, h, 60, 40)];
        if (_companyOrShop==1) {
            leftL.text = leftArray[i];
        }
        else{
            leftL.text = leftArrayTwo[i];
        }
        
        leftL.textColor = COLOR_BLACK_CLASS_3;
        leftL.font = [UIFont systemFontOfSize
                      :14];

        leftL.textAlignment = NSTextAlignmentLeft;
        [self.srcV addSubview:leftL];
        
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, leftL.bottom-1, kSCREEN_WIDTH, 1)];
        lineV.backgroundColor = COLOR_BLACK_CLASS_0;
        
        [self.srcV addSubview:lineV];
        if (i == 0) {
            _signTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _signTimeBtn.frame = CGRectMake(leftL.right+20, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height);

            _signTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_signTimeBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
            _signTimeBtn.titleLabel.font = NB_FONTSEIZ_NOR;
            _signTimeBtn.tag = i;
            [_signTimeBtn addTarget:self action:@selector(changeTime:) forControlEvents:UIControlEventTouchUpInside];
            [self.srcV addSubview:self.signTimeBtn];
        }
        
        if (i == 1) {
            _beginTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _beginTimeBtn.frame = CGRectMake(leftL.right+20, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height);

            _beginTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_beginTimeBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
            _beginTimeBtn.titleLabel.font = NB_FONTSEIZ_NOR;
            _beginTimeBtn.tag = i;
            [_beginTimeBtn addTarget:self action:@selector(changeTime:) forControlEvents:UIControlEventTouchUpInside];
            [self.srcV addSubview:self.beginTimeBtn];
        }
        
        if (i == 2) {
            _endTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _endTimeBtn.frame = CGRectMake(leftL.right+20, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height);

            _endTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_endTimeBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
            _endTimeBtn.titleLabel.font = NB_FONTSEIZ_NOR;
            _endTimeBtn.tag = i;
            [_endTimeBtn addTarget:self action:@selector(changeTime:) forControlEvents:UIControlEventTouchUpInside];
            [self.srcV addSubview:self.endTimeBtn];
        }
        
        
        h = h+40;
        
    }
    
    _successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _successBtn.frame = CGRectMake(30,h+30,kSCREEN_WIDTH-60,40);

    _successBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_successBtn setTitleColor:White_Color forState:UIControlStateNormal];
    _successBtn.titleLabel.font = NB_FONTSEIZ_NOR;
    
    [_successBtn setTitle:@"完    成" forState:UIControlStateNormal];
    [_successBtn addTarget:self action:@selector(successTouch) forControlEvents:UIControlEventTouchUpInside];
    _successBtn.backgroundColor = Main_Color;
    [self.srcV addSubview:self.successBtn];
    [self.view addSubview:self.regionView];
    
    self.srcV.contentSize = CGSizeMake(kSCREEN_WIDTH, self.successBtn.bottom+20);
}

-(void)tagviewclick
{
    selectsitetagsVC *vc = [selectsitetagsVC new];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)myTabVClick:(NSMutableArray *)array
{
    self.label = [array componentsJoinedByString:@","]?:@"";
    [self.typeBtn setTitle:self.label forState:normal];
}

-(void)getRegion{
    [self.view endEditing:YES];
    self.regionView.hidden = NO;
    
    __weak CreateConstructionViewController *weakSelf = self;
    
    self.regionView.selectBlock = ^(NSMutableArray *array){
        
        weakSelf.regionView.hidden = YES;
        weakSelf.pmodel = [array objectAtIndex:0];
        weakSelf.cmodel = [array objectAtIndex:1];
        weakSelf.dmodel = [array objectAtIndex:2];
        
        weakSelf.addressStr = [NSString stringWithFormat:@"%@ %@ %@",weakSelf.pmodel.name,weakSelf.cmodel.name,weakSelf.dmodel.name];
        NSInteger regionId = [weakSelf.pmodel.regionId integerValue];
        
        if (regionId == 110000||regionId == 120000||regionId == 500000||regionId == 310000)//四个直辖市只传省和市
        {
            weakSelf.addressStr = [NSString stringWithFormat:@"%@ %@",weakSelf.pmodel.name,weakSelf.dmodel.name];
        }
        
        //        [weakSelf.editTableView reloadData];
        [weakSelf.addressBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
        [weakSelf.addressBtn setTitle:weakSelf.addressStr forState:UIControlStateNormal];
        
    };
    
}

-(void)changeAddress{

    [self getRegion];
}



-(void)changeTime:(UIButton *)btn{
    self.regionView.hidden = YES;
     WWPickerView *pickerView = [[WWPickerView alloc] init];
    [self.view endEditing:YES];
    if (_companyOrShop==1) {
        [pickerView setDateViewWithTitle:@[@"签约日期:",@"开工日期:",@"竣工日期:"][btn.tag] withMode:UIDatePickerModeDate];
    }
    else{
        [pickerView setDateViewWithTitle:@[@"测量日期:",@"下单日期:",@"安装日期:"][btn.tag] withMode:UIDatePickerModeDate];
    }
    
    [pickerView showPickView:self];
    
    //block回调
    __weak typeof (self) wself = self;
    pickerView.block = ^(NSString *selectedStr)
    {
        //格式化当前日期,并作出比较
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        //NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
        if (btn.tag == 0) {
            [wself.signTimeBtn setTitle:selectedStr forState:UIControlStateNormal];
            wself.signStr = selectedStr;
        }
        else if (btn.tag == 1) {
            [wself.beginTimeBtn setTitle:selectedStr forState:UIControlStateNormal];
            wself.beginStr = selectedStr;
        }
        else{
            [wself.endTimeBtn setTitle:selectedStr forState:UIControlStateNormal];
            wself.endStr = selectedStr;
        }
        
        
    };

}

#pragma mark - 上传图片相关

-(void)imagePicker{
    
    UIImagePickerController * photoAlbum = [[UIImagePickerController alloc]init];
    photoAlbum.delegate = self;
    photoAlbum.allowsEditing = NO;
    photoAlbum.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:photoAlbum animated:YES completion:^{}];
}

//图片选择完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //自定义裁剪方式
    UIImage*image = [self turnImageWithInfo:info];
    CGSize tempSize = CGSizeMake(kSCREEN_WIDTH, 200);
    HKImageClipperViewController *clipperVC = [[HKImageClipperViewController alloc]initWithBaseImg:image
                                                                                     resultImgSize:tempSize clipperType:ClipperTypeImgMove];
    
    __weak typeof(self)weakSelf = self;
    clipperVC.cancelClippedHandler = ^(){
        [picker dismissViewControllerAnimated:YES completion:nil];
    };
    clipperVC.successClippedHandler = ^(UIImage *clippedImage){
        __strong typeof(self)strongSelf = weakSelf;

        NSData *imageData = [NSObject imageData:clippedImage];
        if ([imageData length] >0) {
            imageData = [GTMBase64 encodeData:imageData];
        }
        NSString *imageStr = [[NSString alloc]initWithData:imageData encoding:NSUTF8StringEncoding];
        
        [strongSelf uploadImageWithBase64Str:imageStr];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    };
    
    [picker pushViewController:clipperVC animated:YES];

}

//取消选择图片
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

-(void)uploadImageWithBase64Str:(NSString*)base64Str{
    
    UploadImageApi *uploadApi = [[UploadImageApi alloc]initWithImgStr:base64Str type:@"png"];
    
    [uploadApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSDictionary *dic = request.responseJSONObject;
        NSString *code = [dic objectForKey:@"code"];
        
        if ([code isEqualToString:@"1000"]) {
            NSString *photoUrl = [dic objectForKey:@"imageUrl"];
            self.coverStr = photoUrl;
            self.placeHolderImgV.hidden = YES;
            [self.coverImgV sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:nil];
            [[PublicTool defaultTool] publicToolsHUDStr:@"图片上传成功" controller:self sleep:1.5];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
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

#pragma mark - 提交数据

-(void)successTouch{
    [self.view endEditing:YES];
    
    //获取群组的ID
#if DELETEHUANXIN
    // (@"注释掉环信")
    NSString *groupid = @"";
#else
    NSString *groupid = [self creatGroup:self.socialName];
    
    //创建施工日志需要验证ID
    if (_companyOrShop == 1) {
        if (!groupid||groupid.length<=0) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"创建失败, 稍后重试"];
            YSNLog(@"工地创建失败，环信创建聊天群组失败");
            return;
        }
    }
#endif
    
    
    
    
    
    
    if (self.coverStr.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"封面图不能为空" controller:self sleep:1.0];
        return;
    }
    self.userName = [self.userName ew_removeSpacesAndLineBreaks];
    self.userName = [self.userName ew_removeSpaces];
    if (self.userName.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"姓名不能为空" controller:self sleep:1.0];
        return;
    }
    if (self.label.length==0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"标签不能为空" controller:self sleep:1.0];
        return;
    }
    self.addressStr = [self.addressStr ew_removeSpacesAndLineBreaks];
    self.addressStr = [self.addressStr ew_removeSpaces];
    if (self.addressStr.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"地址不能为空" controller:self sleep:1.0];
        return;
    }
    self.socialName = [self.socialName ew_removeSpacesAndLineBreaks];
    self.socialName = [self.socialName ew_removeSpaces];
    if (self.socialName.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"小区名称不能为空" controller:self sleep:1.0];
        return;
    }
    self.shareTitle = self.shareTitleTv.text;
    self.shareTitle = [self.shareTitle ew_removeSpaces];
    if (self.shareTitle.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"分享标题不能为空" controller:self sleep:1.0];
        return;
    }
    if (!self.signStr||self.signStr.length<=0) {
        self.signStr = @"";
    }
    
    self.style = [self.style ew_removeSpacesAndLineBreaks];
    self.style = [self.style ew_removeSpaces];
    self.area = [self.area ew_removeSpacesAndLineBreaks];
    self.area = [self.area ew_removeSpaces];
    if ([self.constructionType isEqualToString:@"0"]) {
        if (!self.style||self.style.length<=0) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"装修风格不能为空" controller:self sleep:1.0];
            return;
        }
        
    }
    else{
        if (!self.style||self.style.length<=0) {
            self.style = @"";
        }

    }
    if (!self.area||self.area.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"房屋面积不能为空" controller:self sleep:1.0];
        return;
    }
    if (self.area &&self.area.length>0) {
        BOOL check = [self.area ew_checkNumber];
        if (!check) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"面积只能输入数字" controller:self sleep:1.0];
            return;
        }
    }
    
    self.beginStr = [self.beginStr ew_removeSpacesAndLineBreaks];
    self.beginStr = [self.beginStr ew_removeSpaces];
    self.endStr = [self.endStr ew_removeSpacesAndLineBreaks];
    self.endStr = [self.endStr ew_removeSpaces];
    if (self.beginStr.length<=0) {
        if (self.companyType == 1018 || self.companyType == 1064 || self.companyType == 1065){
            [[PublicTool defaultTool] publicToolsHUDStr:@"开工日期不能为空" controller:self sleep:1.0];
        }
        else{
            [[PublicTool defaultTool] publicToolsHUDStr:@"下单日期不能为空" controller:self sleep:1.0];
        }
        
        return;
    }
    if (self.endStr.length<=0) {
        if (self.companyType == 1018 || self.companyType == 1064 || self.companyType == 1065){
            [[PublicTool defaultTool] publicToolsHUDStr:@"竣工日期不能为空" controller:self sleep:1.0];
        }
        else{
            [[PublicTool defaultTool] publicToolsHUDStr:@"安装日期不能为空" controller:self sleep:1.0];
        }
        
        return;
    }
    
    NSString *temDmodelR = @"";

    NSInteger regionId = [self.pmodel.regionId integerValue];
    if (regionId == 110000||regionId == 120000||regionId == 500000||regionId == 310000)//四个直辖市只传省和市
    {
        self.cmodel.regionId = self.dmodel.regionId;
        //        self.dmodel.regionId = @"-1";
        temDmodelR = @"-1";
        self.addressStr = [NSString stringWithFormat:@"%@ %@",self.pmodel.name,self.dmodel.name];
    }
    else{
        self.cmodel.regionId = self.cmodel.regionId;
        temDmodelR = self.dmodel.regionId;
    }
    [self.view hudShow];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    
    NSString *requestString = [BASEURL stringByAppendingString:@"construction/addConstructs.do"];
    
    NSDictionary *dic = @{@"houseHolderName":self.userName,
                          @"address":self.addressStr,
                          @"housingEstateName":self.socialName,
                          @"signingTime":self.signStr,
                          @"ccSrartTime":self.beginStr,
                          @"completionDate":self.endStr,
                          @"cpLimitsId":self.roleTypeId,
                          @"cpPersonId":@(user.agencyId),
                          @"ccBuilder":self.ConstructionName,
                          @"userName":user.trueName,
                          @"ccShareTitle":self.shareTitle,
                          @"companyId":self.companyId,
                          @"ccConstructionNodeId":@(0),
                          @"id":@(0),
                          @"ccHouseholderId":@(user.agencyId),
                          @"ccComplete":@(0),
                          @"province":self.pmodel.regionId,
                          @"city":self.cmodel.regionId,
                          @"area":temDmodelR,
                          @"ccAcreage":self.area,
                          @"style":self.style,
                          @"coverMap":self.coverStr,
                          @"companyType":@(self.companyType),
                          @"groupId":groupid,
                          @"constructionType":self.constructionType,
                          @"label":self.label};
    
    [NetManager afPostRequest:requestString parms:dic finished:^(id responseObj) {
        YSNLog(@"responseObj: %@",responseObj);
        [self.view hiddleHud];
        if ([responseObj[@"code"] isEqualToString:@"1000"]) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"创建成功" controller:self.navigationController sleep:1.5];
            
            // 创建成功， 把经理拉入俩天群
            NSArray *jingliID = responseObj[@"agencysList"];
            NSMutableArray *huanxinIDArray = [NSMutableArray array];
            for (int i = 0; i < jingliID.count; i ++) {
               NSString *huanXinId = jingliID[i][@"huanXinId"];
                [huanxinIDArray addObject:huanXinId];
            }
#if DELETEHUANXIN
            // (@"注释掉环信")
#else
            //(@"打开环信代码")
            EMError *error = nil;
            EMGroup *group = [[EMClient sharedClient].groupManager  addOccupants:huanxinIDArray toGroup:groupid welcomeMessage:nil error:&error];
#endif
            
            
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CreatContructList" object:nil];
            //[self.navigationController popViewControllerAnimated:YES];
            
            int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
   
            
        }
        else{
            [[PublicTool defaultTool] publicToolsHUDStr:@"创建失败，请重试" controller:self sleep:1.5];
            // 创建工地失败， 同时把创建好的群组删除
#if DELETEHUANXIN
            // (@"注释掉环信")
#else
            //(@"打开环信代码")
            EMError *EMError = nil;
            EMError = [[EMClient sharedClient].groupManager destroyGroup:groupid];
            if (!EMError) {
                YSNLog(@"解散成功");
            }
#endif
            
        }
    } failed:^(NSString *errorMsg) {
        [self.view hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

#pragma mark - aletview

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2000) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

#pragma mark  创建群组

#if DELETEHUANXIN
// (@"注释掉环信")
#else
//(@"打开环信代码")
-(NSString *)creatGroup:(NSString *)title{
    
    
    EMGroupOptions *setting = [[EMGroupOptions alloc]init];
    
    //设置群组的人员最大数量
    setting.maxUsersCount = 500;
    
    //设置群组的类型
    setting.style = EMGroupStylePrivateMemberCanInvite;
    
    setting.IsInviteNeedConfirm = NO;
    
    EMError *error = nil;
    
    //群组的名称为小区的名称
    BOOL isLoggedIn = [EMClient sharedClient].isLoggedIn;
    if (!isLoggedIn) {
        UserInfoModel *model = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
        EMError *EMerror = [[EMClient  sharedClient]loginWithUsername:model.huanXinId password:model.huanXinPassword];
        
        if (!EMerror) {
            [[EMClient sharedClient].options setIsAutoLogin:YES];
        }
    }
    
    EMGroup *group = [[EMClient sharedClient].groupManager createGroupWithSubject:title description:nil invitees:nil message:nil setting:setting error:&error];
    
    if (!error) {
        return  group.groupId;
    }else{
        return @"";
    }
    
    return 0;
}
#endif




-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.regionView.hidden = YES;
    if (_companyOrShop==1) {
        if (textField.tag == 4) {
            
            CGSize size = [self.shareTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) withFont:NB_FONTSEIZ_NOR];
            if (size.width<=(kSCREEN_WIDTH-15-60-20)) {
                size.width = kSCREEN_WIDTH-15-60-20;
            }
            
        }
    }
    else{
        if (textField.tag == 4) {
            CGSize size = [self.shareTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) withFont:NB_FONTSEIZ_NOR];
            if (size.width<=(kSCREEN_WIDTH-15-60-20)) {
                size.width = kSCREEN_WIDTH-15-60-20;
            }
            
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (_companyOrShop==1) {
        if (textField.tag == 4) {
            CGSize size = [self.shareTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) withFont:NB_FONTSEIZ_NOR];
            if (size.width<=(kSCREEN_WIDTH-15-60-20)) {
                size.width = kSCREEN_WIDTH-15-60-20;
            }
            
        }
    }
    else{
        if (textField.tag == 4) {
            CGSize size = [self.shareTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) withFont:NB_FONTSEIZ_NOR];
            if (size.width<=(kSCREEN_WIDTH-15-60-20)) {
                size.width = kSCREEN_WIDTH-15-60-20;
            }
            
        }
    }
    return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (_companyOrShop==1) {
        if (textField.tag == 0) {
            self.userName = textField.text;
        }
        if (textField.tag == 2) {
            //self.socialName = textField.text;
        }
        if (textField.tag == 4) {
            self.shareTitle = textField.text;
            

        }
        if (textField.tag == 5) {
            self.style = textField.text;
        }
        if (textField.tag == 6) {
            self.area = textField.text;
        }
    }
    else{
        if (textField.tag == 0) {
            self.userName = textField.text;
        }
        if (textField.tag == 2) {
           // self.socialName = textField.text;
        }
        if (textField.tag == 4) {
            self.shareTitle = textField.text;
            
            
        }
        
        if (textField.tag == 6) {
            self.area = textField.text;
        }
    }
    
}


#pragma mark - 选择小区

-(void)choosebtnclick
{
    localcommunityVC *VC = [localcommunityVC new];
    VC.cityId = self.cityId;
    VC.countyId = self.countyId;
    VC.ischange = NO;
    VC.isfromsite = YES;
    VC.returnValueBlock = ^(NSString *passedValue){
        self.socialName = passedValue;
        if (self.socialName.length==0) {
            [self.chooseBtn setTitle:@"选择小区" forState:normal];
        }
        else
        {
            [self.chooseBtn setTitle:self.socialName forState:normal];
        }
    };
    [self.navigationController pushViewController:VC animated:YES];
}


-(void)changePhoto{
    isHavePhoto = YES;
    [self imagePicker];
}

-(void)setFirstPhoto{
    isHavePhoto = NO;
    [self imagePicker];
}

-(UIScrollView *)srcV{
    if (!_srcV) {
        _srcV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64)];
//        _srcV.backgroundColor = Red_Color;
    }
    return _srcV;
}

-(UIImageView *)coverImgV{
    if (!_coverImgV) {
        _coverImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200)];
//        _coverImgV.image = [UIImage imageNamed:@"upload_logo.png"];
        
        _coverImgV.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePhoto)];
        [_coverImgV addGestureRecognizer:ges];
    }
    return _coverImgV;
}

-(UIImageView *)placeHolderImgV{
    if (!_placeHolderImgV) {
        _placeHolderImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _placeHolderImgV.image = [UIImage imageNamed:@"upload_logo.png"];
//        [_placeHolderImgV sizeToFit];
        _placeHolderImgV.left = self.coverImgV.width/2-_placeHolderImgV.width/2;
        _placeHolderImgV.top = self.coverImgV.height/2-_placeHolderImgV.height/2;
        _placeHolderImgV.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setFirstPhoto)];
        [_placeHolderImgV addGestureRecognizer:ges];
    }
    return _placeHolderImgV;
}

-(RegionView *)regionView{
    if (!_regionView) {
        _regionView = [[RegionView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-305, kSCREEN_WIDTH, 305)];
        _regionView.closeBtn.hidden = NO;
        _regionView.hidden = YES;
    }
    return _regionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
