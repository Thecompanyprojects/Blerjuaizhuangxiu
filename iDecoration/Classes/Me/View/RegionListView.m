//
//  RegionListView.m
//  iDecoration
//
//  Created by RealSeven on 17/3/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "RegionListView.h"

@implementation RegionListView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = Bottom_Color;
        
        [self addSubview:self.firstTableView];
        [self addSubview:self.secondTableView];
        [self addSubview:self.thirdTableView];
    }
    return self;
}

-(UITableView*)firstTableView{
    
    if (!_firstTableView) {
        _firstTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH/3, kSCREEN_HEIGHT) style:UITableViewStylePlain];
        _firstTableView.delegate = self;
        _firstTableView.dataSource = self;
        _firstTableView.backgroundColor = White_Color;
        _firstTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _firstTableView.tableFooterView = [[UIView alloc]init];
    }
    
    return _firstTableView;
}

-(UITableView*)secondTableView{
    
    if (!_secondTableView) {
        _secondTableView = [[UITableView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/3, 0, kSCREEN_WIDTH/3, kSCREEN_HEIGHT) style:UITableViewStylePlain];
        _secondTableView.delegate = self;
        _secondTableView.dataSource = self;
        _secondTableView.backgroundColor = Main_Color;
        _secondTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _secondTableView.tableFooterView = [[UIView alloc]init];
    }
    
    return _secondTableView;
}

-(UITableView*)thirdTableView{
    
    if (!_thirdTableView) {
        _thirdTableView = [[UITableView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/3*2, 0, kSCREEN_WIDTH/3, kSCREEN_HEIGHT) style:UITableViewStylePlain];
        _thirdTableView.delegate = self;
        _thirdTableView.dataSource = self;
        _thirdTableView.backgroundColor = [UIColor orangeColor];
        _thirdTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _thirdTableView.tableFooterView = [[UIView alloc]init];
    }
    
    return _thirdTableView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
