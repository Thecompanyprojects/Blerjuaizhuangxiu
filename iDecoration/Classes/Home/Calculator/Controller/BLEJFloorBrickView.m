//
//  BLEJFloorBrickView.m
//  iDecoration
//
//  Created by john wall on 2018/8/28.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "BLEJFloorBrickView.h"
#import "floorBrickTableViewCell.h"
@interface BLEJFloorBrickView ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@end

@implementation BLEJFloorBrickView


-(instancetype)initWithFrame:(CGRect)frame{
    self= [super initWithFrame:frame];
    
      self.frame=  CGRectMake(0, 0, BLEJWidth, BLEJHeight);
    
    self.tableView=[[UITableView alloc]init];
    self.tableView.frame =self.frame;
      
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([floorBrickTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([floorBrickTableViewCell class])];
       //  [[NSNotificationCenter defaultCenter] postNotificationName:@"didClickCalculatorBottomViewConfirmBtnAdd" object:nil userInfo:dic];
    
    return self;
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    self.frame=  CGRectMake(self.frame.origin.x, self.frame.origin.y, BLEJWidth, BLEJHeight);
//    
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView           {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *   cellID=NSStringFromClass([floorBrickTableViewCell class]);
   floorBrickTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil) //没碗可取
    {
        
        //样式: Default,Value1,Value2,Subtitle
        cell = (floorBrickTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        
    }
    cell.nameLA.text =@"sddd";
   
    return cell;
}


- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

@end
