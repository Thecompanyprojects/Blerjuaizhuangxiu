//
//  InformationBackDetailViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/7/7.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "InformationBackDetailViewController.h"

@interface InformationBackDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *questionContentLabel;
@property (nonatomic, strong) UILabel *questionTimeLabel;
@property (nonatomic, strong) UILabel *backContentLabel;
@property (nonatomic, strong) UILabel *backTimeLabel;
@end

@implementation InformationBackDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈回复";
    self.view.backgroundColor = kBackgroundColor;
    [self getData];
    [self tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)getData {
    // 修改消息的阅读状态
    NSString *defaultApi = [BASEURL stringByAppendingString:@"feedback/updateByIdAndType.do"];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:@(self.messageModel.messageId) forKeyedSubscript:@"id"];
    [paramDic setObject:@(2) forKeyedSubscript:@"type"];
    
    [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {

        YSNLog(@"---");
    } failed:^(NSString *errorMsg) {
        YSNLog(@"---");
    }];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        UILabel *questionTitleLabel = [[UILabel alloc] init];
        [cell.contentView addSubview:questionTitleLabel];
        questionTitleLabel.text = @"用户反馈内容：";
        questionTitleLabel.font = [UIFont systemFontOfSize:16];
        questionTitleLabel.textColor = [UIColor blackColor];
        [questionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(12);
            make.left.equalTo(12);
        }];
        
        self.questionContentLabel = [UILabel new];
        [cell.contentView addSubview:self.questionContentLabel];
        self.questionContentLabel.numberOfLines = 0;
        [self.questionContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(12);
            make.top.equalTo(questionTitleLabel.mas_bottom).equalTo(4);
            make.right.equalTo(-12);
            make.height.greaterThanOrEqualTo(0);
        }];
        self.questionContentLabel.font = [UIFont systemFontOfSize:16];
        self.questionContentLabel.textColor = COLOR_BLACK_CLASS_9;
        self.questionContentLabel.text = self.messageModel.content;
        
        self.questionTimeLabel = [UILabel new];
        [cell.contentView addSubview:self.questionTimeLabel];
        [self.questionTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-12);
            make.top.equalTo(self.questionContentLabel.mas_bottom).equalTo(4);
            make.bottom.equalTo(-12);
        }];
        self.questionTimeLabel.textAlignment = NSTextAlignmentRight;
        self.questionTimeLabel.font = [UIFont systemFontOfSize:16];
        self.questionTimeLabel.textColor = COLOR_BLACK_CLASS_9;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.messageModel.createDate/1000.0];
        NSString *dateStr = [dateFormatter stringFromDate:date];
        self.questionTimeLabel.text = dateStr;
    }
    if (indexPath.row == 1) {
        UILabel *backTitlLabel = [UILabel new];
        [cell.contentView addSubview:backTitlLabel];
        [backTitlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(12);
            make.left.equalTo(12);
        }];
        backTitlLabel.text = @"系统回复内容：";
        backTitlLabel.font = [UIFont systemFontOfSize:16];
        backTitlLabel.textColor = [UIColor blackColor];
        
        self.backContentLabel = [UILabel new];
        [cell.contentView addSubview:self.backContentLabel];
        self.backContentLabel.numberOfLines = 0;
        [self.backContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(12);
            make.top.equalTo(backTitlLabel.mas_bottom).equalTo(4);
            make.right.equalTo(-12);
            make.height.greaterThanOrEqualTo(0);
        }];
        self.backContentLabel.font = [UIFont systemFontOfSize:16];
        self.backContentLabel.textColor = COLOR_BLACK_CLASS_9;
        self.backContentLabel.text = self.messageModel.replyContent;
        
        self.backTimeLabel = [UILabel new];
        [cell.contentView addSubview:self.backTimeLabel];
        [self.backTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-12);
            make.top.equalTo(self.backContentLabel.mas_bottom).equalTo(4);
            make.bottom.equalTo(-12);
        }];
        self.backTimeLabel.textAlignment = NSTextAlignmentRight;
        self.backTimeLabel.font = [UIFont systemFontOfSize:16];
        self.backTimeLabel.textColor = COLOR_BLACK_CLASS_9;
        self.backTimeLabel.text = self.messageModel.replyTime;
    }
    
    cell.userInteractionEnabled = NO;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(64);
            make.left.right.bottom.equalTo(0);
        }];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = kBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    return _tableView;
}

@end
