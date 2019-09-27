//
//  EditShopDetailController.h
//  iDecoration
//
//  Created by Apple on 2017/5/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FinishBlock)();

@interface EditShopDetailController : UITableViewController

@property (copy, nonatomic) NSString *merchantNo;
@property (copy, nonatomic) FinishBlock finishBlock;

@property (strong, nonatomic) NSMutableDictionary *topDic;
@property (strong, nonatomic) NSMutableArray *dataArr;

@end
