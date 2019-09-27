//
//  professionallabelVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/3.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "professionallabelVC.h"
#import "GBTagListView.h"

@interface professionallabelVC ()
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UILabel *toplab;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *Individualarray;
@property (nonatomic,strong) NSMutableArray *infoarray;
@property (strong, nonatomic) GBTagListView *tempTag;
@end

@implementation professionallabelVC

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@"大好人",@"自定义流式标签",@"github",@"code4app",@"已婚",@"阳光开朗"].mutableCopy;
        [_dataSource addObject:@"+自定义"];
    }
    return _dataSource;
}

- (UIView *)topView {
    if(!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, kNaviBottom, kSCREEN_WIDTH, 30)];
        _topView.backgroundColor = [UIColor hexStringToColor:@"E8E8E8"];
    }
    return _topView;
}

- (UILabel *)toplab {
    if(!_toplab) {
        _toplab = [[UILabel alloc] initWithFrame:CGRectMake(20, self.topView.top+5, kSCREEN_WIDTH-40, 16)];
        _toplab.font = [UIFont systemFontOfSize:13];
        _toplab.textColor = [UIColor darkGrayColor];
        _toplab.text = @"添加属于你的5个标签";
    }
    return _toplab;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人标签";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickEvent)];
    self.navigationItem.rightBarButtonItem = myButton;
    self.Individualarray = [NSMutableArray array];
    GBTagListView *tagList = [[GBTagListView alloc]initWithFrame:CGRectMake(0, kNaviBottom+35, kSCREEN_WIDTH, 0)];
    /**允许点击 */
    tagList.canTouch=YES;
    /**可以控制允许点击的标签数 */
    tagList.canTouchNum = 5;
    /**控制是否是单选模式 */
    tagList.isSingleSelect = NO;
    tagList.signalTagColor = [UIColor clearColor];
    [tagList setTagWithTagArray:self.dataSource];
    tagList.backgroundColor = [UIColor whiteColor];
    [tagList setDidselectItemBlock:^(NSArray *arr) {
        NSLog(@"选中的标签%@",arr);
        [self.Individualarray removeAllObjects];
        [self.Individualarray addObjectsFromArray:arr];
    }];
    
    [tagList setAddItemBlock:^(NSArray *arr) {
        NSLog(@"选中的标签%@",arr);
    }];
    [self.view addSubview:tagList];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.toplab];
}

- (void)clickEvent {
    self.infoarray = [self.Individualarray copy];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
