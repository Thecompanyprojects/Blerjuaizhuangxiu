//
//  ZCHConstructionCommentController.m
//  iDecoration
//
//  Created by 赵春浩 on 17/6/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHConstructionCommentController.h"
#import "ZCHStarCommentCell.h"
#import "ZCHConstructionCommentModel.h"

static NSString *reuseIdentifier = @"ZCHStarCommentCell";
@interface ZCHConstructionCommentController ()<UITextViewDelegate, ZCHStarCommentCellDelegate>

// 存储人员列表
@property (strong, nonatomic) NSMutableArray *listArr;
// 存储工地信息
@property (strong, nonatomic) NSMutableDictionary *constructionDic;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *pHLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) UIButton *releaseBtn;
@property (weak, nonatomic) IBOutlet UILabel *sumCommentLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *starCell;

// 工地评价
@property (strong, nonatomic) NSMutableString *contentText;
// 综合评价五项内容
@property (strong, nonatomic) NSMutableArray *starGrade;
// 对应人员列表的评论与星星评级
@property (strong, nonatomic) NSMutableArray *listStarAndCommmentArr;

@end

@implementation ZCHConstructionCommentController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"工地评价";
//    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.listArr = [NSMutableArray array];
    self.contentText = [NSMutableString string];
    self.textView.delegate = self;
    self.starGrade = [NSMutableArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil];
    self.constructionDic = [NSMutableDictionary dictionary];
    self.listStarAndCommmentArr = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZCHStarCommentCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    if (self.isNewComment) {
        
        [self addRightItem];
    }
    
    self.textView.userInteractionEnabled = self.isNewComment;
    self.starCell.userInteractionEnabled = self.isNewComment;
    self.sumCommentLabel.hidden = self.isNewComment;
    self.textView.backgroundColor = RGB(246, 246, 246);
    
    [self setData];
}

#pragma mark - 添加navBar右侧的编辑按钮
- (void)addRightItem {
    
    // 设置导航栏最右侧的按钮
    UIButton *releaseBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    releaseBtn.frame = CGRectMake(0, 0, 44, 44);
    [releaseBtn setTitle:@"发布" forState:UIControlStateNormal];
    [releaseBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    releaseBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    releaseBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    releaseBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    releaseBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [releaseBtn addTarget:self action:@selector(didClickReleaseBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.releaseBtn = releaseBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseBtn];
}

#pragma mark - 获取数据
- (void)setData {
    
    if (self.isNewComment) {
        
        NSString *apiStr = [BASEURL stringByAppendingString:@"constructionEvaluate/getConstructionInfo.do"];
        NSDictionary *param = @{
                                @"constructionId" : self.constructionId
                                };
        [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
            
            if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
                
                [self.listArr removeAllObjects];
                NSDictionary *dicData = responseObj[@"data"];
                NSString *agencyId = [[[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT] objectForKey:@"agencyId"];
                self.listArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[ZCHConstructionCommentModel class] json:dicData[@"personList"]]];
                self.constructionDic = dicData[@"constructionEvaluate"];
                
                for (int i = 0; i < self.listArr.count; i ++) {
                    
                    ZCHConstructionCommentModel *model = self.listArr[i];
                    
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"", @"content", @"0", @"grade", self.constructionId, @"constructionId", nil];
                    [dic setObject:self.constructionDic[@"companyId"] forKey:@"companyId"];
                    [dic setObject:agencyId forKey:@"proprietorId"];
                    [dic setObject:model.agencyId forKey:@"agencyId"];
                    [self.listStarAndCommmentArr addObject:dic];
                }
                
                [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.constructionDic[@"picUrl"]] placeholderImage:[UIImage imageNamed:@"default_icon"]];
                self.nameLabel.text = self.constructionDic[@"shareTitle"];
            }
            
            [self.tableView reloadTableViewWithRow:-1 andSection:2];
        } failed:^(NSString *errorMsg) {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
        }];
    } else {
        
        NSString *apiStr = [BASEURL stringByAppendingString:@"constructionEvaluate/getEvaluates.do"];
        NSDictionary *param = @{
                                @"constructionId" : self.constructionId
                                };
        [NetManager afGetRequest:apiStr parms:param finished:^(id responseObj) {
            
            if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
                
                [self.listArr removeAllObjects];
                NSDictionary *dicData = responseObj[@"data"];
                
                self.listArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[ZCHConstructionCommentModel class] json:dicData[@"personList"]]];
                self.constructionDic = dicData[@"constructionEvaluate"];
                
                [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.constructionDic[@"frontPage"]] placeholderImage:nil];
                self.textView.text = self.constructionDic[@"content"];
                if (![self.constructionDic[@"content"] isEqualToString:@""]) {
                    
                    self.pHLabel.hidden = YES;
                }
                
                self.nameLabel.text = self.constructionDic[@"shareTitle"];
                self.sumCommentLabel.text = self.constructionDic[@"sum"];
                
                UIButton *btnService = [self.view viewWithTag:[self.constructionDic[@"service"] integerValue] + 699];
                [self didClickServiceAttributeBtn:btnService];
                UIButton *btnPrice = [self.view viewWithTag:[self.constructionDic[@"price"] integerValue] + 709];
                [self didClickBudgetPriceBtn:btnPrice];
                UIButton *btnDesign = [self.view viewWithTag:[self.constructionDic[@"design"] integerValue] + 719];
                [self didClickDesignLevelBtn:btnDesign];
                UIButton *btnQuality = [self.view viewWithTag:[self.constructionDic[@"quality"] integerValue] + 729];
                [self didClickConstructionQualityBtn:btnQuality];
                UIButton *btnSpeed = [self.view viewWithTag:[self.constructionDic[@"speed"] integerValue] + 739];
                [self didClickConstructionSpeedBtn:btnSpeed];
                
            }
            
            [self.tableView reloadTableViewWithRow:-1 andSection:2];
        } failed:^(NSString *errorMsg) {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:errorMsg];
        }];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 2) {
        
        return self.listArr.count;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        
        ZCHStarCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        cell.isNewComment = self.isNewComment;
        cell.model = self.listArr[indexPath.row];
        if (self.isNewComment) {
            cell.indexPath = indexPath;
            cell.delegate = self;
            if (self.listStarAndCommmentArr.count > 0) {
                
                cell.dic = self.listStarAndCommmentArr[indexPath.row];
            }
        }
        cell.userInteractionEnabled = self.isNewComment;
        return cell;
    } else {
        
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

// 静态动态cell混用 此方法必须实现
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        
        return [super tableView:tableView indentationLevelForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    } else {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        
        return 190;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}

#pragma mark - 评价星星的点击事件
// 服务态度
- (IBAction)didClickServiceAttributeBtn:(UIButton *)sender {
    
    sender.selected = YES;
    for (int i = 700; i < sender.tag; i ++) {
        
        UIButton *btn = [self.view viewWithTag:i];
        btn.selected = YES;
    }
    
    for (int i = 704; i > sender.tag; i --) {
        
        UIButton *btn = [self.view viewWithTag:i];
        btn.selected = NO;
    }
    
    self.starGrade[0] = [NSString stringWithFormat:@"%ld", sender.tag - 700 + 1];
}

// 预算价格
- (IBAction)didClickBudgetPriceBtn:(UIButton *)sender {
    
    sender.selected = YES;
    for (int i = 710; i < sender.tag; i ++) {
        
        UIButton *btn = [self.view viewWithTag:i];
        btn.selected = YES;
    }
    
    for (int i = 714; i > sender.tag; i --) {
        
        UIButton *btn = [self.view viewWithTag:i];
        btn.selected = NO;
    }
    
    self.starGrade[1] = [NSString stringWithFormat:@"%ld", sender.tag - 710 + 1];
}

// 设计水平
- (IBAction)didClickDesignLevelBtn:(UIButton *)sender {
    
    sender.selected = YES;
    for (int i = 720; i < sender.tag; i ++) {
        
        UIButton *btn = [self.view viewWithTag:i];
        btn.selected = YES;
    }
    
    for (int i = 724; i > sender.tag; i --) {
        
        UIButton *btn = [self.view viewWithTag:i];
        btn.selected = NO;
    }
    
    self.starGrade[2] = [NSString stringWithFormat:@"%ld", sender.tag - 720 + 1];
}

// 施工质量
- (IBAction)didClickConstructionQualityBtn:(UIButton *)sender {
    
    sender.selected = YES;
    for (int i = 730; i < sender.tag; i ++) {
        
        UIButton *btn = [self.view viewWithTag:i];
        btn.selected = YES;
    }
    
    for (int i = 734; i > sender.tag; i --) {
        
        UIButton *btn = [self.view viewWithTag:i];
        btn.selected = NO;
    }
    
    self.starGrade[3] = [NSString stringWithFormat:@"%ld", sender.tag - 730 + 1];
}

// 施工速度
- (IBAction)didClickConstructionSpeedBtn:(UIButton *)sender {
    
    sender.selected = YES;
    for (int i = 740; i < sender.tag; i ++) {
        
        UIButton *btn = [self.view viewWithTag:i];
        btn.selected = YES;
    }
    
    for (int i = 744; i > sender.tag; i --) {
        
        UIButton *btn = [self.view viewWithTag:i];
        btn.selected = NO;
    }
    
    self.starGrade[4] = [NSString stringWithFormat:@"%ld", sender.tag - 740 + 1];
}

#pragma mark - ZCHStarCommentCellDelegate方法
- (void)finishEditCommentWithObject:(id)object andIndex:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *dic = self.listStarAndCommmentArr[indexPath.row];
    if ([object isKindOfClass:[NSString class]]) {
        
        [dic setObject:object forKey:@"content"];
        
    } else {
        
        [dic setObject:[NSString stringWithFormat:@"%ld", [((NSNumber *)object) integerValue]] forKey:@"grade"];
    }
    
    [self.listStarAndCommmentArr replaceObjectAtIndex:indexPath.row withObject:dic];
}

#pragma mark - 发布按钮的点击事件
- (void)didClickReleaseBtn:(UIButton *)btn {
    
    if ([self.contentText isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"还未评价该工地"];
        return;
    }
    NSArray *titleArr = @[@"服务态度还未评分", @"预算价格还未评分", @"设计水平还未评分", @"施工质量还未评分", @"施工速度还未评分"];
    for (int i = 0; i < self.starGrade.count; i ++) {
        
        if ([self.starGrade[i] isEqualToString:@"0"]) {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:titleArr[i]];
            return;
        }
    }
    
    for (int i = 0; i < self.listStarAndCommmentArr.count; i ++) {
        
        if ([[self.listStarAndCommmentArr[i] objectForKey:@"grade"] isEqualToString:@"0"]) {
            
            ZCHConstructionCommentModel *model = self.listArr[i];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:[NSString stringWithFormat:@"请给%@-%@打分", model.JobTypeName, model.trueName]];
             return;
        }
    }
    
    NSInteger sum = 0;
    
    for (NSString *grade in self.starGrade) {
        
        sum = sum + [grade integerValue];
    }
    
    
    NSString *agencyId = [[[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT] objectForKey:@"agencyId"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.listStarAndCommmentArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *arrStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"constructionEvaluate/save.do"];
    NSDictionary *dic = @{
                          @"constructionId" : self.constructionId,
                          @"companyId" : self.constructionDic[@"companyId"],
                          @"serviceGrade" : self.starGrade[0],
                          @"priceGrade" : self.starGrade[1],
                          @"designGrade" : self.starGrade[2],
                          @"qualityGrade" : self.starGrade[3],
                          @"speedGrade" : self.starGrade[4],
                          @"sumGrade" : [NSString stringWithFormat:@"%.1f", sum / 5.0],
                          @"proprietorId" : agencyId,
                          @"content" : self.contentText
                          };
    NSData *dataDic = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *arrStrDic = [[NSString alloc] initWithData:dataDic encoding:NSUTF8StringEncoding];
    
    
    NSDictionary *param = @{
                            @"ccem" : arrStrDic,
                            @"aeList" : arrStr
                            };
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [self.listArr removeAllObjects];
            NSDictionary *dic = responseObj[@"data"];
            self.listArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[ZCHConstructionCommentModel class] json:dic[@"personList"]]];
            self.constructionDic = dic[@"constructionEvaluate"];
            
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.constructionDic[@"picUrl"]] placeholderImage:nil];
            self.nameLabel.text = self.constructionDic[@"shareTitle"];
            [self.navigationController popViewControllerAnimated:YES];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"评价成功"];
            if (self.refreshBlock) {
                
                self.refreshBlock();
            }
        }
        
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:errorMsg];
    }];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    self.contentText = textView.text.mutableCopy;
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length) {
        
        self.pHLabel.hidden = YES;
    } else {
        
        self.pHLabel.hidden = NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
