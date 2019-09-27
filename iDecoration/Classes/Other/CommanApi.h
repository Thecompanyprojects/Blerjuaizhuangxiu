//
//  CommanApi.h
//  iDecoration
//
//  Created by RealSeven on 17/3/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#ifndef CommanApi_h
#define CommanApi_h

#pragma mark -- 接口相关

//查看手机号是否注册过
#define IsRegistedUrl @"person/iphoneVerification.do"
//发送短信（手机验证码有效时间为20分钟）//已经作废
#define GetIdentifyCodeUrl @"sms/getSms.do"
//验证短信验证码
#define VerifyIdentifyCodeUrl @"person/checkPhoneCode.do"
//注册
#define RegisterUrl @"agency/registNewUserSingle.do"

//#define RegisterUrl @"agency/registNewUserSingle.do"
//登录
#define LoginUrl @"agency/login.do"
//找回密码
#define ResetPasswordUrl @"agency/resetPwd.do"
//获取所有职位类型
#define GetJobListUrl @"jobType/getCblejJobTypeGetList.do"
//修改密码
#define ModifyPwdUrl @"agency/changeNewPwd.do"
//修改手机
#define ModifyPhoneUrl @"agency/bindNewPhone.do"
//申请投诉列表
#define ComplainListUrl @"complain/getNotReadComplainsByPage.do"
//获取所有地区数据
#define AreaListUrl @"china/getAllData.do"
//根据上一级Id获取省市区县列表（获取省份pid为0）
#define DetailAreaListUrl @"china/getDataByPid.do"
//上传头像
#define UploadImageUrl @"file/base64ToImage.do"
//意见反馈
#define FeedBackUrl @"feedback/upFeedback.do"
//个人信息提交
#define UploadPersonInfoUrl @"agency/updateInfo.do"
//判断权限新建工地
#define NewConstructionUrl @"constructionPerson/newGdQx.do"
//公司LOGO
#define CompanyLogoUrl @"file/uploadFiles.do"
//创建公司
#define CreateCompanyUrl @"company/saveCompany.do"
//根据上一级Id获取省市区县列表（获取省份pid为0）
#define GetCityListUrl @"china/getDataByPid.do"
//获取工地列表
#define GetSiteListUrl @"construction/getConstructs.do"
//喊装修订单
#define GetConstructsUrl @"hanzhuangxiu/getConstructs.do"
//获取工地管理轮播图
#define GetSiteImageListUrl @"construction/getCityImgList.do"
//获取地区数据树形结构
#define GetRegionUrl @"construction/getRegion.do"
//编辑喊装修订单
#define EditHanOrderUrl @"hanzhuangxiu/getDeleteHan.do"
//通过用户ID得到用户信息
#define GetUserInfoUrl @"agency/getAgencyById.do"
//获取公司列表
#define GetCompanyListUrl @"company/findCompanyList.do"
//获取我的工地
#define GetAllMyConstructionUrl @"constructionPerson/getMyConstructionByPage.do"
//确认交工
#define ConfirmCompleteUrl @"construction/confirmComplete.do"
//根据工地id获取工地信息
#define GetSiteInfoByIDUrl @"construction/getConstruction.do"
//创建店铺
#define CreateShopUrl @"merchant/createMerchant.do"
//店铺类型
#define GetShopTypeUrl @"cblejMerchantType/getList.do"
//根据Id获取店铺基本信息
#define GetShopInfoByIDUrl @"merchant/getMerchantById.do"
//施工日志
#define GetDiaryUrl @"construction/getJournalDetail.do"
//根据Id获取店铺基本信息(以及搜索)
#define BLEJCalculatorGetCompanyListUrl @"calculator/list.do"
//根据公司ID获取公司模板
#define BLEJCalculatorGetTempletByCompanyIdUrl @"calculator/getAllTemplate.do"



#endif /* CommanApi_h */
