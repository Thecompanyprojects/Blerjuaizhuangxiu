//
//  CelebrityInterviewsArticleTableViewCell.h
//  iDecoration
//
//  Created by 张毅成 on 2018/6/20.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CelebrityInterviewsArticleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *buttonLike;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelLikeNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelWatchNumber;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLike;
+ (instancetype)cellWithTableView:(UITableView *)tableView AndIndex:(NSInteger)index;
@end
