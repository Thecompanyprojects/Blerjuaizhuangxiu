//
//  myattentionVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "myattentionVC.h"
#import <ICPagingManager/ICPagingManager.h>
#import "attentionVC0.h"
#import "attentionVC1.h"
#import "attentionVC2.h"

@interface myattentionVC ()<ICPagingManagerProtocol>
@property (nonatomic,strong) ICPagingManager *manager;
@property (nonatomic,strong) UIView *redView;
@end

@implementation myattentionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关注";
    [self loadnewdata];
    self.manager = [ICPagingManager manager];
    self.manager.delegate = self;
    [self.manager loadPagingWithConfig:^(ICSegmentBarConfig *config)
     {
         config.nor_color([UIColor darkGrayColor]);
         config.sel_color([UIColor blackColor]);
         config.line_color(Main_Color);
         config.backgroundColor = [UIColor clearColor];
     }];
    [self.view addSubview:self.redView];
    self.redView.frame = CGRectMake(kSCREEN_WIDTH-50, kNaviBottom+18, 8, 8);
    [self.redView setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ICPagingComponentBarStyle)style
{
    return ICPagingComponentStyleNormal;
}

/**
 
 控制器集合
 @return 控制器集合
 */
- (NSArray<UIViewController *> *)pagingControllerComponentChildViewControllers
{
    attentionVC0 *vc0 = [attentionVC0 new];
    attentionVC1 *vc1 = [attentionVC1 new];
    attentionVC2 *vc2 = [attentionVC2 new];
    vc2.companyId = self.companyId;
    return @[vc0,vc1,vc2];
}

/**
 选项卡标题
 
 @return @[]
 */
- (NSArray<NSString *> *)pagingControllerComponentSegmentTitles
{
    return @[@"推荐",@"我的关注",@"粉丝"];
}

/**
 选项卡位置 适配iPhone X 则减去88
 
 @return rect
 */
- (CGRect)pagingControllerComponentSegmentFrame
{
    return CGRectMake(0, kNaviBottom, self.view.bounds.size.width, 44);
}

/**
 选项卡位置 中间控制器view 高度
 
 @return CGFloat
 */
- (CGFloat)pagingControllerComponentContainerViewHeight
{
    return self.view.bounds.size.height - kNaviBottom;
}


-(UIView *)redView
{
    if(!_redView)
    {
        _redView = [[UIView alloc] init];
        _redView.backgroundColor = [UIColor redColor];
        _redView.layer.masksToBounds = YES;
        _redView.layer.cornerRadius = 4;
    }
    return _redView;
}


-(void)loadnewdata
{
    NSString *url = [BASEURL stringByAppendingString:GENXINGUANZHUXIAOXI];
    NSString *agencyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    NSDictionary *para = @{@"agencyId":agencyId};
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        
    } failed:^(NSString *errorMsg) {
        
    }];
}

@end
