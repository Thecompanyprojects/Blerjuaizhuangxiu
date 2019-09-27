//
//  BLEJBudgetPriceController.m
//  Calculator
//
//  Created by 赵春浩 on 17/4/28.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import "BLEJBudgetPriceController.h"
#import "BLEJBudgetPriceCell.h"
#import "BLEJBudgetPriceHeaderCell.h"
#import "BLEJBudgetPriceGroupHeaderCell.h"
#import "BLEJBudgetPriceFooterCell.h"

#import "BLEJCalculatorBottomShadowView.h"
#import "ZCHCalculatorSimpleOfferModel.h"
#import "ZCHCalculatorRoomListModel.h"
#import "ZCHCalculatorItemsModel.h"
#import "BLEJPRriceDetailCell.h"

static NSString *reuseIdentifier = @"BLEJBudgetPriceCell";
static NSString *reuseHeaderIdentifier = @"BLEJBudgetPriceGroupHeaderCell";
@interface BLEJBudgetPriceController ()<BLEJBudgetPriceGroupHeaderCellDelegate, BLEJBudgetPriceCellDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (assign, nonatomic) NSInteger totalSection;

// 用于标记分组视图中的减号按钮是否被点击了
@property (strong, nonatomic) NSMutableArray *isGroupBtnClick;

@property (strong, nonatomic) BLEJBudgetPriceHeaderCell *topHeaderView;
@property (strong, nonatomic) BLEJBudgetPriceFooterCell *bottomFooterView;

// 底部弹出视图
@property (strong, nonatomic) BLEJCalculatorBottomShadowView *bottomView;

// 标记被点击的cell
@property (strong, nonatomic) NSIndexPath *isClickedCellIndexPath;
// 标记被点击的组
@property (assign, nonatomic) NSInteger section;

@property (strong, nonatomic) UIButton *simpleBtn;
@property (strong, nonatomic) UIButton *refineBtn;
@property (strong, nonatomic) UILabel *sumPriceLabel;
@end

@implementation BLEJBudgetPriceController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"预算报价";
    
    self.view.backgroundColor = kBackgroundColor;

    self.isGroupBtnClick = [NSMutableArray array];
    self.isClickedCellIndexPath = [[NSIndexPath alloc] init];

    for (int i = 0; i < 3 + [self.hallNum integerValue] + [self.diningRoomNum integerValue] + [self.kitchenNum integerValue] + [self.bedroomNum integerValue] + [self.bathroomNum integerValue] + [self.balconyNum integerValue]; i ++) {
        
        [self.isGroupBtnClick addObject:@{@"isClick" : @"0"}];
    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 115, BLEJWidth, BLEJHeight - 115) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = kBackgroundColor;
    self.tableView.rowHeight = 60;
    [self.tableView registerNib:[UINib nibWithNibName:@"BLEJBudgetPriceCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"BLEJBudgetPriceGroupHeaderCell" bundle:nil]  forHeaderFooterViewReuseIdentifier:reuseHeaderIdentifier];
    
  // /增加头部的简装按钮和精装/
    [self addTopSelectBtn];
    
    self.bottomView = [[BLEJCalculatorBottomShadowView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    self.bottomView.hidden = YES;
    self.bottomView.dataArr = self.suppleListArr;
    [self.view addSubview:self.bottomView];
    
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReplaceMes:) name:@"didClickCalculatorBottomViewConfirmBtnReplace" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAddMes:) name:@"didClickCalculatorBottomViewConfirmBtnAdd" object:nil];
}

- (void)addTopSelectBtn {
   
   
    /*简装报价*/
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, BLEJWidth, 50)];
    if (isiPhoneX) {
        bgView.frame = CGRectMake(0, 78, BLEJWidth, 50);
    }
   
    bgView.backgroundColor = kColorRGB(0xdedede);
    [self.view addSubview:bgView];
     /*中间的那个线*/
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(BLEJWidth * 0.5 - 0.5, 10, 1, 30)];
    sepLine.backgroundColor = [UIColor darkGrayColor] ;
    [bgView addSubview:sepLine];
    
    UIButton *simpleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth * 0.5 - 0.5, bgView.height)];
    [simpleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [simpleBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [simpleBtn addTarget:self action:@selector(didClickSimpleBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.simpleBtn = simpleBtn;
    [bgView addSubview:simpleBtn];
    
    if (self.calculatorTotalModel == nil) {
        
        [simpleBtn setTitle:@"简装报价" forState:UIControlStateNormal];
        
    } else {
        
        if ([self.calculatorTotalModel.isPackage boolValue]) {
            
            [simpleBtn setTitle:[NSString stringWithFormat:@"%@套餐报价", self.calculatorTotalModel.packagePrice] forState:UIControlStateNormal];
        } else {
            
            [simpleBtn setTitle:@"简装报价" forState:UIControlStateNormal];
        }
    }

     /*简装报价*/
    UIButton *refineBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth * 0.5 + 0.5, 0, BLEJWidth * 0.5 - 0.5, bgView.height)];
    [refineBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [refineBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [refineBtn addTarget:self action:@selector(didClickRefineBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.refineBtn = refineBtn;
    [bgView addSubview:refineBtn];
    if (self.calculatorRefineModel == nil) {
        
        [refineBtn setTitle:@"精装报价" forState:UIControlStateNormal];
    } else {
        
        if ([self.calculatorRefineModel.isPackage boolValue]) {
            
            [refineBtn setTitle:[NSString stringWithFormat:@"%@套餐报价", self.calculatorRefineModel.packagePrice] forState:UIControlStateNormal];
        } else {
            
            [refineBtn setTitle:@"精装报价" forState:UIControlStateNormal];
        }
    }
  
    
    if (self.calculatorTotalModel != nil) {
        
        refineBtn.selected = NO;
        simpleBtn.selected = YES;
        [self settingCountWithType:1];

    } else {
        
        simpleBtn.selected = NO;
        refineBtn.selected = YES;
        [self settingCountWithType:0];

    }
    
  
}

- (void)settingCountWithType:(BOOL)isSimple {
    
    if (isSimple) {
        
        if (self.calculatorTotalModel == nil) {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该公司没有进行简装设置"];
            return;
        }
        if ([self.calculatorTotalModel.isPackage boolValue] == 1) {
            
            [self addbottomViewWithoutDetailContent];
            self.totalSection = 0;
            float pricenum = [self.calculatorTotalModel.total floatValue];
            self.sumPriceLabel.text = [NSString stringWithFormat:@"%.2f",pricenum];
        } else {
            
            if ([self.calculatorTotalModel.hideDetail boolValue] == 1) {
                
                self.totalSection = 0;
                [self addHeaderAndFooterNoDetail];
            } else {
                [self addHeaderViewAndFooterView];
                self.totalSection = 1 + [self.hallNum integerValue] + [self.diningRoomNum integerValue] + [self.kitchenNum integerValue] + [self.bedroomNum integerValue] + [self.bathroomNum integerValue] + [self.balconyNum integerValue];
            }
           [self reloadHeaderData];
        }
    } else {
        
        if (self.calculatorRefineModel == nil) {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该公司没有进行精装设置"];
            return;
        }
        if ([self.calculatorRefineModel.isPackage boolValue] == 1) {
            
            [self addbottomViewWithoutDetailContent];
            self.totalSection = 0;
            //self.sumPriceLabel.text = self.calculatorRefineModel.total;
            float pricenum = [self.calculatorRefineModel.total floatValue];
            self.sumPriceLabel.text = [NSString stringWithFormat:@"%.2f",pricenum];
        } else {
            
            if ([self.calculatorRefineModel.hideDetail boolValue] == 1) {
                
                [self addHeaderAndFooterNoDetail];
                self.totalSection = 0;
            } else {
                
                [self addHeaderViewAndFooterView];
                self.totalSection = 1 + [self.hallNum integerValue] + [self.diningRoomNum integerValue] + [self.kitchenNum integerValue] + [self.bedroomNum integerValue] + [self.bathroomNum integerValue] + [self.balconyNum integerValue];
            }
           [self reloadHeaderData];
        }
    }
}


- (void)addHeaderViewAndFooterView {
    
    self.topHeaderView = [BLEJBudgetPriceHeaderCell blej_viewFromXib];
    self.topHeaderView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIView *topView = [[UIView alloc] initWithFrame:self.topHeaderView.frame];
    [topView addSubview:self.topHeaderView];
    self.tableView.tableHeaderView = topView;
    
    NSString *str = @"温馨提示：尊敬的业主您好，您现在看到的是我公司的预算报价总计，稍后我公司将有客服人员与您联系，并将详细报价清单发送给您，如有打扰敬请谅解！";

    CGSize size = [str boundingRectWithSize:CGSizeMake(BLEJWidth-20, MAXFLOAT) withFont:[UIFont systemFontOfSize:15]];
    UIView *bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 80 + size.height + 20)];
    UIView *bottomTopBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, size.height + 20)];
    bottomTopBgView.backgroundColor = [UIColor lightGrayColor];
    [bottomBgView addSubview:bottomTopBgView];
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, BLEJWidth-20, size.height)];
    bottomLabel.text = str;
    bottomLabel.textAlignment = NSTextAlignmentLeft;
    bottomLabel.textColor = [UIColor darkGrayColor];
    bottomLabel.font = [UIFont systemFontOfSize:15];
    bottomLabel.numberOfLines = 0;
    [bottomTopBgView addSubview:bottomLabel];
    self.tableView.tableFooterView = bottomBgView;
    
}

- (void)addHeaderAndFooterNoDetail {
    
    self.topHeaderView = [BLEJBudgetPriceHeaderCell blej_viewFromXib];
    self.topHeaderView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.bottomFooterView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UIView *topView = [[UIView alloc] initWithFrame:self.topHeaderView.frame];
    [topView addSubview:self.topHeaderView];
    self.tableView.tableHeaderView = topView;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight - CGRectGetMaxY(self.topHeaderView.frame) - 64 - 51)];
    if (isiPhoneX) {
        bottomView.frame = CGRectMake(0, 0, BLEJWidth, BLEJHeight - CGRectGetMaxY(self.topHeaderView.frame) - 78 - 51);
    }
    bottomView.backgroundColor = White_Color;
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, BLEJWidth, 44)];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.backgroundColor = kColorRGB(0xdedede);
    tipLabel.font = [UIFont systemFontOfSize:16];
    tipLabel.text = @"程序员小哥友情提示：预算非决算！";
    tipLabel.textColor = [UIColor redColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:tipLabel];
    
   NSString *str = @"温馨提示：尊敬的业主您好，您现在看到的是我公司的预算报价总计，稍后我公司将有客服人员与您联系，并将详细报价清单发送给您，如有打扰敬请谅解！";
  //  NSString *str = self.calculatorTempletModel.introuction;
    CGSize size = [str boundingRectWithSize:CGSizeMake(BLEJWidth-20, MAXFLOAT) withFont:[UIFont systemFontOfSize:15]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, tipLabel.bottom + 20, BLEJWidth - 20, size.height)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:15];
    label.numberOfLines = 0;
    label.text = str;
    [bottomView addSubview:label];
    
    self.tableView.tableFooterView = bottomView;
}


- (void)addbottomViewWithoutDetailContent {
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight - 51 - 64)];
    if (isiPhoneX) {
        bottomView.frame = CGRectMake(0, 0, BLEJWidth, BLEJHeight - 51 - 78);
    }
    bottomView.backgroundColor = White_Color;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 150)];
    topView.backgroundColor = kColorRGB(0xdedede);
    [bottomView addSubview:topView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, BLEJWidth - 20, 20)];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.text = @"根据该面积的预算报价为:";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [topView addSubview:titleLabel];
    
    UILabel *sumPriceLabel = [[UILabel alloc] init];
    sumPriceLabel.textColor = [UIColor redColor];
    sumPriceLabel.font = [UIFont systemFontOfSize:45];
    self.sumPriceLabel = sumPriceLabel;
    sumPriceLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:sumPriceLabel];
    [sumPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(topView);
        make.top.mas_equalTo(@30);
        make.height.mas_equalTo(@120);
    }];
    
    UILabel *unitLabel = [[UILabel alloc] init];
    unitLabel.textColor = [UIColor redColor];
    unitLabel.font = [UIFont systemFontOfSize:16];
    unitLabel.text = @"元";
    unitLabel.textAlignment = NSTextAlignmentLeft;
    [topView addSubview:unitLabel];
    [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(sumPriceLabel).offset(-40);
        make.left.mas_equalTo(sumPriceLabel.mas_right).offset(5);
    }];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 151, BLEJWidth, 44)];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.backgroundColor = kColorRGB(0xdedede);
    tipLabel.font = [UIFont systemFontOfSize:16];
    tipLabel.text = @"程序员小哥友情提示：预算非决算！";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor redColor];
    [bottomView addSubview:tipLabel];
    
    
    NSString *str = @"温馨提示：尊敬的业主您好，您现在看到的是我公司的预算报价总计，稍后我公司将有客服人员与您联系，并将详细报价清单发送给您，如有打扰敬请谅解！";
   // NSString *str = self.calculatorTempletModel.introuction;
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(BLEJWidth-20, MAXFLOAT) withFont:[UIFont systemFontOfSize:15]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, tipLabel.bottom + 20, BLEJWidth - 20, size.height)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:15];
    label.numberOfLines = 0;
    label.text = str;
    [bottomView addSubview:label];
    
    self.tableView.tableFooterView = bottomView;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 0.0001)];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.totalSection;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == self.totalSection - 1) {
        return 0;
    }
    ZCHCalculatorRoomListModel *model;
    if (self.simpleBtn.selected == YES) {
        model = [self.calculatorTotalModel.roomList objectAtIndex:section];
    } else {
        model = self.calculatorRefineModel.roomList[section];
    }
    return model.items.count?:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BLEJBudgetPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    ZCHCalculatorRoomListModel *model;
    if (self.simpleBtn.selected == YES) {
        model = self.calculatorTotalModel.roomList[indexPath.section];
    } else {
        
        model = self.calculatorRefineModel.roomList[indexPath.section];
    }
    cell.itemModel = model.items[indexPath.row];
    cell.isShowMinus = [[self.isGroupBtnClick[indexPath.section] objectForKey:@"isClick"] boolValue];
    cell.indexPath = indexPath;
    cell.budgetPriceCellDelegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCHCalculatorRoomListModel *model;
    if (self.simpleBtn.selected == YES) {
        
        model = self.calculatorTotalModel.roomList[indexPath.section];
    } else {
        
        model = self.calculatorRefineModel.roomList[indexPath.section];
    }
   
    self.isClickedCellIndexPath = indexPath;
    self.bottomView.allcalModel = model.items[indexPath.row];
    if (indexPath.section == self.totalSection - 2 || (indexPath.section == self.totalSection - 3 && [@[@"2021", @"2022", @"2023", @"2024"] containsObject:  [NSString stringWithFormat:@"%lu",(unsigned long)self.bottomView.allcalModel.templeteTypeNo]])) {
        self.bottomView.edittingType = @"3";
    } else {
        self.bottomView.edittingType = @"1";
    }
    self.bottomView.viewType = 2;
    self.bottomView.hidden = NO;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    BLEJBudgetPriceGroupHeaderCell *headerCell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseHeaderIdentifier];
    
    if (section == self.totalSection - 1) {
        headerCell.titleName = @"预算总计";
        if (self.simpleBtn.selected == YES) {

            float pricenum = [self.calculatorTotalModel.total floatValue];
            headerCell.sumPrice = [NSString stringWithFormat:@"%.2f",pricenum];
        } else {

            float pricenum = [self.calculatorRefineModel.total floatValue];
            headerCell.sumPrice = [NSString stringWithFormat:@"%.2f",pricenum];
        }
    } else {
        ZCHCalculatorRoomListModel *model;
        if (self.simpleBtn.selected == YES) {
            
            if (section>=self.calculatorTotalModel.roomList.count) {
                
            }
            else
            {
                model = self.calculatorTotalModel.roomList[section];
            }
            
        } else {
            
            if (section>=self.calculatorRefineModel.roomList.count) {

            }
            else
            {
                model = self.calculatorRefineModel.roomList[section];
            }

        }
        headerCell.titleName = model.name;
        headerCell.sumPrice = [NSString stringWithFormat:@"%.2lf", [model.sum doubleValue]];
    }
    headerCell.budgetPriceGroupHeaderCellDelegate = self;
    headerCell.sectionIndex = section;
    headerCell.isRotate = [[self.isGroupBtnClick[section] objectForKey:@"isClick"] boolValue];
    
    if (section == self.totalSection - 1 || section == self.totalSection - 2) {
        
        headerCell.isShowPlusAndMinusBtn = NO;
    } else {
        
        headerCell.isShowPlusAndMinusBtn = YES;
    }
    
    return headerCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}


#pragma mark - 刷新数据
- (void)reloadAllData {
    
    double directMoney = 0;
    double bedroomMoney = 0;
    double bathroomMoney = 0;
    double hallMoney = 0;
    double kitchenMoney = 0;
    double balconyMoney = 0;
    double diningMoney = 0;
    
    ZCHCalculatorSimpleOfferModel *totalModel;
    if (self.simpleBtn.selected == YES) {
        
        totalModel = self.calculatorTotalModel;
    } else {
        
        totalModel = self.calculatorRefineModel;
    }
    
    for (ZCHCalculatorRoomListModel *model in totalModel.roomList) {
        
        NSInteger index = [model.typeClass integerValue];
        switch (index) {
            case 0:// 客厅
                hallMoney += [model.sum doubleValue];
                break;
            case 1:// 餐厅
                diningMoney += [model.sum doubleValue];
                break;
            case 2:// 卧室
                bedroomMoney += [model.sum doubleValue];
                break;
            case 3:// 阳台
                balconyMoney += [model.sum doubleValue];
                break;
            case 4:// 卫生间
                bathroomMoney += [model.sum doubleValue];
                break;
            case 5:// 厨房
                kitchenMoney += [model.sum doubleValue];
                break;
            default:
                break;
        }
    }
    
    totalModel.sittingTotal = [self roundDouble:hallMoney];
    totalModel.dinningTotal = [self roundDouble:diningMoney];
    totalModel.bedroomTotal = [self roundDouble:bedroomMoney];
    totalModel.balconeyTotal = [self roundDouble:balconyMoney];
    totalModel.washTotal = [self roundDouble:bathroomMoney];
    totalModel.kitchenTotal = [self roundDouble:kitchenMoney];
    
    
    directMoney = hallMoney + diningMoney + bedroomMoney + balconyMoney + bathroomMoney + kitchenMoney;
    totalModel.directTotal = [self roundDouble:directMoney];
    [self reloadTotalMoney];
    
    ZCHCalculatorRoomListModel *modelManager = totalModel.roomList[self.totalSection - 2];// 管理费用
    ZCHCalculatorRoomListModel *modelElse = totalModel.roomList[self.totalSection - 3];// 其他费用
    
    totalModel.otherTotal = modelElse.sum;
    totalModel.managerTotal = modelManager.sum;
    totalModel.total = [self roundDouble:directMoney + [modelManager.sum doubleValue] + [modelElse.sum doubleValue]];
    
    [self reloadHeaderData];
}

- (void)reloadHeaderData {
    
    ZCHCalculatorSimpleOfferModel *totalModel;
    if (self.simpleBtn.selected == YES) {
        
        totalModel = self.calculatorTotalModel;
    } else {
        
        totalModel = self.calculatorRefineModel;
    }
  
    UIView *topView = self.tableView.tableHeaderView;
    for (UIView *view in topView.subviews) {
        if ([view isKindOfClass:[BLEJBudgetPriceHeaderCell class]]) {
            ((BLEJBudgetPriceHeaderCell *)view).hallMoney = [NSString stringWithFormat:@"%.2lf", [totalModel.sittingTotal doubleValue]];// 客厅
            ((BLEJBudgetPriceHeaderCell *)view).bedroomMoney = [NSString stringWithFormat:@"%.2lf", [totalModel.bedroomTotal doubleValue]];// 卧室
            ((BLEJBudgetPriceHeaderCell *)view).kitchenMoney = [NSString stringWithFormat:@"%.2lf", [totalModel.kitchenTotal doubleValue]];// 厨房
            ((BLEJBudgetPriceHeaderCell *)view).bathroomMoney = [NSString stringWithFormat:@"%.2lf", [totalModel.washTotal doubleValue]];// 卫生间
            ((BLEJBudgetPriceHeaderCell *)view).balconyMoney = [NSString stringWithFormat:@"%.2lf", [totalModel.balconeyTotal doubleValue]];// 阳台
            ((BLEJBudgetPriceHeaderCell *)view).diningMoney = [NSString stringWithFormat:@"%.2lf", [totalModel.dinningTotal doubleValue]];// 餐厅
            ((BLEJBudgetPriceHeaderCell *)view).elseMoney = [NSString stringWithFormat:@"%.2lf", [totalModel.otherTotal doubleValue]];// 其他
            ((BLEJBudgetPriceHeaderCell *)view).manageMoney = [NSString stringWithFormat:@"%.2lf", [totalModel.managerTotal doubleValue]];// 管理
            ((BLEJBudgetPriceHeaderCell *)view).totalMoney = [NSString stringWithFormat:@"%.2lf", [totalModel.total doubleValue]];// 总价
        }
    }
    
}

- (void)reloadGroupTotalPrice:(NSInteger)section {
    
    double sumPrice = 0;
    ZCHCalculatorRoomListModel *model;
    if (self.simpleBtn.selected == YES) {
        
        model = self.calculatorTotalModel.roomList[section];
    } else {
        
        model = self.calculatorRefineModel.roomList[section];
    }
    NSArray *modelArr = model.items;
    for (ZCHCalculatorItemsModel *model in modelArr) {
        sumPrice += [model.sumMoney doubleValue];
    }
    
    model.sum = [self roundDouble:sumPrice];
}

- (void)reloadTotalMoney {
    
    ZCHCalculatorSimpleOfferModel *totalModel;
    if (self.simpleBtn.selected == YES) {
        
        totalModel = self.calculatorTotalModel;
    } else {
        
        totalModel = self.calculatorRefineModel;
    }
    
    ZCHCalculatorRoomListModel *modelManager = totalModel.roomList[self.totalSection - 2];// 管理费用
    ZCHCalculatorRoomListModel *modelElse = totalModel.roomList[self.totalSection - 3];// 其他费用
    
    
    for (ZCHCalculatorItemsModel *model in modelElse.items) {
        
        if ([@[@"2021", @"2022", @"2023"] containsObject:model.templeteTypeNo]) {
            model.number = totalModel.directTotal;
            model.sumMoney = [self roundDouble:[model.supplementPrice doubleValue] * [totalModel.directTotal doubleValue]];
        }
    }
    [self reloadGroupTotalPrice:self.totalSection - 3];
    for (ZCHCalculatorItemsModel *model in modelManager.items) {
        
        if ([model.supplementName isEqualToString:@"直接费用"]) {
            
            model.number = totalModel.directTotal;
            model.sumMoney = [self roundDouble:[model.supplementPrice doubleValue] * [totalModel.directTotal doubleValue]];
        }
        
        if ([model.supplementName isEqualToString:@"其他费用"]) {
            
            model.number = modelElse.sum;
            model.sumMoney = [self roundDouble:[model.supplementPrice doubleValue] * [model.number doubleValue]];
        }
    }
    [self reloadGroupTotalPrice:self.totalSection - 2];
}

#pragma mark - 简装报价的点击事件

- (void)didClickSimpleBtn:(UIButton *)btn {
    
    if (self.calculatorTotalModel == nil) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该公司还没有设置简装报价"];
        return;
    }
    if (btn.selected) {
        return;
    }
    [self settingCountWithType:1];
    btn.selected = YES;
    self.refineBtn.selected = NO;
    if ([self.calculatorTotalModel.isPackage boolValue]) {
        
      
        float pricenum = [self.calculatorTotalModel.total floatValue];
        self.sumPriceLabel.text = [NSString stringWithFormat:@"%.2f",pricenum];
    } else {
        
        [self reloadHeaderData];
    }
    for (int i = 0; i < self.isGroupBtnClick.count; i ++) {
        
        NSDictionary *dic = self.isGroupBtnClick[i];
        if ([dic[@"isClick"] boolValue] == 1) {
            
            [self.isGroupBtnClick replaceObjectAtIndex:i withObject:@{@"isClick" : @"0"}];
        }
    }
    [self.tableView reloadData];
}

// 精装报价的点击事件
- (void)didClickRefineBtn:(UIButton *)btn {
    
    if (self.calculatorRefineModel == nil) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该公司还没有设置精装报价"];
        return;
    }
    
    if (btn.selected) {
        return;
    }
    [self settingCountWithType:0];
    btn.selected = YES;
    self.simpleBtn.selected = NO;
    if ([self.calculatorRefineModel.isPackage boolValue]) {
        
        //self.sumPriceLabel.text = self.calculatorRefineModel.total;
        float pricenum = [self.calculatorRefineModel.total floatValue];
        self.sumPriceLabel.text = [NSString stringWithFormat:@"%.2f",pricenum];
    } else {
        
        [self reloadHeaderData];
    }
    for (int i = 0; i < self.isGroupBtnClick.count; i ++) {
        
        NSDictionary *dic = self.isGroupBtnClick[i];
        if ([dic[@"isClick"] boolValue] == 1) {
            
            [self.isGroupBtnClick replaceObjectAtIndex:i withObject:@{@"isClick" : @"0"}];
        }
    }
    [self.tableView reloadData];
}


#pragma mark - BLEJBudgetPriceGroupHeaderCellDelegate方法
// 点击+
- (void)didClickPlusBtnWithSection:(NSInteger)section {
    
    for (int i = 0; i < self.isGroupBtnClick.count; i ++) {
        
        NSDictionary *dic = self.isGroupBtnClick[i];
        if ([dic[@"isClick"] boolValue] == 1) {
            
            [self.isGroupBtnClick replaceObjectAtIndex:i withObject:@{@"isClick" : @"0"}];
        }
    }
        [self.tableView reloadData];
    

    
    self.section = section;
    self.bottomView.allcalModel = nil;
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"补充报价" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.suppleListArr && self.suppleListArr.count != 0) {
            
            self.bottomView.viewType = 1;
            self.bottomView.hidden = NO;
        } else {
            [self.view hudShowWithText:@"暂无补充报价项目"];
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"新项目报价" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.bottomView.allcalModel = nil;
        self.bottomView.viewType = 4;
        self.bottomView.edittingType = @"0";
        self.bottomView.showType = @"2";
        self.bottomView.hidden = NO;
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:action];
    [alertC addAction:action2];
    [alertC addAction:action4];
    [self presentViewController:alertC animated:YES completion:nil];
}

// 点击-
- (void)didClickMinusBtnWithSection:(NSInteger)section andIsSelected:(BOOL)isSeleted {
    
    [self.isGroupBtnClick replaceObjectAtIndex:section withObject:@{@"isClick" : [NSString stringWithFormat:@"%d", isSeleted]}];
    [self.tableView reloadData];
}

#pragma mark - BLEJBudgetPriceCellDelegate方法
- (void)didClickDeleteBtn:(NSIndexPath *)indexPath {
    
    ZCHCalculatorRoomListModel *model;
    if (self.simpleBtn.selected == YES) {
        
        model = self.calculatorTotalModel.roomList[indexPath.section];
    } else {
        
        model = self.calculatorRefineModel.roomList[indexPath.section];
    }
    [model.items removeObjectAtIndex:indexPath.row];
    
    [self reloadGroupTotalPrice:indexPath.section];
    [self reloadAllData];
    [self.tableView reloadData];
}

// 通知处理
- (void)notificationReplaceMes:(NSNotification *)noc {
    
    NSDictionary *dic = noc.userInfo;
    ZCHCalculatorRoomListModel *model;
    if (self.simpleBtn.selected == YES) {
        
        model = self.calculatorTotalModel.roomList[self.isClickedCellIndexPath.section];
    } else {
        
        model = self.calculatorRefineModel.roomList[self.isClickedCellIndexPath.section];
    }
    BLRJCalculatortempletModelAllCalculatorTypes *itemModel = model.items[self.isClickedCellIndexPath.row];
    itemModel.supplementName = [dic objectForKey:@"name"];
    itemModel.number = [[dic objectForKey:@"area"] unsignedIntegerValue];
    itemModel.supplementPrice = [NSString stringWithFormat:@"%@",[dic objectForKey:@"price"]];
    itemModel.sumMoney = (unsigned long)[self roundDouble:[[dic objectForKey:@"price"]unsignedIntegerValue ] * [[dic objectForKey:@"area"] unsignedIntegerValue]];
    
    itemModel.supplementTech = [dic objectForKey:@"supplementTech"];
    
    [self reloadGroupTotalPrice:self.isClickedCellIndexPath.section];
    [self reloadAllData];
    [self.tableView reloadData];
}

- (void)notificationAddMes:(NSNotification *)noc {
    
    NSDictionary *dic = noc.userInfo;
    ZCHCalculatorItemsModel *itemModel = [[ZCHCalculatorItemsModel alloc] init];
    itemModel.supplementName = [dic objectForKey:@"name"];
    itemModel.number = [dic objectForKey:@"area"];
    itemModel.supplementPrice = [dic objectForKey:@"price"];
    itemModel.supplementUnit = [dic objectForKey:@"unitName"];
    itemModel.sumMoney = [self roundDouble:[[dic objectForKey:@"price"] doubleValue] * [[dic objectForKey:@"area"] doubleValue]];
    
    itemModel.supplementTech = [dic objectForKey:@"supplementTech"];
    itemModel.templeteTypeNo = @"0";
//    itemModel.supplementUnit = @"";
    
    ZCHCalculatorRoomListModel *model;
    if (self.simpleBtn.selected == YES) {
        
        model = self.calculatorTotalModel.roomList[self.section];
    } else {
        
        model = self.calculatorRefineModel.roomList[self.section];
    }
    [model.items insertObject:itemModel atIndex:0];
    
    [self reloadGroupTotalPrice:self.section];
    [self reloadAllData];
    [self.tableView reloadData];
}



// 处理四舍五入的
- (NSString *)roundDouble:(double)price {
    
    /// 将计算的数值加千分之五。精度
    CGFloat i = price + 0.005;
    
    /// 首先保留三位小数
    NSString *strTemp       = [NSString stringWithFormat:@"%f",i];
    NSRange range           = [strTemp rangeOfString:@"."];
    /// 在截取两位小数
    NSString *strLastResult = [strTemp substringWithRange:NSMakeRange(0, range.location+3)];
    NSLog(@"first method = %@",strLastResult);//实际输出143.55
    
    return strLastResult;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didClickCalculatorBottomViewConfirmBtnReplace" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didClickCalculatorBottomViewConfirmBtnAdd" object:nil];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
