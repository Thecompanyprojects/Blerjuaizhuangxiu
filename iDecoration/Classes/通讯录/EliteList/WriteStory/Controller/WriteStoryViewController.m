//
//  WriteStoryViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "WriteStoryViewController.h"
#import "DesignCaseListModel.h"
#import "MyBeautifulArtController.h"
#import "NewMyPersonCardController.h"
@interface WriteStoryViewController ()

@end

@implementation WriteStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑";
    [self SuspendedButtonDisapper];//隐藏说明书按钮
    [self.successBtn setTitle:@"提交" forState:(UIControlStateNormal)];
    self.bottomMusicStyleV.hidden = true;
    self.addVideoBtn.hidden = true;
    self.isHaveMusicButton = false;
    self.tableView.height = screenH - 64;
    if (self.dataArray.count == 0) {
        [self makeCell];
    }
}

- (void)makeCell {
    isHaveDefaultLogo = NO;
    DesignCaseListModel *model = [[DesignCaseListModel alloc]init];
    model.detailsId = 0;
    model.imgUrl = @"";
    model.htmlContent = @"";
    model.link = @"";
    model.linkDescribe = @"";
    model.content = @"点击添加文字";
    [self.dataArray insertObject:model atIndex:0];
    NSString *key = [NSString stringWithFormat:@"%lu",self.dataArray.count-1];
    [hiddenStateDict setObject:@(1) forKey:key];
    //一个section刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
}

- (void)pushData {
    self.type = 5;
    NSString *dataStr = [self jsonfrom];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"designs/saveBellesLettres.do"];
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"jsonList":dataStr,@"type":@(self.type)};
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if (responseObj) {
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode == 1000) {
                if (self.isFistr) {
                    self.isFistr = NO;
                }
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshBeatAteList" object:nil];
                for (UIViewController *vc in self.navigationController.childViewControllers) {
                    if ([vc isKindOfClass:[NewMyPersonCardController class]]) {
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
            }else if(statusCode==1001){
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
            }else if(statusCode==2000){
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:true];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
