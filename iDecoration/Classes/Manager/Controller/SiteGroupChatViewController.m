//
//  SiteGroupChatViewController.m
//  iDecoration
//
//  Created by RealSeven on 2017/3/31.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SiteGroupChatViewController.h"
#import "UserInfoModel.h"
@interface SiteGroupChatViewController ()<EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource, EMClientDelegate>

@end

@implementation SiteGroupChatViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
    manager.enableAutoToolbar = NO;//这个是它自带键盘工具条开关
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.toolbarDoneBarButtonItemText = @"完成";
    manager.toolbarTintColor = kMainThemeColor;
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
    manager.enableAutoToolbar = YES;//这个是它自带键盘工具条开关
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = kBackgroundColor;
    self.title = self.chatTitle;
    
    self.dataSource = self;

    UserInfoModel *model = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    
    [[NSUserDefaults  standardUserDefaults] setObject:model.photo forKey:@"userPhoto"];
    [[NSUserDefaults standardUserDefaults] setObject:model.trueName forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] setObject:model.huanXinId forKey:@"huanXinId"];
    

    // 去掉更多中多余的功能 位置视频等
    // 单聊
    if(self.conversation.type == EMConversationTypeChat) {
        [self.chatBarMoreView removeItematIndex:4];
        [self.chatBarMoreView removeItematIndex:3];
        [self.chatBarMoreView removeItematIndex:1];
    }
    // 群聊
    if(self.conversation.type == EMConversationTypeGroupChat){
        [self.chatBarMoreView removeItematIndex:1];
    }
}

#pragma mark - EaseChatBarMoreViewDelegate
// 重写拍照方法 去掉视频
- (void)moreViewTakePicAction:(EaseChatBarMoreView *)moreView
{
    // Hide the keyboard
    [self.chatToolbar endEditing:YES];
    
#if TARGET_IPHONE_SIMULATOR
    [self showHint:NSEaseLocalizedString(@"message.simulatorNotSupportCamera", @"simulator does not support taking picture")];
#elif TARGET_OS_IPHONE
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
    
    self.isViewDidAppear = NO;
    [[EaseSDKHelper shareHelper] setIsShowingimagePicker:YES];
#endif
}


//单聊设置头像
-(id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController  modelForMessage:(EMMessage *)message {
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc]initWithMessage:message];
    UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];

    model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
    if (model.isSender) {
        //发消息者取本地
        model.nickname = userModel.trueName;
        model.avatarURLPath = userModel.photo;
        message.ext = @{@"HEAD_IMAGE_URL":userModel.photo, @"USER_NAME":userModel.trueName};
    }else{
        //取消息体中的
        model.avatarURLPath = message.ext[@"HEAD_IMAGE_URL"];
        model.nickname = message.ext[@"USER_NAME"];
    }
    if ([self.title isEqualToString:@""]) {
        self.title = model.nickname;
    }
    return model;
}






@end
