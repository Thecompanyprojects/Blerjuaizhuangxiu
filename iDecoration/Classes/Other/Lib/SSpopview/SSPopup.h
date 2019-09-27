//
//  OrdersDropdownSelection.h
//  CooperChimney
//
//  Created by Karthik Baskaran on 29/09/16.
//  Copyright © 2016 Karthik Baskaran. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

#define AvenirMedium(_size)   [UIFont fontWithName:@"Avenir-Medium" size:_size]

#define RGB_W(_red,_green,_blue)  [UIColor colorWithRed:_red/255.0 green:_green/255.0 blue:_blue/255.0 alpha:1]

#define NormalAnimation(_inView,_duration,_option,_frames)            [UIView transitionWithView:_inView duration:_duration options:_option animations:^{ _frames    }

@class SSPopup;

typedef void (^VSActionBlock)(int);
typedef void (^SSPopupBlock)(NSInteger index);
@protocol SSPopupDelegate <NSObject>

@optional
/* Pickup Outlet get Delegate */

-(void)GetSelectedOutlet:(int)tag;

-(void)disMissDoSomething;


@end

@interface SSPopup : UIControl<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *DropdownTable;
    NSString *Title;
    
}
@property (nonatomic, assign) id<SSPopupDelegate> SSPopupDelegate;
@property (copy, nonatomic) VSActionBlock completionBlock;
@property (copy, nonatomic) SSPopupBlock blockDidTouchCell;


- (id)initWithFrame:(CGRect)frame delegate:(id<SSPopupDelegate>)delegate;

-(void)CreateTableview:(NSArray *)Contentarray withSender:(id)sender withTitle:(NSString *)title setCompletionBlock:(VSActionBlock )aCompletionBlock;

-(void)CreateTableview:(NSArray *)Contentarray withTitle:(NSString *)title setCompletionBlock:(VSActionBlock )aCompletionBlock;
@end
