//
//  EditShopInfoTableViewCell.h
//  iDecoration
//
//  Created by RealSeven on 2017/4/1.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditShopInfoTableViewCell : UITableViewCell
{
    BOOL _isSelected;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTF;
//@property (nonatomic, strong) UIButton *selectBtn;
//@property (nonatomic, strong) UILabel *quiryLabel;
//@property (nonatomic, assign) NSInteger seeFlag;
//@property (nonatomic, copy) void(^selectBlock)(NSInteger flag);

@end
