//
//  AddressBookSearchListViewController.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "EliteListViewController.h"

typedef enum{
    SearchListTypeCard,//名片
    SearchListTypeElite,//精英
    SearchListTypeFamous//名人专访
}SearchListType;

@interface AddressBookSearchListViewController : EliteListViewController
@property (assign, nonatomic) SearchListType listType;

@end
