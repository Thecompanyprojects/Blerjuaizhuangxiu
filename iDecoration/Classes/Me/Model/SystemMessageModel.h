//
//  SystemMessageModel.h
//  iDecoration
//
//  Created by zuxi li on 2017/6/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemMessageModel : NSObject

//"id": 310,
//"detail": "57585565685离开了巨魔LOL咯恶露拉锯5句露露露露1阿Q不哭哭论坛查了V5绝路独乐乐哈ALS端口6句巴萨图册可拉可拉LBS考虑考虑8口",
//"phone": "15910251475",
//"deal": 0,
//"constructionId": 1365,
//"generalManagerId": 10003,
//"managerId": ",10089,",
//"complainType": "装修区域过大不能正常接单 ",
//"createDate": 1496820346000,
//"managerName": null,
//"managerPhone": null,
//"generalManagerName": "田丽",
//"generalManagerPhone": null,
//"generalManagerDelete": null,
//"managerDelete": null,
//"generalManagerRead": 1,
//"managerRead": 0,
//"createDateStr": "2017-06-07"


//@property (nonatomic, assign) NSInteger messageId;
//@property (nonatomic, strong) NSString *detail;
//@property (nonatomic, strong) NSString *phone;
//@property (nonatomic, assign) NSInteger deal;
//@property (nonatomic, assign) NSInteger constructionId;
//// 总经理id 可能为空
//@property (nonatomic, assign) NSInteger generalManagerId;
//// 经理id 可能为空
//;@property (nonatomic, strong) NSString *complainType;
//@property (nonatomic, assign) NSInteger createDate;
//@property (nonatomic, strong) NSString *managerName;
//@property (nonatomic, strong) NSString *managerPhone;
//@property (nonatomic, strong) NSString *managerId;
//@property (nonatomic, strong) NSString *generalManagerName;
//@property (nonatomic, strong) NSString *generalManagerPhone;
//@property (nonatomic, strong) NSString *generalManagerDelete;
//@property (nonatomic, strong) NSString *managerDelete;
//// 总经理是否已读  0 未读  1已读
//@property (nonatomic, assign) NSInteger generalManagerRead;
//// 经理是否已读   0未读  1 已读
//@property (nonatomic, assign) NSInteger managerRead;
//@property (nonatomic, strong) NSString *createDateStr;


//投诉详情
@property (nonatomic, strong) NSString *detail;
// 投诉手机号
@property (nonatomic, strong) NSString *phone;
//投诉类型
@property (nonatomic, strong) NSString *complainType;
// 经理手机号（投诉）
@property (nonatomic, strong) NSString *managerName;
// 经理是否已读（投诉）
@property (nonatomic, strong) NSString *managerRead;
// 总经理姓名（投诉）
@property (nonatomic, strong) NSString *generalManagerName;
// 总经理是否已读
@property (nonatomic, strong) NSString *generalManagerRead;

// 数据id
@property (nonatomic, assign) NSInteger messageId;
// 数据类型（0：投诉，1：反馈回复）
@property (nonatomic, assign) NSInteger type;

// 经理id
@property (nonatomic, strong) NSString *managerId;
// 总经理id
@property (nonatomic, strong) NSString *generalManagerId;

//回复内容（反馈回复）
@property (nonatomic, strong) NSString *replyContent;
// 回复时间（反馈回复）
@property (nonatomic, strong) NSString *replyTime;
// 反馈内容（反馈回复）
@property (nonatomic, strong) NSString *content;
// 投诉或者反馈回复时间
@property (nonatomic, assign) double createDate;

// 处理结果
@property (nonatomic, strong) NSString *deal;



// 是否阅读（反馈回复（0：未读，1：已读））
@property (nonatomic, assign) NSInteger read;







@end
