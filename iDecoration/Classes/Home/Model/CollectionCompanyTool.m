//
//  CollectionCompanyTool.m
//  iDecoration
//
//  Created by zuxi li on 2018/5/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "CollectionCompanyTool.h"

@implementation CollectionCompanyTool

+ (void)saveShopOrCompanyWithCompanyID:(NSInteger)companyId completion:(void (^)(NSInteger, BOOL))completionBlock {
    
    NSString *url = @"collection/add.do";
    NSString *requestString = [BASEURL stringByAppendingString:url];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(companyId) forKey:@"relId"]; // 店铺或公司ID
    [params setObject:@(user.agencyId) forKey:@"agencysId"]; // 用户ID
    YSNLog(@"%@", params);
    [NetManager afGetRequest:requestString parms:params finished:^(id responseObj) {
        
        if ([responseObj[@"code"] isEqualToString:@"1000"]) {
            completionBlock([responseObj[@"collectionId"] integerValue], YES);
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"收藏成功"];
            
        } else if([responseObj[@"code"] isEqualToString:@"1002"]) {
            completionBlock(0, NO);
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"已经收藏过了"];
        } else {
            completionBlock(0, NO);
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"收藏失败"];
        }
    } failed:^(NSString *errorMsg) {
        completionBlock(0, NO);
        [[UIApplication sharedApplication].keyWindow hudShowWithText:errorMsg];
    }];
}

+ (void)unCollectionShopOrCompanyWithCollectionID:(NSInteger)collectionId completion:(void (^)(NSInteger, BOOL))completionBlock {
    
    NSString *defaultApi = [BASEURL stringByAppendingString:DELETE_SHOUCANG];
    NSDictionary *paramDic = @{
                               @"collectionId" : @(collectionId)
                               };
    YSNLog(@"------%@", paramDic);
    [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        switch (code) {
            case 1000:
            {
                completionBlock(collectionId, YES);
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"已从收藏列表中移除"];
            }
                break;
                
            default:
            {
                completionBlock(collectionId, NO);
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"操作失败"];
            }
                break;
        }
    } failed:^(NSString *errorMsg) {
        completionBlock(collectionId, NO);
    }];
}

@end
