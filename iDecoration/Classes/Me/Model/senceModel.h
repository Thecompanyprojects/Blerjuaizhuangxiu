//
//  senceModel.h
//  iDecoration
//
//  Created by 涂晓雨 on 2017/7/10.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface senceModel : NSObject

//全景连接
@property(nonatomic,copy)NSString *picHref;


//展厅
@property(nonatomic,copy)NSString *picTitle;

//图片的ID
@property(nonatomic,copy)NSString *picId;

//图片的连接
@property(nonatomic,copy)NSString *picUrl;

// 展现量
@property (nonatomic, assign) NSInteger displayNumbers;

@end
