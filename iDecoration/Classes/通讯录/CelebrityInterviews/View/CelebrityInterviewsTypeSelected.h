//
//  CelebrityInterviewsTypeSelected.h
//  iDecoration
//
//  Created by 张毅成 on 2018/6/20.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CelebrityInterviewsTypeSelectedTableViewCell.h"
#import "CelebrityInterviewsTypeSelectedModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface CelebrityInterviewsTypeSelected : UIView<UITableViewDelegate, UITableViewDataSource>
typedef void(^CelebrityInterviewsTypeSelectedBlock)(NSString *title);
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayData;
@property (copy, nonatomic) CelebrityInterviewsTypeSelectedBlock blockDidTouchCell;

@end

NS_ASSUME_NONNULL_END
