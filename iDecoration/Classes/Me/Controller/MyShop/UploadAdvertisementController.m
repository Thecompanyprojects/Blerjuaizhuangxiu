//
//  UploadAdvertisementController.m
//  iDecoration
//
//  Created by zuxi li on 2017/7/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//
// 图片地址  图片id  图片排序  没有的穿@“”  图片类型
// 添加  有图片 没图片ID   // 修改  有图片 有图片ID   // 删除   没有图片   有图片ID

// 253  264  行， 获取到的数据 内网企业18 和内网工地(19) 类别标识需要修改


#import "UploadAdvertisementController.h"
#import "UploadAdvertisementCell.h"
#import "HKImageClipperViewController.h"
#import "NSObject+CompressImage.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "ZCHUploadCooperateCell.h"

@interface UploadAdvertisementController ()<UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, strong) NSMutableArray *headUpArray; // 企业广告上 控制cell个数
@property (nonatomic, strong) NSMutableArray *headUpImageArray; // 图片数组
@property (nonatomic, strong) NSMutableArray *headUpImageURLArray; // 上传成功后的图片URL数组
@property (nonatomic, strong) NSMutableArray *headUpImageIDARray; // 企业广告上  图片的ID数组
@property (nonatomic, strong) NSMutableArray *headUpWebsiteArray; // 网址数组

@property (nonatomic, strong) NSMutableArray *calculateUpArray; // 计算器广告位上 控制cell个数
@property (nonatomic, strong) NSMutableArray *calculateUpImageArray; // 图片数组
@property (nonatomic, strong) NSMutableArray *calculateUpImageURLArray; // 上传成功后的图片URL数组
@property (nonatomic, strong) NSMutableArray *calculateUpImageIDArray;
@property (nonatomic, strong) NSMutableArray *calculateUpWebsiteArray; // 网址数组

@property (nonatomic, strong) NSMutableArray *deletedImageIDArray; // 被删除的iamgeID

@property (nonatomic, strong) UIImage *headDownImage;
@property (nonatomic, strong) NSString *headDownImageURL;
@property (nonatomic, assign) NSInteger headDownImageID;
@property (nonatomic, strong) NSString *headDownWebsite; // 企业下网址

@property (nonatomic, strong) UIImage *calculateDownImage;
@property (nonatomic, strong) NSString *calculateDownImageURL;
@property (nonatomic, assign) NSInteger calculateDownImageID;
@property (nonatomic, strong) NSString *calculateDownWebsite; // 企业下网址

// cooperate 合作企业
@property (nonatomic, strong) UIImage *cooperateDownImage;
@property (nonatomic, strong) NSString *cooperateDownImageURL;
@property (nonatomic, assign) NSInteger cooperateDownImageID;

// 内网企业广告
@property (nonatomic, strong) NSMutableArray *innerYPArray; // 内网企业广告 控制cell个数
@property (nonatomic, strong) NSMutableArray *innerYPImageArray; // 内网企业广告 图片数组
@property (nonatomic, strong) NSMutableArray *innerYPImageURLArray; // 上传成功后的图片URL数组
@property (nonatomic, strong) NSMutableArray *innerYPImageIDArray; // 内网企业广告  图片的ID数组
@property (nonatomic, strong) NSMutableArray *innerYPWebsiteArray; // 内网企业广告 网址数组

// 内网工地广告  更名为  云管理广告图
@property (nonatomic, strong) NSMutableArray *innerConArray; // 内网工地广告 控制cell个数
@property (nonatomic, strong) NSMutableArray *innerConImageArray; // 内网工地广告 图片数组
@property (nonatomic, strong) NSMutableArray *innerConImageURLArray; // 上传成功后的图片URL数组
@property (nonatomic, strong) NSMutableArray *innerConImageIDArray; // 内网工地广告  图片的ID数组
@property (nonatomic, strong) NSMutableArray *innerConWebsiteArray; // 内网工地广告 网址数组

// 接口请求下来的数据
@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) NSIndexPath *indexPath; // 选择的cell的indexPath
// 选择照片自定义剪切框
@property (nonatomic, assign) ClipperType clipperType;
@property (nonatomic, assign) BOOL systemEditing;
@property (nonatomic, assign) BOOL isSystemType;

@end

@implementation UploadAdvertisementController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableView];
    self.title = @"上传广告";
   
    [self setupRight];
    self.headUpArray = [@[@"", @""] mutableCopy];
    self.headUpImageArray = [NSMutableArray array];
    self.headUpImageURLArray = [NSMutableArray array];
    self.headUpImageIDARray = [NSMutableArray array];
    self.headUpWebsiteArray = [NSMutableArray array];
    
    self.calculateUpArray = [@[@"", @""] mutableCopy];
    self.calculateUpImageArray = [NSMutableArray array];
    self.calculateUpImageURLArray = [NSMutableArray array];
    self.calculateUpImageIDArray = [NSMutableArray array];
    self.calculateUpWebsiteArray = [NSMutableArray array];
    
    self.deletedImageIDArray = [NSMutableArray array];
    
    self.innerYPArray = [@[@"", @""] mutableCopy];
    self.innerYPImageArray = [NSMutableArray array];
    self.innerYPImageURLArray = [NSMutableArray array];
    self.innerYPImageIDArray = [NSMutableArray array];
    self.innerYPWebsiteArray = [NSMutableArray array];
    
    self.innerConArray = [@[@"", @""] mutableCopy];
    self.innerConImageArray = [NSMutableArray array];
    self.innerConImageURLArray = [NSMutableArray array];
    self.innerConImageIDArray = [NSMutableArray array];
    self.innerConWebsiteArray = [NSMutableArray array];
    
    self.dataList = [NSMutableArray array];
    [self getData];
    
    // 单独处理这里的返回按钮(因为需要返回到根控制器)
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
    
}

- (void)setupRight {
    UIButton *save = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.saveBtn = save;
    save.frame = CGRectMake(0, 0, 44, 44);
    [save setTitle:@"保存" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    save.titleLabel.font = [UIFont systemFontOfSize:16];
    save.titleLabel.textAlignment = NSTextAlignmentRight;
    save.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [save addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:save];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)getData {
    
    // 查询公司广告图
    [[UIApplication sharedApplication].keyWindow hudShow];
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"img/findListByRelId.do"];

    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    NSString *paramString = self.companyID;
    [paramDic setObject:@(paramString.integerValue) forKeyedSubscript:@"companyId"];
    
    YSNLog(@"%@", paramDic);
    
    [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        // 加载成功
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        
        if (code == 1000) {
            NSDictionary *dict = [responseObj objectForKey:@"data"];
            [self.dataList addObjectsFromArray: [dict objectForKey:@"list"]];
            if (self.dataList.count > 0) {
                if (self.adBlock) {
                    self.adBlock(1);
                }
                [self.saveBtn setTitle:@"编辑" forState:UIControlStateNormal];
            } else {
                if (self.adBlock) {
                    self.adBlock(0);
                }
            }
            [self setNetDataList];
            
            
        } else if(code == 1001) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"公司id出现问题"];
        } else {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请求数据出错"];
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
        YSNLog(@"%@", NETERROR);
    }];
    
    
}

- (void)setNetDataList {
    [self.headUpImageArray removeAllObjects];
    [self.headUpWebsiteArray removeAllObjects];
    [self.calculateUpImageArray removeAllObjects];
    [self.calculateUpWebsiteArray removeAllObjects];
    
    [self.innerYPImageArray removeAllObjects];
    [self.innerYPWebsiteArray removeAllObjects];
    [self.innerConImageArray removeAllObjects];
    [self.innerConWebsiteArray removeAllObjects];
    
    if (self.dataList.count > 0) {
        [self.headUpArray removeAllObjects];
        [self.calculateUpArray removeAllObjects];
        [self.innerYPArray removeAllObjects];
        [self.innerConArray removeAllObjects];
        for (int i = 0; i < self.dataList.count; i ++) {
            NSDictionary *dataDict = self.dataList[i];

            switch ([dataDict[@"type"] integerValue]) {
                case 8: // 企业上
                {
                    [self.headUpImageURLArray addObject:dataDict[@"picUrl"]];
                    [self.headUpImageIDARray addObject:dataDict[@"picId"]];
                    [self.headUpArray addObject:@""];
                    NSInteger count = self.headUpImageURLArray.count;
                    if (self.headUpImageArray.count < count) {
                        [self.headUpImageArray addObject:dataDict[@"picUrl"]];
                    }
                    [self.headUpWebsiteArray addObject:dataDict[@"picHref"]];
                }
                    
                    break;
                case 9: // 企业下
                {
                    self.headDownImageURL = dataDict[@"picUrl"];
                    self.headDownImageID = [dataDict[@"picId"] integerValue];
                    self.headDownWebsite = dataDict[@"picHref"];
                    
                }
                    break;
                case 11: // 计算器上
                {
                    [self.calculateUpImageURLArray addObject:dataDict[@"picUrl"]];
                    [self.calculateUpImageIDArray addObject:dataDict[@"picId"]];
                    [self.calculateUpArray addObject:@""];
                    NSInteger count = self.calculateUpImageURLArray.count;
                    if (self.calculateUpImageArray.count < count) {
                        [self.calculateUpImageArray addObject:dataDict[@"picUrl"]];
                    }
                    [self.calculateUpWebsiteArray addObject:dataDict[@"picHref"]];
                }
                    break;
                case 12: // 计算器下
                {
                    self.calculateDownImageURL = dataDict[@"picUrl"];
                    self.calculateDownImageID = [dataDict[@"picId"] integerValue];
                    self.calculateDownWebsite = dataDict[@"picHref"];
                }
                    break;
                case 16: // 合作企业
                {
                    self.cooperateDownImageURL = dataDict[@"picUrl"];
                    self.cooperateDownImageID = [dataDict[@"picId"] integerValue];
                }
                    break;
//                case 18: // 内网企业  数值待定
//                {
//                    [self.innerYPImageURLArray addObject:dataDict[@"picUrl"]];
//                    [self.innerYPImageIDArray addObject:dataDict[@"picId"]];
//                    [self.innerYPArray addObject:@""];
//                    NSInteger count = self.innerYPImageURLArray.count;
//                    if (self.innerYPImageArray.count < count) {
//                        [self.innerYPImageArray addObject:dataDict[@"picUrl"]];
//                    }
//                    [self.innerYPWebsiteArray addObject:dataDict[@"picHref"]];
//                }
//                    break;
                case 19: // 内网工地  数值待定
                {
                    [self.innerConImageURLArray addObject:dataDict[@"picUrl"]];
                    [self.innerConImageIDArray addObject:dataDict[@"picId"]];
                    [self.innerConArray addObject:@""];
                    NSInteger count = self.innerConImageURLArray.count;
                    if (self.innerConImageArray.count < count) {
                        [self.innerConImageArray addObject:dataDict[@"picUrl"]];
                    }
                    [self.innerConWebsiteArray addObject:dataDict[@"picHref"]];
                }
                    break;
                default:
                    break;
            }
        }
        
        // 防止cell被销毁
        if (self.headUpArray.count == 0) {
            self.headUpArray = [@[@""] mutableCopy];
        }
        [self.headUpArray addObject:@""];
        
        if (self.calculateUpArray.count == 0) {
            self.calculateUpArray = [@[@""] mutableCopy];
        }
        [self.calculateUpArray addObject:@""];
        
        if (self.innerYPArray.count == 0) {
            self.innerYPArray = [@[@""] mutableCopy];
        }
        [self.innerYPArray addObject:@""];
        
        if (self.innerConArray.count == 0) {
            self.innerConArray = [@[@""] mutableCopy];
        }
        [self.innerConArray addObject:@""];
        
        [self.tableView reloadData];
        
    }
}
#pragma mark - 保存
- (void)saveAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    if ([sender.titleLabel.text isEqualToString:@"编辑"]) {
        [sender setTitle:@"保存" forState:UIControlStateNormal];
        [self.tableView reloadData];
        return;
    }else {
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
//        [self.tableView reloadData];
    }
    
    
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"img/saveImg.do"];
    

    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *multiDict = [NSMutableDictionary dictionary];
    NSMutableString *paramString = [NSMutableString string];
    [paramString appendString:@"["];
    for (int i = 0; i < self.headUpImageURLArray.count; i ++) {
        [multiDict setObject:self.companyID forKey:@"companyId"];
        [multiDict setObject:self.headUpImageURLArray[i] forKey:@"picUrl"];
        [multiDict setObject:self.headUpImageIDARray[i] forKey:@"picId"];
        [multiDict setObject:[NSString stringWithFormat:@"%d", i + 1] forKey:@"sort"];
        [multiDict setObject:@"8" forKey:@"type"];
        if (self.headUpImageArray.count > i) {
            [multiDict setObject:self.headUpWebsiteArray[i] forKey:@"picHref"];
        } else {
            [multiDict setObject:@"" forKey:@"picHref"];
        }
        
        NSString *dictStr = [self dictionaryToJson:multiDict];
        [paramString appendString:dictStr];
        [paramString appendString:@","];
        [multiDict removeAllObjects];
    }
    for (int i = 0; i< self.calculateUpImageURLArray.count; i ++) {
        [multiDict setObject:self.companyID forKey:@"companyId"];
        [multiDict setObject:self.calculateUpImageURLArray[i] forKey:@"picUrl"];
        [multiDict setObject:self.calculateUpImageIDArray[i] forKey:@"picId"];
        [multiDict setObject:[NSString stringWithFormat:@"%d", i + 1] forKey:@"sort"];
        [multiDict setObject:@"11" forKey:@"type"];
        if (self.calculateUpWebsiteArray.count > i) {
            [multiDict setObject:self.calculateUpWebsiteArray[i] forKey:@"picHref"];
        } else {
            [multiDict setObject:@"" forKey:@"picHref"];
        }
        
        NSString *dictStr = [self dictionaryToJson:multiDict];
        [paramString appendString:dictStr];
        [paramString appendString:@","];
        [multiDict removeAllObjects];
    }
    [multiDict setObject:self.companyID forKey:@"companyId"];
    [multiDict setObject:self.headDownImageURL ? self.headDownImageURL : @"" forKey:@"picUrl"];
    [multiDict setObject:self.headDownImageID>0?@(self.headDownImageID):@(0) forKey:@"picId"];
    [multiDict setObject:@"1" forKey:@"sort"];
    [multiDict setObject:@"9" forKey:@"type"];
    [multiDict setObject:self.headDownWebsite ? self.headDownWebsite : @"" forKey:@"picHref"];
    NSString *dictStr = [self dictionaryToJson:multiDict];
    [paramString appendString:dictStr];
    [paramString appendString:@","];
    [multiDict removeAllObjects];
    
    
    
    for (int i = 0; i < self.deletedImageIDArray.count; i ++) {
        [multiDict setObject:self.companyID forKey:@"companyId"];
        [multiDict setObject:@"" forKey:@"picUrl"];
        [multiDict setObject:self.deletedImageIDArray[i] forKey:@"picId"];
        [multiDict setObject:@"" forKey:@"picHref"];
        [multiDict setObject:@"0" forKey:@"sort"];
        [multiDict setObject:@"0" forKey:@"type"];
        NSString *dictStr = [self dictionaryToJson:multiDict];
        [paramString appendString:dictStr];
        [paramString appendString:@","];
        [multiDict removeAllObjects];
    }
    
    [multiDict setObject:self.companyID forKey:@"companyId"];
    [multiDict setObject:self.calculateDownImageURL?self.calculateDownImageURL:@"" forKey:@"picUrl"];
    [multiDict setObject:self.calculateDownImageID > 0 ? @(self.calculateDownImageID):@(0) forKey:@"picId"];
    [multiDict setObject:self.calculateDownWebsite ? self.calculateDownWebsite : @"" forKey:@"picHref"];
    [multiDict setObject:@"1" forKey:@"sort"];
    [multiDict setObject:@"12" forKey:@"type"];
    dictStr = [self dictionaryToJson:multiDict];
    [paramString appendString:dictStr];
    [paramString appendString:@","];
    [multiDict removeAllObjects];
    
    [multiDict setObject:self.companyID forKey:@"companyId"];
    [multiDict setObject:self.cooperateDownImageURL?self.cooperateDownImageURL:@"" forKey:@"picUrl"];
    [multiDict setObject:self.cooperateDownImageID > 0 ? @(self.cooperateDownImageID):@(0) forKey:@"picId"];
    [multiDict setObject:@"" forKey:@"picHref"];
    [multiDict setObject:@"1" forKey:@"sort"];
    [multiDict setObject:@"16" forKey:@"type"];
    dictStr = [self dictionaryToJson:multiDict];
    [paramString appendString:dictStr];
    [paramString appendString:@","];
    [multiDict removeAllObjects];
//    // 内网企业
//    for (int i = 0; i < self.innerYPImageURLArray.count; i ++) {
//        [multiDict setObject:self.companyID forKey:@"companyId"];
//        [multiDict setObject:self.innerYPImageURLArray[i] forKey:@"picUrl"];
//        [multiDict setObject:self.innerYPImageIDArray[i] forKey:@"picId"];
//        [multiDict setObject:[NSString stringWithFormat:@"%d", i + 1] forKey:@"sort"];
//        [multiDict setObject:@"18" forKey:@"type"];
//        if (self.innerYPImageArray.count > i) {
//            [multiDict setObject:self.innerYPWebsiteArray[i] forKey:@"picHref"];
//        } else {
//            [multiDict setObject:@"" forKey:@"picHref"];
//        }
//
//        NSString *dictStr = [self dictionaryToJson:multiDict];
//        [paramString appendString:dictStr];
//        [paramString appendString:@","];
//        [multiDict removeAllObjects];
//    }
    // 内网工地
    for (int i = 0; i < self.innerConImageURLArray.count; i ++) {
        [multiDict setObject:self.companyID forKey:@"companyId"];
        [multiDict setObject:self.innerConImageURLArray[i] forKey:@"picUrl"];
        [multiDict setObject:self.innerConImageIDArray[i] forKey:@"picId"];
        [multiDict setObject:[NSString stringWithFormat:@"%d", i + 1] forKey:@"sort"];
        [multiDict setObject:@"19" forKey:@"type"];
        if (self.innerConImageArray.count > i) {
            [multiDict setObject:self.innerConWebsiteArray[i] forKey:@"picHref"];
        } else {
            [multiDict setObject:@"" forKey:@"picHref"];
        }

        NSString *dictStr = [self dictionaryToJson:multiDict];
        [paramString appendString:dictStr];
        if (i != self.innerConImageURLArray.count - 1) {
            [paramString appendString:@","];
        }
        [multiDict removeAllObjects];

    }

    [paramString appendString:@"]"];
    
    [paramDic setObject:paramString forKeyedSubscript:@"imgList"];
    YSNLog(@"-------%@", paramDic);
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        // 加载成功
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        
        if (code == 1000) {
            
            if (self.backBlock) {
                self.backBlock();
            }
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"保存成功"];
            
            self.headUpArray = [@[@"", @""] mutableCopy];
            self.headUpImageURLArray = [NSMutableArray array];
            self.headUpImageIDARray = [NSMutableArray array];
            
            self.calculateUpArray = [@[@"", @""] mutableCopy];
            self.calculateUpImageURLArray = [NSMutableArray array];
            self.calculateUpImageIDArray = [NSMutableArray array];
            
            self.innerYPArray = [@[@"", @""] mutableCopy];
            self.innerYPImageURLArray = [NSMutableArray array];
            self.innerYPImageIDArray = [NSMutableArray array];
            
            self.innerConArray = [@[@"", @""] mutableCopy];
            self.innerConImageURLArray = [NSMutableArray array];
            self.innerConImageIDArray = [NSMutableArray array];
            
            self.deletedImageIDArray = [NSMutableArray array];
            
            self.dataList = [NSMutableArray array];
            
            [self getData];
            
            
        } else {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"保存数据出错"];
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
        YSNLog(@"%@", NETERROR);
    }];
    
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
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
            UploadAdvertisementCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
       
            if (self.indexPath.section == 0) {
                if (self.headUpImageURLArray.count == 0) {
                    // 添加图片 增加图片url
                    [self.headUpImageURLArray addObject:photoUrl];
                    [self.headUpImageIDARray addObject:@""];
                    [self.headUpWebsiteArray addObject:@""];
                } else {
                    if (self.headUpImageURLArray.count - 1 >= self.indexPath.row) {
                        // 修改图片 修改图片url
                        [self.headUpImageURLArray replaceObjectAtIndex:self.indexPath.row withObject:photoUrl];
                    } else {
                        // 添加图片 增加图片url
                        [self.headUpImageURLArray addObject:photoUrl];
                        [self.headUpImageIDARray addObject:@""];
                        [self.headUpWebsiteArray addObject:@""];
                    }
                }
                if (cell.placeHolderTV.text.length > 0) {
                    self.headUpWebsiteArray[self.indexPath.row] = cell.placeHolderTV.text;
                }
                
            }
            if(self.indexPath.section == 1) {
                self.headDownImageURL = photoUrl;
                if (!(self.headDownImageID > 0)) {
                    self.headDownImageID = 0;
                }
                self.headDownWebsite = cell.placeHolderTV.text;
            }
            if(self.indexPath.section == 2) {
                if (self.calculateUpImageURLArray.count == 0) {
                    // 添加图片 增加图片url
                    [self.calculateUpImageURLArray addObject:photoUrl];
                    [self.calculateUpImageIDArray addObject:@""];
                    [self.calculateUpWebsiteArray addObject:@""];
                } else {
                    if (self.calculateUpImageURLArray.count - 1 >= self.indexPath.row) {
                        // 修改图片 修改图片url
                        [self.calculateUpImageURLArray replaceObjectAtIndex:self.indexPath.row withObject:photoUrl];
                    } else {
                        // 添加图片 增加图片url   可能会有遗留问题还没测出啦
                        [self.calculateUpImageURLArray replaceObjectAtIndex:self.indexPath.row withObject:photoUrl];
                        [self.calculateUpImageIDArray addObject:@""];
                        [self.calculateUpWebsiteArray addObject:@""];
                    }
                }
                if (cell.placeHolderTV.text.length > 0) {
                    self.calculateUpWebsiteArray[self.indexPath.row] = cell.placeHolderTV.text;
                }
                
            }
            if (self.indexPath.section == 3) {
                self.calculateDownImageURL = photoUrl;
                if (!(self.calculateDownImageID > 0)) {
                    self.calculateDownImageID = 0;
                    self.calculateDownWebsite = cell.placeHolderTV.text;
                }
            }
            if (self.indexPath.section == 4) {
                self.cooperateDownImageURL = photoUrl;
                if (!(self.cooperateDownImageID > 0)) {
                    self.cooperateDownImageID = 0;
                }
            }
            if (self.indexPath.section == 5) {
                if (self.innerYPImageURLArray.count == 0) {
                    // 添加图片 增加图片url
                    [self.innerYPImageURLArray addObject:photoUrl];
                    [self.innerYPImageIDArray addObject:@""];
                    [self.innerYPWebsiteArray addObject:@""];
                } else {
                    if (self.innerYPImageURLArray.count - 1 >= self.indexPath.row) {
                        // 修改图片 修改图片url
                        [self.innerYPImageURLArray replaceObjectAtIndex:self.indexPath.row withObject:photoUrl];
                    } else {
                        // 添加图片 增加图片url
                        [self.innerYPImageURLArray addObject:photoUrl];
                        [self.innerYPImageIDArray addObject:@""];
                        [self.innerYPWebsiteArray addObject:@""];
                    }
                }
                if (cell.placeHolderTV.text.length > 0) {
                    self.innerYPWebsiteArray[self.indexPath.row] = cell.placeHolderTV.text;
                }
                
            }
            if (self.indexPath.section == 6) {
                if (self.innerConImageURLArray.count == 0) {
                    // 添加图片 增加图片url
                    [self.innerConImageURLArray addObject:photoUrl];
                    [self.innerConImageIDArray addObject:@""];
                    [self.innerConWebsiteArray addObject:@""];
                } else {
                    if (self.innerConImageURLArray.count - 1 >= self.indexPath.row) {
                        // 修改图片 修改图片url
                        [self.innerConImageURLArray replaceObjectAtIndex:self.indexPath.row withObject:photoUrl];
                    } else {
                        // 添加图片 增加图片url
                        [self.innerConImageURLArray addObject:photoUrl];
                        [self.innerConImageIDArray addObject:@""];
                        [self.innerConWebsiteArray addObject:@""];
                    }
                }
                if (cell.placeHolderTV.text.length > 0) {
                    self.innerConWebsiteArray[self.indexPath.row] = cell.placeHolderTV.text;
                }
                
            }
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            [[PublicTool defaultTool] publicToolsHUDStr:@"图片上传成功" controller:self sleep:1.5];
        } else {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            [[PublicTool defaultTool] publicToolsHUDStr:@"图片上传失败" controller:self sleep:1.5];
            
            if (self.indexPath.section == 4) {
                ZCHUploadCooperateCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
                cell.imageV.hidden = NO;
                cell.imageV.image = [UIImage imageNamed:@"jia_kuang"];
            } else {
                UploadAdvertisementCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
                cell.imageV.hidden = NO;
                cell.imageV.image = [UIImage imageNamed:@"jia_kuang"];
            }
            
            if (self.indexPath.section == 0) {
                [self.headUpImageArray removeObjectAtIndex:self.indexPath.row];
            }
            if (self.indexPath.section == 1) {
                self.headDownImage = nil;
            }
            if (self.indexPath.section == 2) {
                [self.calculateUpImageArray removeObjectAtIndex:self.indexPath.row];
            }
            if (self.indexPath.section == 3) {
                self.calculateDownImage = nil;
            }
            if (self.indexPath.section == 4) {
                self.cooperateDownImage = nil;
            }
            if (self.indexPath.section == 5) {
                [self.innerYPImageArray removeObjectAtIndex:self.indexPath.row];
            }
            if (self.indexPath.section == 6) {
                [self.innerConImageArray removeObjectAtIndex:self.indexPath.row];
            }
        }
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"图片上传失败" controller:self sleep:1.5];
    }];
}

#pragma  mark - 继续添加   
// section的值为tag值， 对应的cell 加1  然后刷新这个section
- (void)addImage:(UIButton *) sender {
    [self.view endEditing:YES];
    if (sender.tag == 0) {
        
        if (((NSString *)self.headUpImageURLArray.lastObject).length == 0) {
            return;
        }
        if (self.headUpArray.count >=7) {
            [self.view hudShowWithText:@"最多添加6张照片"];
            return;
        }
        [self.headUpArray addObject:@""];
        [self.headUpImageURLArray addObject:@""];
        [self.headUpImageIDARray addObject:@""];
        [self.headUpWebsiteArray addObject:@""];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.headUpArray.count - 2 inSection:0];

        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        UploadAdvertisementCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.placeHolderTV.text = @"";
    }
    if (sender.tag == 2) {
        if (((NSString *)self.calculateUpImageURLArray.lastObject).length == 0) {
            return;
        }
        if (self.calculateUpArray.count >= 7) {
            [self.view hudShowWithText:@"最多添加6张照片"];
            return;
        }

        [self.calculateUpArray addObject:@""];
        [self.calculateUpImageURLArray addObject:@""];
        [self.calculateUpImageIDArray addObject:@""];
        [self.calculateUpWebsiteArray addObject:@""];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.calculateUpArray.count - 2 inSection:2];
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        UploadAdvertisementCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.placeHolderTV.text = @"";
    }

    if (sender.tag == 5) {
        if (((NSString *)self.innerYPImageURLArray.lastObject).length == 0) {
            return;
        }
        if (self.innerYPArray.count >= 7) {
            [self.view hudShowWithText:@"最多添加6张照片"];
            return;
        }
        
        [self.innerYPArray addObject:@""];
        [self.innerYPImageURLArray addObject:@""];
        [self.innerYPImageIDArray addObject:@""];
        [self.innerYPWebsiteArray addObject:@""];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.innerYPArray.count - 2 inSection:5];
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        UploadAdvertisementCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.placeHolderTV.text = @"";
    }
    
    if (sender.tag == 6) {
        if (((NSString *)self.innerConImageURLArray.lastObject).length == 0) {
            return;
        }
        if (self.innerConArray.count >= 7) {
            [self.view hudShowWithText:@"最多添加6张照片"];
            return;
        }
        
        [self.innerConArray addObject:@""];
        [self.innerConImageURLArray addObject:@""];
        [self.innerConImageIDArray addObject:@""];
        [self.innerConWebsiteArray addObject:@""];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.innerConArray.count - 2 inSection:6];
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        UploadAdvertisementCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.placeHolderTV.text = @"";
    }

    
    
    
}

#pragma mark - UITablViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 6;
//    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if ([self.saveBtn.titleLabel.text isEqualToString:@"保存"]) {
            return self.headUpArray.count;
        } else {
            return self.headUpArray.count - 1;
        }
        
    } else if(section == 1) {
        if (self.isShop) {
            return 0;
        } else {
            return 1;
        }
    } else if(section == 2) {
        if ([self.saveBtn.titleLabel.text isEqualToString:@"保存"]) {
            return self.calculateUpArray.count;
        } else {
            return self.calculateUpArray.count - 1;
        }
        
    } else if(section == 3)  {
        
        if (self.isShop) {
            return 0;
        } else {
            return 1;
        }
    } else if(section == 4)  {
        return 1;
    } else if(section == 5)  {
        if (self.isShop) {
            return 0;
        }
        if ([self.saveBtn.titleLabel.text isEqualToString:@"保存"]) {
            return self.innerYPArray.count;
        } else {
            
            return self.innerYPArray.count - 1;
        }
    } else if(section == 6)  {
//        if (self.isShop) {
//            return 0;
//        }
        if ([self.saveBtn.titleLabel.text isEqualToString:@"保存"]) {
            return self.innerConArray.count;
        } else {
            return self.innerConArray.count - 1;
        }
    } else {
        return 0;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UploadAdvertisementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UploadAdvertisementCell" forIndexPath:indexPath];
    cell.promptLabel.text = @"建议上传1000*600尺寸";
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    if ([self.saveBtn.titleLabel.text isEqualToString:@"编辑"]) {
        cell.placeHolderTV.userInteractionEnabled = NO;
    } else {
        cell.placeHolderTV.userInteractionEnabled = YES;
    }
    cell.placeHolderTV.tag = indexPath.section * 10000 + indexPath.row;
    cell.placeHolderTV.delegate = self;
    
    if ((indexPath.section == 0 && indexPath.row == self.headUpArray.count - 1) || (indexPath.section == 2 && indexPath.row == self.calculateUpArray.count - 1) || (indexPath.section == 5 && indexPath.row == self.innerYPArray.count - 1) || (indexPath.section == 6 && indexPath.row == self.innerConArray.count - 1)) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setTitle:@"继续添加" forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-16);
            make.top.equalTo(0);
            make.bottom.equalTo(0);
            make.height.equalTo(44);
        }];
        addBtn.tag = indexPath.section;
        [addBtn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
        
        if (indexPath.section == 6) {
            addBtn.hidden = YES;
        } else {
            addBtn.hidden = NO;
        }
        return cell;
    } else {
        if (indexPath.section == 0) {
            cell.promptLabel.hidden = NO;
            cell.lineViewTopCon.constant = 38.5;
            if (self.headUpImageURLArray.count == 0 || indexPath.row > self.headUpImageURLArray.count - 1) {
                cell.imageV.image = [UIImage imageNamed:@"jia_kuang"];
                cell.placeHolderTV.text = @"";
                if ([self.saveBtn.titleLabel.text isEqualToString:@"编辑"]) {
                    cell.imageV.hidden = YES;
                } else {
                    cell.imageV.hidden = NO;
                }
            } else {
                if ([self.headUpImageURLArray[indexPath.row] isEqualToString:@""]) {
                    cell.imageV.image = [UIImage imageNamed:@"jia_kuang"];
                    cell.placeHolderTV.text = @"";
                    if ([self.saveBtn.titleLabel.text isEqualToString:@"编辑"]) {
                        cell.imageV.hidden = YES;
                    } else {
                        cell.imageV.hidden = NO;
                    }
                } else {
                    cell.imageV.hidden = NO;
                    // 使用url和选择的图片设置imageView的图片
                    if ([self.headUpImageArray[indexPath.row] isKindOfClass:[NSString class]]) {
                        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:self.headUpImageArray[indexPath.row]] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            if (error) {
                                return;
                            }
                            [self.headUpImageArray replaceObjectAtIndex:indexPath.row withObject:image];
                            [cell setNeedsLayout];
                            [cell layoutIfNeeded];
                            //                            [cell layoutSubviews];
                        }];
                    } else {
                        cell.imageV.image = self.headUpImageArray[indexPath.row];
                    }
                    if (self.headUpWebsiteArray.count >= indexPath.row) {
                        cell.placeHolderTV.text = self.headUpWebsiteArray[indexPath.row];
                    }
                    
                    
                }
                
            }
        }
        if (indexPath.section == 1) {
            cell.promptLabel.hidden = YES;
            cell.lineViewTopCon.constant = 10;
            if (self.headDownImageURL.length > 0 || self.headDownImageID > 0) {
                cell.imageV.hidden = NO;
                if (self.headDownImage == nil) {
                    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:self.headDownImageURL] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        if (error) {
                            return;
                        }
                        self.headDownImage = image;
                        [cell setNeedsLayout];
                        [cell layoutIfNeeded];
                    }];
                } else {
                    cell.imageV.image = self.headDownImage;
                }
                cell.placeHolderTV.text = self.headDownWebsite;
                
            } else {
                cell.imageV.image = [UIImage imageNamed:@"jia_kuang"];
                cell.placeHolderTV.text = @"";
                if ([self.saveBtn.titleLabel.text isEqualToString:@"编辑"]) {
                    cell.imageV.hidden = YES;
                }
                if ([self.saveBtn.titleLabel.text isEqualToString:@"保存"]) {
                    cell.imageV.hidden = NO;
                }
            }
            if (self.headDownImageURL.length == 0 || self.headDownImageURL == nil) {
                cell.imageV.image = [UIImage imageNamed:@"jia_kuang"];
                cell.placeHolderTV.text = @"";
                if ([self.saveBtn.titleLabel.text isEqualToString:@"编辑"]) {
                    cell.imageV.hidden = YES;
                }
                if ([self.saveBtn.titleLabel.text isEqualToString:@"保存"]) {
                    cell.imageV.hidden = NO;
                }
            }
            
        }
        if (indexPath.section == 2) {
            cell.promptLabel.hidden = NO;
            cell.lineViewTopCon.constant = 38.5;
            if (self.calculateUpImageURLArray.count == 0 || indexPath.row > self.calculateUpImageURLArray.count - 1) {
                cell.imageV.image = [UIImage imageNamed:@"jia_kuang"];
                cell.placeHolderTV.text = @"";
                if ([self.saveBtn.titleLabel.text isEqualToString:@"编辑"]) {
                    cell.imageV.hidden = YES;
                } else {
                    cell.imageV.hidden = NO;
                }
            } else {
                if ([self.calculateUpImageURLArray[indexPath.row] isEqualToString:@""]) {
                    cell.imageV.image = [UIImage imageNamed:@"jia_kuang"];
                    cell.placeHolderTV.text = @"";
                    if ([self.saveBtn.titleLabel.text isEqualToString:@"编辑"]) {
                        cell.imageV.hidden = YES;
                    } else {
                        cell.imageV.hidden = NO;
                    }
                } else {
                    cell.imageV.hidden = NO;
                    // 使用url和选择的图片设置imageView的图片
                    if ([self.calculateUpImageArray[indexPath.row] isKindOfClass:[NSString class]]) {
                        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:self.calculateUpImageArray[indexPath.row]] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            if (error) {
                                return;
                            }
                            [self.calculateUpImageArray replaceObjectAtIndex:indexPath.row withObject:image];
                            [cell setNeedsLayout];
                            [cell layoutIfNeeded];
                        }];
                    } else {
                        cell.imageV.image = self.calculateUpImageArray[indexPath.row];
                    }
                    
                    if (self.calculateUpWebsiteArray.count > indexPath.row) {
                        cell.placeHolderTV.text = self.calculateUpWebsiteArray[indexPath.row];                }
                    }
                
            }
            
        }
        if (indexPath.section == 3) {
            cell.promptLabel.hidden = YES;
            cell.lineViewTopCon.constant = 10;
            if (self.calculateDownImageURL.length > 0 || self.headDownImageID > 0) {
                cell.imageV.hidden = NO;
                if (self.calculateDownImage == nil) {
                    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:self.calculateDownImageURL] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        if (error) {
                            return;
                        }
                        self.calculateDownImage = image;
                        [cell setNeedsLayout];
                        [cell layoutIfNeeded];
                    }];
                } else {
                    cell.imageV.image = self.calculateDownImage;
                }
                cell.placeHolderTV.text = self.calculateDownWebsite;
                
            } else {
                cell.imageV.image = [UIImage imageNamed:@"jia_kuang"];
                cell.placeHolderTV.text = @"";
                if ([self.saveBtn.titleLabel.text isEqualToString:@"编辑"]) {
                    cell.imageV.hidden = YES;
                }
                if ([self.saveBtn.titleLabel.text isEqualToString:@"保存"]) {
                    cell.imageV.hidden = NO;
                }
            }
            if (self.calculateDownImageURL.length == 0 || self.calculateDownImageURL == nil) {
                cell.imageV.image = [UIImage imageNamed:@"jia_kuang"];
                cell.placeHolderTV.text = @"";
                if ([self.saveBtn.titleLabel.text isEqualToString:@"编辑"]) {
                    cell.imageV.hidden = YES;
                }
                if ([self.saveBtn.titleLabel.text isEqualToString:@"保存"]) {
                    cell.imageV.hidden = NO;
                }
            }
        }
        
        if (indexPath.section == 4) {
            
            ZCHUploadCooperateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCHUploadCooperateCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
//            ZCHUploadCooperateCell *cell = [ZCHUploadCooperateCell blej_viewFromXib];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.promptLabel.hidden = NO;
            cell.lineViewTopCon.constant = 38.5;
            if (self.cooperateDownImageURL.length > 0 || self.cooperateDownImageID > 0) {
                cell.imageV.hidden = NO;
                if (self.cooperateDownImage == nil) {
                    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:self.cooperateDownImageURL] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        if (error) {
                            return;
                        }
                        self.cooperateDownImage = image;
                        [cell setNeedsLayout];
                        [cell layoutIfNeeded];
                    }];
                } else {
                    cell.imageV.image = self.cooperateDownImage;
                }
                
            } else {
                cell.imageV.image = [UIImage imageNamed:@"jia_kuang"];
                if ([self.saveBtn.titleLabel.text isEqualToString:@"编辑"]) {
                    cell.imageV.hidden = YES;
                }
                if ([self.saveBtn.titleLabel.text isEqualToString:@"保存"]) {
                    cell.imageV.hidden = NO;
                }
            }
            if (self.cooperateDownImageURL.length == 0 || self.cooperateDownImageURL == nil) {
                cell.imageV.image = [UIImage imageNamed:@"jia_kuang"];
                if ([self.saveBtn.titleLabel.text isEqualToString:@"编辑"]) {
                    cell.imageV.hidden = YES;
                }
                if ([self.saveBtn.titleLabel.text isEqualToString:@"保存"]) {
                    cell.imageV.hidden = NO;
                }
            }
            return cell;
        }
        
//        if (indexPath.section == 5) {
//            cell.promptLabel.hidden = NO;
//            cell.lineViewTopCon.constant = 38.5;
//            if (self.innerYPImageURLArray.count == 0 || indexPath.row > self.innerYPImageURLArray.count - 1) {
//                cell.imageV.image = [UIImage imageNamed:@"jia_kuang"];
//                cell.placeHolderTV.text = @"";
//                if ([self.saveBtn.titleLabel.text isEqualToString:@"编辑"]) {
//                    cell.imageV.hidden = YES;
//                } else {
//                    cell.imageV.hidden = NO;
//                }
//            } else {
//                if ([self.innerYPImageURLArray[indexPath.row] isEqualToString:@""]) {
//                    cell.imageV.image = [UIImage imageNamed:@"jia_kuang"];
//                    cell.placeHolderTV.text = @"";
//                    if ([self.saveBtn.titleLabel.text isEqualToString:@"编辑"]) {
//                        cell.imageV.hidden = YES;
//                    } else {
//                        cell.imageV.hidden = NO;
//                    }
//                } else {
//                    cell.imageV.hidden = NO;
//                    // 使用url和选择的图片设置imageView的图片
//                    if ([self.innerYPImageArray[indexPath.row] isKindOfClass:[NSString class]]) {
//                        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:self.innerYPImageArray[indexPath.row]] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                            if (error) {
//                                return;
//                            }
//                            [self.innerYPImageArray replaceObjectAtIndex:indexPath.row withObject:image];
//                            [cell setNeedsLayout];
//                            [cell layoutIfNeeded];
//                            //                            [cell layoutSubviews];
//                        }];
//                    } else {
//                        cell.imageV.image = self.innerYPImageArray[indexPath.row];
//                    }
//                    if (self.innerYPWebsiteArray.count >= indexPath.row) {
//                        cell.placeHolderTV.text = self.innerYPWebsiteArray[indexPath.row];
//                    }
//                }
//            }
//        }
//云管理广告图
        if (indexPath.section == 5) {
            cell.promptLabel.text = @"建议上传684*276尺寸";
            cell.promptLabel.hidden = NO;
            cell.lineViewTopCon.constant = 38.5;
            if (self.innerConImageURLArray.count == 0 || indexPath.row > self.innerConImageURLArray.count - 1) {
                cell.imageV.image = [UIImage imageNamed:@"jia_kuang"];
                cell.placeHolderTV.text = @"";
                if ([self.saveBtn.titleLabel.text isEqualToString:@"编辑"]) {
                    cell.imageV.hidden = YES;
                } else {
                    cell.imageV.hidden = NO;
                }
            } else {
                if ([self.innerConImageURLArray[indexPath.row] isEqualToString:@""]) {
                    cell.imageV.image = [UIImage imageNamed:@"jia_kuang"];
                    cell.placeHolderTV.text = @"";
                    if ([self.saveBtn.titleLabel.text isEqualToString:@"编辑"]) {
                        cell.imageV.hidden = YES;
                    } else {
                        cell.imageV.hidden = NO;
                    }
                } else {
                    cell.imageV.hidden = NO;
                    // 使用url和选择的图片设置imageView的图片
                    if ([self.innerConImageArray[indexPath.row] isKindOfClass:[NSString class]]) {
                        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:self.innerConImageArray[indexPath.row]] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            if (error) {
                                return;
                            }
                            [self.innerConImageArray replaceObjectAtIndex:indexPath.row withObject:image];
                            [cell setNeedsLayout];
                            [cell layoutIfNeeded];
                            //                            [cell layoutSubviews];
                        }];
                    } else {
                        cell.imageV.image = self.innerConImageArray[indexPath.row];
                    }
                    if (self.innerConWebsiteArray.count >= indexPath.row) {
                        cell.placeHolderTV.text = self.innerConWebsiteArray[indexPath.row];
                    }
                }
            }
        }
        return  cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isShop) {
        if (section == 1 || section == 3 || section == 5) {
            return 0.000000000001;
        } else {
            return 34;
        }
    } else {
        return 34;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00000001;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    switch (section) {
        case 0:
            if (self.isShop) {
                title = @"店铺/公司企业广告位";
            } else {
                title = @"店铺/公司企业广告位（上）";
            }
            
            break;
        case 1:
            if (self.isShop) {
                return nil;
            } else {
                title = @"店铺/公司企业广告位（下）";
            }
            
            break;
        case 2:
            if (self.isShop) {
                title = @"计算器广告位";
            } else {
                title = @"计算器广告位（上）";
            }
            
            break;
        case 3:
            if (self.isShop) {
                
                return nil;
            } else {
                title = @"计算器广告位（下）";
            }
            
            break;
        case 4:
            if (self.isShop) {
                title = @"合作企业广告位";
            } else {
                title = @"合作企业广告位";
            }
            
            break;
//        case 5:
//            if (self.isShop) {
//                return nil;
//            } else {
//                title = @"内网企业广告位";
//            }
//            break;
        case 5:
            title = @"云管理广告图";
            break;
        default:
            break;
    }
    return title;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }

    UITextField *text = [[UITextField alloc] init];
    text.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 34);
    text.backgroundColor = [UIColor clearColor];
    text.textColor = [UIColor darkGrayColor];
    text.font = [UIFont boldSystemFontOfSize:16];
    text.text = sectionTitle;
    text.textAlignment = NSTextAlignmentCenter;
    text.userInteractionEnabled = NO;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 34)];
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:text];
    text.centerY = view.centerY;
    return view;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ((indexPath.section == 0 && indexPath.row == self.headUpArray.count - 1) || (indexPath.section == 2 && indexPath.row == self.calculateUpArray.count - 1) || (indexPath.section == 5 && indexPath.row == self.innerYPArray.count - 1) || (indexPath.section == 6 && indexPath.row == self.innerConArray.count - 1)) {
        return ;
    }
    
    if ([self.saveBtn.titleLabel.text isEqualToString:@"编辑"]) {
        return;
    }
    self.indexPath = indexPath;
    
    
    if (indexPath.section == 0 ||indexPath.section == 2 || indexPath.section == 4) { // 自定义剪裁图片
        self.clipperType = ClipperTypeImgMove;
        self.systemEditing = NO;
        self.isSystemType = YES; // 是否剪裁图片  NO剪裁  YES不剪裁
    } else {
        self.systemEditing = NO;
        self.isSystemType = YES;
    }
    if ([TTHelper checkPhotoLibraryAuthorizationStatus]) {
        UIActionSheet *_sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"拍照", @"从相册选择", nil];
        [_sheet showInView:[UIApplication sharedApplication].keyWindow];
    }
    
}


//是否允许编辑，默认值是YES
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 0 && indexPath.row == self.headUpArray.count - 1)|| (indexPath.section == 2 && indexPath.row == self.calculateUpArray.count - 1) || (indexPath.section == 5 && indexPath.row == self.innerYPArray.count - 1) || (indexPath.section == 6 && indexPath.row == self.innerConArray.count - 1)) {
        return UITableViewCellEditingStyleNone;
    }
    if ([self.saveBtn.titleLabel.text isEqualToString:@"编辑"]) {
        return UITableViewCellEditingStyleNone;
    }
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
        {
            if (self.headUpImageArray.count < row + 1) {
                return UITableViewCellEditingStyleNone;
            }
        }
            break;
        case 1:
        {
            if (self.headDownImage == nil) {
                return UITableViewCellEditingStyleNone;
            }
        }
            break;
        case 2:
        {
            if (self.calculateUpImageArray.count < row + 1) {
                return UITableViewCellEditingStyleNone;
            }
        }
            break;
        case 3:
        {
            if (self.calculateDownImage == nil) {
                return UITableViewCellEditingStyleNone;
            }
        }
            break;
        case 5:
        {
            if (self.innerYPImageArray.count < row + 1) {
                return UITableViewCellEditingStyleNone;
            }
        }
            break;
        case 6:
        {
            if (self.innerConImageArray.count < row + 1) {
                return UITableViewCellEditingStyleNone;
            }
        }
            break;
        default:
            return  YES;
            break;
    }
    
    return UITableViewCellEditingStyleDelete;
}

//修改删除按钮的title
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        YSNLog(@"删除");
        UploadAdvertisementCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (indexPath.section == 1) {
            // 只删除图片不删除cell
            self.headDownImage = nil;
            cell.imageV.image = [UIImage imageNamed:@"jia_kuang"];
            cell.placeHolderTV.text = @"";
            self.headDownImageURL = @"";
            self.headDownWebsite = @"";
            [self.deletedImageIDArray addObject:@(self.headDownImageID)];
            self.headDownImageID = 0;
            
        }
        if (indexPath.section == 3) {
            // 只删除图片不删除cell
            self.calculateDownImage = nil;
            cell.imageV.image = [UIImage imageNamed:@"jia_kuang"];
            cell.placeHolderTV.text = @"";
            self.calculateDownImageURL = @"";
            self.calculateDownWebsite = @"";
            [self.deletedImageIDArray addObject: @(self.calculateDownImageID)];
            self.calculateDownImageID = 0;
        }
        if (indexPath.section == 4) {
            ZCHUploadCooperateCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            // 只删除图片不删除cell
            self.cooperateDownImage = nil;
            cell.imageV.image = [UIImage imageNamed:@"jia_kuang"];
            self.cooperateDownImageURL = @"";
            [self.deletedImageIDArray addObject: @(self.cooperateDownImageID)];
        }
        if (indexPath.section == 0) {
            if (self.headUpArray.count == 2) {
                // 只删除图片不删除cell
                
                if (self.headUpImageURLArray.count > 0) {
                    [self.headUpArray replaceObjectAtIndex:indexPath.row withObject:@""];
                    cell.imageV.image = [UIImage imageNamed:@"jia_kuang"];
                    cell.placeHolderTV.text = @"";
                    [self.headUpImageURLArray removeObjectAtIndex:indexPath.row];
                    [self.deletedImageIDArray addObject:self.headUpImageIDARray[indexPath.row]];
                    [self.headUpImageIDARray removeObjectAtIndex:indexPath.row];
                    [self.headUpImageArray removeObjectAtIndex:indexPath.row];
                    [self.headUpWebsiteArray removeObjectAtIndex:indexPath.row];
                } else {
                    
                }
                
            } else{
                // 删除图片和cell
                [self.headUpArray removeObjectAtIndex:indexPath.row];
                [self.headUpImageURLArray removeObjectAtIndex:indexPath.row];
                [self.deletedImageIDArray addObject:self.headUpImageIDARray[indexPath.row]];
                [self.headUpImageIDARray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self.headUpImageArray removeObjectAtIndex:indexPath.row];
                [self.headUpWebsiteArray removeObjectAtIndex:indexPath.row];
            }
        }
        if (indexPath.section == 2) {
            if (self.calculateUpArray.count == 2) {
                // 只删除图片不删除cell
                if (self.calculateUpImageURLArray.count > 0) {
                    [self.calculateUpArray replaceObjectAtIndex:indexPath.row withObject:@""];
                    cell.imageV.image = [UIImage imageNamed:@"jia_kuang"];
                    cell.placeHolderTV.text = @"";
                    [self.calculateUpImageURLArray removeObjectAtIndex:indexPath.row];
                    [self.deletedImageIDArray addObject:self.calculateUpImageIDArray[indexPath.row]];
                    [self.calculateUpImageIDArray removeObjectAtIndex:indexPath.row];
                    [self.calculateUpImageArray removeObjectAtIndex:indexPath.row];
                    [self.calculateUpWebsiteArray removeObjectAtIndex:indexPath.row];
                } else {
                    
                }
                
            } else{
                // 删除图片和cell
                [self.calculateUpArray removeObjectAtIndex:indexPath.row];
                [self.calculateUpImageURLArray removeObjectAtIndex:indexPath.row];
                [self.deletedImageIDArray addObject:self.calculateUpImageIDArray[indexPath.row]];
                [self.calculateUpImageIDArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self.calculateUpImageArray removeObjectAtIndex:indexPath.row];
                [self.calculateUpWebsiteArray removeObjectAtIndex:indexPath.row];
            }
        }
        
        if (indexPath.section == 5) {
            if (self.innerYPArray.count == 2) {
                // 只删除图片不删除cell
                if (self.innerYPImageURLArray.count > 0) {
                    [self.innerYPArray replaceObjectAtIndex:indexPath.row withObject:@""];
                    cell.imageV.image = [UIImage imageNamed:@"jia_kuang"];
                    cell.placeHolderTV.text = @"";
                    [self.innerYPImageURLArray removeObjectAtIndex:indexPath.row];
                    [self.deletedImageIDArray addObject:self.innerYPImageIDArray[indexPath.row]];
                    [self.innerYPImageIDArray removeObjectAtIndex:indexPath.row];
                    [self.innerYPImageArray removeObjectAtIndex:indexPath.row];
                    [self.innerYPWebsiteArray removeObjectAtIndex:indexPath.row];
                } else {
                    
                }
                
            } else{
                // 删除图片和cell
                [self.innerYPArray removeObjectAtIndex:indexPath.row];
                [self.innerYPImageURLArray removeObjectAtIndex:indexPath.row];
                [self.deletedImageIDArray addObject:self.innerYPImageIDArray[indexPath.row]];
                [self.innerYPImageIDArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self.innerYPImageArray removeObjectAtIndex:indexPath.row];
                [self.innerYPWebsiteArray removeObjectAtIndex:indexPath.row];
            }
        }
        
        if (indexPath.section == 6) {
            if (self.innerConArray.count == 2) {
                // 只删除图片不删除cell
                if (self.innerConImageURLArray.count > 0) {
                    [self.innerConArray replaceObjectAtIndex:indexPath.row withObject:@""];
                    cell.imageV.image = [UIImage imageNamed:@"jia_kuang"];
                    cell.placeHolderTV.text = @"";
                    [self.innerConImageURLArray removeObjectAtIndex:indexPath.row];
                    [self.deletedImageIDArray addObject:self.innerConImageIDArray[indexPath.row]];
                    [self.innerConImageIDArray removeObjectAtIndex:indexPath.row];
                    [self.innerConImageArray removeObjectAtIndex:indexPath.row];
                    [self.innerConWebsiteArray removeObjectAtIndex:indexPath.row];
                } else {
                    
                }
                
            } else{
                // 删除图片和cell
                [self.innerConArray removeObjectAtIndex:indexPath.row];
                [self.innerConImageURLArray removeObjectAtIndex:indexPath.row];
                [self.deletedImageIDArray addObject:self.innerConImageIDArray[indexPath.row]];
                [self.innerConImageIDArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self.innerConImageArray removeObjectAtIndex:indexPath.row];
                [self.innerConWebsiteArray removeObjectAtIndex:indexPath.row];
            }
        }
        
        [tableView setEditing:NO animated:YES];
//        [self.tableView reloadData];
    }
    [tableView setEditing:NO animated:YES];
}


#pragma mark - UItextViewDewlegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSInteger row = textView.tag%10000;
    NSInteger section = textView.tag / 10000;
    switch (section) {
        case 0:
        {
            if (self.headUpImageArray.count < row + 1) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请先上传广告图"];
                return  NO;
            }
        }
            break;
        case 1:
        {
            if (self.headDownImage == nil) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请先上传广告图"];
                return  NO;
            }
        }
            break;
        case 2:
        {
            if (self.calculateUpImageArray.count < row + 1) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请先上传广告图"];
                return  NO;
            }
        }
            break;
        case 3:
        {
            if (self.calculateDownImage == nil) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请先上传广告图"];
                return  NO;
            }
        }
            break;
        case 5:
        {
            if (self.innerYPImageArray.count < row + 1) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请先上传广告图"];
                return  NO;
            }
        }
            break;
        case 6:
        {
            if (self.innerConImageArray.count < row + 1) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请先上传广告图"];
                return  NO;
            }
        }
            break;
        default:
            return  YES;
            break;
    }
    return  YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
//    NSIndexPath *indexP = [NSIndexPath indexPathForRow:textView.tag%10000 inSection:textView.tag / 10000];
    NSInteger section = textView.tag / 10000;
    switch (section) {
        case 0:
        {
            self.headUpWebsiteArray[textView.tag%10000] = textView.text;
        }
            break;
        case 1:
        {
            self.headDownWebsite = textView.text;
        }
            break;
        case 2:
        {
            self.calculateUpWebsiteArray[textView.tag%10000] = textView.text;
        }
            break;
        case 3:
        {
            self.calculateDownWebsite = textView.text;
        }
            break;
        case 5:
        {
            self.innerYPWebsiteArray[textView.tag%10000] = textView.text;
        }
            break;
        case 6:
        {
            self.innerConWebsiteArray[textView.tag%10000] = textView.text;
        }
            break;
        default:
            break;
    }
    
    if (![textView.text ew_isUrlString]) {
        [[UIApplication sharedApplication].keyWindow showHudFailed:@"请输入正确的网址链接"];
    }
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    dispatch_after(0., dispatch_get_main_queue(), ^{
        if (buttonIndex == 0) {
            [self photoWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        else if(buttonIndex == 1) {
            [self photoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    });
}

- (void)photoWithSourceType:(UIImagePickerControllerSourceType)type{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = type;
    imagePicker.allowsEditing = self.systemEditing;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}



#pragma mark - PickerImage完成后的代理方法
//图片选择完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    __block UIImage * chooseImage;

    if (!self.isSystemType) {
        //自定义裁剪方式
        UIImage*image = [self turnImageWithInfo:info];
        // 图片裁切大小
        CGSize imageSize;
        
        if (self.indexPath.section == 4) {
            
            imageSize = CGSizeMake(kSCREEN_WIDTH, kSCREEN_WIDTH * 3.0 / 8.0);
        } else {
            
            imageSize = CGSizeMake(kSCREEN_WIDTH, kSCREEN_WIDTH * 3.0 / 5.0);
        }
//        imageSize = CGSizeMake(kSCREEN_WIDTH, kSCREEN_WIDTH * 3.0 / 5.0);
        
        HKImageClipperViewController *clipperVC = [[HKImageClipperViewController alloc]initWithBaseImg:image
                                                                                         resultImgSize:imageSize clipperType:self.clipperType];
        
        __weak typeof(self)weakSelf = self;
        clipperVC.cancelClippedHandler = ^(){
            [picker dismissViewControllerAnimated:YES completion:nil];
        };
        clipperVC.successClippedHandler = ^(UIImage *clippedImage){
            chooseImage = clippedImage;
            [weakSelf setChoosedImage:chooseImage];
            [picker dismissViewControllerAnimated:YES completion:nil];
        };
        
        [picker pushViewController:clipperVC animated:YES];
    } else {
        //系统方式
        chooseImage = [self turnImageWithInfo:info];
        [self setChoosedImage:chooseImage];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }

}

- (void)setChoosedImage:(UIImage *)chooseImage {
    // 压缩后的图片
    NSData *imageData = [NSObject imageData:chooseImage];
    
    UIImage *image = [UIImage imageWithData:imageData];
    if (self.indexPath.section == 0) {
        UploadAdvertisementCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
        cell.imageV.hidden = NO;
        cell.imageV.image = image;
        [self.headUpImageArray addObject:image];
        
    }
    if (self.indexPath.section == 1) {
        UploadAdvertisementCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
        cell.imageV.hidden = NO;
        cell.imageV.image = image;
        self.headDownImage = image;
        
    }
    if (self.indexPath.section == 2) {
        UploadAdvertisementCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
        cell.imageV.hidden = NO;
        cell.imageV.image = image;
        [self.calculateUpImageArray addObject:image];
        
    }
    if (self.indexPath.section == 3) {
        UploadAdvertisementCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
        cell.imageV.hidden = NO;
        cell.imageV.image = image;
        self.calculateDownImage = image;
    }
    
    if (self.indexPath.section == 4) {
        ZCHUploadCooperateCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
        cell.imageV.hidden = NO;
        cell.imageV.image = image;
        self.cooperateDownImage = image;
    }
    if (self.indexPath.section == 5) {
        UploadAdvertisementCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
        cell.imageV.hidden = NO;
        cell.imageV.image = image;
        [self.innerYPImageArray addObject:image];
        
    }
    if (self.indexPath.section == 6) {
        UploadAdvertisementCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
        cell.imageV.hidden = NO;
        cell.imageV.image = image;
        [self.innerConImageArray addObject:image];
        
    }
    if ([imageData length] >0) {
        imageData = [GTMBase64 encodeData:imageData];
    }
    NSString *imageStr = [[NSString alloc]initWithData:imageData encoding:NSUTF8StringEncoding];
    
    [self uploadImageWithBase64Str:imageStr];
    
    
    
    
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
//取消选择图片
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2000) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
}

-(void)back{
    if ([self.saveBtn.titleLabel.text isEqualToString:@"编辑"]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出编辑"
                                                    message:@"是否确定退出编辑？"
                                                   delegate:self
                                          cancelButtonTitle:@"否"
                                          otherButtonTitles:@"是",nil];
    alert.tag = 2000;
    [alert show];
}

#pragma mark - lazyMethod
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(64);
            make.left.right.bottom.equalTo(0);
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"UploadAdvertisementCell" bundle:nil] forCellReuseIdentifier:@"UploadAdvertisementCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"ZCHUploadCooperateCell" bundle:nil] forCellReuseIdentifier:@"ZCHUploadCooperateCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 50)];
        footerView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = footerView;
    }
    return  _tableView;
}

@end
