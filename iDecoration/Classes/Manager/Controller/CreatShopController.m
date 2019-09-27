//
//  CreatShopController.m
//  iDecoration
//  创建分公司或店铺
//  Created by Apple on 2017/5/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CreatShopController.h"
#import "CategoryViewController.h"
#import "CategoryModel.h"
#import "AreaListModel.h"
#import "DecorationAreaViewController.h"
#import "DecoreAreaSelectController.h"
#import "SubsidiaryModel.h"
#import "ShopClassificationDetailViewController.h"
#import "RegionView.h"
#import "PModel.h"
#import "CModel.h"
#import "DModel.h"
#import "GTMBase64.h"

#import "UploadImageApi.h"
#import "UIBarButtonItem+Item.h"
// 判断是否是区号
#import "NSString+AreaCode.h"
#import "PlaceHolderTextView.h"

#import "NSObject+CompressImage.h"
#import "LocationViewController.h"

@interface CreatShopController ()<UITextFieldDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIScrollViewDelegate,UIAlertViewDelegate>
{
    
    CategoryModel *_category;
    NSString *_photoUrl;
    NSString *_companyName;
    NSString *_linePhone;
    NSString *_address;
    NSString *_telePhone;//业务经理电话
    NSString *_weChat;
    
    NSString *_Email;//邮箱替代手机号
    NSString *_Website;//网址替代微信号
    NSString *_areaList;
    NSString *_introduce;
    
    NSInteger _isCheck;
    
    NSString *temEmailStr;
    
    NSString *_areaCodeStr;//区号
    NSString *_behindPhoneStr;//区号后面的号
}
//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *srcV;
@property (nonatomic, strong) UILabel *logoL;
@property (nonatomic, strong) UIImageView *logoImg;
@property (nonatomic, strong) UILabel *placeHoldL;
@property (nonatomic, strong) UITextView *textV;
@property (nonatomic, strong) UIButton *successBtn;

@property (nonatomic, strong) UIButton *typeBtn;
@property (nonatomic, strong) UIButton *addressBtn;
@property (nonatomic, strong) UIButton *decorationbBtn;

//@property (nonatomic, strong) UILabel *queryL;
//@property (nonatomic, strong) UIButton *queryBtn;

@property (nonatomic, strong) RegionView *regionView;
// 省
@property (nonatomic, strong) PModel *pmodel;
// 市
@property (nonatomic, strong) CModel *cmodel;
// 区
@property (nonatomic, strong) DModel *dmodel;
@property (nonatomic, copy) NSString *addressStr;//公司地址
@property (nonatomic, assign) double lantitude; // 地址经纬度
@property (nonatomic, assign) double longitude;
@property (nonatomic, copy) NSString *addressDetailStr;//公司详细地址
@property (nonatomic, strong) NSMutableString *decorationStr;//装修区域

@property (nonatomic, strong) NSMutableArray *decorationArray;//装修区域的数组

@property (nonatomic, strong) NSArray *districtArr;

// 拼接数据
//@property (strong, nonatomic) NSMutableArray *dataArr;

// 存放type对应的字典
@property (strong, nonatomic) NSDictionary *typeDic;
// 用于存放这个页面的所有数据
@property (strong, nonatomic) NSMutableDictionary *allData;

@property (nonatomic, strong) UITextField *phoneTextField;

//区号
@property (nonatomic, strong) UITextField *areaCodeField;
//横杠
@property (nonatomic, strong) UILabel *midLineLabel;
//座机后面的号
@property (nonatomic, strong) UITextField *phoneBehindField;
// 详细地址
@property (nonatomic, strong) PlaceHolderTextView *detailAddressTV;

@end

@implementation CreatShopController

NSInteger textFieldFlag; //电话号输入标识

- (void)viewDidLoad {
    
    [super viewDidLoad];
    textFieldFlag = 0;
    temEmailStr = @"邮       箱";
    self.view.backgroundColor = kBackgroundColor;
//    self.dataArr = [NSMutableArray array];
    self.decorationStr = [NSMutableString string];
    self.decorationArray = [NSMutableArray array];
    self.allData = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"", @"logo", @"", @"0", @"", @"1", @"", @"2", @"", @"3", @"", @"4", @"", @"5", @"", @"6", @"", @"7", @"", @"isCheck", @"", @"intro", nil];
    _type = 0;
    self.typeDic = @{@"1001" : @"软装配饰",
                     @"1002" : @"陶瓷卫浴",
                     @"1003" : @"瓷砖理石",
                     @"1004" : @"橱柜衣柜",
                     @"1005" : @"窗帘壁纸",
                     @"1006" : @"门窗地板",
                     @"1007" : @"灯具吊顶",
                     @"1008" : @"油漆涂料",
                     @"1009" : @"五金建材",
                     @"1010" : @"其他",
                     @"1011" : @"家具家电",
                     @"1012" : @"广告牌匾",
                     @"1013" : @"家政保洁",
                     @"1014" : @"搬家",
                     @"1015" : @"空气治理",
                     @"1016" : @"瓷砖美缝",
                     @"1017" : @"软包纱窗",
                     @"1018" : @"装修公司",
                     @"1019" : @"智能家居",
                     @"1020" : @"房产中介"
                     };
    if (self.model) {
        
        [self settingData];
        
        self.lantitude = [self.model.latitude doubleValue];
        self.longitude = [self.model.longitude doubleValue];

    }
    if ((!self.model)&&(self.creatType==1)) {
        _type = 1018;
    }
    
    if (!self.model) {
        if (self.creatType==1) {
            self.title = @"装修公司";
        }
        
        if (self.creatType==2) {
            self.title = @"整装公司";
        }
        if (self.creatType == 3) {
            self.title = @"新型装修";
        }
        if (self.creatType == 4) {
            self.title = @"建材店铺";
        }
        _isCheck = 0;
        [self createUIWithNoData];
    } else if ([self.model.companyType integerValue] == 1018 || [self.model.companyType integerValue] == 1065 || [self.model.companyType integerValue] == 1064) {
        self.title = @"编辑公司";
        [self createUIWithEditCompany];
    } else {
        self.title = @"编辑商铺";
        //类别具体名称
        if (!_category) {
            _category = [[CategoryModel alloc]init];
        }
        
        _category.typeName = self.model.typeName;
        [self createUIWithEditShop];
    }
    
    // 单独处理这里的返回按钮(因为需要返回到根控制器)
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
}

- (void)settingData {
    
    // 品牌名称
//    [self.dataArr addObject:self.model.companyName];
    [self.allData setObject:self.model.companyName forKey:@"0"];
    _companyName = self.model.companyName;
    // 类别
//    [self.dataArr addObject:self.model.companyType];
    [self.allData setObject:self.model.companyType forKey:@"1"];
    _type = [self.model.companyType integerValue];
    // 装修区域
//    [self.dataArr addObject:self.areaListArray];
    [self.allData setObject:self.areaListArray forKey:@"2"];
    self.decorationArray = self.areaListArray;
    // 座机
//    [self.dataArr addObject:self.model.companyLandline];
    [self.allData setObject:self.model.companyLandline forKey:@"3"];
    
    //业务经理电话
    _telePhone = self.model.companyPhone;
    
    NSString *temStr = self.model.companyLandline;
    if ([temStr containsString:@"-"]) {
        NSArray *temArr = [temStr componentsSeparatedByString:@"-"];
        _areaCodeStr = temArr[0];
        _behindPhoneStr = temArr[1];
//        _behindPhoneStr = @"2345256672";
    }
    else{
        _areaCodeStr = @"";
        _behindPhoneStr = @"";
    }
    // 地址
//    [self.dataArr addObject:self.model.companyAddress];
    [self.allData setObject:self.model.companyAddress forKey:@"4"];
//    self.addressStr = self.model.companyAddress;
    
    
    
    //根据城市id获取城市地址
    NSString *pidStr;
    NSString *cidStr;
    NSString *didStr;
    
    PModel *temppmodel;
    CModel *tempcmodel;
    DModel *tempdmodel;
    
    NSMutableArray *tempPidArray = [NSMutableArray array];
    NSMutableArray *tempCidArray = [NSMutableArray array];
    NSMutableArray *tempDidArray = [NSMutableArray array];
    
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"city_blej_tree" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    if (self.model.companyProvince) {
        
        
        
        for (NSDictionary *dict in jsonArr) {
            
            PModel *pmodel = [PModel yy_modelWithJSON:dict];
            [tempPidArray addObject:pmodel];
        }
        
        for (PModel *pmodel in tempPidArray) {
            if ([pmodel.regionId integerValue]==[self.model.companyProvince integerValue]) {
                pidStr = pmodel.name;
                temppmodel = pmodel;
                
                break;
            }
        }
        
        NSInteger regionId = [self.model.companyProvince integerValue];
        if (regionId == 110000||regionId == 120000||regionId == 500000||regionId == 310000)//四个直辖市
        {
            //                        cidStr = pidStr;
            NSInteger temInt = [self.model.companyCounty integerValue];
            if (temInt==-1||temInt==0) {
                for (NSDictionary *dict in temppmodel.cities) {
                    
                    CModel *cmodel = [CModel yy_modelWithJSON:dict];
                    [tempCidArray addObject:cmodel];
                }
                
                for (CModel *cmodel in tempCidArray) {
                    if ([cmodel.regionId integerValue]==[self.model.companyProvince integerValue]) {
                        cidStr = @"";
                        tempcmodel = cmodel;
                        break;
                    }
                }
                
                for (NSDictionary *dict in tempcmodel.counties) {
                    
                    DModel *dmodel = [DModel yy_modelWithJSON:dict];
                    [tempDidArray addObject:dmodel];
                }
                
                for (DModel *dmodel in tempDidArray) {
                    if ([dmodel.regionId integerValue]==[self.model.companyCity integerValue]) {
                        didStr = dmodel.name;
                        tempdmodel = dmodel;
                        break;
                    }
                }
            }
            
            else{
                for (NSDictionary *dict in temppmodel.cities) {
                    
                    CModel *cmodel = [CModel yy_modelWithJSON:dict];
                    [tempCidArray addObject:cmodel];
                }
                
                for (CModel *cmodel in tempCidArray) {
                    if ([cmodel.regionId integerValue]==[self.model.companyCity integerValue]) {
                        cidStr = cmodel.name;
                        tempcmodel = cmodel;
                        
                        break;
                    }
                }
                
                for (NSDictionary *dict in tempcmodel.counties) {
                    
                    DModel *dmodel = [DModel yy_modelWithJSON:dict];
                    [tempDidArray addObject:dmodel];
                }
                
                for (DModel *dmodel in tempDidArray) {
                    if ([dmodel.regionId integerValue]==[self.model.companyCounty integerValue]) {
                        didStr = dmodel.name;
                        tempdmodel = dmodel;
                        break;
                    }
                }
            }
            
            
            
            
        }
        else{
            for (NSDictionary *dict in temppmodel.cities) {
                
                CModel *cmodel = [CModel yy_modelWithJSON:dict];
                [tempCidArray addObject:cmodel];
            }
            
            for (CModel *cmodel in tempCidArray) {
                if ([cmodel.regionId integerValue]==[self.model.companyCity integerValue]) {
                    cidStr = cmodel.name;
                    tempcmodel = cmodel;
                    
                    break;
                }
            }
            
            for (NSDictionary *dict in tempcmodel.counties) {
                
                DModel *dmodel = [DModel yy_modelWithJSON:dict];
                [tempDidArray addObject:dmodel];
            }
            
            for (DModel *dmodel in tempDidArray) {
                if ([dmodel.regionId integerValue]==[self.model.companyCounty integerValue]) {
                    didStr = dmodel.name;
                    tempdmodel = dmodel;
                    break;
                }
            }
        }
        if (!pidStr) {
            pidStr = @"";
        }
        if (!cidStr) {
            cidStr = @"";
        }
        if (!didStr) {
            didStr = @"";
        }
        self.addressStr = [NSString stringWithFormat:@"%@ %@ %@",pidStr,cidStr,didStr];
    }
    else{
        self.addressStr = @"";
    }
    // 详细地址
//    [self.dataArr addObject:self.model.detailedAddress];
    [self.allData setObject:self.model.detailedAddress forKey:@"5"];
    self.addressDetailStr = self.model.detailedAddress;
    
    
//    // 手机号
////    [self.dataArr addObject:self.model.companyPhone];
//    [self.allData setObject:self.model.companyPhone forKey:@"6"];
//    _telePhone = self.model.companyPhone;
//    // 微信
////    [self.dataArr addObject:self.model.companyWx];
//    [self.allData setObject:self.model.companyWx forKey:@"7"];
//    _weChat = self.model.companyWx;
    
    
    //6-16 by sty M
    // 邮箱
    //    [self.dataArr addObject:self.model.companyPhone];
    [self.allData setObject:self.model.companyEmail forKey:@"6"];
    _Email = self.model.companyEmail;
    // 网址
    //    [self.dataArr addObject:self.model.companyWx];
    [self.allData setObject:self.model.companyUrl forKey:@"7"];
    _Website = self.model.companyUrl;
    
    
    
//    if (self.model.seeFlag==nil) {
//        [self.allData setObject:@(1) forKey:@"isCheck"];
//        _isCheck = 1;
//    }
//    else{
//        [self.allData setObject:self.model.seeFlag forKey:@"isCheck"];
//        _isCheck = [self.model.seeFlag integerValue];
//    }
    
    _introduce = self.model.companyIntroduction;
    [self.allData setObject:self.model.companyIntroduction forKey:@"intro"];
    _photoUrl = self.model.companyLogo;
    [self.allData setObject:self.model.companyLogo forKey:@"logo"];
    self.pmodel = [[PModel alloc] init];
    self.cmodel = [[CModel alloc] init];
    self.dmodel = [[DModel alloc] init];
    self.pmodel.regionId = self.model.companyProvince;
    self.cmodel.regionId = self.model.companyCity;
    self.dmodel.regionId = self.model.companyCounty;
    
//    if ([self.model.companyType integerValue] != 1018) {
//        [self.dataArr removeObject:self.areaListArray];
//        [self.decorationArray removeAllObjects];
//    }
}

#pragma mark - 创建店铺
- (void)createUIWithNoData {
    
    [self.srcV removeAllSubViews];
    [self.srcV removeFromSuperview];
    [self.view addSubview:self.srcV];
    [self.srcV addSubview:self.logoL];
    [self.srcV addSubview:self.logoImg];
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.logoImg.bottom + 10, BLEJWidth, 1)];
    topLine.backgroundColor = kBackgroundColor;
    [self.srcV addSubview:topLine];
    
    int h = self.logoImg.bottom + 10;
    
    if (_type == 1018 || _type == 1064 || _type == 1065 || self.creatType == 1 || self.creatType == 2 || self.creatType == 3) {
        //装修公司
        for (int i = 0; i < 9; i ++) {
            NSArray *leftArray = @[@"品牌名称",@"类   \ \ \ \ 别", @"装修区域", @"座   \ \ \ \ 机",@"地   \ \ \ \ 址",@"详细地址",@"业务经理电话",temEmailStr,@"网   \ \ \ \ 址"];
            UILabel *leftL = [[UILabel alloc]initWithFrame:CGRectMake(15, h, 70, 60)];
            leftL.text = leftArray[i];
            leftL.textColor = COLOR_BLACK_CLASS_3;
            leftL.font = [UIFont systemFontOfSize:16];
            leftL.textAlignment = NSTextAlignmentLeft;
            
            UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(leftL.right+10, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height)];
            textF.textColor = COLOR_BLACK_CLASS_3;
            textF.font = [UIFont systemFontOfSize:16];
            [textF setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
            [textF setValue:NB_FONTSEIZ_NOR forKeyPath:@"_placeholderLabel.font"];
            
            [textF addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
            [textF addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventAllEvents];
            textF.tag = i;
            textF.delegate = self;
            if (i == 0) {
                textF.placeholder = @"请输入品牌名称";
                
                [textF removeFromSuperview];
                PlaceHolderTextView *companyNameTextView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(leftL.right + 5.5, leftL.top + 12, kSCREEN_WIDTH-leftL.right-20, leftL.height - 12)];
                companyNameTextView.placeHolder = @"请输入品牌名称";
                companyNameTextView.placeHolderColor = [UIColor lightGrayColor];
                //                companyNameTextView.placeHolderFont = [UIFont systemFontOfSize:16];
                
                companyNameTextView.font = [UIFont systemFontOfSize:16];
                companyNameTextView.textColor = COLOR_BLACK_CLASS_3;
                companyNameTextView.tag = i;
                companyNameTextView.delegate = self;
                companyNameTextView.text = [self.allData objectForKey:[NSString stringWithFormat:@"%d", i]];
                [self.srcV addSubview:companyNameTextView];
                
            }
            
            if (i == 5) {
                textF.placeholder = @"请输入详细地址";
            }
            if (i == 5) {
                [textF removeFromSuperview];
                PlaceHolderTextView *addressTextView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(leftL.right + 5.5, leftL.top + 12, kSCREEN_WIDTH-leftL.right-40, leftL.height - 12)];
                self.detailAddressTV = addressTextView;
                addressTextView.placeHolder = @"请输入详细地址";
                addressTextView.placeHolderColor = [UIColor lightGrayColor];
                //                addressTextView.placeHolderFont = [UIFont systemFontOfSize:16];
                
                addressTextView.font = [UIFont systemFontOfSize:16];
                addressTextView.textColor = COLOR_BLACK_CLASS_3;
                addressTextView.tag = i;
                addressTextView.delegate = self;
                addressTextView.text = [self.allData objectForKey:[NSString stringWithFormat:@"%d", i]];
                [self.srcV addSubview:addressTextView];
                
                UIButton *locationButton = [[UIButton alloc]initWithFrame:CGRectMake(addressTextView.right - 5, 0,  30, 30)];
                locationButton.centerY = leftL.centerY;
                locationButton.contentMode = UIViewContentModeScaleAspectFit;
                [locationButton  addTarget:self action:@selector(localionButtonAction) forControlEvents:UIControlEventTouchUpInside];
                [locationButton  setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
                [self.srcV addSubview:locationButton];
                
            }
            if (i == 6) {
                textF.placeholder = @"为避免骚扰,请谨慎填写手机号";
                leftL.frame = CGRectMake(15, h, 100, 60);
                textF.frame = CGRectMake(leftL.right+10, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height);
                if (kSCREEN_WIDTH<350) {
                    [textF setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
                }
            }
            
            if (i == 7) {
                textF.placeholder = @"请输入邮箱";
            }
            if (i == 8) {
                textF.placeholder = @"请输入网址";
            }
            
            if (i == 3) {
                
//                _queryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                _queryBtn.frame = CGRectMake(kSCREEN_WIDTH-8-30, h+7, 30, 30);
//                _queryBtn.centerY = leftL.centerY;
//                if (_isCheck == 0) {
//
//                    [_queryBtn setImage:[UIImage imageNamed:@"circle_kong"] forState:UIControlStateNormal];
//                } else {
//
//                    [_queryBtn setImage:[UIImage imageNamed:@"circle_shi"] forState:UIControlStateNormal];
//                }
//
//                [_queryBtn addTarget:self action:@selector(queryBtnClick) forControlEvents:UIControlEventTouchUpInside];
//                [self.srcV addSubview:self.queryBtn];
//                _queryL = [[UILabel alloc]initWithFrame:CGRectMake(self.queryBtn.left-60,h+10, 65, 20)];
//                _queryL.centerY = leftL.centerY;
//                _queryL.textColor = COLOR_BLACK_CLASS_3;
//                _queryL.font = [UIFont systemFontOfSize:16];
//                _queryL.text = @"114可查";
//                _queryL.textAlignment = NSTextAlignmentRight;
//                [self.srcV addSubview:self.queryL];
                textF.frame = CGRectMake(leftL.right+10, leftL.top, kSCREEN_WIDTH-leftL.right-110, leftL.height);
                textF.placeholder = @"请输入区号+号码";
                
                textF.adjustsFontSizeToFitWidth = YES;
                self.phoneTextField = textF;
                
                self.phoneTextField.hidden = YES;
                
                // 修改座机 3个固定的控件  7-17 by sty
                UITextField *areaCode = [[UITextField alloc]initWithFrame:CGRectMake(leftL.right+10, leftL.top+15, 50, 30)];
                
                //                areaCode.layer.masksToBounds = YES;
                //                areaCode.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
                //                areaCode.layer.borderWidth = 1;
                //                areaCode.layer.cornerRadius = 5;
                areaCode.placeholder = @"区号";
                //                if (kSCREEN_WIDTH<350) {
                //                    areaCode.textAlignment = NSTextAlignmentRight;
                //                }else{
                //                    areaCode.textAlignment = NSTextAlignmentCenter;
                //                }
                areaCode.textAlignment = NSTextAlignmentLeft;
                areaCode.textColor = COLOR_BLACK_CLASS_3;
                areaCode.font = NB_FONTSEIZ_BIG;
                [areaCode setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
                [areaCode setValue:NB_FONTSEIZ_BIG forKeyPath:@"_placeholderLabel.font"];
                areaCode.keyboardType = UIKeyboardTypeNumberPad;
                NSString *str = @"0377";
                CGSize textSize = [str boundingRectWithSize:CGSizeMake(50, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                    context:nil].size;
                [areaCode sizeThatFits:CGSizeMake(textSize.width, 30)];
                
                if (_areaCodeStr&&_areaCodeStr.length>0) {
                    areaCode.text = _areaCodeStr;
                }
                else{
                    areaCode.text = @"";
                }
                
                areaCode.tag = 100;
                self.areaCodeField = areaCode;
                self.areaCodeField.delegate = self;
                //                [self.areaCodeField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                [self.srcV addSubview:self.areaCodeField];
                
                UILabel *midLineL = [[UILabel alloc]initWithFrame:CGRectMake(self.areaCodeField.right-7, self.areaCodeField.top, 5, self.areaCodeField.height)];
                midLineL.text = @"-";
                midLineL.textColor = COLOR_BLACK_CLASS_3;
                midLineL.font = NB_FONTSEIZ_BIG;
                //        companyJob.backgroundColor = Red_Color;
                midLineL.textAlignment = NSTextAlignmentCenter;
                self.midLineLabel = midLineL;
                [self.srcV addSubview:self.midLineLabel];
                
                //                [textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                
                UITextField *phoneBehind = [[UITextField alloc]initWithFrame:CGRectMake(self.midLineLabel.right+5, self.areaCodeField.top, 100, 30)];
                
                //                areaCode.layer.masksToBounds = YES;
                //                areaCode.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
                //                areaCode.layer.borderWidth = 1;
                //                areaCode.layer.cornerRadius = 5;
                phoneBehind.placeholder = @"座机号";
                phoneBehind.textAlignment = NSTextAlignmentLeft;
                phoneBehind.keyboardType = UIKeyboardTypeNumberPad;
                phoneBehind.textColor = COLOR_BLACK_CLASS_3;
                phoneBehind.font = NB_FONTSEIZ_BIG;
                [phoneBehind setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
                [phoneBehind setValue:NB_FONTSEIZ_BIG forKeyPath:@"_placeholderLabel.font"];
                
                if (_behindPhoneStr&&_behindPhoneStr.length>0) {
                    phoneBehind.text = _behindPhoneStr;
                }
                else{
                    phoneBehind.text = @"";
                }
                
                self.phoneBehindField = phoneBehind;
                self.phoneBehindField.tag=200;
                self.phoneBehindField.delegate = self;
                [self.srcV addSubview:self.phoneBehindField];
                
                
                //                [textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            }
            
            
            UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, leftL.bottom-1, kSCREEN_WIDTH, 1)];
            lineV.backgroundColor = kBackgroundColor;
            h = h +60;
            [self.srcV addSubview:leftL];
            //            [self.srcV addSubview:textF];
            if (i != 5 && i != 0) {
                [self.srcV addSubview:textF];
            }
            [self.srcV addSubview:lineV];
            if (i != 2) {
                
                textF.text = [self.allData objectForKey:[NSString stringWithFormat:@"%d", i]];
                //            textF.text = self.dataArr[i];
            }
            
            if (i == 1) {
                _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];

                _typeBtn.frame = textF.frame;
                _typeBtn.height = 60;
                _typeBtn.centerY = leftL.centerY;
                _typeBtn.width = textF.width - 35;

                if ([self.model.companyType integerValue] == 1018 || self.creatType == 1) {
                    [_typeBtn setTitle:@"装修公司" forState:UIControlStateNormal];
                    _typeBtn.userInteractionEnabled = false;
                }else if ([self.model.companyType integerValue] == 1064 || self.creatType == 2) {
                    [_typeBtn setTitle:@"整装公司" forState:UIControlStateNormal];
                    _typeBtn.userInteractionEnabled = false;
                }else if ([self.model.companyType integerValue] == 1065 || self.creatType == 3) {
                    [_typeBtn setTitle:@"新型装修" forState:UIControlStateNormal];
                    _typeBtn.userInteractionEnabled = false;
                }else{
                    [_typeBtn setTitle:_category.typeName forState:UIControlStateNormal];
                }

                _typeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [_typeBtn setTitleColor:Black_Color forState:UIControlStateNormal];
                _typeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
                [_typeBtn addTarget:self action:@selector(typeBtnClick) forControlEvents:UIControlEventTouchUpInside];
                _typeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
                _typeBtn.backgroundColor = [UIColor clearColor];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = textF.frame;
                btn.size = CGSizeMake(30, 30);
                btn.right = self.view.right - 5;
                btn.height = 39;
                btn.centerY = leftL.centerY;
                [btn setImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];
                btn.hidden = true;
                [self.srcV addSubview:self.typeBtn];
                [self.srcV addSubview:btn];
                textF.hidden = YES;
            }
            
            if (i == 4) {
                _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _addressBtn.frame = textF.frame;
                _addressBtn.height = 60;
                _addressBtn.centerY = leftL.centerY;
                _addressBtn.width = textF.width - 35;
                
                if (!self.addressStr||self.addressStr.length<=0) {
                    [_addressBtn setTitle:@"请选择地址" forState:UIControlStateNormal];
                    [_addressBtn setTitleColor:COLOR_BLACK_CLASS_9 forState:UIControlStateNormal];
                }
                else{
                    [_addressBtn setTitle:self.addressStr forState:UIControlStateNormal];
                    [_addressBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                }
                
                _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//                [_addressBtn setTitleColor:Black_Color forState:UIControlStateNormal];
                _addressBtn.titleLabel.font = [UIFont systemFontOfSize:16];
                [_addressBtn addTarget:self action:@selector(addressBtnClick) forControlEvents:UIControlEventTouchUpInside];
                _addressBtn.backgroundColor = [UIColor clearColor];
                _addressBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                [self.srcV addSubview:self.addressBtn];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = textF.frame;
                btn.size = CGSizeMake(30, 30);
                btn.right = self.view.right - 5;
                btn.height = 39;
                btn.centerY = leftL.centerY;
                [btn addTarget:self action:@selector(addressBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [btn setImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];
                [self.srcV addSubview:btn];
                
                textF.hidden = YES;
            }
            
            if (i == 2) {
                _decorationbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _decorationbBtn.frame = textF.frame;
                _decorationbBtn.height = 60;
                _decorationbBtn.width = textF.width - 35;
                _decorationbBtn.centerY = leftL.centerY;
                _decorationbBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//                [_decorationbBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                _decorationbBtn.titleLabel.font = [UIFont systemFontOfSize:16];
                [_decorationbBtn addTarget:self action:@selector(decorationbBtnClick) forControlEvents:UIControlEventTouchUpInside];
                _decorationbBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                _decorationbBtn.backgroundColor = [UIColor clearColor];
                [self.srcV addSubview:self.decorationbBtn];
                NSMutableArray *arrM = [NSMutableArray array];
                for (AreaListModel *model in self.decorationArray) {
                    NSArray *arr = [model.retion componentsSeparatedByString:@" "];
                    [arrM addObject:arr.lastObject];
                }
                self.decorationStr = [NSMutableString stringWithString:[arrM componentsJoinedByString:@" "]];
                if (!self.decorationStr||self.decorationStr.length<=0) {
                    [self.decorationbBtn setTitle:@"请选择装修区域" forState:UIControlStateNormal];
                    [_decorationbBtn setTitleColor:COLOR_BLACK_CLASS_9 forState:UIControlStateNormal];
                }
                else{
                    [self.decorationbBtn setTitle:self.decorationStr forState:UIControlStateNormal];
                [self.decorationbBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                }
                
                
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = textF.frame;
                btn.size = CGSizeMake(30, 30);
                btn.right = self.view.right - 5;
                btn.height = 39;
                btn.centerY = leftL.centerY;
                [btn addTarget:self action:@selector(decorationbBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [btn setImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];
                [self.srcV addSubview:btn];
                
                textF.hidden = YES;
            }
        }
    }
    else{
        //店铺
        for (int i = 0; i < 8; i ++) {
            
            NSArray *leftArray = @[@"品牌名称", @"类   \ \ \ \ 别", @"座   \ \ \ \ 机", @"地   \ \ \ \ 址", @"详细地址", @"业务经理电话", temEmailStr, @"网  \ \ \ \ 址"];
            UILabel *leftL = [[UILabel alloc]initWithFrame:CGRectMake(15, h, 70, 60)];
            leftL.text = leftArray[i];
            leftL.textColor = COLOR_BLACK_CLASS_3;
            leftL.font = [UIFont systemFontOfSize:16];
            leftL.textAlignment = NSTextAlignmentLeft;
            
            UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(leftL.right+10, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height)];
            textF.textColor = COLOR_BLACK_CLASS_3;
            textF.font = [UIFont systemFontOfSize:16];
            [textF setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
            [textF setValue:NB_FONTSEIZ_NOR forKeyPath:@"_placeholderLabel.font"];
            
            [textF addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
            [textF addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventAllEvents];
            textF.tag = i;
            textF.delegate = self;
            
            if (i < 2) {
                textF.text = [self.allData objectForKey:[NSString stringWithFormat:@"%d", i]];
            } else {
                textF.text = [self.allData objectForKey:[NSString stringWithFormat:@"%d", i + 1]];
            }
            
            if (i == 0) {
                textF.placeholder = @"请输入品牌名称";
                
                [textF removeFromSuperview];
                PlaceHolderTextView *companyNameTextView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(leftL.right + 5.5, leftL.top + 12, kSCREEN_WIDTH-leftL.right-20, leftL.height - 12)];
                companyNameTextView.placeHolder = @"请输入品牌名称";
                companyNameTextView.placeHolderColor = [UIColor lightGrayColor];
                //                companyNameTextView.placeHolderFont = [UIFont systemFontOfSize:16];
                
                companyNameTextView.font = [UIFont systemFontOfSize:16];
                companyNameTextView.textColor = COLOR_BLACK_CLASS_3;
                companyNameTextView.tag = i;
                companyNameTextView.delegate = self;
                companyNameTextView.text = [self.allData objectForKey:[NSString stringWithFormat:@"%d", i]];
                [self.srcV addSubview:companyNameTextView];
                
            }
            
            if (i == 4) {
                textF.placeholder = @"请输入详细地址";
            }
            if (i == 4) {
                [textF removeFromSuperview];
                PlaceHolderTextView *addressTextView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(leftL.right + 5.5, leftL.top + 12, kSCREEN_WIDTH-leftL.right-40, leftL.height - 12)];
                self.detailAddressTV = addressTextView;
                addressTextView.placeHolder = @"请输入详细地址";
                addressTextView.placeHolderColor = [UIColor lightGrayColor];
                //                addressTextView.placeHolderFont = [UIFont systemFontOfSize:16];
                
                addressTextView.font = [UIFont systemFontOfSize:16];
                addressTextView.textColor = COLOR_BLACK_CLASS_3;
                addressTextView.tag = i;
                addressTextView.delegate = self;
                addressTextView.text = [self.allData objectForKey:[NSString stringWithFormat:@"%d", i + 1]];
                [self.srcV addSubview:addressTextView];
                
                UIButton *locationButton = [[UIButton alloc]initWithFrame:CGRectMake(addressTextView.right - 5, 0,  30, 30)];
                locationButton.centerY = leftL.centerY;
                locationButton.contentMode = UIViewContentModeScaleAspectFit;
                [locationButton  addTarget:self action:@selector(localionButtonAction) forControlEvents:UIControlEventTouchUpInside];
                [locationButton  setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
                [self.srcV addSubview:locationButton];
                
            }
            if (i==5) {
                textF.placeholder = @"为避免骚扰,请谨慎填写手机号";
                leftL.frame = CGRectMake(15, h, 100, 60);
                textF.frame = CGRectMake(leftL.right+10, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height);
                
                if (kSCREEN_WIDTH<350) {
                    [textF setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
                }
            }
            
            if (i == 6) {
                textF.placeholder = @"请输入邮箱";
            }
            if (i == 7) {
                textF.placeholder = @"请输入网址";
            }
            
            if (i == 2) {
                
//                _queryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                _queryBtn.frame = CGRectMake(kSCREEN_WIDTH-8-30, h+7, 30, 30);
//                _queryBtn.centerY = leftL.centerY;
//                if (_isCheck == 0) {
//
//                    [_queryBtn setImage:[UIImage imageNamed:@"circle_kong"] forState:UIControlStateNormal];
//                } else {
//
//                    [_queryBtn setImage:[UIImage imageNamed:@"circle_shi"] forState:UIControlStateNormal];
//                }
//                [_queryBtn addTarget:self action:@selector(queryBtnClick) forControlEvents:UIControlEventTouchUpInside];
//                [self.srcV addSubview:self.queryBtn];
//                _queryL = [[UILabel alloc]initWithFrame:CGRectMake(self.queryBtn.left-60,h+10, 65, 20)];
//                _queryL.textColor = COLOR_BLACK_CLASS_3;
//                _queryL.font = [UIFont systemFontOfSize:16];
//                _queryL.text = @"114可查";
//                _queryL.centerY = leftL.centerY;
//                _queryL.textAlignment = NSTextAlignmentRight;
//                [self.srcV addSubview:self.queryL];
                textF.frame = CGRectMake(leftL.right+10, leftL.top, kSCREEN_WIDTH-leftL.right-110, leftL.height);
                textF.placeholder = @"请输入区号+号码";
                
                textF.adjustsFontSizeToFitWidth = YES;
                self.phoneTextField = textF;
                self.phoneTextField.hidden = YES;
                
                // 修改座机 3个固定的控件  7-17 by sty
                UITextField *areaCode = [[UITextField alloc]initWithFrame:CGRectMake(leftL.right+10, leftL.top+15, 50, 30)];
                
                //                areaCode.layer.masksToBounds = YES;
                //                areaCode.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
                //                areaCode.layer.borderWidth = 1;
                //                areaCode.layer.cornerRadius = 5;
                areaCode.placeholder = @"区号";
                areaCode.textAlignment = NSTextAlignmentLeft;
                //                if (kSCREEN_WIDTH<350) {
                //                    areaCode.textAlignment = NSTextAlignmentRight;
                //                }else{
                //                    areaCode.textAlignment = NSTextAlignmentCenter;
                //                }
                
                areaCode.textColor = COLOR_BLACK_CLASS_3;
                areaCode.font = NB_FONTSEIZ_BIG;
                [areaCode setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
                [areaCode setValue:NB_FONTSEIZ_BIG forKeyPath:@"_placeholderLabel.font"];
                areaCode.keyboardType = UIKeyboardTypeNumberPad;
                NSString *str = @"0377";
                CGSize textSize = [str boundingRectWithSize:CGSizeMake(50, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                    context:nil].size;
                [areaCode sizeThatFits:CGSizeMake(textSize.width, 30)];
                
                if (_areaCodeStr&&_areaCodeStr.length>0) {
                    areaCode.text = _areaCodeStr;
                }
                else{
                    areaCode.text = @"";
                }
                
                areaCode.tag = 100;
                self.areaCodeField = areaCode;
                self.areaCodeField.delegate = self;
                //                [self.areaCodeField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                [self.srcV addSubview:self.areaCodeField];
                
                UILabel *midLineL = [[UILabel alloc]initWithFrame:CGRectMake(self.areaCodeField.right-7, self.areaCodeField.top, 5, self.areaCodeField.height)];
                midLineL.text = @"-";
                midLineL.textColor = COLOR_BLACK_CLASS_3;
                midLineL.font = NB_FONTSEIZ_BIG;
                //        companyJob.backgroundColor = Red_Color;
                midLineL.textAlignment = NSTextAlignmentCenter;
                self.midLineLabel = midLineL;
                [self.srcV addSubview:self.midLineLabel];
                
                //                [textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                
                UITextField *phoneBehind = [[UITextField alloc]initWithFrame:CGRectMake(self.midLineLabel.right+5, self.areaCodeField.top, 100, 30)];
                
                //                areaCode.layer.masksToBounds = YES;
                //                areaCode.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
                //                areaCode.layer.borderWidth = 1;
                //                areaCode.layer.cornerRadius = 5;
                phoneBehind.placeholder = @"座机号";
                phoneBehind.textAlignment = NSTextAlignmentLeft;
                phoneBehind.keyboardType = UIKeyboardTypeNumberPad;
                phoneBehind.textColor = COLOR_BLACK_CLASS_3;
                phoneBehind.font = NB_FONTSEIZ_BIG;
                [phoneBehind setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
                [phoneBehind setValue:NB_FONTSEIZ_BIG forKeyPath:@"_placeholderLabel.font"];
                
                if (_behindPhoneStr&&_behindPhoneStr.length>0) {
                    phoneBehind.text = _behindPhoneStr;
                }
                else{
                    phoneBehind.text = @"";
                }
                
                self.phoneBehindField = phoneBehind;
                self.phoneBehindField.tag=200;
                self.phoneBehindField.delegate = self;
                [self.srcV addSubview:self.phoneBehindField];
                
                
                //                [textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            }
            
            
            UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, leftL.bottom-1, kSCREEN_WIDTH, 1)];
            lineV.backgroundColor = kBackgroundColor;
            h = h +60;
            [self.srcV addSubview:leftL];
            //            [self.srcV addSubview:textF];
            if (i != 4 && i != 0) {
                [self.srcV addSubview:textF];
            }
            [self.srcV addSubview:lineV];
            
            if (i == 1) {
                _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];

                _typeBtn.frame = textF.frame;
                _typeBtn.height = 60;
                _typeBtn.width = textF.width - 35;
                _typeBtn.centerY = leftL.centerY;
                [_typeBtn setTitleColor:Black_Color forState:UIControlStateNormal];

                if ([self.model.companyType integerValue] == 1018) {
                    [_typeBtn setTitle:@"装修公司" forState:UIControlStateNormal];
                }else if ([self.model.companyType integerValue] == 1064) {
                    [_typeBtn setTitle:@"整装公司" forState:UIControlStateNormal];
                }else if ([self.model.companyType integerValue] == 1065) {
                    [_typeBtn setTitle:@"新型装修" forState:UIControlStateNormal];
                }else{
                    [_typeBtn setTitle:_category.typeName?:@"请选择类别" forState:UIControlStateNormal];
                    [_typeBtn setTitleColor:COLOR_BLACK_CLASS_9 forState:UIControlStateNormal];
                }

                _typeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                _typeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
                [_typeBtn addTarget:self action:@selector(typeBtnClick) forControlEvents:UIControlEventTouchUpInside];
                _typeBtn.backgroundColor = [UIColor clearColor];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = textF.frame;
                btn.size = CGSizeMake(30, 30);
                btn.right = self.view.right - 5;
                btn.height = 39;
                btn.centerY = leftL.centerY;
                [btn addTarget:self action:@selector(typeBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [btn setImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];
                
                [self.srcV addSubview:self.typeBtn];
                [self.srcV addSubview:btn];
                textF.hidden = YES;
            }
            
            if (i == 3) {
                _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _addressBtn.frame = textF.frame;
                _addressBtn.height = 60;
                _addressBtn.width = textF.width - 35;
                _addressBtn.centerY = leftL.centerY;
                //            [_addressBtn setTitle:@"请选择地址" forState:UIControlStateNormal];
//                [_addressBtn setTitle:@"" forState:UIControlStateNormal];
                
                if (!self.addressStr||self.addressStr.length<=0) {
                    [_addressBtn setTitle:@"请选择地址" forState:UIControlStateNormal];
                    [_addressBtn setTitleColor:COLOR_BLACK_CLASS_9 forState:UIControlStateNormal];
                }
                else{
                    [_addressBtn setTitle:self.addressStr forState:UIControlStateNormal];
                    [_addressBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                }
                
                _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//                [_addressBtn setTitleColor:Black_Color forState:UIControlStateNormal];
                _addressBtn.titleLabel.font = [UIFont systemFontOfSize:16];
                [_addressBtn addTarget:self action:@selector(addressBtnClick) forControlEvents:UIControlEventTouchUpInside];
                _addressBtn.backgroundColor = [UIColor clearColor];
                _addressBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                [self.srcV addSubview:self.addressBtn];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = textF.frame;
                btn.size = CGSizeMake(30, 30);
                btn.right = self.view.right - 5;
                btn.height = 39;
                btn.centerY = leftL.centerY;
                [btn addTarget:self action:@selector(addressBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [btn setImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];
                [self.srcV addSubview:btn];
                
                textF.hidden = YES;
            }
            
        }
    }
    

    
    UILabel *temL = [[UILabel alloc]initWithFrame:CGRectMake(15, h, 75, 60)];
    temL.textColor = COLOR_BLACK_CLASS_3;
    temL.font = [UIFont systemFontOfSize
                 :16];
    temL.text = @"简   \ \ \ \ 介";
    temL.textAlignment = NSTextAlignmentLeft;
    [self.srcV addSubview:temL];
    
    self.textV = [[UITextView alloc]initWithFrame:CGRectMake(10, temL.bottom, kSCREEN_WIDTH-20, 80)];
    self.textV.layer.cornerRadius = 5;
    self.textV.layer.borderColor = kBackgroundColor.CGColor;
    self.textV.layer.borderWidth = 1;
    self.textV.backgroundColor = White_Color;
    self.textV.delegate = self;
    self.textV.font = [UIFont systemFontOfSize:16];
    self.textV.tag = 1111;
    [self.srcV addSubview:self.textV];
    
    
    self.placeHoldL = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 20)];
    self.placeHoldL.textColor = [UIColor lightGrayColor];
    self.placeHoldL.font = [UIFont systemFontOfSize:16];
    
    self.placeHoldL.text = @"填写品牌或店铺信息";
    self.placeHoldL.textAlignment = NSTextAlignmentLeft;
    
    [self.textV addSubview:self.placeHoldL];
    
    
    _successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _successBtn.frame = CGRectMake(10,self.textV.bottom+10,kSCREEN_WIDTH - 20,44);
    _successBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_successBtn setTitleColor:White_Color forState:UIControlStateNormal];
    _successBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_successBtn setTitle:@"完    成" forState:UIControlStateNormal];
    _successBtn.layer.cornerRadius = 5;
    _successBtn.layer.masksToBounds = YES;
    [_successBtn addTarget:self action:@selector(successTouch) forControlEvents:UIControlEventTouchUpInside];
    _successBtn.backgroundColor = Main_Color;
    [self.srcV addSubview:self.successBtn];
    
    self.srcV.contentSize = CGSizeMake(kSCREEN_WIDTH, self.successBtn.bottom+20);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCategory:) name:@"categoryNoti" object:nil];
    
    [self.view addSubview:self.regionView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetArea:) name:@"DecorationAreaNot" object:nil];
}

#pragma mark - 编辑商铺
- (void)createUIWithEditShop {
    
    [self.srcV removeAllSubViews];
    [self.srcV removeFromSuperview];
    [self.view addSubview:self.srcV];
    [self.srcV addSubview:self.logoL];
    [self.srcV addSubview:self.logoImg];
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.logoImg.bottom + 10, BLEJWidth, 1)];
    topLine.backgroundColor = kBackgroundColor;
    [self.srcV addSubview:topLine];
    
    int h = self.logoImg.bottom + 10;
    for (int i = 0; i < 8; i ++) {
        
        NSArray *leftArray = @[@"品牌名称",@"类   \ \ \ \ 别", @"座   \ \ \ \ 机",@"地   \ \ \ \ 址",@"详细地址",@"业务经理电话", temEmailStr,@"网   \ \ \ \ 址"];
//        NSArray *leftArray = @[@"品牌名称", @"类   \ \ \ \ 别", @"座   \ \ \ \ 机", @"地   \ \ \ \ 址", @"详细地址", @"手  机  号", @"微   \ \ \ \ 信"];
        UILabel *leftL = [[UILabel alloc]initWithFrame:CGRectMake(15, h, 70, 60)];
        leftL.text = leftArray[i];
        leftL.textColor = COLOR_BLACK_CLASS_3;
        leftL.font = [UIFont systemFontOfSize:16];
        leftL.textAlignment = NSTextAlignmentLeft;
        
        UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(leftL.right+10, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height)];
        textF.textColor = COLOR_BLACK_CLASS_3;
        textF.font = [UIFont systemFontOfSize:16];;
        [textF setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
        [textF setValue:NB_FONTSEIZ_NOR forKeyPath:@"_placeholderLabel.font"];
        
        [textF addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
        [textF addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventAllEvents];
        textF.tag = i;
        textF.delegate = self;
        if (i < 2) {
            textF.text = [self.allData objectForKey:[NSString stringWithFormat:@"%d", i]];
        } else {
            textF.text = [self.allData objectForKey:[NSString stringWithFormat:@"%d", i + 1]];
        }
        
//        textF.text = self.dataArr[i];
        
        if (i == 0) {
            textF.placeholder = @"请输入品牌名称";
            
            [textF removeFromSuperview];
            PlaceHolderTextView *companyNameTextView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(leftL.right + 5.5, leftL.top + 12, kSCREEN_WIDTH-leftL.right-20, leftL.height - 12)];
            companyNameTextView.placeHolder = @"请输入品牌名称";
            companyNameTextView.placeHolderColor = [UIColor lightGrayColor];
//            companyNameTextView.placeHolderFont = [UIFont systemFontOfSize:16];
            
            companyNameTextView.font = [UIFont systemFontOfSize:16];
            companyNameTextView.textColor = COLOR_BLACK_CLASS_3;
            companyNameTextView.tag = i;
            companyNameTextView.delegate = self;
            companyNameTextView.text = [self.allData objectForKey:[NSString stringWithFormat:@"%d", i]];
            
            [self.srcV addSubview:companyNameTextView];

        }
        
        if (i == 4) {
            textF.placeholder = @"请输入详细地址";
        }
        if (i == 4) {
            [textF removeFromSuperview];
            PlaceHolderTextView *addressTextView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(leftL.right + 5.5, leftL.top + 12, kSCREEN_WIDTH-leftL.right-40, leftL.height - 12)];
            self.detailAddressTV = addressTextView;
            addressTextView.placeHolder = @"请输入详细地址";
            addressTextView.placeHolderColor = [UIColor lightGrayColor];
//            addressTextView.placeHolderFont = [UIFont systemFontOfSize:16];
            
            addressTextView.font = [UIFont systemFontOfSize:16];
            addressTextView.textColor = COLOR_BLACK_CLASS_3;
            addressTextView.tag = i;
            addressTextView.delegate = self;
            addressTextView.text = [self.allData objectForKey:[NSString stringWithFormat:@"%d", i + 1]];

            [self.srcV addSubview:addressTextView];
            
            UIButton *locationButton = [[UIButton alloc]initWithFrame:CGRectMake(addressTextView.right - 5, 0,  30, 30)];
            locationButton.centerY = leftL.centerY;
            locationButton.contentMode = UIViewContentModeScaleAspectFit;
            [locationButton  addTarget:self action:@selector(localionButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [locationButton  setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
            [self.srcV addSubview:locationButton];
            
        }
        
        if (i==5) {
            textF.placeholder = @"为避免骚扰,请谨慎填写手机号";
            leftL.frame = CGRectMake(15, h, 100, 60);
            textF.frame = CGRectMake(leftL.right+10, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height);
            textF.text = _telePhone;
            
            if (kSCREEN_WIDTH<350) {
                [textF setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
            }
        }
        
        if (i == 6) {
            textF.placeholder = @"请输入邮箱";
            textF.text = _Email;
        }
        if (i == 7) {
            textF.placeholder = @"请输入网址";
            textF.text = _Website;
        }
        
        if (i == 2) {
            
//            _queryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            _queryBtn.frame = CGRectMake(kSCREEN_WIDTH-8-30, h+7, 30, 30);
//            _queryBtn.centerY = leftL.centerY;
//            if (_isCheck == 0) {
//
//                [_queryBtn setImage:[UIImage imageNamed:@"circle_kong"] forState:UIControlStateNormal];
//            } else {
//
//                [_queryBtn setImage:[UIImage imageNamed:@"circle_shi"] forState:UIControlStateNormal];
//            }
//            [_queryBtn addTarget:self action:@selector(queryBtnClick) forControlEvents:UIControlEventTouchUpInside];
//            [self.srcV addSubview:self.queryBtn];
//            _queryL = [[UILabel alloc]initWithFrame:CGRectMake(self.queryBtn.left-60,h+10, 65, 20)];
//            _queryL.centerY = leftL.centerY;
//            _queryL.textColor = COLOR_BLACK_CLASS_3;
//            _queryL.font = [UIFont systemFontOfSize:16];
//            _queryL.text = @"114可查";
//            _queryL.textAlignment = NSTextAlignmentRight;
//            [self.srcV addSubview:self.queryL];
            textF.frame = CGRectMake(leftL.right+10, leftL.top, kSCREEN_WIDTH-leftL.right-110, leftL.height);
            textF.placeholder = @"请输入区号+号码";
            textF.keyboardType = UIKeyboardTypeNumberPad;
            textF.adjustsFontSizeToFitWidth = YES;
            self.phoneTextField = textF;
            
            self.phoneTextField.hidden = YES;
            
            
            // 修改座机 3个固定的控件  7-17 by sty
            UITextField *areaCode = [[UITextField alloc]initWithFrame:CGRectMake(leftL.right+10, leftL.top+15, 50, 30)];
            
            //                areaCode.layer.masksToBounds = YES;
            //                areaCode.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
            //                areaCode.layer.borderWidth = 1;
            //                areaCode.layer.cornerRadius = 5;
            areaCode.placeholder = @"区号";
//            if (kSCREEN_WIDTH<350) {
//                areaCode.textAlignment = NSTextAlignmentRight;
//            }else{
//                areaCode.textAlignment = NSTextAlignmentCenter;
//            }
            areaCode.textAlignment = NSTextAlignmentLeft;
            areaCode.textColor = COLOR_BLACK_CLASS_3;
            areaCode.font = NB_FONTSEIZ_BIG;
            [areaCode setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
            [areaCode setValue:NB_FONTSEIZ_BIG forKeyPath:@"_placeholderLabel.font"];
            areaCode.keyboardType = UIKeyboardTypeNumberPad;
            NSString *str = @"0377";
            CGSize textSize = [str boundingRectWithSize:CGSizeMake(50, CGFLOAT_MAX)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                context:nil].size;
            [areaCode sizeThatFits:CGSizeMake(textSize.width, 30)];
            if (_areaCodeStr&&_areaCodeStr.length>0) {
                areaCode.text = _areaCodeStr;
            }
            else{
                areaCode.text = @"";
            }
            
            areaCode.tag = 100;
            self.areaCodeField = areaCode;
            self.areaCodeField.delegate = self;
            //                [self.areaCodeField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            [self.srcV addSubview:self.areaCodeField];
            
            UILabel *midLineL = [[UILabel alloc]initWithFrame:CGRectMake(self.areaCodeField.right-7, self.areaCodeField.top, 5, self.areaCodeField.height)];
            midLineL.text = @"-";
            midLineL.textColor = COLOR_BLACK_CLASS_3;
            midLineL.font = NB_FONTSEIZ_BIG;
            //        companyJob.backgroundColor = Red_Color;
            midLineL.textAlignment = NSTextAlignmentCenter;
            self.midLineLabel = midLineL;
            [self.srcV addSubview:self.midLineLabel];
            
            //                [textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            UITextField *phoneBehind = [[UITextField alloc]initWithFrame:CGRectMake(self.midLineLabel.right+5, self.areaCodeField.top, 100, 30)];
            
            //                areaCode.layer.masksToBounds = YES;
            //                areaCode.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
            //                areaCode.layer.borderWidth = 1;
            //                areaCode.layer.cornerRadius = 5;
            phoneBehind.placeholder = @"座机号";
            phoneBehind.textAlignment = NSTextAlignmentLeft;
            phoneBehind.keyboardType = UIKeyboardTypeNumberPad;
            phoneBehind.textColor = COLOR_BLACK_CLASS_3;
            phoneBehind.font = NB_FONTSEIZ_BIG;
            [phoneBehind setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
            [phoneBehind setValue:NB_FONTSEIZ_BIG forKeyPath:@"_placeholderLabel.font"];
            phoneBehind.text = _behindPhoneStr;
            
            self.phoneBehindField = phoneBehind;
            self.phoneBehindField.tag=200;
            self.phoneBehindField.delegate = self;
            [self.srcV addSubview:self.phoneBehindField];
            
            
            
            
//            [textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        }
        
        
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, leftL.bottom-1, kSCREEN_WIDTH, 1)];
        lineV.backgroundColor = kBackgroundColor;
        h = h +60;
        [self.srcV addSubview:leftL];
//        [self.srcV addSubview:textF];
        if (i != 4 && i != 0) {
            [self.srcV addSubview:textF];
        }
        [self.srcV addSubview:lineV];
        
        if (i == 1) {
            _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];

            _typeBtn.frame = textF.frame;
            _typeBtn.height = 60;
            _typeBtn.centerY = leftL.centerY;
            _typeBtn.width = textF.width - 35;
            
            if ([self.model.companyType integerValue] == 1018) {
                [_typeBtn setTitle:@"装修公司" forState:UIControlStateNormal];
            }else if ([self.model.companyType integerValue] == 1064) {
                [_typeBtn setTitle:@"整装公司" forState:UIControlStateNormal];
            }else if ([self.model.companyType integerValue] == 1065) {
                [_typeBtn setTitle:@"新型装修" forState:UIControlStateNormal];
            }else{
                [_typeBtn setTitle:_category.typeName forState:UIControlStateNormal];
            }

            _typeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_typeBtn setTitleColor:Black_Color forState:UIControlStateNormal];
            _typeBtn.titleLabel.font = [UIFont systemFontOfSize:16];;
            [_typeBtn addTarget:self action:@selector(typeBtnClick) forControlEvents:UIControlEventTouchUpInside];
            _typeBtn.backgroundColor = [UIColor clearColor];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = textF.frame;
            btn.size = CGSizeMake(30, 30);
            btn.right = self.view.right - 5;
            btn.height = 39;
            btn.centerY = leftL.centerY;
            [btn setImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];
            
            [btn addTarget:self action:@selector(typeBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.srcV addSubview:self.typeBtn];
            [self.srcV addSubview:btn];
            textF.hidden = YES;
        }
        
        if (i == 3) {
            _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _addressBtn.frame = textF.frame;
            _addressBtn.height = 39;
            _addressBtn.centerY = leftL.centerY;
            _addressBtn.width = textF.width - 35;
//            [_addressBtn setTitle:@"请选择地址" forState:UIControlStateNormal];
            [_addressBtn setTitle:self.addressStr forState:UIControlStateNormal];
            _addressBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_addressBtn setTitleColor:Black_Color forState:UIControlStateNormal];
            _addressBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [_addressBtn addTarget:self action:@selector(addressBtnClick) forControlEvents:UIControlEventTouchUpInside];
            _addressBtn.backgroundColor = [UIColor clearColor];
            [self.srcV addSubview:self.addressBtn];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = textF.frame;
            btn.size = CGSizeMake(30, 30);
            btn.right = self.view.right - 5;
            btn.height = 39;
            btn.centerY = leftL.centerY;
            [btn addTarget:self action:@selector(addressBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];
            [self.srcV addSubview:btn];
            
            textF.hidden = YES;
        }

    }
    
    UILabel *temL = [[UILabel alloc]initWithFrame:CGRectMake(15, h, 75, 60)];
    temL.textColor = COLOR_BLACK_CLASS_3;
    temL.font = [UIFont systemFontOfSize
                 :16];
    temL.text = @"简   \ \ \ \ 介";
    temL.textAlignment = NSTextAlignmentLeft;
    [self.srcV addSubview:temL];
    
    self.textV = [[UITextView alloc]initWithFrame:CGRectMake(10, temL.bottom, kSCREEN_WIDTH-20, 80)];
    self.textV.layer.cornerRadius = 5;
    self.textV.layer.borderColor = kBackgroundColor.CGColor;
    self.textV.layer.borderWidth = 1;
    self.textV.backgroundColor = White_Color;
    self.textV.delegate = self;
    [self.srcV addSubview:self.textV];
    self.textV.text = _introduce;
    self.textV.font = [UIFont systemFontOfSize:16];
    self.textV.tag = 1111;
    
    
    self.placeHoldL = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 20)];
    self.placeHoldL.textColor = [UIColor lightGrayColor];
    self.placeHoldL.font = [UIFont systemFontOfSize:16];
    self.placeHoldL.text = @"填写品牌或店铺信息";
    self.placeHoldL.textAlignment = NSTextAlignmentLeft;
//    self.placeHoldL.hidden = YES;
    if (self.textV.text.length > 0) {
        self.placeHoldL.hidden = YES;
    }else{
        self.placeHoldL.hidden = NO;
    }

    [self.textV addSubview:self.placeHoldL];
    
    
    
    _successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _successBtn.frame = CGRectMake(10,self.textV.bottom+10,kSCREEN_WIDTH - 20,44);
    _successBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_successBtn setTitleColor:White_Color forState:UIControlStateNormal];
    _successBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_successBtn setTitle:@"完    成" forState:UIControlStateNormal];
    _successBtn.layer.cornerRadius = 5;
    _successBtn.layer.masksToBounds = YES;
    [_successBtn addTarget:self action:@selector(successTouch) forControlEvents:UIControlEventTouchUpInside];
    _successBtn.backgroundColor = Main_Color;
    [self.srcV addSubview:self.successBtn];
    
    self.srcV.contentSize = CGSizeMake(kSCREEN_WIDTH, self.successBtn.bottom+20);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCategory:) name:@"categoryNoti" object:nil];
    
    [self.view addSubview:self.regionView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetArea:) name:@"DecorationAreaNot" object:nil];
}

#pragma  mark -  编辑公司
- (void)createUIWithEditCompany {
    
    [self.srcV removeAllSubViews];
    [self.srcV removeFromSuperview];
    [self.view addSubview:self.srcV];
    [self.srcV addSubview:self.logoL];
    [self.srcV addSubview:self.logoImg];
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.logoImg.bottom + 10, BLEJWidth, 1)];
    topLine.backgroundColor = kBackgroundColor;
    [self.srcV addSubview:topLine];
    
    int h = self.logoImg.bottom + 10;
    for (int i = 0; i < 9; i ++) {
        
        
        NSArray *leftArray = @[@"品牌名称",@"类   \ \ \ \ 别", @"装修区域", @"座   \ \ \ \ 机",@"地   \ \ \ \ 址",@"详细地址",@"业务经理电话", temEmailStr,@"网   \ \ \ \ 址"];
        UILabel *leftL = [[UILabel alloc]initWithFrame:CGRectMake(15, h, 70, 60)];
        leftL.text = leftArray[i];
        leftL.textColor = COLOR_BLACK_CLASS_3;
        leftL.font = [UIFont systemFontOfSize:16];
        leftL.textAlignment = NSTextAlignmentLeft;
        
        UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(leftL.right+10, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height)];
        textF.textColor = COLOR_BLACK_CLASS_3;
        textF.font = [UIFont systemFontOfSize:16];
        [textF setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
        [textF setValue:NB_FONTSEIZ_NOR forKeyPath:@"_placeholderLabel.font"];
        
        [textF addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
        [textF addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventAllEvents];
        textF.tag = i;
        textF.delegate = self;
        if (i != 2) {
            
            textF.text = [self.allData objectForKey:[NSString stringWithFormat:@"%d", i]];
//            textF.text = self.dataArr[i];
        }
        
        if (i == 0) {
            textF.placeholder = @"请输入品牌名称";
            
            [textF removeFromSuperview];
            PlaceHolderTextView *companyNameTextView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(leftL.right + 5.5, leftL.top + 12, kSCREEN_WIDTH-leftL.right-20, leftL.height - 12)];
            companyNameTextView.placeHolder = @"请输入品牌名称";
            companyNameTextView.placeHolderColor = [UIColor lightGrayColor];
//            companyNameTextView.placeHolderFont = [UIFont systemFontOfSize:16];
            
            companyNameTextView.font = [UIFont systemFontOfSize:16];
            companyNameTextView.textColor = COLOR_BLACK_CLASS_3;
            companyNameTextView.tag = i;
            companyNameTextView.delegate = self;
            companyNameTextView.text = [self.allData objectForKey:[NSString stringWithFormat:@"%d", i]];
            [self.srcV addSubview:companyNameTextView];

        }
        
        if (i == 5) {
            textF.placeholder = @"请输入详细地址";
        }
        if (i == 5) {
            [textF removeFromSuperview];
            PlaceHolderTextView *addressTextView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(leftL.right + 5.5, leftL.top + 12, kSCREEN_WIDTH-leftL.right-40, leftL.height - 12)];
            self.detailAddressTV = addressTextView;
            addressTextView.placeHolder = @"请输入详细地址";
            addressTextView.placeHolderColor = [UIColor lightGrayColor];
//            addressTextView.placeHolderFont = [UIFont systemFontOfSize:16];
            
            addressTextView.font = [UIFont systemFontOfSize:16];
            addressTextView.textColor = COLOR_BLACK_CLASS_3;
            addressTextView.tag = i;
            addressTextView.delegate = self;
            addressTextView.text = [self.allData objectForKey:[NSString stringWithFormat:@"%d", i]];
            [self.srcV addSubview:addressTextView];
            
            UIButton *locationButton = [[UIButton alloc]initWithFrame:CGRectMake(addressTextView.right - 5, 0,  30, 30)];
            locationButton.centerY = leftL.centerY;
            locationButton.contentMode = UIViewContentModeScaleAspectFit;
            [locationButton  addTarget:self action:@selector(localionButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [locationButton  setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
            [self.srcV addSubview:locationButton];
            
        }
        
        if (i==6) {
            textF.placeholder = @"为避免骚扰,请谨慎填写手机号";
            leftL.frame = CGRectMake(15, h, 100, 60);
            textF.frame = CGRectMake(leftL.right+10, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height);
            textF.text = _telePhone;
            
            if (kSCREEN_WIDTH<350) {
                [textF setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
            }
        }
        
        if (i == 7) {
            textF.placeholder = @"请输入邮箱";
            textF.text =_Email;
        }
        if (i == 8) {
            textF.placeholder = @"请输入网址";
            textF.text = _Website;
        }
        
        if (i == 3) {
            
//            _queryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            _queryBtn.frame = CGRectMake(kSCREEN_WIDTH-8-30, h+7, 30, 30);
//            _queryBtn.centerY = leftL.centerY;
//            if (_isCheck == 0) {
//
//                [_queryBtn setImage:[UIImage imageNamed:@"circle_kong"] forState:UIControlStateNormal];
//            } else {
//
//                [_queryBtn setImage:[UIImage imageNamed:@"circle_shi"] forState:UIControlStateNormal];
//            }
//
//            [_queryBtn addTarget:self action:@selector(queryBtnClick) forControlEvents:UIControlEventTouchUpInside];
//            [self.srcV addSubview:self.queryBtn];
//            _queryL = [[UILabel alloc]initWithFrame:CGRectMake(self.queryBtn.left-60,h+10, 65, 20)];
//            _queryL.centerY = leftL.centerY;
//            _queryL.textColor = COLOR_BLACK_CLASS_3;
//            _queryL.font = [UIFont systemFontOfSize:16];
//            _queryL.text = @"114可查";
//            _queryL.textAlignment = NSTextAlignmentRight;
//            [self.srcV addSubview:self.queryL];
            
            
            textF.frame = CGRectMake(leftL.right+10, leftL.top, kSCREEN_WIDTH-leftL.right-110, leftL.height);
            textF.placeholder = @"请输入区号+号码";
            textF.keyboardType = UIKeyboardTypeNumberPad;
            textF.adjustsFontSizeToFitWidth = YES;
            self.phoneTextField = textF;
            
            self.phoneTextField.hidden = YES;
            
            
            // 修改座机 3个固定的控件  7-17 by sty
            UITextField *areaCode = [[UITextField alloc]initWithFrame:CGRectMake(leftL.right+10, leftL.top+15, 50, 30)];
            
            //                areaCode.layer.masksToBounds = YES;
            //                areaCode.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
            //                areaCode.layer.borderWidth = 1;
            //                areaCode.layer.cornerRadius = 5;
            areaCode.placeholder = @"区号";
//            if (kSCREEN_WIDTH<350) {
//                areaCode.textAlignment = NSTextAlignmentRight;
//            }else{
//                areaCode.textAlignment = NSTextAlignmentCenter;
//            }
            areaCode.textAlignment = NSTextAlignmentLeft;
            areaCode.textColor = COLOR_BLACK_CLASS_3;
            areaCode.font = NB_FONTSEIZ_BIG;
            [areaCode setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
            [areaCode setValue:NB_FONTSEIZ_BIG forKeyPath:@"_placeholderLabel.font"];
            areaCode.keyboardType = UIKeyboardTypeNumberPad;
            NSString *str = @"0377";
            CGSize textSize = [str boundingRectWithSize:CGSizeMake(50, CGFLOAT_MAX)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                context:nil].size;
            [areaCode sizeThatFits:CGSizeMake(textSize.width, 30)];
            if (_areaCodeStr&&_areaCodeStr.length>0) {
                areaCode.text = _areaCodeStr;
            }
            else{
                areaCode.text = @"";
            }
            
            areaCode.tag = 100;
            self.areaCodeField = areaCode;
            self.areaCodeField.delegate = self;
            //                [self.areaCodeField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            [self.srcV addSubview:self.areaCodeField];
            
            UILabel *midLineL = [[UILabel alloc]initWithFrame:CGRectMake(self.areaCodeField.right-7, self.areaCodeField.top, 5, self.areaCodeField.height)];
            midLineL.text = @"-";
            midLineL.textColor = COLOR_BLACK_CLASS_3;
            midLineL.font = NB_FONTSEIZ_BIG;
            //        companyJob.backgroundColor = Red_Color;
            midLineL.textAlignment = NSTextAlignmentCenter;
            self.midLineLabel = midLineL;
            [self.srcV addSubview:self.midLineLabel];
            
            //                [textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            UITextField *phoneBehind = [[UITextField alloc]initWithFrame:CGRectMake(self.midLineLabel.right+5, self.areaCodeField.top, 100, 30)];
            
            //                areaCode.layer.masksToBounds = YES;
            //                areaCode.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
            //                areaCode.layer.borderWidth = 1;
            //                areaCode.layer.cornerRadius = 5;
            phoneBehind.placeholder = @"座机号";
            phoneBehind.textAlignment = NSTextAlignmentLeft;
            phoneBehind.keyboardType = UIKeyboardTypeNumberPad;
            phoneBehind.textColor = COLOR_BLACK_CLASS_3;
            phoneBehind.font = NB_FONTSEIZ_BIG;
            [phoneBehind setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
            [phoneBehind setValue:NB_FONTSEIZ_BIG forKeyPath:@"_placeholderLabel.font"];
            phoneBehind.text = _behindPhoneStr;
            
            self.phoneBehindField = phoneBehind;
            self.phoneBehindField.tag=200;
            self.phoneBehindField.delegate = self;
            [self.srcV addSubview:self.phoneBehindField];
            
//            [textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        }
        
        
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, leftL.bottom-1, kSCREEN_WIDTH, 1)];
        lineV.backgroundColor = kBackgroundColor;
        h = h + 60;
        [self.srcV addSubview:leftL];
        if (i != 5 && i != 0) {
            [self.srcV addSubview:textF];
        }
//        [self.srcV addSubview:textF];
        [self.srcV addSubview:lineV];
        
        if (i == 1) {
            _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];

            _typeBtn.frame = textF.frame;
//            _typeBtn.height = 39;
            _typeBtn.width = textF.width - 35;
            if ([self.model.companyType integerValue] == 1018) {
                [_typeBtn setTitle:@"装修公司" forState:UIControlStateNormal];
            }else if ([self.model.companyType integerValue] == 1064) {
                [_typeBtn setTitle:@"整装公司" forState:UIControlStateNormal];
            }else if ([self.model.companyType integerValue] == 1065) {
                [_typeBtn setTitle:@"新型装修" forState:UIControlStateNormal];
            }else{
                [_typeBtn setTitle:_category.typeName forState:UIControlStateNormal];
            }

            _typeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_typeBtn setTitleColor:Black_Color forState:UIControlStateNormal];
            _typeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [_typeBtn addTarget:self action:@selector(typeBtnClick) forControlEvents:UIControlEventTouchUpInside];
            _typeBtn.backgroundColor = [UIColor clearColor];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = textF.frame;
            btn.size = CGSizeMake(30, 30);
            btn.right = self.view.right - 5;
            btn.height = 39;
            btn.centerY = leftL.centerY;
            [btn setImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];

            if ([self.model.companyType integerValue] == 1018 || [self.model.companyType integerValue] == 1065 || [self.model.companyType integerValue] == 1064 || [self.model.companyType integerValue] == 1068) {
                btn.hidden = true;
            }
            [self.srcV addSubview:self.typeBtn];
            [self.srcV addSubview:btn];
            textF.hidden = YES;
        }
        
        if (i == 4) {
            _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _addressBtn.frame = textF.frame;
            _addressBtn.height = 60;
            _addressBtn.centerY = leftL.centerY;
            _addressBtn.width = textF.width - 35;
            [_addressBtn setTitle:self.addressStr forState:UIControlStateNormal];
            _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_addressBtn setTitleColor:Black_Color forState:UIControlStateNormal];
            _addressBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            _addressBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            [_addressBtn addTarget:self action:@selector(addressBtnClick) forControlEvents:UIControlEventTouchUpInside];
            _addressBtn.backgroundColor = [UIColor clearColor];
            [self.srcV addSubview:self.addressBtn];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = textF.frame;
            btn.size = CGSizeMake(30, 30);
            btn.right = self.view.right - 5;
            btn.height = 39;
            btn.centerY = leftL.centerY;
            [btn addTarget:self action:@selector(addressBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];
            [self.srcV addSubview:btn];
            
            textF.hidden = YES;
        }
        
        if (i == 2) {
            _decorationbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _decorationbBtn.frame = textF.frame;
            _decorationbBtn.height = 60;
            _decorationbBtn.centerY = leftL.centerY;
            _decorationbBtn.width = textF.width - 35;
            _decorationbBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_decorationbBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
            _decorationbBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [_decorationbBtn addTarget:self action:@selector(decorationbBtnClick) forControlEvents:UIControlEventTouchUpInside];
            _decorationbBtn.backgroundColor = [UIColor clearColor];
            [self.srcV addSubview:self.decorationbBtn];
            NSMutableArray *arrM = [NSMutableArray array];
            for (AreaListModel *model in self.decorationArray) {
                NSArray *arr = [model.retion componentsSeparatedByString:@" "];
                [arrM addObject:arr.lastObject];
            }
            self.decorationStr = [NSMutableString stringWithString:[arrM componentsJoinedByString:@" "]];
            [self.decorationbBtn setTitle:self.decorationStr forState:UIControlStateNormal];
            self.decorationbBtn.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = textF.frame;
            btn.size = CGSizeMake(30, 30);
            btn.right = self.view.right - 5;
            btn.height = 39;
            btn.centerY = leftL.centerY;
            [btn addTarget:self action:@selector(decorationbBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];
            [self.srcV addSubview:btn];
            
            textF.hidden = YES;
        }
    }
    
    UILabel *temL = [[UILabel alloc]initWithFrame:CGRectMake(15, h, 75, 60)];
    temL.textColor = COLOR_BLACK_CLASS_3;
    temL.font = [UIFont systemFontOfSize:16];
    temL.text = @"简   \ \ \ \ 介";
    temL.textAlignment = NSTextAlignmentLeft;
    [self.srcV addSubview:temL];
    
    self.textV = [[UITextView alloc]initWithFrame:CGRectMake(10, temL.bottom, kSCREEN_WIDTH-20, 80)];
    self.textV.layer.cornerRadius = 5;
    self.textV.layer.borderColor = kBackgroundColor.CGColor;
    self.textV.layer.borderWidth = 1;
    self.textV.backgroundColor = White_Color;
    self.textV.delegate = self;
    [self.srcV addSubview:self.textV];
    self.textV.text = _introduce;
    self.textV.font = [UIFont systemFontOfSize:16];
    self.textV.tag = 1111;
    
    
    self.placeHoldL = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 20)];
    self.placeHoldL.textColor = [UIColor lightGrayColor];
    self.placeHoldL.font = [UIFont systemFontOfSize:16];
    self.placeHoldL.text = @"填写品牌或店铺信息";
    self.placeHoldL.textAlignment = NSTextAlignmentLeft;
//    self.placeHoldL.hidden = YES;
    [self.textV addSubview:self.placeHoldL];
    
    if (self.textV.text.length > 0) {
        self.placeHoldL.hidden = YES;
    }else{
        self.placeHoldL.hidden = NO;
    }
    
    
    _successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _successBtn.frame = CGRectMake(10,self.textV.bottom+10,kSCREEN_WIDTH - 20,44);
    _successBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_successBtn setTitleColor:White_Color forState:UIControlStateNormal];
    _successBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_successBtn setTitle:@"完    成" forState:UIControlStateNormal];
    _successBtn.layer.cornerRadius = 5;
    _successBtn.layer.masksToBounds = YES;
    [_successBtn addTarget:self action:@selector(successTouch) forControlEvents:UIControlEventTouchUpInside];
    _successBtn.backgroundColor = Main_Color;
    [self.srcV addSubview:self.successBtn];
    
    self.srcV.contentSize = CGSizeMake(kSCREEN_WIDTH, self.successBtn.bottom+20);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCategory:) name:@"categoryNoti" object:nil];
    
    [self.view addSubview:self.regionView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetArea:) name:@"DecorationAreaNot" object:nil];
}

#pragma mark - 定位获取地址

- (void)localionButtonAction {
    
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        
        //定位功能可用
        LocationViewController *locationVC = [[LocationViewController alloc] init];
        NSString *addressDetailStr = self.addressDetailStr.length > 0 ? self.addressDetailStr: @"";
        NSString *addressStr = self.addressStr.length > 0 ? self.addressStr: @"";
        locationVC.address = [NSString stringWithFormat:@"%@%@", addressStr, addressDetailStr];
        locationVC.longitude = self.longitude;
        locationVC.latitude  = self.lantitude;
        MJWeakSelf;
        locationVC.locationBlock = ^(NSString *addressName, double lantitude, double longitude){
            weakSelf.addressDetailStr = addressName;
            weakSelf.longitude = longitude;
            weakSelf.lantitude = lantitude;
            weakSelf.detailAddressTV.text = addressName;
        };
        [self.navigationController pushViewController:locationVC animated:YES];
        
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        
        //定位不能用
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"位置不可用"
                                                        message:@"请到 手机设置->爱装修->位置 进行设置"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        alert.tag = 999;
        [alert show];
        
    }
    

    
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (_type == 1018 || _type == 1064 || _type == 1065) {
        
        [self.allData setObject:textField.text forKey:[NSString stringWithFormat:@"%ld", textField.tag]];
        if (textField.tag == 0) {
            _companyName = textField.text;
//            UIScrollView *scrollView = (UIScrollView *)[self.srcV viewWithTag:20000];
//            scrollView.contentOffset = CGPointMake(0, 0);
        }
        if (textField.tag == 3) {
//            _linePhone = textField.text;
        }
        if (textField.tag == 100) {
            _areaCodeStr = textField.text;
        }
        
        if (textField.tag == 200) {
            _behindPhoneStr = textField.text;
        }
        
        if (textField.tag == 4) {
            //        _address = textField.text;
            UIScrollView *scrollView = (UIScrollView *)[self.srcV viewWithTag:10000];
            scrollView.contentOffset = CGPointMake(0, 0);
        }
        if (textField.tag == 5) {
            self.addressDetailStr = textField.text;
            UIScrollView *scrollView = (UIScrollView *)[self.srcV viewWithTag:10000];
            scrollView.contentOffset = CGPointMake(0, 0);
        }
        if (textField.tag == 6) {
            //            _telePhone = textField.text;
            _telePhone = textField.text;
        }
        
        if (textField.tag == 7) {
//            _telePhone = textField.text;
            _Email = textField.text;
        }
        if (textField.tag == 8) {
//            _weChat = textField.text;
            _Website = textField.text;
        }
    } else {
        
        if (textField.tag < 2) {
            
            [self.allData setObject:textField.text forKey:[NSString stringWithFormat:@"%ld", textField.tag]];
        } else {
            
            [self.allData setObject:textField.text forKey:[NSString stringWithFormat:@"%ld", textField.tag + 1]];
        }
        
        if (textField.tag == 0) {
            _companyName = textField.text;
//            UIScrollView *scrollView = (UIScrollView *)[self.srcV viewWithTag:20000];
//            scrollView.contentOffset = CGPointMake(0, 0);
        }
        if (textField.tag == 2) {
//            _linePhone = textField.text;
        }
        
        
        if (textField.tag == 100) {
            _areaCodeStr = textField.text;
        }
        
        if (textField.tag == 200) {
            _behindPhoneStr = textField.text;
        }
        
        if (textField.tag == 3) {
            //        _address = textField.text;
        }
        if (textField.tag == 4) {
            self.addressDetailStr = textField.text;
            UIScrollView *scrollView = (UIScrollView *)[self.srcV viewWithTag:10000];
            scrollView.contentOffset = CGPointMake(0, 0);
        }
        
        if (textField.tag == 5) {
            _telePhone = textField.text;
        }
        
        if (textField.tag == 6) {
            _Email = textField.text;
        }
        if (textField.tag == 7) {
//            _weChat = textField.text;
            _Website = textField.text;
        }
    }
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.regionView.hidden = YES;
    if (_type == 1018 || _type == 1064 || _type == 1065) {
//        if (textField.tag == 0) {
//            // 公司名称textfield下的滚动视图
//            UIScrollView *nameScrollView = (UIScrollView *)[self.srcV viewWithTag:20000];
//            CGSize size2 = [textField.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 60) withFont:[UIFont systemFontOfSize:16]];
//            CGFloat width2 = nameScrollView.size.width;
//            if (size2.width > width2) {
//                nameScrollView.contentOffset = CGPointMake((size2.width - width2), 0);
//                CGRect frame = textField.frame;
//                frame.size.width = size2.width;
//                textField.frame = frame;
//                nameScrollView.contentSize = textField.frame.size;
//            } else {
//                nameScrollView.contentOffset = CGPointMake(0, 0);
//            }
//        }
//        if (textField.tag == 5) {
//            UIScrollView *scrollView = (UIScrollView *)[self.srcV viewWithTag:10000];
//            CGSize size = [textField.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 60) withFont:[UIFont systemFontOfSize:16]];
//            CGFloat width = scrollView.size.width;
//            if (size.width > width) {
//                scrollView.contentOffset = CGPointMake(size.width - width, 0);
//                textField.frame = CGRectMake(0, 0, size.width, 60);
//                scrollView.contentSize = textField.frame.size;
//            } else {
//                scrollView.contentOffset = CGPointMake(0, 0);
//            }
//        }
    } else {
//        if (textField.tag == 0) {
//            // 公司名称textfield下的滚动视图
//            UIScrollView *nameScrollView = (UIScrollView *)[self.srcV viewWithTag:20000];
//            CGSize size2 = [textField.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 60) withFont:[UIFont systemFontOfSize:16]];
//            CGFloat width2 = nameScrollView.size.width;
//            if (size2.width > width2) {
//                nameScrollView.contentOffset = CGPointMake((size2.width - width2), 0);
//                CGRect frame = textField.frame;
//                frame.size.width = size2.width;
//                textField.frame = frame;
//                nameScrollView.contentSize = textField.frame.size;
//            } else {
//                nameScrollView.contentOffset = CGPointMake(0, 0);
//            }
//        }
//        if (textField.tag == 4) {
//            UIScrollView *scrollView = (UIScrollView *)[self.srcV viewWithTag:10000];
//            CGSize size = [textField.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 60) withFont:[UIFont systemFontOfSize:16]];
//            CGFloat width = scrollView.size.width;
//            if (size.width > width) {
//                scrollView.contentOffset = CGPointMake(size.width - width, 0);
//                textField.frame = CGRectMake(0, 0, size.width, 60);
//                scrollView.contentSize = textField.frame.size;
//            } else {
//                scrollView.contentOffset = CGPointMake(0, 0);
//            }
//        }
    }
    
   
    
}



// 给电话号textfield添加 ”-“
- (void)textFieldDidChange:(UITextField *)textField {
//    if (textField == self.phoneTextField) {
//        if (textField.text.length > textFieldFlag && [textField.text isAreaCode]) {
//             // 区号完成后 自动添加 - 
//            NSMutableString * str = [[NSMutableString alloc ] initWithString:textField.text];
//            [str insertString:@"-" atIndex:(textField.text.length)];
//            textField.text = str;
//            
//            textFieldFlag = textField.text.length;
//        }else if (textField.text.length < textFieldFlag){//删除
//            textFieldFlag = textField.text.length;
//        } else if(textField.text.length > textFieldFlag) { // 在区号后加数字自动添加 -
//            NSString *mulStr = textField.text;
//            NSRange range = {mulStr.length - 1, 1};
//            
//            NSString *strr = [mulStr stringByReplacingCharactersInRange:range withString:@""];
//            if (![mulStr containsString:@"-"] && [strr isAreaCode]) {
//                NSMutableString *mulStr2 = [NSMutableString stringWithString:mulStr];
//                [mulStr2 insertString:@"-" atIndex:(textField.text.length - 1)];
//                textField.text = mulStr2;
//            }
//             textFieldFlag = textField.text.length;
//        }
//    }
    
    
    if (textField.tag == 100) {
        _areaCodeStr = textField.text;
    }
    
    if (textField.tag == 200) {
        _behindPhoneStr = textField.text;
    }
    
}

//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
//    if (action == @selector(paste:)) {
//        return NO;
//    }
//    return YES;
//}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 100) {
        //区号
        if (range.location>3) {
            return NO;
        }
        else{
            return [self validateNumber:string];
        }


    }
//
    if (textField.tag == 200) {
        //区号后面的号码
        _behindPhoneStr = textField.text;
        _behindPhoneStr = [_behindPhoneStr ew_removeSpaces];
        _behindPhoneStr = [_behindPhoneStr ew_removeSpacesAndLineBreaks];
        if (_behindPhoneStr.length>8) {
            return YES;
        }
        else{
            if (range.location>7) {
                
                return NO;
            }
            else{
                return [self validateNumber:string];
            }
        }
        

    }
    
    return YES;
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

//- (void)textFieldEditChanged:(UITextField *)textField
//{
//    // 详细地址下的滚动视图
//    UIScrollView *scrollView = (UIScrollView *)[self.srcV viewWithTag:10000];
//    CGSize size = [textField.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 60) withFont:[UIFont systemFontOfSize:16]];
//    CGFloat width = scrollView.size.width;
//    if (size.width > width) {
//        scrollView.contentOffset = CGPointMake((size.width - width), 0);
//        CGRect frame = textField.frame;
//        frame.size.width = size.width;
//        textField.frame = frame;
////        textField.frame = CGRectMake(2, 0, size.width, 60);
//        scrollView.contentSize = textField.frame.size;
//    } else {
//        scrollView.contentOffset = CGPointMake(0, 0);
//    }
//
//    
//}

//- (void)companyNameTextFieldEditChanged:(UITextField *)textField {
//    // 公司名称textfield下的滚动视图
//    UIScrollView *nameScrollView = (UIScrollView *)[self.srcV viewWithTag:20000];
//    CGSize size2 = [textField.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 60) withFont:[UIFont systemFontOfSize:16]];
//    CGFloat width2 = nameScrollView.size.width;
//    if (size2.width > width2) {
//        nameScrollView.contentOffset = CGPointMake((size2.width - width2), 0);
//        CGRect frame = textField.frame;
//        frame.size.width = size2.width;
//        textField.frame = frame;
//        nameScrollView.contentSize = textField.frame.size;
//    } else {
//        nameScrollView.contentOffset = CGPointMake(0, 0);
//    }
//}

-(void)back{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出编辑"
                                                    message:@"是否确定退出编辑？"
                                                   delegate:self
                                          cancelButtonTitle:@"否"
                                          otherButtonTitles:@"是",nil];
    alert.tag = 2000;
    [alert show];
}

#pragma mark - 跳转分类界面
- (void)typeBtnClick {
#warning !!!!!
    [self.view endEditing:YES];
    if ([self.model.companyType integerValue] == 1018 || [self.model.companyType integerValue] == 1065 || [self.model.companyType integerValue] == 1064) {//@"装修公司", @"整装公司", @"新型装修",@"建材店铺" 前三个不能选择
        return;
    }
    self.regionView.hidden = YES;
    ShopClassificationDetailViewController *vc = [[ShopClassificationDetailViewController alloc] initWithNibName:@"HomeClassificationDetailViewController" bundle:nil];
    [vc.view setBackgroundColor:[UIColor whiteColor]];
    WorkTypeModel *m = [WorkTypeModel new];
    m.name = _category.typeName?:_typeBtn.titleLabel.text;
    m.jobId = @(_type).stringValue;
    [vc getModelWithTitle:m];
    vc.blockDidTouchItem = ^(WorkTypeModel *model) {
        _category.typeName = model.name;
        _type = model.jobId.integerValue;
        [_typeBtn setTitle:model.name forState:(UIControlStateNormal)];
        [_typeBtn setTitleColor:Black_Color forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:vc animated:YES];
//    CategoryViewController *vc = [[CategoryViewController alloc]init];
//    if (self.model) {
//        vc.isNewBuild = NO;
//    } else {
//        vc.isNewBuild = YES;
//    }
//
////    BOOL isShop = NO;
////    if ((!self.model)&&(self.creatType==2)) {
////        //创建的是店铺
////        isShop = YES;
////    }
//    vc.dic = @{@"type" : [NSString stringWithFormat:@"%ld", (long)_type]};
}

//- (void)queryBtnClick {
//
//    if (_isCheck == 1) {
//        [_queryBtn setImage:[UIImage imageNamed:@"circle_kong"] forState:UIControlStateNormal];
//        _isCheck = 0;
//    } else {
//        [_queryBtn setImage:[UIImage imageNamed:@"circle_shi"] forState:UIControlStateNormal];
//        _isCheck = 1;
//    }
//}



#pragma mark - 装修区域

- (void)resetArea:(NSNotification *)note {
    
    [self.decorationArray removeAllObjects];
    self.decorationStr = [NSMutableString stringWithString:@""];
    NSDictionary *dict = note.userInfo;
    
    NSMutableArray *arr = [dict objectForKey:@"info"];
    NSInteger indexInt = [[dict objectForKey:@"index"] integerValue];
    for (NSDictionary *dict in arr) {
        
        AreaListModel *model = [[AreaListModel alloc] init];
        model.province = [dict[@"pid"] integerValue];
        model.city = [dict[@"cid"] integerValue];
        if (indexInt==1) {
            model.county = [dict[@"did"] integerValue];
        }
        else{
            model.county = [dict[@"county"] integerValue];
        }
        
        model.retion = dict[@"address"];
        
        [self.decorationArray addObject:model];
    }
    
//    [self.decorationArray addObjectsFromArray:arr];
    //    NSMutableString *str = [NSMutableString string];
    if (!self.decorationStr||self.decorationStr.length<=0) {
        self.decorationStr = [NSMutableString string];
    }
    for (NSDictionary *temDict in arr) {
        NSString *temStr = [temDict objectForKey:@"address"];
        self.decorationStr = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@ %@",self.decorationStr,[temStr componentsSeparatedByString:@" "].lastObject]];
    }
    
    if (!self.decorationStr||self.decorationStr.length<=0) {
        [self.decorationbBtn setTitle:@"请选择装修区域" forState:UIControlStateNormal];
        [_decorationbBtn setTitleColor:COLOR_BLACK_CLASS_9 forState:UIControlStateNormal];
    }
    else{
        [self.decorationbBtn setTitle:self.decorationStr forState:UIControlStateNormal];
        [self.decorationbBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
    }
    
//    [self.decorationbBtn setTitle:self.decorationStr forState:UIControlStateNormal];
}

- (void)addressBtnClick {
    
    [self.view endEditing:YES];
    [self getRegion];
}

#pragma mark - 选择完分类之后的回调
- (void)getCategory:(NSNotification*)sender {
    _category = [CategoryModel yy_modelWithJSON:sender.userInfo];
    _type = [_category.typeNo integerValue];
    [_typeBtn setTitle:_category.typeName forState:UIControlStateNormal];
    [_typeBtn setTitleColor:Black_Color forState:UIControlStateNormal];
    [self reloadTheView];
}

#pragma mark - 选择完分类之后进行页面的重新刷新(是否显示装修区域)
- (void)reloadTheView {
    
    [self.srcV removeAllSubViews];
    [self.srcV removeFromSuperview];
    [self.view addSubview:self.srcV];
    [self.srcV addSubview:self.logoL];
    [self.srcV addSubview:self.logoImg];
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.logoImg.bottom + 10, BLEJWidth, 1)];
    topLine.backgroundColor = kBackgroundColor;
    [self.srcV addSubview:topLine];
    
    int h = self.logoImg.bottom + 10;
    if (_type == 1018 || _type == 1064 || _type == 1065) {
        
        for (int i = 0; i < 9; i ++) {
            NSArray *leftArray = @[@"品牌名称",@"类   \ \ \ \ 别", @"装修区域", @"座   \ \ \ \ 机",@"地   \ \ \ \ 址",@"详细地址",@"业务经理电话", temEmailStr,@"网   \ \ \ \ 址"];
            UILabel *leftL = [[UILabel alloc]initWithFrame:CGRectMake(15, h, 70, 60)];
            leftL.text = leftArray[i];
            leftL.textColor = COLOR_BLACK_CLASS_3;
            leftL.font = [UIFont systemFontOfSize:16];
            leftL.textAlignment = NSTextAlignmentLeft;
            
            UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(leftL.right+10, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height)];
            textF.textColor = COLOR_BLACK_CLASS_3;
            textF.font = [UIFont systemFontOfSize:16];
            [textF setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
            [textF setValue:NB_FONTSEIZ_NOR forKeyPath:@"_placeholderLabel.font"];
            
            [textF addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
            [textF addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventAllEvents];
            textF.tag = i;
            textF.delegate = self;
            if (i == 0) {
                textF.placeholder = @"请输入品牌名称";
                
                [textF removeFromSuperview];
                PlaceHolderTextView *companyNameTextView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(leftL.right + 5.5, leftL.top + 12, kSCREEN_WIDTH-leftL.right-20, leftL.height - 12)];
                companyNameTextView.placeHolder = @"请输入品牌名称";
                companyNameTextView.placeHolderColor = [UIColor lightGrayColor];
//                companyNameTextView.placeHolderFont = [UIFont systemFontOfSize:16];
                
                companyNameTextView.font = [UIFont systemFontOfSize:16];
                companyNameTextView.textColor = COLOR_BLACK_CLASS_3;
                companyNameTextView.tag = i;
                companyNameTextView.delegate = self;
                companyNameTextView.text = [self.allData objectForKey:[NSString stringWithFormat:@"%d", i]];
                [self.srcV addSubview:companyNameTextView];

            }
            
            if (i == 5) {
                textF.placeholder = @"请输入详细地址";
            }
            if (i == 5) {
                [textF removeFromSuperview];
                PlaceHolderTextView *addressTextView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(leftL.right + 5.5, leftL.top + 12, kSCREEN_WIDTH-leftL.right-40, leftL.height - 12)];
                self.detailAddressTV = addressTextView;
                addressTextView.placeHolder = @"请输入详细地址";
                addressTextView.placeHolderColor = [UIColor lightGrayColor];
//                addressTextView.placeHolderFont = [UIFont systemFontOfSize:16];
                
                addressTextView.font = [UIFont systemFontOfSize:16];
                addressTextView.textColor = COLOR_BLACK_CLASS_3;
                addressTextView.tag = i;
                addressTextView.delegate = self;
                addressTextView.text = [self.allData objectForKey:[NSString stringWithFormat:@"%d", i]];
                addressTextView.text = self.addressDetailStr;
                [self.srcV addSubview:addressTextView];
                
                UIButton *locationButton = [[UIButton alloc]initWithFrame:CGRectMake(addressTextView.right - 5, 0,  30, 30)];
                locationButton.centerY = leftL.centerY;
                locationButton.contentMode = UIViewContentModeScaleAspectFit;
                [locationButton  addTarget:self action:@selector(localionButtonAction) forControlEvents:UIControlEventTouchUpInside];
                [locationButton  setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
                [self.srcV addSubview:locationButton];
                
            }
            
            if (i==6) {
                textF.placeholder = @"为避免骚扰,请谨慎填写手机号";
                leftL.frame = CGRectMake(15, h, 100, 60);
                textF.frame = CGRectMake(leftL.right+10, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height);
                textF.text = _telePhone;
                if (kSCREEN_WIDTH<350) {
                    [textF setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
                }
            }
            
            if (i == 7) {
                textF.placeholder = @"请输入邮箱";
                textF.text = _Email;
            }
            if (i == 8) {
                textF.placeholder = @"请输入网址";
                textF.text = _Website;
            }
            
            if (i == 3) {
                
//                _queryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                _queryBtn.frame = CGRectMake(kSCREEN_WIDTH-8-30, h+7, 30, 30);
//                _queryBtn.centerY = leftL.centerY;
//                if (_isCheck == 0) {
//
//                    [_queryBtn setImage:[UIImage imageNamed:@"circle_kong"] forState:UIControlStateNormal];
//                } else {
//
//                    [_queryBtn setImage:[UIImage imageNamed:@"circle_shi"] forState:UIControlStateNormal];
//                }
//
//                [_queryBtn addTarget:self action:@selector(queryBtnClick) forControlEvents:UIControlEventTouchUpInside];
//                [self.srcV addSubview:self.queryBtn];
//                _queryL = [[UILabel alloc]initWithFrame:CGRectMake(self.queryBtn.left-60,h+10, 65, 20)];
//                _queryL.centerY = leftL.centerY;
//                _queryL.textColor = COLOR_BLACK_CLASS_3;
//                _queryL.font = [UIFont systemFontOfSize:16];
//                _queryL.text = @"114可查";
//                _queryL.textAlignment = NSTextAlignmentRight;
//                [self.srcV addSubview:self.queryL];
                textF.frame = CGRectMake(leftL.right+10, leftL.top, kSCREEN_WIDTH-leftL.right-110, leftL.height);
                textF.placeholder = @"请输入区号+号码";
                
                textF.adjustsFontSizeToFitWidth = YES;
                self.phoneTextField = textF;
                
                self.phoneTextField.hidden = YES;
                
                // 修改座机 3个固定的控件  7-17 by sty
                UITextField *areaCode = [[UITextField alloc]initWithFrame:CGRectMake(leftL.right+10, leftL.top+15, 50, 30)];
                
                //                areaCode.layer.masksToBounds = YES;
                //                areaCode.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
                //                areaCode.layer.borderWidth = 1;
                //                areaCode.layer.cornerRadius = 5;
                areaCode.placeholder = @"区号";
//                if (kSCREEN_WIDTH<350) {
//                    areaCode.textAlignment = NSTextAlignmentRight;
//                }else{
//                    areaCode.textAlignment = NSTextAlignmentCenter;
//                }
                areaCode.textAlignment = NSTextAlignmentLeft;
                areaCode.textColor = COLOR_BLACK_CLASS_3;
                areaCode.font = NB_FONTSEIZ_BIG;
                [areaCode setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
                [areaCode setValue:NB_FONTSEIZ_BIG forKeyPath:@"_placeholderLabel.font"];
                areaCode.keyboardType = UIKeyboardTypeNumberPad;
                NSString *str = @"0377";
                CGSize textSize = [str boundingRectWithSize:CGSizeMake(50, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                    context:nil].size;
                [areaCode sizeThatFits:CGSizeMake(textSize.width, 30)];
                
                if (_areaCodeStr&&_areaCodeStr.length>0) {
                    areaCode.text = _areaCodeStr;
                }
                else{
                    areaCode.text = @"";
                }
                
                areaCode.tag = 100;
                self.areaCodeField = areaCode;
                self.areaCodeField.delegate = self;
                //                [self.areaCodeField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                [self.srcV addSubview:self.areaCodeField];
                
                UILabel *midLineL = [[UILabel alloc]initWithFrame:CGRectMake(self.areaCodeField.right-7, self.areaCodeField.top, 5, self.areaCodeField.height)];
                midLineL.text = @"-";
                midLineL.textColor = COLOR_BLACK_CLASS_3;
                midLineL.font = NB_FONTSEIZ_BIG;
                //        companyJob.backgroundColor = Red_Color;
                midLineL.textAlignment = NSTextAlignmentCenter;
                self.midLineLabel = midLineL;
                [self.srcV addSubview:self.midLineLabel];
                
                //                [textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                
                UITextField *phoneBehind = [[UITextField alloc]initWithFrame:CGRectMake(self.midLineLabel.right+5, self.areaCodeField.top, 100, 30)];
                
                //                areaCode.layer.masksToBounds = YES;
                //                areaCode.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
                //                areaCode.layer.borderWidth = 1;
                //                areaCode.layer.cornerRadius = 5;
                phoneBehind.placeholder = @"座机号";
                phoneBehind.textAlignment = NSTextAlignmentLeft;
                phoneBehind.keyboardType = UIKeyboardTypeNumberPad;
                phoneBehind.textColor = COLOR_BLACK_CLASS_3;
                phoneBehind.font = NB_FONTSEIZ_BIG;
                [phoneBehind setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
                [phoneBehind setValue:NB_FONTSEIZ_BIG forKeyPath:@"_placeholderLabel.font"];
                
                if (_behindPhoneStr&&_behindPhoneStr.length>0) {
                    phoneBehind.text = _behindPhoneStr;
                }
                else{
                    phoneBehind.text = @"";
                }
                
                self.phoneBehindField = phoneBehind;
                self.phoneBehindField.tag=200;
                self.phoneBehindField.delegate = self;
                [self.srcV addSubview:self.phoneBehindField];
                
                
//                [textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            }
            
            
            UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, leftL.bottom-1, kSCREEN_WIDTH, 1)];
            lineV.backgroundColor = kBackgroundColor;
            h = h +60;
            [self.srcV addSubview:leftL];
//            [self.srcV addSubview:textF];
            if (i != 5 && i != 0) {
                [self.srcV addSubview:textF];
            }
            [self.srcV addSubview:lineV];
            if (i != 2) {
                
                textF.text = [self.allData objectForKey:[NSString stringWithFormat:@"%d", i]];
                //            textF.text = self.dataArr[i];
            }
            
            if (i == 1) {
                _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];

                _typeBtn.frame = textF.frame;
                _typeBtn.height = 60;
                _typeBtn.centerY = leftL.centerY;
                _typeBtn.width = textF.width - 35;

                if ([self.model.companyType integerValue] == 1018) {
                    [_typeBtn setTitle:@"装修公司" forState:UIControlStateNormal];
                }else if ([self.model.companyType integerValue] == 1064) {
                    [_typeBtn setTitle:@"整装公司" forState:UIControlStateNormal];
                }else if ([self.model.companyType integerValue] == 1065) {
                    [_typeBtn setTitle:@"新型装修" forState:UIControlStateNormal];
                }else{
                    [_typeBtn setTitle:_category.typeName forState:UIControlStateNormal];
                }

                
                _typeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [_typeBtn setTitleColor:Black_Color forState:UIControlStateNormal];
                _typeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
                [_typeBtn addTarget:self action:@selector(typeBtnClick) forControlEvents:UIControlEventTouchUpInside];
                _typeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
                _typeBtn.backgroundColor = [UIColor clearColor];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = textF.frame;
                btn.size = CGSizeMake(30, 30);
                btn.right = self.view.right - 5;
                btn.height = 39;
                btn.centerY = leftL.centerY;
                [btn setImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];
                
                [self.srcV addSubview:self.typeBtn];
                [self.srcV addSubview:btn];
                textF.hidden = YES;
            }
            
            if (i == 4) {
                _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _addressBtn.frame = textF.frame;
                _addressBtn.height = 60;
                _addressBtn.centerY = leftL.centerY;
                _addressBtn.width = textF.width - 35;
//                [_addressBtn setTitle:self.addressStr forState:UIControlStateNormal];
                
                if (!self.addressStr||self.addressStr.length<=0) {
                    [_addressBtn setTitle:@"请选择地址" forState:UIControlStateNormal];
                    [_addressBtn setTitleColor:COLOR_BLACK_CLASS_9 forState:UIControlStateNormal];
                }
                else{
                    [_addressBtn setTitle:self.addressStr forState:UIControlStateNormal];
                    [_addressBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                }
                
                _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//                [_addressBtn setTitleColor:Black_Color forState:UIControlStateNormal];
                _addressBtn.titleLabel.font = [UIFont systemFontOfSize:16];
                [_addressBtn addTarget:self action:@selector(addressBtnClick) forControlEvents:UIControlEventTouchUpInside];
                _addressBtn.backgroundColor = [UIColor clearColor];
                _addressBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                [self.srcV addSubview:self.addressBtn];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = textF.frame;
                btn.size = CGSizeMake(30, 30);
                btn.right = self.view.right - 5;
                btn.height = 39;
                btn.centerY = leftL.centerY;
                [btn addTarget:self action:@selector(addressBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [btn setImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];
                [self.srcV addSubview:btn];
                
                textF.hidden = YES;
            }
            
            if (i == 2) {
                _decorationbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _decorationbBtn.frame = textF.frame;
                _decorationbBtn.height = 60;
                _decorationbBtn.width = textF.width - 35;
                _decorationbBtn.centerY = leftL.centerY;
                _decorationbBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//                [_decorationbBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                _decorationbBtn.titleLabel.font = [UIFont systemFontOfSize:16];
                [_decorationbBtn addTarget:self action:@selector(decorationbBtnClick) forControlEvents:UIControlEventTouchUpInside];
                _decorationbBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                _decorationbBtn.backgroundColor = [UIColor clearColor];
                [self.srcV addSubview:self.decorationbBtn];
                NSMutableArray *arrM = [NSMutableArray array];
                for (AreaListModel *model in self.decorationArray) {
                    NSArray *arr = [model.retion componentsSeparatedByString:@" "];
                    [arrM addObject:arr.lastObject];
                }
                self.decorationStr = [NSMutableString stringWithString:[arrM componentsJoinedByString:@" "]];
//                [self.decorationbBtn setTitle:self.decorationStr forState:UIControlStateNormal];
                
                if (!self.decorationStr||self.decorationStr.length<=0) {
                    [self.decorationbBtn setTitle:@"请选择装修区域" forState:UIControlStateNormal];
                    [_decorationbBtn setTitleColor:COLOR_BLACK_CLASS_9 forState:UIControlStateNormal];
                }
                else{
                    [self.decorationbBtn setTitle:self.decorationStr forState:UIControlStateNormal];
                    [self.decorationbBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                }
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = textF.frame;
                btn.size = CGSizeMake(30, 30);
                btn.right = self.view.right - 5;
                btn.height = 39;
                btn.centerY = leftL.centerY;
                [btn addTarget:self action:@selector(decorationbBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [btn setImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];
                [self.srcV addSubview:btn];
                
                textF.hidden = YES;
            }
        }
    } else {
        
        for (int i = 0; i < 8; i ++) {
            
            NSArray *leftArray = @[@"品牌名称", @"类   \ \ \ \ 别", @"座   \ \ \ \ 机", @"地   \ \ \ \ 址", @"详细地址",@"业务经理电话", temEmailStr, @"网  \ \ \ \ 址"];
            UILabel *leftL = [[UILabel alloc]initWithFrame:CGRectMake(15, h, 70, 60)];
            leftL.text = leftArray[i];
            leftL.textColor = COLOR_BLACK_CLASS_3;
            leftL.font = [UIFont systemFontOfSize:16];
            leftL.textAlignment = NSTextAlignmentLeft;
            
            UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(leftL.right+10, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height)];
            textF.textColor = COLOR_BLACK_CLASS_3;
            textF.font = [UIFont systemFontOfSize:16];
            [textF setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
            [textF setValue:NB_FONTSEIZ_NOR forKeyPath:@"_placeholderLabel.font"];
            
            [textF addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
            [textF addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventAllEvents];
            textF.tag = i;
            textF.delegate = self;
            
            if (i < 2) {
                textF.text = [self.allData objectForKey:[NSString stringWithFormat:@"%d", i]];
            } else {
                textF.text = [self.allData objectForKey:[NSString stringWithFormat:@"%d", i + 1]];
            }
            
            if (i == 0) {
                textF.placeholder = @"请输入品牌名称";
                
                [textF removeFromSuperview];
                PlaceHolderTextView *companyNameTextView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(leftL.right + 5.5, leftL.top + 12, kSCREEN_WIDTH-leftL.right-20, leftL.height - 12)];
                companyNameTextView.placeHolder = @"请输入品牌名称";
                companyNameTextView.placeHolderColor = [UIColor lightGrayColor];
//                companyNameTextView.placeHolderFont = [UIFont systemFontOfSize:16];
                
                companyNameTextView.font = [UIFont systemFontOfSize:16];
                companyNameTextView.textColor = COLOR_BLACK_CLASS_3;
                companyNameTextView.tag = i;
                companyNameTextView.delegate = self;
                companyNameTextView.text = [self.allData objectForKey:[NSString stringWithFormat:@"%d", i]];
                [self.srcV addSubview:companyNameTextView];

            }
            
            if (i == 4) {
                textF.placeholder = @"请输入详细地址";
            }
            if (i == 4) {
                [textF removeFromSuperview];
                PlaceHolderTextView *addressTextView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(leftL.right + 5.5, leftL.top + 12, kSCREEN_WIDTH-leftL.right-40, leftL.height - 12)];
                self.detailAddressTV = addressTextView;
                addressTextView.placeHolder = @"请输入详细地址";
                addressTextView.placeHolderColor = [UIColor lightGrayColor];
//                addressTextView.placeHolderFont = [UIFont systemFontOfSize:16];
                
                addressTextView.font = [UIFont systemFontOfSize:16];
                addressTextView.textColor = COLOR_BLACK_CLASS_3;
                addressTextView.tag = i;
                addressTextView.delegate = self;
                addressTextView.text = self.addressDetailStr;
                [self.srcV addSubview:addressTextView];
                
                UIButton *locationButton = [[UIButton alloc]initWithFrame:CGRectMake(addressTextView.right - 5, 0,  30, 30)];
                locationButton.centerY = leftL.centerY;
                locationButton.contentMode = UIViewContentModeScaleAspectFit;
                [locationButton  addTarget:self action:@selector(localionButtonAction) forControlEvents:UIControlEventTouchUpInside];
                [locationButton  setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
                [self.srcV addSubview:locationButton];
                
            }
            
            if (i==5) {
                textF.placeholder = @"为避免骚扰,请谨慎填写手机号";
                leftL.frame = CGRectMake(15, h, 100, 60);
                textF.frame = CGRectMake(leftL.right+10, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height);
                if (kSCREEN_WIDTH<350) {
                  [textF setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
                }
                
                textF.text = _telePhone;
                
            }
            
            if (i == 6) {
                textF.placeholder = @"请输入邮箱";
                textF.text = _Email;
            }
            if (i == 7) {
                textF.placeholder = @"请输入网址";
                textF.text = _Website;
            }
            
            if (i == 2) {
                
//                _queryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                _queryBtn.frame = CGRectMake(kSCREEN_WIDTH-8-30, h+7, 30, 30);
//                _queryBtn.centerY = leftL.centerY;
//                if (_isCheck == 0) {
//                    
//                    [_queryBtn setImage:[UIImage imageNamed:@"circle_kong"] forState:UIControlStateNormal];
//                } else {
//                    
//                    [_queryBtn setImage:[UIImage imageNamed:@"circle_shi"] forState:UIControlStateNormal];
//                }
//                [_queryBtn addTarget:self action:@selector(queryBtnClick) forControlEvents:UIControlEventTouchUpInside];
//                [self.srcV addSubview:self.queryBtn];
//                _queryL = [[UILabel alloc]initWithFrame:CGRectMake(self.queryBtn.left-60,h+10, 65, 20)];
//                _queryL.textColor = COLOR_BLACK_CLASS_3;
//                _queryL.font = [UIFont systemFontOfSize:16];
//                _queryL.text = @"114可查";
//                _queryL.centerY = leftL.centerY;
//                _queryL.textAlignment = NSTextAlignmentRight;
//                [self.srcV addSubview:self.queryL];
                textF.frame = CGRectMake(leftL.right+10, leftL.top, kSCREEN_WIDTH-leftL.right-110, leftL.height);
                textF.placeholder = @"请输入区号+号码";
                
                textF.adjustsFontSizeToFitWidth = YES;
                self.phoneTextField = textF;
                self.phoneTextField.hidden = YES;
                
                // 修改座机 3个固定的控件  7-17 by sty
                UITextField *areaCode = [[UITextField alloc]initWithFrame:CGRectMake(leftL.right+10, leftL.top+15, 50, 30)];
                
                //                areaCode.layer.masksToBounds = YES;
                //                areaCode.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
                //                areaCode.layer.borderWidth = 1;
                //                areaCode.layer.cornerRadius = 5;
                areaCode.placeholder = @"区号";
                areaCode.textAlignment = NSTextAlignmentLeft;
//                if (kSCREEN_WIDTH<350) {
//                    areaCode.textAlignment = NSTextAlignmentRight;
//                }else{
//                    areaCode.textAlignment = NSTextAlignmentCenter;
//                }
                
                areaCode.textColor = COLOR_BLACK_CLASS_3;
                areaCode.font = NB_FONTSEIZ_BIG;
                [areaCode setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
                [areaCode setValue:NB_FONTSEIZ_BIG forKeyPath:@"_placeholderLabel.font"];
                areaCode.keyboardType = UIKeyboardTypeNumberPad;
                NSString *str = @"0377";
                CGSize textSize = [str boundingRectWithSize:CGSizeMake(50, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                    context:nil].size;
                [areaCode sizeThatFits:CGSizeMake(textSize.width, 30)];
                
                if (_areaCodeStr&&_areaCodeStr.length>0) {
                    areaCode.text = _areaCodeStr;
                }
                else{
                    areaCode.text = @"";
                }
                
                areaCode.tag = 100;
                self.areaCodeField = areaCode;
                self.areaCodeField.delegate = self;
                //                [self.areaCodeField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                [self.srcV addSubview:self.areaCodeField];
                
                UILabel *midLineL = [[UILabel alloc]initWithFrame:CGRectMake(self.areaCodeField.right-7, self.areaCodeField.top, 5, self.areaCodeField.height)];
                midLineL.text = @"-";
                midLineL.textColor = COLOR_BLACK_CLASS_3;
                midLineL.font = NB_FONTSEIZ_BIG;
                //        companyJob.backgroundColor = Red_Color;
                midLineL.textAlignment = NSTextAlignmentCenter;
                self.midLineLabel = midLineL;
                [self.srcV addSubview:self.midLineLabel];
                
                //                [textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                
                UITextField *phoneBehind = [[UITextField alloc]initWithFrame:CGRectMake(self.midLineLabel.right+5, self.areaCodeField.top, 100, 30)];
                
                //                areaCode.layer.masksToBounds = YES;
                //                areaCode.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
                //                areaCode.layer.borderWidth = 1;
                //                areaCode.layer.cornerRadius = 5;
                phoneBehind.placeholder = @"座机号";
                phoneBehind.textAlignment = NSTextAlignmentLeft;
                phoneBehind.keyboardType = UIKeyboardTypeNumberPad;
                phoneBehind.textColor = COLOR_BLACK_CLASS_3;
                phoneBehind.font = NB_FONTSEIZ_BIG;
                [phoneBehind setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
                [phoneBehind setValue:NB_FONTSEIZ_BIG forKeyPath:@"_placeholderLabel.font"];
                
                if (_behindPhoneStr&&_behindPhoneStr.length>0) {
                    phoneBehind.text = _behindPhoneStr;
                }
                else{
                    phoneBehind.text = @"";
                }
                
                self.phoneBehindField = phoneBehind;
                self.phoneBehindField.tag=200;
                self.phoneBehindField.delegate = self;
                [self.srcV addSubview:self.phoneBehindField];
                
                
//                [textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            }
            
            
            UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, leftL.bottom-1, kSCREEN_WIDTH, 1)];
            lineV.backgroundColor = kBackgroundColor;
            h = h +60;
            [self.srcV addSubview:leftL];
//            [self.srcV addSubview:textF];
            if (i != 4 && i != 0) {
                [self.srcV addSubview:textF];
            }
            [self.srcV addSubview:lineV];
            
            if (i == 1) {
                _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];

                _typeBtn.frame = textF.frame;
                _typeBtn.height = 60;
                _typeBtn.width = textF.width - 35;
                _typeBtn.centerY = leftL.centerY;
                if ([self.model.companyType integerValue] == 1018) {
                    [_typeBtn setTitle:@"装修公司" forState:UIControlStateNormal];
                }else if ([self.model.companyType integerValue] == 1064) {
                    [_typeBtn setTitle:@"整装公司" forState:UIControlStateNormal];
                }else if ([self.model.companyType integerValue] == 1065) {
                    [_typeBtn setTitle:@"新型装修" forState:UIControlStateNormal];
                }else{
                    [_typeBtn setTitle:_category.typeName forState:UIControlStateNormal];
                }
                
                _typeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [_typeBtn setTitleColor:Black_Color forState:UIControlStateNormal];
                _typeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
                [_typeBtn addTarget:self action:@selector(typeBtnClick) forControlEvents:UIControlEventTouchUpInside];
                _typeBtn.backgroundColor = [UIColor clearColor];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = textF.frame;
                btn.size = CGSizeMake(30, 30);
                btn.right = self.view.right - 5;
                btn.height = 39;
                btn.centerY = leftL.centerY;
                [btn addTarget:self action:@selector(typeBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [btn setImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];
                
                [self.srcV addSubview:self.typeBtn];
                [self.srcV addSubview:btn];
                textF.hidden = YES;
            }
            
            if (i == 3) {
                _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _addressBtn.frame = textF.frame;
                _addressBtn.height = 60;
                _addressBtn.width = textF.width - 35;
                _addressBtn.centerY = leftL.centerY;
                //            [_addressBtn setTitle:@"请选择地址" forState:UIControlStateNormal];
//                [_addressBtn setTitle:self.addressStr forState:UIControlStateNormal];
                
                if (!self.addressStr||self.addressStr.length<=0) {
                    [_addressBtn setTitle:@"请选择地址" forState:UIControlStateNormal];
                    [_addressBtn setTitleColor:COLOR_BLACK_CLASS_9 forState:UIControlStateNormal];
                }
                else{
                    [_addressBtn setTitle:self.addressStr forState:UIControlStateNormal];
                    [_addressBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                }
                
                _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//                [_addressBtn setTitleColor:Black_Color forState:UIControlStateNormal];
                _addressBtn.titleLabel.font = [UIFont systemFontOfSize:16];
                [_addressBtn addTarget:self action:@selector(addressBtnClick) forControlEvents:UIControlEventTouchUpInside];
                _addressBtn.backgroundColor = [UIColor clearColor];
                _addressBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                [self.srcV addSubview:self.addressBtn];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = textF.frame;
                btn.size = CGSizeMake(30, 30);
                btn.right = self.view.right - 5;
                btn.height = 39;
                btn.centerY = leftL.centerY;
                [btn addTarget:self action:@selector(addressBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [btn setImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];
                [self.srcV addSubview:btn];
                
                textF.hidden = YES;
            }
            
        }
    }
    
    UILabel *temL = [[UILabel alloc]initWithFrame:CGRectMake(15, h, 75, 60)];
    temL.textColor = COLOR_BLACK_CLASS_3;
    temL.font = [UIFont systemFontOfSize:16];
    temL.text = @"简   \ \ \ \ 介";
    temL.textAlignment = NSTextAlignmentLeft;
    [self.srcV addSubview:temL];
    
    self.textV = [[UITextView alloc]initWithFrame:CGRectMake(10, temL.bottom, kSCREEN_WIDTH-20, 80)];
    self.textV.layer.cornerRadius = 5;
    self.textV.layer.borderColor = kBackgroundColor.CGColor;
    self.textV.layer.borderWidth = 1;
    self.textV.backgroundColor = White_Color;
    self.textV.delegate = self;
    [self.srcV addSubview:self.textV];
    self.textV.text = _introduce;
    self.textV.font = [UIFont systemFontOfSize:16];
    self.textV.tag = 1111;
    
    self.placeHoldL = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 20)];
    self.placeHoldL.textColor = [UIColor lightGrayColor];
    self.placeHoldL.font = [UIFont systemFontOfSize:16];
    
    self.placeHoldL.text = @"填写品牌或店铺信息";
    self.placeHoldL.textAlignment = NSTextAlignmentLeft;
//    self.placeHoldL.hidden = YES;
    
    [self.textV addSubview:self.placeHoldL];
    
    
    if (self.textV.text.length > 0) {
        self.placeHoldL.hidden = YES;
    }else{
        self.placeHoldL.hidden = NO;
    }
    
    
    _successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _successBtn.frame = CGRectMake(10,self.textV.bottom+10,kSCREEN_WIDTH - 20,44);
    _successBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_successBtn setTitleColor:White_Color forState:UIControlStateNormal];
    _successBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_successBtn setTitle:@"完    成" forState:UIControlStateNormal];
    _successBtn.layer.cornerRadius = 5;
    _successBtn.layer.masksToBounds = YES;
    [_successBtn addTarget:self action:@selector(successTouch) forControlEvents:UIControlEventTouchUpInside];
    _successBtn.backgroundColor = Main_Color;
    [self.srcV addSubview:self.successBtn];
    
    self.srcV.contentSize = CGSizeMake(kSCREEN_WIDTH, self.successBtn.bottom+20);
}


- (void)getRegion {
    
    [self.view endEditing:YES];
    [self.view bringSubviewToFront:self.regionView];
    self.regionView.hidden = NO;
    __weak CreatShopController *weakSelf = self;

    self.regionView.selectBlock = ^(NSMutableArray *array){
        weakSelf.regionView.hidden = YES;
        weakSelf.pmodel = [array objectAtIndex:0];
        weakSelf.cmodel = [array objectAtIndex:1];
        weakSelf.dmodel = [array objectAtIndex:2];
        
        weakSelf.addressStr = [NSString stringWithFormat:@"%@ %@ %@",weakSelf.pmodel.name,weakSelf.cmodel.name,weakSelf.dmodel.name];
        NSInteger regionId = [weakSelf.pmodel.regionId integerValue];
        if (regionId == 110000||regionId == 120000||regionId == 500000||regionId == 310000) {
            weakSelf.addressStr = [NSString stringWithFormat:@"%@ %@",weakSelf.pmodel.name,weakSelf.dmodel.name];
        }
        
        [weakSelf.addressBtn setTitle:weakSelf.addressStr forState:UIControlStateNormal];
        [weakSelf.addressBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
    };
}

- (void)decorationbBtnClick {
    
    DecorationAreaViewController *areaVC = [[DecorationAreaViewController alloc] init];
    areaVC.listArray = self.decorationArray;
    [areaVC setRegionViewShow];
    if (self.model){
        //修改店铺
        areaVC.index = 2;
    }else{
        //创建店铺
        areaVC.index = 1;
    }
    [self.navigationController pushViewController:areaVC animated:YES];
}

#pragma mark - uialertviewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2000) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    if (alertView.tag == 999) {
        if (buttonIndex == 1) {
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                [[UIApplication sharedApplication] openURL:settingsURL];
            }
        }
    }
}

// 判断电话是否正确
- (BOOL)checkNumber:(NSString *)number
{
    //验证输入的固话中不带 "-"符号
    
    //    NSString * strNum = @"^(0[0-9]{2,3})?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$|(^(13[0-9]|15[0|3|6|7|8|9]|18[8|9])\\d{8}$)";
    
    //验证输入的固话中带 "-"符号
    
    NSString * strNum = @"^(0[0-9]{2,3}-{1,3})?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$|(^(13[0-9]|14[5|7|9]|15[0-9]|17[0|1|3|5|6|7|8]|18[0-9])\\d{8}$)";
    
    NSPredicate *checktest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strNum];
    
    return [checktest evaluateWithObject:number];
}

#pragma mark - 提交数据
- (void)successTouch {
    
    [self.view endEditing:YES];
    
    if (!_photoUrl||_photoUrl.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"公司logo不能为空" controller:self sleep:1.5];
        return;
    }
    
    _companyName = [_companyName ew_removeSpaces];
    _companyName = [_companyName ew_removeSpacesAndLineBreaks];
    if (!_companyName||_companyName.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"品牌名称不能为空" controller:self sleep:1.5];
        return;
    }
    NSString *typeName = self.typeBtn.currentTitle;
    if (typeName.length<=0||[typeName isEqualToString:@"请选择类别"]) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"类别不能为空" controller:self sleep:1.5];
        return;
    }
//    self.phoneTextField
//    if (![self checkNumber:self.phoneTextField.text]) {
//        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入正确的电话" controller:self sleep:1.5];
//        return;
//    }
//    if (![self.phoneTextField.text containsString:@"-"]) {
//        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入区号加号码" controller:self sleep:1.5];
//        return;
//    }
//    if (![self checkNumber:self.phoneTextField.text]) {
//        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入正确的电话" controller:self sleep:1.5];
//        return;
//    }
    
    if ((!self.model)) {
        if (self.creatType == 1) {
            _type = 1018;
        }else if (self.creatType == 2) {
            _type = 1064;
        }else if (self.creatType == 3) {
            _type = 1065;
        }
    }
    
    if (_type == 1018 || _type == 1064 || _type == 1065) {
        if (self.decorationArray.count<=0) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"装修区域不能为空" controller:self sleep:1.5];
            return;
        }else{
            
        }
    }
    else{
        
    }
    
    _areaCodeStr = [_areaCodeStr ew_removeSpaces];
    _areaCodeStr = [_areaCodeStr ew_removeSpacesAndLineBreaks];
    if (!_areaCodeStr||_areaCodeStr.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入区号" controller:self sleep:1.5];
        return;
    }
    
//    if (!_linePhone||_linePhone.length<=0) {
//        [[PublicTool defaultTool] publicToolsHUDStr:@"座机号码不能为空" controller:self sleep:1.5];
//        return;
//    }
    
//    if (![_linePhone ew_checkLinePhone]) {
//        [[PublicTool defaultTool] publicToolsHUDStr:@"座机号格式为 区号-号码" controller:self sleep:1.5];
//        return;
//    }
    NSString *tempStr = [_areaCodeStr substringToIndex:1];
    NSInteger temInt = [tempStr integerValue];
//    if ((temInt==1)||[_linePhone ew_justCheckPhone]) {
//        [[PublicTool defaultTool] publicToolsHUDStr:@"座机号有误！" controller:self sleep:1.5];
//        return;
//    }
    if (!(temInt==0||temInt==4)) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"区号格式不正确，必须是0或4开头" controller:self sleep:1.5];
        return;
    }
    
    if (_areaCodeStr.length>4||_areaCodeStr.length<3) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入3-4位数区号" controller:self sleep:1.5];
        return;
    }
    
    
    _behindPhoneStr = [_behindPhoneStr ew_removeSpaces];
    _behindPhoneStr = [_behindPhoneStr ew_removeSpacesAndLineBreaks];
    if (!_behindPhoneStr||_behindPhoneStr.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"座机号" controller:self sleep:1.5];
        return;
    }
    
    if (_behindPhoneStr.length<5||_behindPhoneStr.length>8) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入5-8位数座机号" controller:self sleep:1.5];
        return;
    }
    
    _linePhone = [NSString stringWithFormat:@"%@-%@",_areaCodeStr,_behindPhoneStr];
    
//    BOOL istrue = false;//格式是否正确
//    //遍历nsstring的没一个字符
//    for (int i = 0; i<[_linePhone length]; i++) {
//        NSString *temSub = [_linePhone substringWithRange:NSMakeRange(i, 1)];
//        if ([temSub ew_checkNumber]) {
//            istrue = YES;
//        }
//        else{
//            istrue = NO;
//            break;
//        }
//    }
//    
//    if (!istrue) {
//        [[PublicTool defaultTool] publicToolsHUDStr:@"座机号有误！" controller:self sleep:1.5];
//        return;
//    }
    
    
    self.addressStr = [self.addressStr ew_removeSpaces];
    self.addressStr = [self.addressStr ew_removeSpacesAndLineBreaks];
    self.addressDetailStr = [self.addressDetailStr ew_removeSpaces];
    self.addressDetailStr = [self.addressDetailStr ew_removeSpacesAndLineBreaks];
    NSString *temDmodelR = @"";
    
    if (self.pmodel.name == nil && self.model != nil) {
        
//        temDmodelR = self.addressStr;
        NSInteger regionId = [self.pmodel.regionId integerValue];
        if (regionId == 110000||regionId == 120000||regionId == 500000||regionId == 310000)//四个直辖市只传省和市
        {
            if (![self.dmodel.regionId isEqualToString:@"-1"]) {
                
                self.cmodel.regionId = self.dmodel.regionId;
            }
            
            //        self.dmodel.regionId = @"-1";
            temDmodelR = @"-1";
        } else {
            self.cmodel.regionId = self.cmodel.regionId;
            temDmodelR = self.dmodel.regionId;
        }
        
        
        if (!self.addressStr||self.addressStr.length<=0) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"地址不能为空" controller:self sleep:1.5];
            return;
        }
        
        
        if (!self.addressDetailStr||self.addressDetailStr.length<=0) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"详细地址不能为空" controller:self sleep:1.5];
            return;
        }
        
    } else {
    
        NSInteger regionId = [self.pmodel.regionId integerValue];
        if (regionId == 110000||regionId == 120000||regionId == 500000||regionId == 310000)//四个直辖市只传省和市
        {
            if (![self.dmodel.regionId isEqualToString:@"-1"]) {
                
                self.cmodel.regionId = self.dmodel.regionId;
            }
            temDmodelR = @"-1";
            self.addressStr = [NSString stringWithFormat:@"%@ %@",[self.pmodel.name isEqual:[NSNull null]] || self.pmodel.name == nil ? @"" : self.pmodel.name,[self.dmodel.name isEqual:[NSNull null]] || self.dmodel.name == nil ? @"" : self.dmodel.name];
        }
        else{
            self.cmodel.regionId = self.cmodel.regionId;
            temDmodelR = self.dmodel.regionId;
        }
        
        if (!self.addressStr||self.addressStr.length<=0) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"地址不能为空" controller:self sleep:1.5];
            return;
        }
        
        if (!self.addressDetailStr||self.addressDetailStr.length<=0) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"详细地址不能为空" controller:self sleep:1.5];
            return;
        }
        
//        self.addressStr = [NSString stringWithFormat:@"%@ %@",self.addressStr,self.addressDetailStr];
    }
    
    

    
    NSMutableArray *areaArray = [NSMutableArray array];
    //    NSMutableArray *arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"haveSelect"];
    NSString *temJsonStr = @"";
    
    
    if (self.decorationArray.count > 0) {
        for (NSDictionary *temDict in self.decorationArray) {
            
            if (![temDict isKindOfClass:[AreaListModel class]]) {
                
                NSInteger pidN = [[temDict objectForKey:@"pid"] integerValue];
                NSInteger cidN = [[temDict objectForKey:@"cid"] integerValue];
                NSInteger didN = [[temDict objectForKey:@"did"] integerValue];
                NSString *address = [temDict objectForKey:@"address"];
                NSMutableDictionary *areaDict = [NSMutableDictionary dictionary];
                
                [areaDict setObject:@(pidN) forKey:@"province"];
                [areaDict setObject:@(cidN) forKey:@"city"];
                [areaDict setObject:@(didN) forKey:@"county"];
                [areaDict setObject:address forKey:@"retion"];
                [areaArray addObject:areaDict];
            } else {
                
                NSMutableDictionary *areaDict = [NSMutableDictionary dictionary];
                
                [areaDict setObject:@(((AreaListModel *)temDict).province) forKey:@"province"];
                [areaDict setObject:@(((AreaListModel *)temDict).city) forKey:@"city"];
                [areaDict setObject:@(((AreaListModel *)temDict).county) forKey:@"county"];
                [areaDict setObject:((AreaListModel *)temDict).retion forKey:@"retion"];
                [areaArray addObject:areaDict];
            }
        }
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:areaArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        temJsonStr = jsonStr;
    }
    else
    {
        temJsonStr = @"";
    }
    
    _telePhone = [_telePhone ew_removeSpaces];
    _telePhone = [_telePhone ew_removeSpacesAndLineBreaks];
    if (!_telePhone||_telePhone.length<=0) {
        _telePhone = @"";
    }
    if (_telePhone&&_telePhone.length>0) {
        if (![_telePhone ew_justCheckPhone]||_telePhone.length>11) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"业务经理电话格式不正确" controller:self sleep:1.5];
            return;
        }
        
    }
    
    _Email = [_Email ew_removeSpaces];
    _Email = [_Email ew_removeSpacesAndLineBreaks];
    if (!_Email||_Email.length<=0) {
        _Email = @"";
    }
    
    if (_Email.length>0) {
        if (![_Email ew_checkEmail]) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"请输入正确的邮箱" controller:self sleep:1.5];
            return;
        }
    }
    
    _weChat = [_weChat ew_removeSpaces];
    _weChat = [_weChat ew_removeSpacesAndLineBreaks];
    if (!_weChat||_weChat.length<=0) {
        _weChat = @"";
    }
    
    _Website = [_Website ew_removeSpaces];
    _Website = [_Website ew_removeSpacesAndLineBreaks];
    if (!_Website||_Website.length<=0) {
        _Website = @"";
    }
    
    _introduce = [_introduce ew_removeSpaces];
    _introduce = [_introduce ew_removeSpacesAndLineBreaks];
    if (!_introduce||_introduce.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"公司简介不能为空" controller:self sleep:1.5];
        return;
    }
    
    
    NSString *temAddressStr = [NSString stringWithFormat:@"%@ %@",self.addressStr,self.addressDetailStr];
//    self.addressStr = [NSString stringWithFormat:@"%@ %@",self.addressStr,self.addressDetailStr];
    
    NSInteger first = 0;
    
    
    if (_isFirst) {
        first = 1;
    }else{
        first = 0;
    }
    
    
    if (self.model) {
        [self.view hudShow];
//        NSString *str = @"http://192.168.1.175:8080/blej-api-blej/api/";
        NSString *defaultApi = [BASEURL stringByAppendingString:@"area/saveArea.do"];
        NSDictionary *paramDic = @{@"companyName":_companyName,
                                   @"areaList":temJsonStr,
                                   @"companyProvince":self.pmodel.regionId,
                                   @"companyCity":self.cmodel.regionId,
                                   @"companyCounty":temDmodelR,
                                   @"companyLandline":_linePhone,
                                   @"companyAddress":temAddressStr,
                                   @"companyPhone":_telePhone,
                                   @"companyIntroduction":_introduce,
                                   @"companyWx":_weChat,
                                   @"companyId":self.model.companyId,
                                   @"companyType":@(_type),
                                   @"seeFlag":@(_isCheck),
                                   @"companyLogo":_photoUrl,
                                   @"companyEmail":_Email,
                                   @"companyUrl":_Website,
                                   @"longitude": @(self.longitude),
                                   @"latitude": @(self.lantitude)
                                   };
        
        YSNLog(@"paramedic: %@", paramDic);
        [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
            [self.view hiddleHud];
            if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
                
                NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
                
                switch (statusCode) {
                    case 1000:
                        
                    {
                        [[PublicTool defaultTool] publicToolsHUDStr:@"修改成功" controller:self sleep:1.5];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"requestCompanyList" object:nil];
                        self.refreshBlock();
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                        ////                    NSDictionary *dic = [NSDictionary ]
                        break;
                        
                    case 1001:
                    {
                        [[PublicTool defaultTool] publicToolsHUDStr:@"公司名称重复" controller:self sleep:1.5];
                    }
                        ////                    NSDictionary *dic = [NSDictionary ]
                        break;
                        
                    case 1004:
                        
                    {
                        NSString *msg = [responseObj objectForKey:@"msg"];
                        [[PublicTool defaultTool] publicToolsHUDStr:msg controller:self sleep:1.5];
                    }
                        break;
                        
                    case 2000:
                    {
                        [[PublicTool defaultTool] publicToolsHUDStr:@"修改失败" controller:self sleep:1.5];
                    }
                        ////                    NSDictionary *dic = [NSDictionary ]
                        break;
                        
                    default:
                        [[PublicTool defaultTool] publicToolsHUDStr:@"修改失败" controller:self sleep:1.5];
                        break;
                }
            }
            //        NSLog(@"%@",responseObj);
        } failed:^(NSString *errorMsg) {
            [self.view hiddleHud];
            [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        }];
    } else {
        [self.view hudShow];
        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        NSString *defaultApi = [BASEURL stringByAppendingString:@"company/saveHeadquarters.do"];
        YSNLog(@"%@",user);
        
        if (user.agencyId==0||user.agencyId==-1) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"登陆信息有误，请重新登录" controller:self sleep:1.5];
            return;
        }
        NSDictionary *paramDic = @{@"headQuarters":@(first),
                                   @"createPerson":@(user.agencyId),
                                   @"companyName":_companyName,
                                   @"areaList":temJsonStr,
                                   @"agencysJob":@(1002),
                                   @"companyProvince":self.pmodel.regionId,
                                   @"companyCity":self.cmodel.regionId,
                                   @"companyCounty":temDmodelR,
                                   @"companyLandline":_linePhone,
                                   @"companyAddress":temAddressStr,
                                   @"companyPhone":_telePhone,
                                   @"companyIntroduction":_introduce,
                                   @"companyWx":_weChat,
                                   @"pid":self.companyId,
                                   @"companyType":@(_type),
                                   @"seeFlag":@(_isCheck),
                                   @"companyLogo":_photoUrl,
                                   @"companyEmail":_Email,
                                   @"companyUrl":_Website,
                                   @"longitude": @(self.longitude),
                                   @"latitude": @(self.lantitude)
                                   };
        YSNLog(@"parame: %@", paramDic);
        [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
            [self.view hiddleHud];
            if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
                
                NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
                
                switch (statusCode) {
                    case 1000:
                        
                    {
                        [[PublicTool defaultTool] publicToolsHUDStr:@"创建成功" controller:self sleep:1.5];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"requestCompanyList" object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                        ////                    NSDictionary *dic = [NSDictionary ]
                        break;
                        
                    case 1001:
                    {
                        [[PublicTool defaultTool] publicToolsHUDStr:@"公司名称重复" controller:self sleep:1.5];
                    }
                        ////                    NSDictionary *dic = [NSDictionary ]
                        break;
                        
                    case 1004:
                        
                    {
                        NSString *msg = [responseObj objectForKey:@"msg"];
                        [[PublicTool defaultTool] publicToolsHUDStr:msg controller:self sleep:1.5];
                    }
                        break;
                        
                    case 2000:
                    {
                        [[PublicTool defaultTool] publicToolsHUDStr:@"创建失败" controller:self sleep:1.5];
                    }
                        ////                    NSDictionary *dic = [NSDictionary ]
                        break;
                        
                    default:
                        [[PublicTool defaultTool] publicToolsHUDStr:@"创建失败" controller:self sleep:1.5];
                        break;
                }
                
                
                
                
                
            }
            
            //        NSLog(@"%@",responseObj);
        } failed:^(NSString *errorMsg) {
            [self.view hiddleHud];
            [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        }];
    }
}

#pragma mark - textViewDelegateb

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView.tag != 1111) {
        self.regionView.hidden = YES;
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.tag == 1111) {
        if (textView.text.length>0) {
            self.placeHoldL.hidden = YES;
        }
        else{
            self.placeHoldL.hidden = NO;
        }
        _introduce = textView.text;
    }
    
    else {
        if (_type == 1018 || _type == 1064 || _type == 1065) {
            
            [self.allData setObject:textView.text forKey:[NSString stringWithFormat:@"%ld", textView.tag]];
            if (textView.tag == 0) {
                _companyName = textView.text;
            }
            
            if (textView.tag == 4) {
                //        _address = textField.text;
            }
            if (textView.tag == 5) {
                self.addressDetailStr = textView.text;
            }
            
        } else {
            
            if (textView.tag < 2) {
                
                [self.allData setObject:textView.text forKey:[NSString stringWithFormat:@"%ld", textView.tag]];
            } else {
                
                [self.allData setObject:textView.text forKey:[NSString stringWithFormat:@"%ld", textView.tag + 1]];
            }
            
            if (textView.tag == 0) {
                _companyName = textView.text;
                
            }
            
            if (textView.tag == 3) {
                //        _address = textField.text;
            }
            if (textView.tag == 4) {
                self.addressDetailStr = textView.text;
            }
        }
        
    }
    
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.tag == 1111) {
        if (textView.text.length>0) {
            self.placeHoldL.hidden = YES;
        }
        else{
            self.placeHoldL.hidden = NO;
        }
        _introduce = textView.text;
    } else {
        if (_type == 1018 || _type == 1064 || _type == 1065) {
            
            [self.allData setObject:textView.text forKey:[NSString stringWithFormat:@"%ld", textView.tag]];
            if (textView.tag == 0) {
                _companyName = textView.text;
            }
            
            if (textView.tag == 4) {
                //        _address = textField.text;
            }
            if (textView.tag == 5) {
                self.addressDetailStr = textView.text;
            }
        } else {
            
            if (textView.tag < 2) {
                
                [self.allData setObject:textView.text forKey:[NSString stringWithFormat:@"%ld", textView.tag]];
            } else {
                
                [self.allData setObject:textView.text forKey:[NSString stringWithFormat:@"%ld", textView.tag + 1]];
            }
            
            if (textView.tag == 0) {
                _companyName = textView.text;

            }

            if (textView.tag == 3) {
                //        _address = textField.text;
            }
            if (textView.tag == 4) {
                self.addressDetailStr = textView.text;
            }
        }

    }
    
}


- (void)changeImg:(UITapGestureRecognizer *)ges {
    
    [self imagePicker];
}

-(void)imagePicker{
    
    UIImagePickerController * photoAlbum = [[UIImagePickerController alloc]init];
    photoAlbum.delegate = self;
    photoAlbum.allowsEditing = YES;
    photoAlbum.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:photoAlbum animated:YES completion:^{}];
}

//图片选择完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage * chooseImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
//    NSData *imageData = UIImageJPEGRepresentation(chooseImage, PHOTO_COMPRESS);
    NSData *imageData = [NSObject imageData:chooseImage];
    
    if ([imageData length] >0) {
        imageData = [GTMBase64 encodeData:imageData];
    }
    NSString *imageStr = [[NSString alloc]initWithData:imageData encoding:NSUTF8StringEncoding];
    
    [self uploadImageWithBase64Str:imageStr];
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
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
//            [[PublicTool defaultTool] publicToolsHUDStr:@"上传成功" controller:self sleep:1.5];
            _photoUrl = [dic objectForKey:@"imageUrl"];
            
            [self.logoImg sd_setImageWithURL:[NSURL URLWithString:_photoUrl] placeholderImage:[UIImage imageNamed:@"jia1"]];
            
            
            
            //            [self.editInfoTableView reloadData];
            
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"上传失败" controller:self sleep:1.5];
    }];
}

-(UIScrollView *)srcV{
    if (!_srcV) {
        _srcV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64)];
        _srcV.backgroundColor = White_Color;
        _srcV.delegate = self;
    }
    return _srcV;
}

-(UILabel *)logoL{
    if (!_logoL) {
        _logoL = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, kSCREEN_WIDTH, 30)];
        _logoL.textColor = COLOR_BLACK_CLASS_3;
        _logoL.font = [UIFont systemFontOfSize:16];
        _logoL.text = @"品牌Logo";
        _logoL.textAlignment = NSTextAlignmentCenter;
    }
    return _logoL;
}

-(UIImageView *)logoImg{
    if (!_logoImg) {
        _logoImg = [[UIImageView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/3, self.logoL.bottom + 10, kSCREEN_WIDTH/3, kSCREEN_WIDTH/3)];
        _logoImg.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
        _logoImg.layer.borderWidth = 1;
        _logoImg.layer.masksToBounds = YES;
        _logoImg.contentMode = UIViewContentModeScaleAspectFill;
        if (self.model) {
            [_logoImg sd_setImageWithURL:[NSURL URLWithString:_photoUrl] placeholderImage:nil];
        } else {
            if ([[self.allData objectForKey:@"logo"] isEqualToString:@""]) {
                
                _logoImg.image = [UIImage imageNamed:@"jia1"];
            } else {
                
                [_logoImg sd_setImageWithURL:[NSURL URLWithString:[self.allData objectForKey:@"logo"]] placeholderImage:nil];
            }
            
        }
        
        
        
        _logoImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeImg:)];
        [_logoImg addGestureRecognizer:ges];
        
    }
    return _logoImg;
}

- (RegionView *)regionView {
    
    if (!_regionView) {
        _regionView = [[RegionView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-305, kSCREEN_WIDTH, 305)];
        _regionView.closeBtn.hidden = NO;
        _regionView.hidden = YES;
        _regionView.line.hidden = YES;
        _regionView.backgroundColor = [White_Color colorWithAlphaComponent:0];
    }
    return _regionView;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.regionView.hidden = YES;
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"categoryNoti" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DecorationAreaNot" object:nil];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}



@end
