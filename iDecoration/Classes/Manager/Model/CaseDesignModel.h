//
//  CaseDesignModel.h
//  iDecoration
//
//  Created by Apple on 2017/5/31.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaseDesignModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *cdConstructionId;
@property (nonatomic, copy) NSString *cdPicture;
@property (nonatomic, copy) NSString *cdDesignComments;
@property (nonatomic, copy) NSString *cdCreateDate;
@property (nonatomic, copy) NSString *cdPersonId;

@property (nonatomic, copy) NSString *orderBy;
@property (nonatomic, copy) NSString *typeFlag;
@property (nonatomic, copy) NSString *updateFalg;
@property (nonatomic, copy) NSString *shareFlag;
@property (nonatomic, copy) NSString *cdPictureLike;
@property (nonatomic, copy) NSString *cdDesignCommentsLike;

@property (nonatomic, copy) NSString *cdCreateDateBegin;
@property (nonatomic, copy) NSString *cdCreateDateEnd;
@property (nonatomic, copy) NSString *cdCreateDateChar;
@property (nonatomic, copy) NSString *cdCreateDateCharAll;
@end
