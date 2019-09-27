//
//  localgoodstypeVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localgoodstypeVC.h"
#import "localgoodstypeCell.h"
#import "localgoodstypeHeaderView.h"
#import "localgoodsModel.h"

@interface localgoodstypeVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UILabel *topLab;
@property (nonatomic,strong) NSArray *arr0;
@property (nonatomic,strong) NSArray *arrid0;
@property (nonatomic,strong) NSArray *arr1;
@property (nonatomic,strong) NSArray *arrid1;
@property (nonatomic,strong) NSArray *arr2;
@property (nonatomic,strong) NSArray *arrid2;
@property (nonatomic,strong) NSArray *arr3;
@property (nonatomic,strong) NSArray *arrid3;
@property (nonatomic,strong) NSArray *arr4;
@property (nonatomic,strong) NSArray *arrid4;
@end

static NSString *localgoodstypeidentfid = @"localgoodstypeidentfid";

@implementation localgoodstypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.topLab];
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
       // CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom);
        CGFloat naviBottom = kSCREEN_HEIGHT-52;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 52, kSCREEN_WIDTH, naviBottom-5) collectionViewLayout:flowLayout];
        //定义每个UICollectionView 的大小
        flowLayout.itemSize = CGSizeMake(80, 41);
        flowLayout.minimumLineSpacing = 2;
        flowLayout.minimumInteritemSpacing = 1;
        [_collectionView registerClass:[localgoodstypeCell class] forCellWithReuseIdentifier:localgoodstypeidentfid];
        flowLayout.sectionInset =UIEdgeInsetsMake(10,7, 7, 7);
        
        flowLayout.headerReferenceSize =CGSizeMake(kSCREEN_WIDTH,27);//头视图大小
        [_collectionView registerClass:[localgoodstypeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //背景颜色
        _collectionView.backgroundColor = [UIColor whiteColor];
        //自适应大小
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _collectionView;
}

-(UILabel *)topLab
{
    if(!_topLab)
    {
        _topLab = [[UILabel alloc] init];
        _topLab.frame = CGRectMake(0, 30, kSCREEN_WIDTH, 22);
        _topLab.font = [UIFont systemFontOfSize:13];
        _topLab.textColor = [UIColor hexStringToColor:@"999999"];
        _topLab.text = @"   分类";
        _topLab.backgroundColor = [UIColor hexStringToColor:@"F1F1F1"];
    }
    return _topLab;
}


#pragma mark -UICollectionViewDataSource&&UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.arr0.count?:0;
            break;
        case 1:
            return self.arr1.count?:0;
            break;
        case 2:
            return self.arr2.count?:0;
            break;
        case 3:
            return self.arr3.count?:0;
            break;
        case 4:
            return self.arr4.count?:0;
            break;
        default:
            break;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    localgoodstypeCell *cell = (localgoodstypeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:localgoodstypeidentfid forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.nameLab.backgroundColor = [UIColor hexStringToColor:@"F2F2F2"];

    switch (indexPath.section) {
        case 0:
            cell.nameLab.text = self.arr0[indexPath.item];
            break;
        case 1:
            cell.nameLab.text = self.arr1[indexPath.item];
            break;
        case 2:
            cell.nameLab.text = self.arr2[indexPath.item];
            break;
        case 3:
            cell.nameLab.text = self.arr3[indexPath.item];
            break;
        case 4:
            cell.nameLab.text = self.arr4[indexPath.item];
            break;
        default:
            break;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    localgoodstypeHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            header.typeLab.text = @"硬装软装";
            break;
        case 1:
            header.typeLab.text = @"主材辅材";
            break;
        case 2:
            header.typeLab.text = @"家具电器";
            break;
        case 3:
            header.typeLab.text = @"配套/服务";
            break;
        case 4:
            header.typeLab.text = @"家居生活";
            break;
        default:
            break;
    }
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kSCREEN_WIDTH, 27);
}

//点击选定

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    localgoodstypeCell*cell = (localgoodstypeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor = [UIColor hexStringToColor:@"25B764"].CGColor;
    
    //NSLog(@"第%ld区，第%ld个",(long)indexPath.section,(long)indexPath.row);
    //[self makeSure];
    NSString *strName =[NSString string];
    if (indexPath.section==0) {
        NSString *str = self.arrid0[indexPath.item];
        strName =self.arr0[indexPath.item];
        [self.delegate myTabVClick:str];
    }
    if (indexPath.section==1) {
        NSString *str = self.arrid1[indexPath.item];
        strName =self.arr1[indexPath.item];
        [self.delegate myTabVClick:str];
    }
    if (indexPath.section==2) {
        NSString *str = self.arrid2[indexPath.item];
        strName =self.arr2[indexPath.item];
        [self.delegate myTabVClick:str];
    }
    if (indexPath.section==3) {
        NSString *str = self.arrid3[indexPath.item];
        strName =self.arr3[indexPath.item];
        [self.delegate myTabVClick:str];
    }
    if (indexPath.section==4) {
        NSString *str = self.arrid4[indexPath.item];
        strName =self.arr4[indexPath.item];
        [self.delegate myTabVClick:str];
    }
    NSDictionary *dic =@{@"name":strName};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kAppTransferSectionNameForTitle" object:nil userInfo:dic];
}

//取消选定

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    localgoodstypeCell *cell = (localgoodstypeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor = [UIColor hexStringToColor:@"EEEEEE"].CGColor;
    // NSLog(@"1第%ld区，1第%ld个",(long)indexPath.section,(long)indexPath.row);
    // [self cancel];
    
}
#pragma mark - 数组

-(NSArray *)arr0
{
    if(!_arr0)
    {
        _arr0 = [NSArray arrayWithObjects:@"装修公司",@"整装公司",@"软装馆",@"设计工作室",@"新型装修",@"家纺布艺", nil];
        
    }
    return _arr0;
}

-(NSArray *)arr1
{
    if(!_arr1)
    {
        _arr1 = [NSArray arrayWithObjects:@"瓷砖",@"卫浴洁具",@"品牌橱柜",@"品牌衣柜",@"五金日杂",@"墙布墙纸",@"门窗", @"地板",@"灯具开关",@"石材",@"吊顶",@"成品定制",@"环保材料",@"装饰辅材",@"隔断背景墙",@"橡胶材料",@"竹木材料",@"楼梯",@"冷暖净水",@"暖通管道",@"金属材料",@"艺术玻璃",@"油漆材料",@"新型材料",nil];
        
    }
    return _arr1;
}

-(NSArray *)arr2
{
    if(!_arr2)
    {
        _arr2 = [NSArray arrayWithObjects:@"办公家具",@"电器", @"家具沙发",@"智能家居",@"机电工具",@"灯具开关",nil];
        
    }
    return _arr2;
}

-(NSArray *)arr3
{
    if(!_arr3)
    {
        _arr3 = [NSArray arrayWithObjects:@"监理公司",@"空气治理",@"广告传媒",@"搬家运输",@"家政保洁", @"软包纱窗",@"家居风水",@"瓷砖美缝",@"房屋中介",@"消防器材",nil];
        
    }
    return _arr3;
}

-(NSArray *)arr4
{
    if(!_arr4)
    {
        _arr4 = [NSArray arrayWithObjects:@"家居用品",@"晾衣架",@"绿植花卉",@"新风系统",@"家纺布艺",@"名人名画",@"艺术字画",@"机器人",@"钟表摆件",@"互联网+", nil];
        
    }
    return _arr4;
}

-(NSArray *)arrid0
{
    if(!_arrid0)
    {
        _arrid0 = [NSArray arrayWithObjects:@"1018",@"1064",@"1001",@"1022",@"1065",@"1062", nil];
        
    }
    return _arrid0;
}

-(NSArray *)arrid1
{
    if(!_arrid1)
    {
        _arrid1 = [NSArray arrayWithObjects:@"1003",@"1002",@"1004",@"1024",@"1027",@"1053",@"1049", @"1051",@"1052",@"1050",@"1054",@"1035",@"1041",@"1055",@"1026",@"1048",@"1032",@"1043",@"1042",@"1037",@"1046",@"1031",@"1008",@"1068",nil];
        
    }
    return _arrid1;
}

-(NSArray *)arrid2
{
    if(!_arrid2)
    {
        _arrid2 = [NSArray arrayWithObjects:@"1047",@"1056",@"1025",@"1019",@"1045",@"1052", nil];
        
    }
    return _arrid2;
}

-(NSArray *)arrid3
{
    if(!_arrid3)
    {
        _arrid3 = [NSArray arrayWithObjects:@"1063",@"1015",@"1034",@"1014",@"1013",@"1017",@"1044",@"1016",@"1020",@"1033", nil];
        
    }
    return _arrid3;
}

-(NSArray *)arrid4
{
    if(!_arrid4)
    {
        _arrid4 = [NSArray arrayWithObjects:@"1060",@"1082",@"1059",@"1075",@"1062",@"1077",@"1076",@"1079",@"1078", @"1080",nil];
        
    }
    return _arrid4;
}


@end
