//
//  myteamModel.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "myteamModel.h"

@implementation myteamModel
//初始化方法
- (instancetype) initWithItem:(NSMutableArray *)item andphone:(NSMutableArray *)phone andleave:(NSMutableArray *)leave andcheckStatusarr:(NSMutableArray *)checkStatus andagencyidarr:(NSMutableArray *)agencyidarr andisChange:(NSMutableArray *)isChangearr andisThreeLevelarr:(NSMutableArray *)isThreeLevelarr andcreateCodearr:(NSMutableArray *)createCodearr{
    if (self = [super init]) {
        self.folded=YES;
        _items = item;
        _phonearr = phone;
        _isLevelarr = leave;
        _checkStatusarr = checkStatus;
        _agencyidarr = agencyidarr;
        _isChangearr = isChangearr;
        _isThreeLevelarr = isThreeLevelarr;
        _createCodearr = createCodearr;
    }
    return self;
}



//每个组内有多少联系人
- (NSUInteger) size {
    return _items.count;
}
@end
