//
//  BLEJCalculatorGetCompantLisy.h
//  Calculator
//
//  Created by 赵春浩 on 17/5/2.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface BLEJCalculatorGetCompanyList : YTKRequest

- (id)initWithCompanyName:(NSString *)companyName;

@end
