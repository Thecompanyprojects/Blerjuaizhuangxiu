//
//  InOutCompanyModel.h
//  iDecoration
//
//  Created by zuxi li on 2018/4/23.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InOutCompanyModel : NSObject
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *innerAndOuterSwitch; //内外网标识 0:内网，1：外网

@end
