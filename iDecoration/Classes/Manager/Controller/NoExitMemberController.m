//
//  NoExitMemberController.m
//  iDecoration
//
//  Created by Apple on 2017/7/3.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "NoExitMemberController.h"
#import "ConstructionMemberModel.h"
#import "ShopDetailBottomCell.h"


@interface NoExitMemberController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation NoExitMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray array];
    self.title = @"参与人员";
    self.view.backgroundColor = Bottom_Color;
    [self.view addSubview:self.tableView];
    [self requestJoinList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *CellIdentifier = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (!CellIdentifier) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//    }
    
    ShopDetailBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailBottomCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ConstructionMemberModel *model = self.dataArray[indexPath.row];
    
    cell.nameL.text = model.trueName;
    cell.jobL.text = model.cJobTypeName;
    [cell.photoImg sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:DefaultManPic]];
//    cell.photoImg.frame = CGRectMake(7, 7, 30, 30);
//    cell.photoImg.width = 30;
//    cell.photoConW.constant= 30;
    return cell;
    
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = White_Color;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerNib:[UINib nibWithNibName:@"ShopDetailBottomCell" bundle:nil] forCellReuseIdentifier:@"ShopDetailBottomCell"];
    }
    return _tableView;
}

#pragma mark - 查询参与人员列表

-(void)requestJoinList{
    [self.dataArray removeAllObjects];
    [self.view hudShow];
//    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"participant/getParticipantList.do"];
    NSDictionary *paramDic = @{@"constructionId":@(self.consID),
                               @"pageSize":@(100),
                               @"page":@(0)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.view hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 10000:
                    
                {
                    NSArray *array = responseObj[@"pageBean"][@"recordList"];
                    NSArray *arr = [NSArray yy_modelArrayWithClass:[ConstructionMemberModel class] json:array];
                    [self.dataArray addObjectsFromArray:arr];
                    
//                    for (ConstructionMemberModel *model in self.dataArray) {
//                        if ([model.cpPersonId integerValue]==user.agencyId) {
//                            MeJobId = [model.cJobTypeId integerValue];
//                            break;
//                        }
//                    }
                    
                }
                    break;
                    
                default:
                    break;
                    
            }
            
            
            
            [self.tableView reloadData];
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [self.view hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
