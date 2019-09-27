//
//  GoodsPromotionController.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/24.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GoodsPromotionController.h"
#import "AddAllSubPromotionController.h"
#import "AddPresentViewController.h"
#import "AddCouponViewController.h"
#import "AddDiscountPromotionController.h"
#import "PromptModel.h"
#import "GoodsPromotionCell.h"

@interface GoodsPromotionController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

// 底部视图
@property (nonatomic, strong) UIView *bottomView;

// 底部推广菜单
@property (strong, nonatomic) UIView *bottomPromptView;
// 推广的遮罩层
@property (strong, nonatomic) UIView *shadowView;

@end

@implementation GoodsPromotionController
#pragma  mark - LifeMethod
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"营销推广";
    self.view.backgroundColor = kBackgroundColor;
    
    [self bottomView];
    [self tableView];

    // 推广选择视图
    [self addBottomPromptView];
    
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NormalMethod

- (void)getData {
    NSString *defaultApi = [BASEURL stringByAppendingString:@"merchandiesActivity/getMerchandiesActivityList.do"];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:@(self.shopId.integerValue) forKey:@"merchantId"];
    
    [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        NSInteger code = [responseObj[@"code"] integerValue];
        switch (code) {
            case 1000:
            {
                self.dataArray = [[NSArray yy_modelArrayWithClass:[PromptModel class] json:[responseObj objectForKey:@"merchandiesActivityList"]] mutableCopy];
                [self.tableView reloadData];
            }
                break;
                
            default:
            {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"添加失败， 稍后再试"];
            }
                break;
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

- (void)addMore:(UITapGestureRecognizer *)tapGR {
    YSNLog(@"继续添加");
//    AddGoodsPromotionController *addPromotion = [AddGoodsPromotionController new];
//    addPromotion.shopId = self.shopId;
//    [self.navigationController pushViewController:addPromotion animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomPromptView.blej_y = BLEJHeight - kSCREEN_WIDTH/2.0 - 70;
        self.shadowView.hidden = NO;
    } completion:^(BOOL finished) {
        
    }];
    
}
#pragma mark - UItableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 60 120 148
    PromptModel *model = self.dataArray[indexPath.row];
    // 活动类型  活动类型1、全店满送 2、商品满送 3、全店满减 4、商品满减 5、全店优惠券 6、商品优惠券 7、套餐
//    @property (nonatomic, copy) NSString *activityType;
    NSInteger type = [model.activityType integerValue];
    switch (type) {
        case 3:
        case 5:
            return 60;
            break;
        case 1:
        case 2:
        case 4:
        case 6:
            return 120;
            break;
        case 7:
            return 148;
            break;
        default:
            return 0;
            break;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PromptModel *model = self.dataArray[indexPath.row];
    GoodsPromotionCell *cell;
    // 活动类型  活动类型1、全店满送 2、商品满送 3、全店满减 4、商品满减 5、全店优惠券 6、商品优惠券 7、套餐
    
    if ([model.activityType isEqualToString:@"3"] ||[model.activityType isEqualToString:@"5"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsPromotionCellFirst"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsPromotionCell" owner:nil options:nil][0];
        }
    }
    if ([model.activityType isEqualToString:@"1"] || [model.activityType isEqualToString:@"2"] || [model.activityType isEqualToString:@"4"] ||[model.activityType isEqualToString:@"6"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsPromotionCellSecond"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsPromotionCell" owner:nil options:nil][1];
        }

    }
    if ([model.activityType isEqualToString:@"7"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsPromotionCellThird"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsPromotionCell" owner:nil options:nil][2];
        }
        
    }
    
    cell.model = model;
    
    NSInteger type = model.activityType.integerValue;
    if (type == 3 || type == 4) {
        // 满减
        cell.priceLabel.hidden = NO;
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.consumeMoney.length>0? model.consumeMoney.doubleValue : 0];
        cell.priceLabelWidth.constant = [cell.priceLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) withFont:[UIFont systemFontOfSize:16]].width + 4;
        
    }else if (type == 5 || type == 6) {
        // 优惠券
        cell.priceLabel.hidden = NO;
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.discountMoney.length>0?model.discountMoney.doubleValue: 0];
        cell.priceLabelWidth.constant = [cell.priceLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) withFont:[UIFont systemFontOfSize:16]].width + 4;
        
    }else if (type == 7) {
        cell.priceLabel.hidden = NO;
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.tcPrice.length>0?model.tcPrice.doubleValue: 0];
        cell.priceLabelWidth.constant = [cell.priceLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) withFont:[UIFont systemFontOfSize:16]].width + 4;
        
    } else {
        cell.priceLabel.hidden = YES;
    }
    
    if (cell == nil) {
        return [UITableViewCell new];
    } else {
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//是否允许编辑，默认值是YES
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PromptModel *model = self.dataArray[indexPath.row];
    //删除
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self deleteActionWithModel:model atIndexPath:indexPath];
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];
    
    return @[deleteRowAction];
}

- (void)deleteActionWithModel:(PromptModel *)model atIndexPath:(NSIndexPath *)indexPath {
    NSString *defaultApi = [BASEURL stringByAppendingString:@"merchandiesActivity/deleteActivity.do"];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:@(model.promptID.integerValue) forKey:@"id"];
//    [paramDic setObject:model.activityName forKey:@"activityName"];
//    [paramDic setObject:model.activityRange forKey:@"activityRange"];
//    [paramDic setObject:model.activityType forKey:@"activityType"];
//    [paramDic setObject:model.merchantId forKey:@"merchantId"];
    
    [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        NSInteger code = [responseObj[@"code"] integerValue];
        switch (code) {
            case 1000:
            {
                [self.dataArray removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
            }
                break;
                
            default:
            {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"操作失败， 稍后再试"];
            }
                break;
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}
#pragma mark - LazyMethod
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        _tableView.backgroundColor = kBackgroundColor;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(64);
            make.bottom.equalTo(-44);
        }];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - 44, kSCREEN_WIDTH, 44)];
        [self.view addSubview:_bottomView];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]init];
        [_bottomView addSubview:label];
        label.text = @"添加推广";
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = kMainThemeColor;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.centerX.equalTo(20);
        }];
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"greenAddBtn"]];
        [_bottomView addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.centerX.equalTo(-30);
            make.size.equalTo(CGSizeMake(24, 24));
        }];
        _bottomView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addMore:)];
        [_bottomView addGestureRecognizer:tapGR];
    }
    return _bottomView;
}

#pragma  mark - 推广 ↓
- (void)addBottomPromptView {
    
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    self.shadowView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickShadowView:)];
    [self.shadowView addGestureRecognizer:tap];
    
    [self.view addSubview:self.shadowView];
    self.shadowView.hidden = YES;
    
    self.bottomPromptView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight, BLEJWidth, kSCREEN_WIDTH/2.0 + 70)];
    self.bottomPromptView.backgroundColor = [UIColor whiteColor];
    [self.shadowView addSubview:self.bottomPromptView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, BLEJWidth - 40, 30)];
    titleLabel.text = @"推广";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.bottomPromptView addSubview:titleLabel];
    //1、全店满送 2、商品满送  3、全店满减  4、商品满减 5、全店优惠券 6、商品优惠券 7、套餐
    NSArray *imageNames = @[@"promotion_present", @"promotion_present", @"promotion_sub", @"promotion_sub", @"promotion_coupon", @"promotion_coupon", @"promotion_discount"];
    NSArray *names = @[@"全店满送", @"商品满送", @"全店满减", @"商品满减", @"全店优惠券", @"商品优惠券", @"优惠套餐"];
    for (int i = 0; i < 7; i ++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i%4 * BLEJWidth * 0.25, titleLabel.bottom + 20 + (i/4 * BLEJWidth * 0.25), BLEJWidth * 0.25, BLEJWidth * 0.25)];
        btn.tag = i;
        [btn addTarget:self action:@selector(didClickPromptContentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [btn setTitle:names[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 1. 得到imageView和titleLabel的宽、高
        CGFloat imageWith = btn.imageView.frame.size.width;
        CGFloat imageHeight = btn.imageView.frame.size.height;
        
        CGFloat labelWidth = 0.0;
        CGFloat labelHeight = 0.0;
        labelWidth = btn.titleLabel.intrinsicContentSize.width;
        labelHeight = btn.titleLabel.intrinsicContentSize.height;
        UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
        UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
        imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-5/2.0, 0, 0, -labelWidth);
        labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-5/2.0, 0);
        btn.titleEdgeInsets = labelEdgeInsets;
        btn.imageEdgeInsets = imageEdgeInsets;
        [self.bottomPromptView addSubview:btn];
    }
    
    
}
- (void)didClickShadowView:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomPromptView.blej_y = BLEJHeight;
    } completion:^(BOOL finished) {
        self.shadowView.hidden = YES;
    }];
}

- (void)didClickPromptContentBtn:(UIButton *)btn {
    
    switch (btn.tag) {
        case 0:
        {// @"全店满送"
            YSNLog(@"--------");
            [self didClickShadowView:nil];
            AddPresentViewController *vc = [AddPresentViewController new];
            vc.isSectionGoods = NO;
            vc.shopId = self.shopId;
            vc.CompletionBlock = ^{
                [self getData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {//@"商品满送"
            YSNLog(@"--------");
            [self didClickShadowView:nil];
            AddPresentViewController *vc = [AddPresentViewController new];
            vc.isSectionGoods = YES;
            vc.shopId = self.shopId;
            vc.CompletionBlock = ^{
                [self getData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {//@"全店满减"
            YSNLog(@"--------");
            [self didClickShadowView:nil];
            
            AddAllSubPromotionController *vc = [AddAllSubPromotionController new];
            vc.isSectionGoods = NO;
            vc.shopId = self.shopId;
            vc.CompletionBlock = ^{
                [self getData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {// @"商品满减
            YSNLog(@"--------");
            [self didClickShadowView:nil];
            AddAllSubPromotionController *vc = [AddAllSubPromotionController new];
            vc.isSectionGoods = YES;
            vc.shopId = self.shopId;
            vc.CompletionBlock = ^{
                [self getData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {// @"全店优惠券"
            YSNLog(@"--------");
            [self didClickShadowView:nil];
            AddCouponViewController *vc = [AddCouponViewController new];
            vc.isSectionGoods = NO;
            vc.shopId = self.shopId;
            vc.CompletionBlock = ^{
                [self getData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {// @"商品优惠券"
            YSNLog(@"--------");
            [self didClickShadowView:nil];
            AddCouponViewController *vc = [AddCouponViewController new];
            vc.isSectionGoods = YES;
            vc.shopId = self.shopId;
            vc.CompletionBlock = ^{
                [self getData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {// @"套餐"
            YSNLog(@"--------");
            [self didClickShadowView:nil];
            AddDiscountPromotionController *vc = [AddDiscountPromotionController new];
            vc.shopId = self.shopId;
            vc.CompletionBlock = ^{
                [self getData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }

}
#pragma  mark - 推广 ↑
@end
