//
//  SelectBgmController.m
//  iDecoration
//
//  Created by sty on 2017/8/30.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SelectBgmController.h"
#import "SelectBgmCell.h"

@interface SelectBgmController ()<UITableViewDelegate,UITableViewDataSource,SelectBgmCellDelegate>{
    NSMutableDictionary *selectSectionDict;
    NSMutableDictionary *cellHDict;
    

    NSInteger musicSection;//选中音乐的组
    NSInteger musicTag;//选中音乐的行
    
    BOOL isHaveMusic;//是否有背景音乐
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *headArray;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIImageView *checkImg;

@end

@implementation SelectBgmController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择背景音乐";
    self.view.backgroundColor = RGB(241, 242, 245);
    
    selectSectionDict = [NSMutableDictionary dictionary];
    cellHDict = [NSMutableDictionary dictionary];
    musicSection = -1;
    musicTag = -1;
    isHaveMusic = NO;
    self.headArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    [self creatUI];
}

-(void)creatUI{
    NSArray *array1 = @[@"父亲节音乐选集",@"母亲节音乐选集"];
    [self.headArray addObjectsFromArray:array1];
    
    for (int i = 0; i<array1.count; i++) {
        NSString *string = [NSString stringWithFormat:@"%d",i];
        [selectSectionDict setObject:@"0" forKey:string];
    }
    
    NSArray *array2 = @[@"父亲",@"时间都去哪了"];
    NSArray *array3 = @[@"母亲",@"世上只有妈妈好"];
    [self.dataArray addObject:array2];
    [self.dataArray addObject:array3];
    [self.view addSubview:self.tableView];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.headArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *string = [NSString stringWithFormat:@"%ld",indexPath.section];
    NSInteger cellH = [[cellHDict objectForKey:string] floatValue];
    return cellH;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 60;
    }
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView *view = [[UIView alloc]init];
        UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kSCREEN_WIDTH-20, 40)];
        backV.backgroundColor = White_Color;
        backV.layer.masksToBounds = YES;
        backV.layer.cornerRadius = 10;
        backV.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(isHaveMuiscView:)];
        [backV addGestureRecognizer:ges];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 150, backV.height)];
        label.text = @"无背景音乐";
        label.font = NB_FONTSEIZ_BIG;
        label.textColor = COLOR_BLACK_CLASS_3;
        [backV addSubview:label];
        [view addSubview:backV];
        
        if (!_checkImg) {
            _checkImg = [[UIImageView alloc]initWithFrame:CGRectMake(backV.width-24-15, 17, 24, 24)];
            _checkImg.image = [UIImage imageNamed:@"check_select"];
            _checkImg.hidden = NO;
        }
        [view addSubview:self.checkImg];
        return view;
    }
    return [[UITableViewHeaderFooterView alloc]init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectBgmCell *cell = [SelectBgmCell cellWithTableView:tableView path:indexPath];
    cell.delegate = self;
    BOOL isopen = NO;
    NSString *string = [NSString stringWithFormat:@"%ld",indexPath.section];
    NSInteger temInt = [[selectSectionDict objectForKey:string] integerValue];
    if (!temInt) {
        isopen = NO;
    }
    else{
        isopen = YES;
    }
    
    BOOL isShowHeadCheck = NO;//是否显示头部的对号
//    BOOL isShowMusicCheck = NO;//是否显示下面的对号
    
    NSInteger tag = -1;
    if (musicSection==-1) {
        isShowHeadCheck = NO;
        tag = -1;
    }
    else{
        if (indexPath.section==musicSection) {
            isShowHeadCheck = YES;
            tag = musicTag;
        }
        else{
            isShowHeadCheck = NO;
            tag = -1;
        }
    }
    
    
    [cell configWith:self.headArray[indexPath.section] count:self.headArray.count dataArray:self.dataArray[indexPath.section] isOpen:isopen isShowHeadCheck:isShowHeadCheck musicTag:tag];
    NSString *temStr = [NSString stringWithFormat:@"%f",cell.cellH];
    [cellHDict setObject:temStr forKey:string];
    return cell;
}

#pragma mark - action

-(void)isHaveMuiscView:(UITapGestureRecognizer *)ges{
    if (isHaveMusic) {
        self.checkImg.hidden = NO;
        
        isHaveMusic = NO;
        
        
        NSInteger temSection = musicSection;
        if (temSection==-1){
            
        }
        else{
            musicSection = -1;
            musicTag = -1;
            
            NSIndexSet *indexSet2=[[NSIndexSet alloc]initWithIndex:temSection];
            [self.tableView reloadSections:indexSet2 withRowAnimation:UITableViewRowAnimationFade];
        }
        
        
    }
}

#pragma mark -SelectBgmCellDelegate

-(void)openOrCloseTargetWith:(NSIndexPath *)path{
    NSString *string = [NSString stringWithFormat:@"%ld",path.section];
    
    if ([selectSectionDict[string] integerValue] == 0) {//如果是0，就把1赋给字典,打开cell
        [selectSectionDict setObject:@"1" forKey:string];
        
    }else{//反之关闭cell
        [selectSectionDict setObject:@"0" forKey:string];
    }
    
    //判断刷新一组还是两组
    BOOL isHaveOther = NO;
    NSInteger temI = 0;
    for (int i=0; i<self.headArray.count; i++) {
        NSString *stringI = [NSString stringWithFormat:@"%d",i];
        NSInteger temInt = [[selectSectionDict objectForKey:stringI] integerValue];
        if (i==path.section) {
            isHaveOther = NO;
        }
        else{
            if (temInt) {
                temI = i;
                isHaveOther = YES;
                [selectSectionDict setObject:@"0" forKey:stringI];
                break;
            }
            else{
                isHaveOther = NO;
            }
        }
    }
    
    if (isHaveOther) {
        //刷新两组
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:path.section];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        
        NSIndexSet *indexSet2=[[NSIndexSet alloc]initWithIndex:temI];
        [self.tableView reloadSections:indexSet2 withRowAnimation:UITableViewRowAnimationFade];
    }
    else{
        //只刷新一组
        //一个section刷新
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:path.section];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }
    
    
}

-(void)selectMusicPath:(NSIndexPath *)path tag:(NSInteger)tag{
    
    //获取musicSection，判断是刷新两组还是一组
    NSInteger temSection = musicSection;
    
    musicSection = path.section;
    musicTag = tag;
    NSArray *array = self.dataArray[path.section];
    NSString *str = array[tag];
    [[PublicTool defaultTool] publicToolsHUDStr:[NSString stringWithFormat:@"你选中的歌曲是%@",str] controller:self sleep:1.5];
    
    if (temSection==-1) {
        //刷新一组
        //一个section刷新
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:path.section];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }
    
    else{
        if (temSection==path.section) {
            //两次点的是同一个section
            
            //一个section刷新
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:path.section];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            
        }
        
        else{
            //两个section刷新
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:path.section];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            
            
            
            NSIndexSet *indexSet2=[[NSIndexSet alloc]initWithIndex:temSection];
            [self.tableView reloadSections:indexSet2 withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    isHaveMusic = YES;
    self.checkImg.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 64, kSCREEN_WIDTH-20, kSCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = RGB(241, 242, 245);
        //        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
