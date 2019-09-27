//
//  CelebrityInterviewsArticleTableViewCell.m
//  iDecoration
//
//  Created by 张毅成 on 2018/6/20.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "CelebrityInterviewsArticleTableViewCell.h"

@implementation CelebrityInterviewsArticleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView AndIndex:(NSInteger)index {
    NSString *ID = [NSString stringWithFormat:@"CelebrityInterviewsArticleTableViewCell%ld",(long)index];
    CelebrityInterviewsArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CelebrityInterviewsArticleTableViewCell" owner:self options:nil][index];
    }
    cell.selectionStyle = UIAccessibilityTraitNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
