//
//  ExplainTableViewCell.h
//  iDecoration
//
//  Created by RealSeven on 2017/4/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExplainTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *addImageBtn;
@property (nonatomic, strong) UIImageView *explainImageView;
@property (nonatomic, strong) UIButton *delImageBtn;

@property (nonatomic, copy) void(^addBlock)();
@property (nonatomic, copy) void(^delBlock)();
@property (nonatomic, assign) NSInteger cellH;
-(void)configWith:(NSString *)imgStr;
@end
