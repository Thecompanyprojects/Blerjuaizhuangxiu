//
//  GoodsParameterView.m
//  iDecoration
//
//  Created by zuxi li on 2018/1/12.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "GoodsParameterView.h"
#import "GoodsParamterModel.h"
#import "EditGoodsParameterCell.h"

#import "GoodsListModel.h"
#import "GoodsPromotionCell.h"


@interface GoodsParameterView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *paramNameLabel;
@property (nonatomic, strong) UIButton *finishBtn;

@end

@implementation GoodsParameterView

@synthesize listArray = _listArray;
@synthesize promptArray = _promptArray;

#pragma mark - lifeMethod
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self paramNameLabel];
        [self finishBtn];
        [self tableView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self  = [super initWithFrame:frame];
    if (self) {
         self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self paramNameLabel];
        [self finishBtn];
        [self tableView];
    }
    return self;
}
#pragma  mark -normalMEthod
- (void)finishAction {
    if (self.finishBlock) {
        self.finishBlock(self);
    }
}
#pragma mark - UITableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.listArray.count > 0) {
         GoodsParamterModel *model = self.listArray[0];
        if ([model.name isEqualToString:@""]) {
            return 0;
        } else {
            return self.listArray.count;
        }
    }

    return self.promptArray.count>0?self.promptArray.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 参数和服务承诺
    if (self.listArray.count > 0) {
        EditGoodsParameterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditGoodsParameterCellSecond"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"EditGoodsParameterCell" owner:nil options:nil][1];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
        }
        
        GoodsParamterModel *model = self.listArray[indexPath.row];
        cell.nameLabel.text = model.name;
        cell.describeLabel.text = model.describ;
        return cell;
    }
    
    // 优惠券的
    if (self.promptArray.count > 0) {
        ActivityListModel *model = self.promptArray[indexPath.row];
        
        NSString *startTimeStr = [NSObject timeStringFromTimeIntervalString:model.startTime.doubleValue/1000.0 WithFromatter:@"yyyy.MM.dd"];
        NSString *endTimeStr = [NSObject timeStringFromTimeIntervalString:model.endTime.doubleValue/1000.0 WithFromatter:@"yyyy.MM.dd"];
        GoodsDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDiscountCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsDiscountCell" owner:nil options:nil][0];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            cell.valueLabel.text = model.discountMoney; // model.discountMoney;
            cell.conditionLabel.text = [NSString stringWithFormat:@"全店满减 | 满%@元可用", model.makeCondition];
            cell.timeLabel.text = [NSString stringWithFormat:@"%@-%@", startTimeStr, endTimeStr];
            cell.bgImageView.image = model.receiveStatus.integerValue > 0? [UIImage imageNamed:@"bg_jihuo"] : [UIImage imageNamed:@"bg_diban"];
        }

        return cell;
    }
    
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 60;
    return self.promptArray.count>0?118:60;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.listArray.count > 0) {
//        return  UITableViewAutomaticDimension;
//    }
//    if (self.promptArray.count > 0) {
//        // 60 120 148
//        PromptModel *model = self.promptArray[indexPath.row];
//        // 活动类型  活动类型1、全店满送 2、商品满送 3、全店满减 4、商品满减 5、全店优惠券 6、商品优惠券 7、套餐
//        //    @property (nonatomic, copy) NSString *activityType;
//        NSInteger type = [model.activityType integerValue];
//        switch (type) {
//            case 3:
//            case 5:
//                return 60;
//                break;
//            case 1:
//            case 2:
//            case 4:
//            case 6:
//                return 120;
//                break;
//            case 7:
//                return 148;
//                break;
//            default:
//                return 0;
//                break;
//        }
//    }
//    return 0;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.promptArray.count > 0) { // 点击了优惠券
        ActivityListModel *model = self.promptArray[indexPath.row];
        GoodsDiscountCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([self.delegate respondsToSelector:@selector(didSelectedPromotionAt:withPromptModel:goodsDiscountCell:)]) {
            [self.delegate didSelectedPromotionAt:indexPath.row withPromptModel:model goodsDiscountCell:cell];
        }
    }
}


#pragma mark - LazyMethod
-(NSMutableArray*)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array]; // [@[[GoodsParamterModel newModel]] mutableCopy];
    }
    return _listArray;
}

- (NSMutableArray<ActivityListModel *> *)promptArray {
    if (!_promptArray) {
        _promptArray = [NSMutableArray array];
    }
    return _promptArray;
}



- (void)setListArray:(NSMutableArray *)listArray {
    _listArray = listArray;
    [self.tableView reloadData];
}

- (void)setPromptArray:(NSMutableArray<ActivityListModel *> *)promptArray {
    _promptArray = promptArray;
    // 优惠券
    self.finishBtn.hidden = YES;
    [self.paramNameLabel setCornerOn:UIRectCornerTopRight|UIRectCornerTopLeft cornerWidth:8.0];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(44, 44));
        make.centerY.equalTo(self.paramNameLabel);
        make.right.equalTo(self.paramNameLabel).equalTo(0);
    }];
    [btn setImage:[UIImage imageNamed:@"icon_goods_shanchu"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paramNameLabel.mas_bottom).equalTo(-1);
        make.left.right.equalTo(0);
        make.bottom.equalTo(0);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
}

- (void)setTopTitle:(NSString *)topTitle {
    _topTitle = topTitle;
    self.paramNameLabel.text = _topTitle;
}
- (UILabel *)paramNameLabel {
    if (_paramNameLabel == nil) {
        _paramNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.25 * kSCREEN_HEIGHT - 64, kSCREEN_WIDTH, 50)];
        [self addSubview:_paramNameLabel];
        _paramNameLabel.font = [UIFont systemFontOfSize:16];
        _paramNameLabel.textAlignment = NSTextAlignmentCenter;
        _paramNameLabel.backgroundColor = [UIColor whiteColor];
        _paramNameLabel.textColor = kColorRGB(0x8f8f8f);
        
    }
    return _paramNameLabel;
}

- (UIButton *)finishBtn {
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_finishBtn];
        [_finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(50);
        }];
        _finishBtn.backgroundColor = kMainThemeColor;
        [_finishBtn setTitle:@"知道了" forState:UIControlStateNormal];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_finishBtn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _finishBtn;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.paramNameLabel.mas_bottom).equalTo(-1);
            make.left.right.equalTo(0);
            make.bottom.equalTo(self.finishBtn.mas_top);
        }];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = Bottom_Color;
        
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}
@end
