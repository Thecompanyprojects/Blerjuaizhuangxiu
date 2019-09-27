//
//  VIPExperienceViewController.h
//  iDecoration
//
//  Created by 张毅成 on 2018/6/22.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIPExperienceModel.h"
#import "UploadAdvertisementCell.h"
#import "VIPExperienceTableViewCell.h"
#import "ShopClassificationDetailViewController.h"//店铺类别
#import "newShopClassificationDetailViewController.h"
#import "PlaceHolderTextView.h"
#import "LocationViewController.h"
#import "PModel.h"
#import "CModel.h"
#import "DModel.h"
#import "AreaListModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,VIPExperienceImageMode){
    VIPExperienceImageModeLogo = 0,
    VIPExperienceImageModeADTop,
    VIPExperienceImageModeADBottom
};
@interface VIPExperienceViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
typedef void(^blockFreshBack)(void);
@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) VIPExperienceImageMode imageMode;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) PModel *pmodel;// 省
@property (strong, nonatomic) CModel *cmodel;// 市
@property (strong, nonatomic) DModel *dmodel;// 区
@property (strong, nonatomic) NSString *companyId;
@property (strong, nonatomic) NSString *companyName;
@property (assign, nonatomic) BOOL isHaveMainCompany;
@property (strong, nonatomic) VIPExperienceModel *model;
@property (copy, nonatomic) blockFreshBack blockFreshBack;
@property (assign, nonatomic) BOOL isNew;

@property (nonatomic,assign) BOOL islogup;
@property (nonatomic,copy) NSString *companyNumber;//注册的时候传值，手机号

- (void)getPicWithIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
