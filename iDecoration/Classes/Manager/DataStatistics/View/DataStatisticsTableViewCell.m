//
//  DataStatisticsTableViewCell.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "DataStatisticsTableViewCell.h"
#import "PNChart.h"
#define PGColor(r,g,b) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f]
@implementation DataStatisticsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.viewBGHeight.constant = Height_Layout(self.viewBGHeight.constant);
    self.viewBg.scrollEnabled = true;
    PGBarChart *barChart = [[PGBarChart alloc] initWithFrame:CGRectMake(0, 0, (kSCREEN_WIDTH - 20) * 2, self.viewBg.height)];
    self.barChart = barChart;
    barChart.barNormalColor = PGColor(58, 137, 217);
    barChart.barWidth = 10;
    barChart.bottomLabelFontSize = 12;
    barChart.bottomLabelFontColor = PGColor(150, 150, 150);
    barChart.verticalFontColor = PGColor(150, 150, 150);
    barChart.verticalFontSize = 12;
    barChart.bottomLineHeight = 1;
    barChart.bottomLineColor = PGColor(225, 225 ,225);
    barChart.leftLineWidth = 1;
    barChart.leftBackgroundColor = PGColor(230, 230, 230);
    barChart.horizontalLineHeight = 1;
    barChart.horizontalLineBackgroundColor = PGColor(230, 230, 230);
    self.barChart = barChart;
    [self.viewBg addSubview:self.barChart];
}

- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = @[].mutableCopy;
    }
    return _arrayData;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"DataStatisticsTableViewCell";
    DataStatisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UIAccessibilityTraitNone;
    return cell;
}

- (void)setModel:(DataStatisticsModel *)model WithScroll:(BOOL)isScroll {
    if (!model) {
        return;
    }
    CGFloat barWidth = (kSCREEN_WIDTH - 20);
    if (!isScroll) {
        self.viewBg.scrollEnabled = false;
        self.viewBg.contentSize = CGSizeMake(barWidth, 0);
        self.barChart.width = barWidth;
    }else{
        self.viewBg.scrollEnabled = true;
        self.viewBg.contentSize = CGSizeMake(barWidth * 2, 0);
        barWidth = barWidth * 2;
    }
    self.labelTitle.text = model.typeName;
    NSArray *arrayX = [model.valueList valueForKeyPath:@"xName"];
    NSArray *YValues = [model.valueList valueForKeyPath:@"xValue"];
    /*
    //柱状图
    PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(10, 0, barWidth, self.viewBg.height - 10)];
    [self.viewBg addSubview:barChart];
    [barChart setYLabelSum:10];
    barChart.showChartBorder = true;
    barChart.barBackgroundColor = [UIColor clearColor];
    barChart.labelTextColor = [UIColor blackColor];
    barChart.barWidth = 10;
    barChart.labelMarginTop = 0;
    [barChart setLabelFont:[UIFont systemFontOfSize:10]];
    barChart.isShowNumbers = false;
    [barChart setXLabels:arrayX];
    [barChart setYValues:YValues];
    [barChart strokeChart];

    //折线图
    PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, self.viewBg.height)];
    [self.viewBg addSubview:lineChart];
    lineChart.showGenYLabels = false;
    lineChart.xLabelColor = [UIColor hexStringToColor:@"666666"];
    [lineChart setXLabels:arrayX];
    PNLineChartData *data = [PNLineChartData new];
    data.inflexionPointStyle = PNLineChartPointStyleCircle;
    data.color = PNLightBlue;
    data.itemCount = lineChart.xLabels.count;
    data.showPointLabel = true;
    data.inflexionPointColor = PNLightBlue;
    data.pointLabelColor = [UIColor hexStringToColor:@"666666"];
    data.pointLabelFont = [UIFont systemFontOfSize:12];
    data.getData = ^(NSUInteger index) {
        CGFloat yValue = [arrayXValue[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
     };
    lineChart.chartData = @[data];
    [lineChart strokeChart];
     */
    [self.arrayData removeAllObjects];
    [YValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *string = obj;
        CGFloat value = string.floatValue;
        PGBarChartDataModel *dataModel = [[PGBarChartDataModel alloc] initWithLabel:arrayX[idx] value:value index:idx unit:@""];
        [self.arrayData addObject:dataModel];
    }];
    [self.barChart setDelegate:self];
    [self.barChart setDataSource:self];
}

#pragma mark PGBarChartDataSource
- (NSArray *)charDataModels {
    NSLog(@"%ld",(long)self.arrayData.count);
    return self.arrayData;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
