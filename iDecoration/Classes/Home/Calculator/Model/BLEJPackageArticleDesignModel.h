//
//  BLEJPackageArticleDesignModel.h
//  iDecoration
//
//  Created by john wall on 2018/8/2.
//  Copyright © 2018年 RealSeven. All rights reserved.
//


/*
 {
 "designId": 32,
 "packageId": 14,
 "content": "999套餐美文",
 "htmlContent": "<b>999套餐美文</b>",
 "imgUrl": "http://testimage.bilinerju.com/group1/M00/00/4E/rBHg0VpPP4aANJHZAADlO_cFEEE942.jpg",
 "sort": 2,
 "videoUrl": "",
 "currencyUrl": "",
 "createBy": 1076,
 "createDate": 1533191008000,
 "updateBy": 1076,
 "updateDate": 1533191008000,
 "deal": "0"
 },
 */
#import <Foundation/Foundation.h>

@interface BLEJPackageArticleDesignModel : NSObject
/**
 *  designid
 */
@property (copy, nonatomic) NSString * designId;

@property (copy, nonatomic) NSString * packageId;;

@property (copy, nonatomic) NSString *content;

@property (copy, nonatomic) NSString *htmlContent;

@property (copy, nonatomic) NSString *imgUrl;

@property (copy, nonatomic) NSString * sort;

@property (copy, nonatomic) NSString *videoUrl;

@property (copy, nonatomic) NSString *currencyUrl;

@property (copy, nonatomic) NSString *createBy;

@property (copy, nonatomic) NSString * createDate;

@property (copy, nonatomic) NSString *updateBy;

@property (copy, nonatomic) NSString * updateDate;

@property (copy, nonatomic) NSString *deal;
@end
