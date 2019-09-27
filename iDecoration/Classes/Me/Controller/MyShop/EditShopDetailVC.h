//
//  EditShopDetailVC.h
//  iDecoration
//
//  Created by zuxi li on 2017/7/10.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

typedef void(^FinishBlock)();

@interface EditShopDetailVC : SNViewController
@property (copy, nonatomic) NSString *merchantNo;
@property (copy, nonatomic) FinishBlock finishBlock;
@property (strong, nonatomic) NSMutableDictionary *topDic;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (nonatomic, assign) BOOL isEditVC;  // YES是编辑   NO新建
@end
