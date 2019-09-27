//
//  UIViewController+Runtime.m
//  iDecoration
//
//  Created by 张毅成 on 2018/6/19.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "UIViewController+Runtime.h"

@implementation UIViewController (Runtime)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method viewDidLoad = class_getInstanceMethod(self, @selector(viewDidLoad));
        Method viewDidLoaded = class_getInstanceMethod(self, @selector(viewDidLoaded));
        method_exchangeImplementations(viewDidLoad, viewDidLoaded);
    });
}

- (void)viewDidLoaded{
    [self viewDidLoaded];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.extendedLayoutIncludesOpaqueBars = true;
}
@end
