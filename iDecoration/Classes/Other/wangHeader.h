//
//  wangHeader.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/3/21.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#ifndef wangHeader_h
#define wangHeader_h


//支付加密KEY

#define ZHIFU_KEY @"8nop2escp2m98srkki7bt8vny2qwo7po"

//图片验证码
#define tupianyanzhengma @"agency/imgCode.do"

//发送验证码
#define SMS_GET @"sms/smsCode.do"

//同城经度

#define Local_dingweijindu @"Local_dingweijindu"

//同城纬度

#define Local_dingweiweidu @"Local_dingweiweidu"


//判断登录方式

#define DENGLUFANGSHI   @"disanfangdenglu"

//报名详情
#define Eventdetailsurl @"/signUp/signUpDetails.do?signUpId=%ld"

//判断是否是分销员

#define GET_clickSpreadSystem @"/spread/clickSpreadSystem.do?agencyId=%ld"

//申请成为分销员

#define POST_applySpread @"agency/applySpread.do"

//推广中心个人信息

#define POST_spreadCenterInfo  @"agency/toPersonalCenter.do"


//选择对接人

#define POST_CHOOSEDUIJIE    @"agency/chooseMiddleMan.do"

//分销员查询团队

#define POST_spreadManTeam   @"agency/spreadManTeam.do"

//对接人查询我的团队

#define POST_middelManTeam   @"agency/middelManTeam.do"

//对接人查询我的二级团队

#define POST_twomiddelManTeam @"agency/middelManTwoLevelTeam.do"

//对接人申请记录

#define POST_SHENQIQGJILU @"agency/middelManTeamApply.do"

//对接人指派默认的三级推广员

#define POST_commitToAdminMessage  @"agency/commitToAdminMessage.do"

//对接人处理申请

#define POST_updateApplyStatus   @"agency/updateApplyStatus.do"

//添加开通商家信息

#define POST_spreadMerchantVip    @"agency/spreadMerchantVip.do"

//绑定账号
#define POST_insertInfo      @"agency/insertPersonalAccountInfo.do"

//查询绑定信息
#define POST_selectinsertinfo @"agency/getPersonalAccountInfo.do"

//分销提现

#define POST_moneytoMyWallet  @"agency/moneytoMyWallet.do"

//分销提现记录

#define POST_FENXIAOTIXIANJILU @"agency/getmakeCash.do"

//推广员信息

#define GET_INFOTUIGUANGYUAN @"agency/spreadManInfoAndTeam.do"

//收入明细

#define POST_shourumingxi @"agency/incomeDetail.do"

//设置执行经理

#define POST_saveImplement  @"companyAgencys/saveImplement.do"

//美文添加广告位

#define POST_imgsave         @"img/save.do"

//查询广告图

#define GET_IMGGUANGGAO     @"img/getList.do"

//修改广告图

#define POST_uploadimg      @"img/update.do"

//同城推荐数据请求
#define Tongcheng_getdat    @"citywiderecomend/getData2.do"


//微信登陆
#define Login_weixin        @"agency/wxLogin.do"

//qq登陆

#define Login_qq            @"agency/qqLogin.do"

//第三方登录验证
#define Login_disanfang     @"agency/otherLoginCheck.do"

//绑定qq
#define BANGDING_QQ         @"agency/bandQq.do"

//同城点赞

#define Local_dianzan       @"citywiderecomend/thumbUp.do"

//取消点赞

#define Local_quxiandianzan @"citywiderecomend/cancleUp.do"

//查询评论列表

#define Local_getDiscuss     @"citywiderecomend/getDiscuss.do"

//同城评论

#define Loczl_adddiscuss  @"citywiderecomend/discuss.do"

//看点-公司
#define Local_gongsi @"citywiderecomend/companys.do"
//看点-工地
#define Local_gongdi @"citywiderecomend/constructions.do"
//看点_商品
#define Local_shangping @"citywiderecomend/goods.do"
//看点_计算器
#define Local_jisuanqi @"citywiderecomend/calculator.do"
//看点_美文
#define Local_meiwen @"citywiderecomend/arts.do"
//看点_活动
#define Local_huodong @"citywiderecomend/acttivities.do"
//查询审核状态
#define widepush_shenhe @"citywiderecomend/getByAgencyId.do"
//同城 增加分享量
#define Local_shareadd @"citywiderecomend/addShare.do"


//美文留言

#define Local_meiwenliuyan @"designsMessage/save.do"

//美文回复

#define Local_meiwenhuifu @"designsMessage/saveHuifu.do"

//工地点赞
#define Local_siteadd1 @"construction/upLikeOrScanCount.do"

//美文点赞

#define Local_notezan @"designs/updateLikeNum.do"


//爱装修关于我们网页链接

#define FENXIAO_WEB @"resources/html/fenxiao.html"
//爱装修排名攻略
#define PaiMingGongLue @"resources/html/gongnengtiao.html"

//同城接单

#define POST_getRangeList  @"citywiderecomend/getRangeList.do"

//公司提现

#define POST_companytixian @"company/companyTransfer.do"

//公司金额查询

#define POST_companymoney @"company/companyMoney.do"

//绑定公司账户

#define POST_bindAccountcompany  @"company/bindAccount.do"

//查询公司账户信息

#define POST_CHAXUNGONGSI @"company/selCompanyAccount.do"

//查询打赏列表

#define POST_CHAXUNDASHANG @"reward/getRewardList.do"

//个人提现

#define POST_GRENTIXIAN  @"reward/agencysTransfer.do"

//查询草稿箱

#define POST_CAOGAO @"designsDraft/getDraftList.do"

//保存草稿箱

#define POST_CAOGAOSAVE @"designsDraft/saveDraft.do"

//推送草稿箱

#define POST_PUSHCAOGAO @"designsDraft/draftPush.do"

//删除草稿箱

#define POST_DELCAOGAO @"designsDraft/deleteDraft.do"

//关注店铺
#define GET_GUANZHU @"attention/follow.do"

//取消关注

#define GET_QUXIAOGUANZHU @"attention/unfollow.do"

//关注 粉丝列表

#define POST_GUANZHIFENSI @"attention/getFans.do"

// 关注 我的关注

#define POST_MYGUANZHU @"attention/getAttentions.do"

// 关注 推荐

#define POST_TUANZHUTUIJIAN @"attention/getAttentionRecommends.do"

//添加收藏

#define POST_ADDSHOUCANG @"collection/collect.do"

//删除收藏

#define DELETE_SHOUCANG @"collection/cancelCollect.do"

//查询公司收藏列表

#define CONPANY_SHOUCANG @"collection/getCompanysCollections.do"

//查询店铺收藏列表

#define SHOP_SHOUCANG @"collection/getShopsCollections.do"

//查询商品类型收藏列表

#define GOODS_SHOUCANG @"collection/getGoodsCollections.do"

//查询工地类型收藏列表

#define SITE_SHOUCANG @"collection/getConstructionsCollections.do"

//查询美文类型收藏列表

#define MEIWEN_SHOUCANG @"collection/getDesignsCollections.do"

//查询名片类型收藏列表

#define IDCARD_SHOUCANG @"collection/getBussCardsCollections.do"

//获取收藏状态

#define GET_SELECTSHOUCANG @"collection/getCollectedState.do"

//美文留言回复

#define POST_MEIWENHUIFU @"designsMessage/saveHuifu.do"

//分销播报

#define GET_FENXIAOBOBAO @"agency/spreadNews.do"


//更新关注消息

#define GENXINGUANZHUXIAOXI @"attention/updateAttentionMessage.do"


//关注消息详情

#define GET_GUANZHUXIAOXIXIANGQING @"attention/getAttentionMessage.do"

//改变关注消息状态

#define GET_CHANGEGUANZHUXIAIXI @"attention/updateIsRead.do"

//报单卡

#define GET_reportCard  @"agency/reportCard.do"

//活动专区

#define GET_ActivityArrondiList @"cblejActivity/getActivityArrondiList.do"

//活动留言列表

#define GET_designcommentlist  @"designsMessage/getList.do"


//查询精品设计

#define GET_DesignVip @"designs/getDesignVip.do"

//查询VR全景

#define GET_ImgVip @"img/getImgVip.do"

//本案设计点赞

#define GET_ZANdesign @"designs/dz.do"

//非会员公司报单

#define GET_authenticReport @"agency/authenticReport.do"

//红包管理

#define GET_redPacketManagerInfo @"agency/redPacketManagerInfo.do"

//红包提现

#define GET_getRedPacketCashMoney @"agency/getRedPacketCashMoney.do"

//同城推荐播报详情

#define GET_LOCALBOBAO @"citywiderecomend/companyPhone.do"

//装修顾问

#define GET_ZHUANGXIUGUWEN @"agency/getListByCityId.do"

//同城 装修攻略

#define GET_getExcellentCase @"citywiderecomend/getExcellentCase.do"

//同城 商品

#define GET_Merchandies2 @"citywiderecomend/getMerchandies2.do"

//同城 搜索

#define GET_SEARCHLOCAL @"citywiderecomend/getSearch.do"

#import "DecorateInfoNeedView.h"
#import "DecorateCompletionViewController.h"
#endif /* wangHeader_h */
