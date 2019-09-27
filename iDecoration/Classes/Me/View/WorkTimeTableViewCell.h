//
//  WorkTimeTableViewCell.h
//  iDecoration
//
//  Created by RealSeven on 17/2/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkTimeTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *timeTF;


@end
