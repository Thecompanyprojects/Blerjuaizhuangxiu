//
//  EventdetailsVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/3/21.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "EventdetailsVC.h"
#import "NSObject+ModelToDictionary.h"

@interface EventdetailsVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UIView *head;
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,copy) NSString *timestr;
@end

static NSString *eventdetailidentfid;

@implementation EventdetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"报名详情";
    self.dataSource = [NSMutableArray array];
    

    self.table.tableHeaderView = self.head;
    [self.view addSubview:self.table];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - getters

-(UITableView *)table
{
    if(!_table)
    {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _table.dataSource = self;
        _table.delegate = self;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
    return _table;
}


-(UIView *)head
{
    if(!_head)
    {
        _head = [[UIView alloc] init];
        _head.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 20);
        
    }
    return _head;
}



#pragma mark - UITableViewDataSource&&UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 7;
    }
    if (section==1) {
        return self.smodel.custList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eventdetailidentfid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:eventdetailidentfid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"报名时间";
                
                cell.detailTextLabel.text = [[PublicTool defaultTool] getDateFormatStrFromTimeStampWithSeconds:self.smodel.signUpTime];
                
                if (self.state == Mytypecompany) {

                  
                }
                if (self.state == Mytypemessage) {
                    
                
                }
                
                break;
            case 1:
                
                cell.textLabel.text = @"已报名";
                cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@%@",@"《",self.smodel.designTitle,@"》"];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
                cell.detailTextLabel.textColor = [UIColor darkGrayColor];
                
                if (self.state == Mytypecompany) {
                 
                }
                if (self.state == Mytypemessage) {
              
                }
                
                
                break;
            case 2:
                cell.textLabel.text = @"报名者详细信息";
                break;
            case 3:
              
                cell.textLabel.text = @"姓   名";
                cell.detailTextLabel.text = self.smodel.userName;
                if (self.state == Mytypecompany) {

                }
                if (self.state == Mytypemessage) {

                }
                
                break;
            case 4:
                cell.textLabel.text = @"电   话";
                cell.detailTextLabel.text = self.smodel.userPhone;
                if (self.state == Mytypecompany) {

                }
                if (self.state == Mytypemessage) {

                }
                
                break;
            case 5:
                cell.textLabel.text = @"报名费用";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@",@"¥",self.smodel.money];
                break;
            case 6:
                cell.textLabel.text = @"订单号";
                cell.detailTextLabel.text = self.smodel.orderId;
                break;
            default:
                break;
        }
    }
    if (indexPath.section==1) {
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        id objc = self.smodel.custList[indexPath.row];
        NSString *name = [objc objectForKey:@"customName"];
        NSString *customValue = [objc objectForKey:@"customValue"];
        cell.textLabel.text = name;
        cell.detailTextLabel.text = customValue;
    }
    return cell;
}

#pragma mark --通过时间戳得到日期字符串
-(NSString *)getDateFormatStrFromTimeStamp:(NSString *)timeStamp{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]/ 1000.0];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

@end
