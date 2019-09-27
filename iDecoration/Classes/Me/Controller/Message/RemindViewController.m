//
//  RemindViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/2/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "RemindViewController.h"

#import "SiteGroupChatViewController.h"
#import "NSObject+CompressImage.h"


@interface RemindViewController ()<EaseConversationListViewControllerDataSource,EaseConversationListViewControllerDelegate>

@end

@implementation RemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.title = @"聊天消息";
    
    self.dataSource = self;
    self.delegate = self;
    self.showRefreshHeader = YES;
    
    BOOL isLoggedIn = [EMClient sharedClient].isLoggedIn;
    if (!isLoggedIn) {
        UserInfoModel *model = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
        EMError *EMerror = [[EMClient  sharedClient]loginWithUsername:model.huanXinId password:model.huanXinPassword];
        if (!EMerror) {
            [[EMClient sharedClient].options setIsAutoLogin:YES];
        }
    }
    
    // 收到聊天消息 跟新消息数量
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessageNumber) name:kHXUpdateMessageNumberWhenRevievedMessage object:nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self tableViewDidTriggerHeaderRefresh];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [NSObject promptWithControllerName:@"RemindViewController"];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NormalMethod
- (void)updateMessageNumber {
    [self.tableView reloadData];
}

-(id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController modelForConversation:(EMConversation *)conversation{

    EaseConversationModel *model = [[EaseConversationModel alloc]initWithConversation:conversation];

    
    if (model.conversation.type == EMConversationTypeChat) {
        //获取扩展消息中的内容
        NSDictionary *dic = conversation.lastReceivedMessage.ext;
        
        if (dic[@"USER_NAME"] == nil || dic[@"HEAD_IMAGE_URL"] == nil) {
            //第一次是取本地的头像

            
        }else{
            //直接在消息扩展中获取
            model.title = dic[@"USER_NAME"];
            model.avatarURLPath = dic[@"HEAD_IMAGE_URL"];
         
        }
        return model;
        
    }else if(model.conversation.type == EMConversationTypeGroupChat){
    
        EMGroup *group = [[EMClient sharedClient].groupManager getGroupSpecificationFromServerWithId:model.title error:nil];
        
        model.title = group.subject;

        return model;
    }
    
    return 0;
}


-(void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController didSelectConversationModel:(id<IConversationModel>)conversationModel{
    
    SiteGroupChatViewController *group = [[SiteGroupChatViewController alloc]initWithConversationChatter:conversationModel.conversation.conversationId conversationType:conversationModel.conversation.type];

        group.chatTitle = conversationModel.title;
    
    [self.navigationController pushViewController:group animated:YES];

}




@end
