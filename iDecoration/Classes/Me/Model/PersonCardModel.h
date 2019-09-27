//
//  PersonCardModel.h
//  iDecoration
//
//  Created by sty on 2018/1/28.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonCardModel : NSObject
@property (copy, nonatomic) NSString *jobName;

@property (nonatomic, assign) NSInteger cardId;
@property (nonatomic, assign) NSInteger agencyId;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *coverMap;

@property (nonatomic, copy) NSString *music;

@property (nonatomic, assign) NSInteger autoPlay;//0:手动播发 1:自动播放
//
@property (nonatomic, copy) NSString *video;
//
@property (nonatomic, copy) NSString *likeNumbers;
//
@property (nonatomic, assign) NSInteger scanNumbers;
//
@property (nonatomic, assign) NSInteger companyId;

@property (nonatomic, copy) NSString *companyName;




//
@property (nonatomic, copy) NSString *videoImg;
//
@property (nonatomic, copy) NSString *musicName;
//
@property (nonatomic, assign) NSInteger hasCons;
//
@property (nonatomic, assign) NSInteger hasDesigns;
//
@property (nonatomic, assign) NSInteger hasMerchandies;

//公司的详细地址和经纬度
@property (nonatomic, copy) NSString *clongitude;
//
@property (nonatomic, copy) NSString *clatitude;
//
@property (nonatomic, copy) NSString *companyAddress;



@property (nonatomic, copy) NSString *trueName;
//
@property (nonatomic, copy) NSString *photo;
//
@property (nonatomic, copy) NSString *address;
//
@property (nonatomic, copy) NSString *phone;
//
@property (nonatomic, copy) NSString *companyJob;
//
@property (nonatomic, copy) NSString *indu;
//
@property (nonatomic, copy) NSString *weixin;
//
@property (nonatomic, copy) NSString *wxQrcode;

//
@property (nonatomic, copy) NSString *email;
//
@property (nonatomic, copy) NSString *comment;
//
@property (nonatomic, copy) NSString *flower;

@property (nonatomic, copy) NSString *detailAddress;
//
@property (nonatomic, copy) NSString *longitude;
//
@property (nonatomic, copy) NSString *latitude;

//
@property (nonatomic, copy) NSString *collectionId;//收藏Id 0表示未收藏

@property (nonatomic, copy) NSString *banner; // 鲜花数

@property (assign, nonatomic) NSInteger eliteDesignId;//精英推荐Id（0没有，大于0有故事）

@property (copy, nonatomic) NSString *huanXinId;
@property (assign, nonatomic) BOOL gender;//true男 false女

@end
