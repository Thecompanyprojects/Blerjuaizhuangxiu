//
//  DecorationAreaViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/2/21.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "DecorationAreaViewController.h"
#import "NameCollectionViewCell.h"
#import "MemberViewController.h"
#import "DeleteCollectionReusableView.h"
#import "RemarkView.h"
#import "PModel.h"
#import "CModel.h"
#import "DModel.h"
#import "AreaListModel.h"

@interface DecorationAreaViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    BOOL _isSaved;
}

@property (nonatomic, strong) UICollectionView *areaCollectionView;
@property (nonatomic, strong) UIButton *deleteAllBtn;
@property (nonatomic, strong) NSMutableArray *areaArray;
@property (nonatomic, strong) UILabel *provinceLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, copy) NSString *btnTitle;
@property (nonatomic, strong) RemarkView *remarkView;

@property (nonatomic, strong) PModel *pmodel;//省
@property (nonatomic, strong) CModel *cmodel;//市
@property (nonatomic, strong) DModel *dmodel;//区

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *editFixArray;

// 标记navBar右侧按钮
@property (strong, nonatomic) UIButton *rightBtn;

@end

@implementation DecorationAreaViewController

-(NSMutableArray*)areaArray{
    
    if (!_areaArray) {
        _areaArray = [NSMutableArray array];
    }
    return _areaArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createCollectionView];
    [self createUI];
}

- (void)createUI {
    
    self.dataArray = [NSMutableArray array];
    self.editFixArray = [NSMutableArray array];
    self.title = @"装修区域";
    self.view.backgroundColor = White_Color;
    
    if ([self.type isEqualToString:@"2"]){
        self.areaCollectionView.frame = CGRectMake(0, 109, kSCREEN_WIDTH, kSCREEN_HEIGHT - 109);
    }
    if (!self.type) {
        
        // 设置导航栏最右侧的按钮
        UIButton *finishBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        finishBtn.frame = CGRectMake(0, 0, 44, 44);
        [finishBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [finishBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//        finishBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        finishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        finishBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        finishBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
        [finishBtn addTarget:self action:@selector(finishClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:finishBtn];
        self.rightBtn = finishBtn;
        self.areaCollectionView.frame = CGRectMake(0, 109, kSCREEN_WIDTH, kSCREEN_HEIGHT - 109 - 350);
    }
    
    if (self.type && [self.type isEqualToString:@"1"]) {
        
        // 设置导航栏最右侧的按钮
        UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        editBtn.frame = CGRectMake(0, 0, 44, 44);
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//        editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
        [editBtn addTarget:self action:@selector(finishClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
        self.rightBtn = editBtn;
        self.areaCollectionView.frame = CGRectMake(0, 109, kSCREEN_WIDTH, kSCREEN_HEIGHT - 109);
    }
    
    if (self.listArray.count<=0) {
        
        // 设置导航栏最右侧的按钮
        UIButton *finishBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        finishBtn.frame = CGRectMake(0, 0, 44, 44);
        [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [finishBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        //        finishBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        finishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        finishBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        finishBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
        [finishBtn addTarget:self action:@selector(finishClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:finishBtn];
        self.rightBtn = finishBtn;
        self.areaCollectionView.frame = CGRectMake(0, 109, kSCREEN_WIDTH, kSCREEN_HEIGHT - 109 - 350);
    }
    if(self.type && [self.type isEqualToString:@"2"]){
        self.rightBtn.hidden = YES;
    }
    
    UILabel *provinceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH/2, 44)];
    provinceLabel.backgroundColor = White_Color;
    provinceLabel.font = [UIFont systemFontOfSize:14];
    provinceLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:provinceLabel];
    self.provinceLabel = provinceLabel;
    
    UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/2, 64, kSCREEN_WIDTH/2, 44)];
    cityLabel.backgroundColor = White_Color;
    cityLabel.font = [UIFont systemFontOfSize:14];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:cityLabel];
    self.cityLabel = cityLabel;
    
    if (self.listArray.count > 0) {
        for (AreaListModel *addressDic in self.listArray) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSMutableDictionary *editDic = [NSMutableDictionary dictionary];
            [dic setObject:[NSString stringWithFormat:@"%ld", addressDic.province] forKey:@"pid"];
            [dic setObject:[NSString stringWithFormat:@"%ld", addressDic.city] forKey:@"cid"];
            [dic setObject:addressDic.retion forKey:@"address"];
            
            [editDic setObject:[NSString stringWithFormat:@"%ld", addressDic.province] forKey:@"province"];
            [editDic setObject:[NSString stringWithFormat:@"%ld", addressDic.city] forKey:@"city"];
            [editDic setObject:addressDic.retion forKey:@"retion"];
            
            DModel *dmodel = [[DModel alloc] init];
            dmodel.name = [addressDic.retion componentsSeparatedByString:@" "].lastObject;
            
            if (addressDic.province == 110000||addressDic.province == 120000||addressDic.province == 500000||addressDic.province == 310000)//四个直辖市
            {
                dmodel.pid = [NSString stringWithFormat:@"%ld", addressDic.province];
            }
            
            else{
                dmodel.pid = [NSString stringWithFormat:@"%ld", addressDic.city];
            }
            
            
            dmodel.cities = nil;
            if (!addressDic.county) {
                
                dmodel.regionId = @"-1";
            } else {
                
                dmodel.regionId = [NSString stringWithFormat:@"%ld", addressDic.county];
            }
            [editDic setObject:dmodel.regionId forKey:@"county"];
            
            if (self.index == 1) {
                //creat  key=did
                [dic setObject:dmodel.regionId forKey:@"did"];
            }
            else{
                [dic setObject:dmodel.regionId forKey:@"county"];
            }
            
            
            [self.editFixArray addObject:editDic];
            [self.areaArray addObject:dmodel];
            [self.dataArray addObject:dic];
        }
        AreaListModel *firstDic = self.listArray.firstObject;
        NSArray *addressArr = [firstDic.retion componentsSeparatedByString:@" "];
        if (addressArr.count == 2) {
            self.provinceLabel.text = addressArr[0];
            self.cityLabel.text = addressArr[0];
        } else {
            self.provinceLabel.text = addressArr[0];
            self.cityLabel.text = addressArr[1];
        }
        [self.areaCollectionView reloadData];
    }
    
    UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 109, kSCREEN_WIDTH, 1.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:lineView];
    
//    选择地址
    __weak DecorationAreaViewController *weakSelf = self;
    self.regionView = [[RegionView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-305, kSCREEN_WIDTH, 305)];
    self.regionView.isType = @"1";
    self.regionView.backgroundColor = White_Color;
    self.regionView.pickerView.backgroundColor = White_Color;
    self.regionView.closeBtn.hidden = NO;
    if (self.areaArray.count<=0) {
        //没有数据，省市可以滚动
        self.regionView.shadowV.hidden = YES;
    }
    else{
        //有数据，省市不能滚动，并且自动滚动到相应位置
        self.regionView.shadowV.hidden = NO;
        
        
        AreaListModel *firstDicTem = self.listArray.firstObject;
        NSString *pidStr = [NSString stringWithFormat:@"%ld",firstDicTem.province];
        NSString *cidStr = [NSString stringWithFormat:@"%ld",firstDicTem.city];
        [self.regionView scrollPickerViewWith:pidStr cid:cidStr];
        
    }
    
    self.regionView.selectBlock = ^(NSMutableArray *regionArray){
        
        weakSelf.pmodel = [regionArray objectAtIndex:0];
        weakSelf.cmodel = [regionArray objectAtIndex:1];
        weakSelf.dmodel = [regionArray objectAtIndex:2];
        
        NSInteger regionId = [weakSelf.pmodel.regionId integerValue];
        
        NSString *temStr = [NSString stringWithFormat:@"%@ %@ %@",weakSelf.pmodel.name,weakSelf.cmodel.name,weakSelf.dmodel.name];
        if (regionId == 110000||regionId == 120000||regionId == 500000||regionId == 310000)//四个直辖市只传省和市
        {
            weakSelf.cmodel.regionId = weakSelf.dmodel.regionId;
            weakSelf.dmodel.regionId = @"-1";
            temStr = [NSString stringWithFormat:@"%@ %@",weakSelf.pmodel.name,weakSelf.dmodel.name];
        }
        NSMutableDictionary *temDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:weakSelf.pmodel.regionId,@"pid",weakSelf.cmodel.regionId,@"cid",temStr,@"address", nil];
        
        NSMutableDictionary *editDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:weakSelf.pmodel.regionId,@"province",weakSelf.cmodel.regionId,@"city",weakSelf.dmodel.regionId,@"county",temStr,@"retion", nil];
        
        NSMutableDictionary *areaDict = [NSMutableDictionary dictionary];
        
        NSDictionary *pDic = [weakSelf.pmodel yy_modelToJSONObject];
        NSDictionary *cDic = [weakSelf.cmodel yy_modelToJSONObject];
        [areaDict setObject:pDic forKey:@"pmodel"];
        [areaDict setObject:cDic forKey:@"cmodel"];

        if (weakSelf.areaArray.count != 0) {
            
            if (![weakSelf.dmodel.pid isEqualToString:[[weakSelf.areaArray firstObject] pid]]) {
                
                [[PublicTool defaultTool] publicToolsHUDStr:@"装修区域只能隶属于同一区域" controller:weakSelf sleep:1.8];
                
                return ;
            }else{
                
                NSMutableArray *nameArr = [NSMutableArray array];
                for (DModel *model in weakSelf.areaArray) {
                    
                    [nameArr addObject:model.name];
                }
                if (![nameArr containsObject:weakSelf.dmodel.name]) {
                    [weakSelf.areaArray addObject:weakSelf.dmodel];
                    
                    if (self.index == 1) {
                        //creat  key=did
                        [temDict setValue:weakSelf.dmodel.regionId forKey:@"did"];
                    }
                    else{
                        [temDict setValue:weakSelf.dmodel.regionId forKey:@"county"];
                    }
                    
                    [weakSelf.dataArray addObject:temDict];
                    [weakSelf.editFixArray addObject:editDict];
                    weakSelf.regionView.shadowV.hidden = NO;
                    
                } else {
                    
                    [weakSelf.view hudShowWithText:@"该地区已选"];
                }
            }
            
        }else{
            weakSelf.provinceLabel.text = weakSelf.pmodel.name;
            weakSelf.cityLabel.text = weakSelf.cmodel.name;
            
            NSMutableArray *nameArr = [NSMutableArray array];
            for (DModel *model in weakSelf.areaArray) {
                
                [nameArr addObject:model.name];
            }
            if (![nameArr containsObject:weakSelf.dmodel.name]) {
                [weakSelf.areaArray addObject:weakSelf.dmodel];
                
                if (self.index == 1) {
                    //creat  key=did
                    [temDict setValue:weakSelf.dmodel.regionId forKey:@"did"];
                }
                else{
                    [temDict setValue:weakSelf.dmodel.regionId forKey:@"county"];
                }
                
                [weakSelf.dataArray addObject:temDict];
                [weakSelf.editFixArray addObject:editDict];
                weakSelf.regionView.shadowV.hidden = NO;
            }
        }
        
        [weakSelf.areaCollectionView reloadData];
        [weakSelf.areaCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.areaArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    };
    
    [self.view addSubview:self.regionView];
//    self.regionView.pickerView.
    
//    if (self.type) {
//        
//        self.regionView.hidden = YES;
//    }
    
    
    //    备注提醒
    RemarkView *remarkView = [[RemarkView alloc] init];
    remarkView.backgroundColor = Bottom_Color;
    [self.view addSubview:remarkView];
    self.remarkView = remarkView;
    
//    if (self.type) {
//        
//        self.remarkView.hidden = YES;
//    }
    
    
    
    [self.remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.regionView.mas_top).offset(50);
        make.width.equalTo(@(kSCREEN_WIDTH));
        make.height.equalTo(@50);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UIButton *deleteAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteAllBtn setTitle:@"全部删除" forState:UIControlStateNormal];
    [deleteAllBtn setTitleColor:Black_Color forState:UIControlStateNormal];
    deleteAllBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    deleteAllBtn.layer.cornerRadius = 5;
    deleteAllBtn.layer.borderWidth = 1;
    deleteAllBtn.layer.masksToBounds = YES;
    deleteAllBtn.layer.borderColor = Bottom_Color.CGColor;
    [deleteAllBtn addTarget:self action:@selector(deleteAll:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:deleteAllBtn];
    self.deleteAllBtn = deleteAllBtn;
//    if (self.type) {
//        
//        self.deleteAllBtn.hidden = YES;
//    }
    
    self.deleteAllBtn.hidden = YES;
    self.remarkView.hidden = YES;
    self.regionView.hidden = YES;
    

    
    if (self.listArray.count<=0) {
        self.deleteAllBtn.hidden = NO;
        self.remarkView.hidden = NO;
        self.regionView.hidden = NO;
    }
    
    

    
    [self.deleteAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@100);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.remarkView.mas_top).offset(-5);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

- (void)createCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(100, 50);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *areaCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 109, kSCREEN_WIDTH, 162) collectionViewLayout:layout];
    
    areaCollectionView.delegate = self;
    areaCollectionView.dataSource = self;
    areaCollectionView.backgroundColor = White_Color;
    areaCollectionView.showsVerticalScrollIndicator = YES;
    areaCollectionView.showsHorizontalScrollIndicator = NO;
    areaCollectionView.alwaysBounceVertical = YES;
    
    [self.view addSubview:areaCollectionView];
    
    [areaCollectionView registerNib:[UINib nibWithNibName:@"NameCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"NameCollectionViewCell"];
    
    self.areaCollectionView = areaCollectionView;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.areaArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"NameCollectionViewCell";
    
    NameCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    DModel *dmodel = self.areaArray[indexPath.row];
    NSMutableDictionary *dict = self.dataArray[indexPath.row];
    NSMutableDictionary *editDict = self.editFixArray[indexPath.row];
    
    [cell setDmodel:dmodel];
    
    if ([self.rightBtn.titleLabel.text isEqualToString: @"编辑"] || [self.type isEqualToString:@"2"]) {
        
        cell.deleteBtn.hidden = YES;
    } else {
        
        cell.deleteBtn.hidden = NO;
    }
    
    cell.deleteBlock = ^(){
     
//        [self.areaArray removeObject:dmodel];
//        [self.dataArray removeObject:dict];
//        [self.editFixArray removeObject:editDict];
        
        [self.areaArray removeObjectAtIndex:indexPath.row];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.editFixArray removeObjectAtIndex:indexPath.row];
        [self.areaCollectionView reloadData];
        if (self.dataArray.count<=0) {
            //没有数据，省市可以滚动
            self.regionView.shadowV.hidden = YES;
        }
        else{
            self.regionView.shadowV.hidden = NO;
        }
    };
    
    return cell;
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    
//    return UIEdgeInsetsMake(5, 10, 5, 10);//分别为上、左、下、右
//}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return CGSizeMake(110, 44);
//}

- (void)deleteAll:(UIButton*)sender {
    
    TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"请谨慎操作" message:@"是否删除全部选择区域?" clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            [self.areaArray removeAllObjects];
            [self.dataArray removeAllObjects];
            [self.editFixArray removeAllObjects];
            self.provinceLabel.text = nil;
            self.cityLabel.text = nil;
            [self.areaCollectionView reloadData];
            self.regionView.shadowV.hidden = YES;
        } else {
            
        }
        
    } cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
}

- (void)setRegionViewShow {
    
    self.regionView.hidden = NO;
}

//完成按钮
- (void)finishClick:(UIBarButtonItem*)sender {

    if (self.areaArray.count != 0) {
        
        if ([self.rightBtn.titleLabel.text isEqualToString:@"完成"]) {
            
            self.areaCollectionView.frame = CGRectMake(0, 109, kSCREEN_WIDTH, kSCREEN_HEIGHT - 109);
            self.deleteAllBtn.hidden = YES;
            [self.regionView removeFromSuperview];
            
            [self.areaCollectionView reloadData];
            
            if (self.refreshBlock) {
                
                self.refreshBlock(self.editFixArray);
            }
//            保存地址
            NSMutableArray *array = [NSMutableArray array];
            
            for (DModel *dmodel in self.areaArray) {
                
                NSDictionary *dic = [dmodel yy_modelToJSONObject];
                [array addObject:dic];
            }
            
            _isSaved = YES;
            NSString *indexStr = [NSString stringWithFormat:@"%ld",self.index];
            NSDictionary *dict = @{@"info":self.dataArray,@"index":indexStr};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DecorationAreaNot" object:self userInfo:dict];
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            self.areaCollectionView.frame = CGRectMake(0, 109, kSCREEN_WIDTH, kSCREEN_HEIGHT - 109 - 350);
            [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
            self.deleteAllBtn.hidden = NO;
            self.regionView.hidden = NO;
            self.remarkView.hidden = NO;
            [self.areaCollectionView reloadData];
        }

    } else {
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"您没有选择任何地区" controller:self sleep:1.5];
        return;
    }
    
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
