//
//  IntroductionToMemberPackagesCollectionViewCell.h
//  iDecoration
//
//  Created by 张毅成 on 2018/8/31.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroductionToMemberPackagesModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IntroductionToMemberPackagesCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelWeChat;
@property (weak, nonatomic) IBOutlet UILabel *labelQQ;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *arrayLabel;
@property (strong, nonatomic) IntroductionToMemberPackagesModel *model;
@end

NS_ASSUME_NONNULL_END
