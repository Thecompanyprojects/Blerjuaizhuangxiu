//
//  HistoryActivityViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/10/30.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "HistoryActivityViewController.h"
#import "UnionActivityListCell.h"
#import "ActivityShowController.h"
#import "BeautifulArtListModel.h"
#import "NewsActivityShowController.h"

@interface HistoryActivityViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *temDataArray;

@end

@implementation HistoryActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史活动";
    self.temDataArray = [NSMutableArray array];
    if (self.dataArray.count>0) {
        NSArray *arr = [NSArray yy_modelArrayWithClass:[BeautifulArtListModel class] json:self.dataArray];
        [self.temDataArray addObjectsFromArray:arr];
        
        for (int i = 0; i<self.temDataArray.count; i++) {
            BeautifulArtListModel *model = self.temDataArray[i];
            model.startTime = [self timeWithTimeIntervalString:model.startTime];
            model.endTime = [self timeWithTimeIntervalString:model.endTime];
            [self.temDataArray replaceObjectAtIndex:i withObject:model];
        }
        
    }
    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BeautifulArtListModel *model = self.temDataArray[indexPath.row];
    UnionActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnionActivityListCellFirst"];
    if (!cell){
        cell = [[NSBundle mainBundle] loadNibNamed:@"UnionActivityListCell" owner:self options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configData:model isLeader:NO];

    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(10, 100 - 1, kSCREEN_WIDTH-10, 1)];
    lineV.backgroundColor = kSepLineColor;
    [cell addSubview:lineV];

    return cell;
}

- (NSString *)stringFromDouble:(double)timeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [formatter stringFromDate:date];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BeautifulArtListModel *model = self.temDataArray[indexPath.row];
    if (model.type==1) {
        //联盟活动
        ActivityShowController *asVC = [[ActivityShowController alloc] init];
        NSDictionary *dic = self.dataArray[indexPath.row];
        asVC.designsId = dic[@"designsId"];
        asVC.activityId = dic[@"activityId"];
        
        asVC.calVipTag = self.companyCalVip;
   
        asVC.coverMap = dic[@"coverMap"];
        if ([dic[@"address"] isEqualToString:@"线下"]) {
            asVC.activityAddress = dic[@"activityAddress"];
        } else {
            asVC.activityAddress = @"线上活动";
        }
        asVC.activityTime = dic[@"startTime"]; // 时间戳
        asVC.designTitle = dic[@"designTitle"];
        asVC.musicStyle = [dic[@"musicPlay"] integerValue];
        asVC.designSubTitle = dic[@"designSubTitle"];
        
        asVC.companyLandLine = self.companyLandLine;
        asVC.companyPhone = self.companyPhone;
        asVC.companyName = self.companyName;
        asVC.companyLogo = self.companyLogo;
        asVC.companyId = self.companyID;
        
        asVC.calVipTag = 1;
        
        
        [self.navigationController pushViewController:asVC animated:YES];
    }
    
    else{
        NewsActivityShowController *vc = [[NewsActivityShowController alloc]init];
        vc.designsId = [model.designsId integerValue];
        vc.activityType = 3;
        
        
        vc.activityTime = model.startTime;
        vc.companyLandLine = self.companyLandLine;
        vc.companyPhone = self.companyPhone;
        vc.companyName = self.companyName;
        vc.companyLogo = self.companyLogo;
        vc.companyId = self.companyID;
        vc.origin = @"0";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

#pragma mark - lazy

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = kBackgroundColor;
        [_tableView registerNib:[UINib nibWithNibName:@"UnionActivityListCell" bundle:nil] forCellReuseIdentifier:@"UnionActivityListCell"];

    }
    return _tableView;
}
@end
