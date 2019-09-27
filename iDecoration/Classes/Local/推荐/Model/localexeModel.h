//
//  localexeModel.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/28.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface localexeModel : NSObject
@property (nonatomic , assign) NSInteger              caseId;
@property (nonatomic , copy) NSString              * caseTitle;
@property (nonatomic , copy) NSString              * coveMap;
@property (nonatomic , copy) NSString              * picHref;
@property (nonatomic , copy) NSString              * designSubtitle;
@property (nonatomic , assign) NSInteger              addTime;
@property (nonatomic , assign) NSInteger              designId;
@property (nonatomic , assign) NSInteger              readNum;
@end
