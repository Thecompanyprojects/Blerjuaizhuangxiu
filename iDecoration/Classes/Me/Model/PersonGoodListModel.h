//
//  PersonGoodListModel.h
//  iDecoration
//
//  Created by sty on 2018/1/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonGoodListModel : NSObject


@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *name;
//
@property (nonatomic, copy) NSString *price;
//
@property (nonatomic, copy) NSString *faceImg;

@property (nonatomic, copy) NSString *merchantId;

//
@property (nonatomic, assign) NSInteger isCardDisPlay;
//
//@property (nonatomic, copy) NSString *ccAcreage;
//
//@property (nonatomic, copy) NSString *ccShareTitle;
////
//@property (nonatomic, copy) NSString *displayNumbers;
////
//@property (nonatomic, copy) NSString *companyType;
@end
