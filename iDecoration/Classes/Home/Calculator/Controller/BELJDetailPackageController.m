//
//  BELJDetailPackageController.m
//  iDecoration
//
//  Created by john wall on 2018/7/28.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "BELJDetailPackageController.h"
#import "CompanyMarginController.h"
#import "BLEJBudgetTemplateController.h"
#import "AddVideoLinkViewController.h"
#import "EditNewsActivityController.h"
#import "SetwWatermarkController.h"
#import "NewDesignImageController.h"
#import "TZImagePickerController.h"
#import "DesignCaseListMidCell.h"
#import "ZCHSimpleBottomCell.h"
#import "DesignCaseListModel.h"
#import "AddDesignFullLook.h"
#import "VrCommenCell.h"
#import "BLEJPackageArticleDesignModel.h"
#import "MyCompanyViewController.h"
#import "NewManagerViewController.h"
#import "ASProgressPopUpView.h"
#import "HKImageClipperViewController.h"
@interface BELJDetailPackageController ()<DesignCaseListMidCellDelegate,UIAlertViewDelegate, UITableViewDelegate,UITableViewDataSource,VrCommenCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>

@property(assign,nonatomic) BOOL isHaveDefaultLogo;//
@property(assign,nonatomic) BOOL bottomCellHidden;

@property(strong,nonatomic) NSMutableDictionary* hiddenDict;
@property(strong,nonatomic) NSMutableDictionary *MidCellHDict;

@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)UIView *backShadowV;
@property (nonatomic, strong)ASProgressPopUpView *progress;
@property (nonatomic, strong) UIView *bottombackGroundV;
@property (nonatomic, strong) UIButton *bottomaddBtn;
@property (nonatomic, strong) UIView *hiddenV;//隐藏或显示的view
@property (nonatomic, strong) UIButton *addTextBtn;
@property (nonatomic, strong) UIButton *addPhotoBtn;
@property (nonatomic, strong) UIButton *addVideoBtn;
@property (nonatomic, strong)NSString* companyName;
@property (nonatomic, strong)NSString *companyLogo;
@property (nonatomic, strong)UIButton* successBtn;
@property (nonatomic, strong)NSString *draftId;
@property (nonatomic, strong)NSString *designsId;
@property (nonatomic, strong)UIView *budgetExplain;
@property (nonatomic, strong)UITextView* textView;
@end
@implementation BELJDetailPackageController{
    NSString*  _videoPath;
    NSIndexPath *addPath;// 添加图片到第几个cell前面
    NSIndexPath *modifyPath;// 修改的是第几个cell的图片
    NSInteger addVidelTag;//添加视频到第几个前面 (-1:放到最后一个)
    NSInteger upTag;//1:选取本地视频上传。2:拍摄视频上传
    BOOL   isFirstCamera;//是否是第一摄像头
    BOOL   isHaveVR;//VR是否添加
   
    BOOL   isCaogao;//是否是草稿
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _orialArray =[NSMutableArray array];
    _hiddenDict=[NSMutableDictionary dictionary];

    _hiddenDict=[NSMutableDictionary dictionary];
    _MidCellHDict=[NSMutableDictionary dictionary];
    _bottomCellHidden=YES;

    if (self.linkUrl && self.linkUrl.length>0) {
        isHaveVR = YES;
    }else{
        isHaveVR = NO;
    }
    self.title= self.isPackage699?@"简装设置":@"精装设置";
    [self videojudge];
    [self addRight];
    [self addTableHeaderView];
   
   
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveAddTextData:) name:@"ActivityaddTextDesign" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveEditTextData:) name:@"ActivityeditTextDesign" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveAddTextToBottomData:) name:@"ActivityaddTextToBottomDesign" object:nil];
    
   
}
-(void)addTableHeaderView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, BLEJHeight - self.navigationController.navigationBar.bottom ) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 44)];
    self.tableView.backgroundColor = White_Color;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZCHSimpleBottomCell" bundle:nil] forCellReuseIdentifier:@"ZCHSimpleBottomCell"];
    [self.view addSubview:self.tableView];
    
    
    self.budgetExplain = [[UIView alloc] init];

        self.budgetExplain.frame = CGRectMake(0, 0, BLEJWidth, 190);

    self.budgetExplain.backgroundColor = White_Color;
   
   // [self.topView addSubview:budgetExplain];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, BLEJWidth-20 , 40)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = Black_Color;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = @"预算说明";
    
    [self.budgetExplain addSubview:titleLabel];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 50, BLEJWidth - 20, 140)];
    textView.font = [UIFont systemFontOfSize:14];
    textView.textColor = Black_Color;
    textView.backgroundColor = kBackgroundColor;
  //  textView.delegate = self;
    textView.layer.cornerRadius = 5;
    textView.layer.masksToBounds = YES;
        textView.editable = YES;
    textView.text =self.introduction;
    self.textView =textView;
    [self.budgetExplain addSubview:textView];
    
    UILabel *feedLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 5, BLEJWidth - 50, 21)];
    feedLabel.textColor = [UIColor darkGrayColor];
    feedLabel.textAlignment = NSTextAlignmentLeft;
    feedLabel.font = [UIFont systemFontOfSize:14];
    if (textView.text) {
        feedLabel.text = @"";
    }else{
        feedLabel.text = @"请输入您想对业主说的话";
    }
    
    [textView addSubview:feedLabel];
   
    self.tableView.tableHeaderView =self.budgetExplain;
}
-(void)addRight{
// if (!self.isCaogao) {
  // 设置导航栏最右侧的按钮
   UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
   editBtn.frame = CGRectMake(0, 0, 44, 44);
   [editBtn setTitle:@"完成" forState:UIControlStateNormal];
  [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
   editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
   editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    self.successBtn = editBtn;
    [self.successBtn addTarget:self action:@selector(successBtnClick:) forControlEvents:UIControlEventTouchUpInside];
   self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.successBtn];
// }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }else if (section==1) {
        return self.dataArray.count;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section ==0) {
         return 44;
    }
    return 0.002;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section ==1) {
        CGFloat temH = 0;
        if (_bottomCellHidden) {
            temH = 25;
        }else{
            temH = 40;
        }
        return temH;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0) {

        return 44;

    }else if (indexPath.section==1 ) {
        NSString *cellHkey = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
       CGFloat cellH = [[self.MidCellHDict objectForKey:cellHkey] floatValue];
        return cellH;
    }else if (indexPath.section==2){
        if (isHaveVR) {
            return 125;
        }
        else{
            return 50;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        ZCHSimpleBottomCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ZCHSimpleBottomCell"];
        cell.unitPrice.delegate = self;
        if ([self.price isEqualToString:@"(null)"]||self.price.length==0) {
             cell.unitPrice.text= @"0";
        }
        else
        {
             cell.unitPrice.text= [NSString stringWithFormat:@"%@",self.price]?:@"0";
        }
        cell.Name.text =@"请输入套餐单价";
        return cell;
    }else if(indexPath.section == 1){
         DesignCaseListMidCell *cell = [DesignCaseListMidCell cellWithTableView:tableView path:indexPath];
         cell.delegate = self;
         NSString *key = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
         NSInteger temInt = [[_hiddenDict objectForKey:key] integerValue];
         id data = self.dataArray[indexPath.row];
         if (temInt==1) {
             [cell configWith:YES data:data isHaveDefaultLogo:!_isHaveDefaultLogo];
         }
         else{
             [cell configWith:NO data:data isHaveDefaultLogo:!_isHaveDefaultLogo];
         }
         NSString *cellHkey = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
         [self.MidCellHDict setObject:@(cell.cellH) forKey:cellHkey];
         if (indexPath.row==0) {
             cell.moveUpBtn.hidden = YES;
         }
         else{
             cell.moveUpBtn.hidden = NO;
         }
         NSInteger count = self.dataArray.count;
         if (indexPath.row==(count-1)) {
             cell.moveDownBtn.hidden = YES;
         }
         else{
             cell.moveDownBtn.hidden = NO;
         }
         return cell;
        
    }else if (indexPath.section ==2){
        VrCommenCell *cell = [VrCommenCell cellWithTableView:tableView indexpath:indexPath];
        cell.delegate = self;
        [cell configCrib:self.nameStr imgStr:self.coverImgStr isHaveVR:isHaveVR];
        return cell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section ==2) {
        if (indexPath.row >0) {//全景视图只创建一个就好
            return;
        }else{
            [self addToVR];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section ==0) {
        UIView *header =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(10, 2, 100, 40)];
        [header addSubview:label];
        label.text =@"套餐报价";
        label.textAlignment =NSTextAlignmentLeft;
      
        label.textColor = [UIColor blackColor];//设置Label上文字的颜色
        label.font = [UIFont systemFontOfSize:15];//设置Label上文字的大小 默认为17
        label.numberOfLines = 0;//设置行数默认为1，当为0时可以就是设置多行
      //  label.font = [UIFont fontWithName:@"Arial" size:30];//设置内容字体和字体大小
        label.highlighted = YES;//Label是否高亮
        return header;
    }
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section ==1) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = RGB(241, 242, 245);
        //        view.backgroundColor = Red_Color;
        //        BOOL _bottomCellHidden; //yes:显示加号。//no:显示添加图片
        [self.bottombackGroundV removeAllSubViews];
        [view addSubview:self.bottombackGroundV];
        [self.bottombackGroundV addSubview:self.bottomaddBtn];
        [self.bottombackGroundV addSubview:self.hiddenV];
        [self.hiddenV addSubview:self.addTextBtn];
        [self.hiddenV addSubview:self.addPhotoBtn];
        [self.hiddenV addSubview:self.addVideoBtn];
        if (_bottomCellHidden) {
            self.bottomaddBtn.hidden = NO;
            self.hiddenV.hidden = YES;
            self.bottombackGroundV.frame = CGRectMake(0,0,kSCREEN_WIDTH,25);
        }
        else{
            self.bottomaddBtn.hidden = YES;
            self.hiddenV.hidden = NO;
            self.bottombackGroundV.frame = CGRectMake(0,0,kSCREEN_WIDTH,40);
        }
        return view;
    }
    return [UIView new];
}

#pragma mark tableviewFooter 是否显示+号和添加图片的判断

-(void)changeToHidden{
    NSInteger count = self.dataArray.count;
    bool isZk = false;//是否张开
    for (int i = 0; i<count; i++){
        NSString *key = [NSString stringWithFormat:@"%d",i];
        NSInteger temInt = [[_hiddenDict objectForKey:key] integerValue];
        if (temInt==0) {
            //有张开
            isZk = YES;
            break;
        }
        else{
            //
            isZk = NO;
        }
    }
    if (isZk||!_bottomCellHidden) {
        [_hiddenDict removeAllObjects];
        
        for (int i = 0; i<count; i++) {
            NSString *key = [NSString stringWithFormat:@"%d",i];
            [_hiddenDict setObject:@(1) forKey:key];
        }
        _bottomCellHidden = YES;
        //一个section刷新
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [UIView animateWithDuration:0 animations:^{
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}

#pragma mark cell 是否显示+号和添加图片的判断*/

-(void)changeHiddenState:(NSIndexPath *)path{
    NSString *key = [NSString stringWithFormat:@"%ld",(long)path.row];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *temkey = [NSString stringWithFormat:@"%d",i];
        if ([temkey isEqualToString:key]) {
            NSInteger temInt = [[_hiddenDict objectForKey:key] integerValue];
            if (temInt==1) {
                [_hiddenDict setObject:@(0) forKey:key];
                _bottomCellHidden = YES;
            }
            
            else{
                [_hiddenDict setObject:@(1) forKey:key];
            }
        }
        else{
            [_hiddenDict setObject:@(1) forKey:temkey];
        }
    }
    //一个section刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
}

#pragma mark cell的delegate 添加text. photo. video.

-(void)addTextCell:(NSIndexPath *)path{
    _isHaveDefaultLogo = NO;
    _bottomCellHidden = YES;
    [_hiddenDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [_hiddenDict setObject:@(1) forKey:key];
    }
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
    NewDesignImageController *vc = [[NewDesignImageController alloc]init];
    vc.fromTag = 3;
    vc.editOrAdd = 2;
    vc.row = path.row;
    vc.nodeImgStr = @"";
    vc.companyId = [NSString stringWithFormat:@"%ld",(long)self.companyId.integerValue];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)addPhotoCell:(NSIndexPath *)path{
    
    _isHaveDefaultLogo = YES;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        addPath = path;
              //  [self uploadImgWith:photos type:3];
        SetwWatermarkController *vc = [[SetwWatermarkController alloc]init];
        vc.fromTag = 2;
        vc.editTag = 3;
        vc.imgArray = photos;
        vc.companyName = self.companyName;
        vc.comanyLogoStr = self.companyLogo;
        vc.setWaterBlock = ^(NSMutableArray *dataArray, NSInteger a) {
            [self replaceDataWith:dataArray type:a];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

-(void)addVideoCell:(NSIndexPath *)path{
    _isHaveDefaultLogo = NO;
    _bottomCellHidden = YES;
    [_hiddenDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [_hiddenDict setObject:@(1) forKey:key];
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
    addVidelTag = path.row;
    [self upLoadVideo];
}

#pragma mark cell的delegate action 编辑，修改，删除

-(void)changePhotoCell:(NSIndexPath *)path{
    _isHaveDefaultLogo = YES;
    BLEJPackageArticleDesignModel *model = self.dataArray[path.row];
    if ((model.videoUrl&&model.videoUrl.length>0)||(model.currencyUrl&&model.currencyUrl.length>0)){
        //视频
        AddVideoLinkViewController *vc = [[AddVideoLinkViewController alloc]init];
        vc.coverImgStr = model.imgUrl;
        vc.linkUrl = model.videoUrl;
        vc.unionURL = model.currencyUrl;
        
        vc.AddLinkCompletionBlock = ^(NSString *coverImgStr, UIImage *coverImg, NSString *linkUrl, NSString *unionURL) {
            BLEJPackageArticleDesignModel *model = [[BLEJPackageArticleDesignModel alloc]init];
            model.imgUrl = coverImgStr;
            model.videoUrl = linkUrl;
            model.currencyUrl = unionURL;
            [self.dataArray replaceObjectAtIndex:path.row withObject:model];
            _bottomCellHidden = YES;
            [_hiddenDict removeAllObjects];
            NSInteger count = self.dataArray.count;
            for (int i = 0; i<count; i++) {
                NSString *key = [NSString stringWithFormat:@"%d",i];
                [_hiddenDict setObject:@(1) forKey:key];
            }
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [UIView animateWithDuration:0 animations:^{
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            }];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            modifyPath = path;
                   [self uploadImgWith:photos type:2];
            
            SetwWatermarkController *vc = [[SetwWatermarkController alloc]init];
            vc.fromTag = 2;
            vc.editTag = 2;
            vc.imgArray = photos;
            vc.companyName = self.companyName;
            vc.comanyLogoStr = self.companyLogo;
            vc.setWaterBlock = ^(NSMutableArray *dataArray, NSInteger a) {
                [self replaceDataWith:dataArray type:a];
            };
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
        
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

-(void)removePhotoCell:(NSIndexPath *)path{
    
    if (self.dataArray.count<=1) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"至少要保留一张图片" controller:self sleep:1.5];
        return;
    }
    //删除的数组要告诉服务器删掉
   
      BLEJPackageArticleDesignModel *model = self.dataArray[path.row];
    if ([model.deal isEqual:@"1"]) {
       
    } else{
         model.deal =[NSString stringWithFormat:@"%@",@"3"];
    }
    [self.orialArray addObject:model];
    [self.dataArray removeObjectAtIndex:path.row];
    
    _bottomCellHidden = YES;
    [_hiddenDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [_hiddenDict setObject:@(1) forKey:key];
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
}

-(void)editTextCell:(NSIndexPath *)path{
    _isHaveDefaultLogo = NO;
    _bottomCellHidden = YES;
    [_hiddenDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [_hiddenDict setObject:@(1) forKey:key];
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    NewDesignImageController *vc = [[NewDesignImageController alloc]init];
    vc.fromTag = 3;
    vc.editOrAdd = 1;
    
    BLEJPackageArticleDesignModel *model = self.dataArray[path.row];
    if ([model.deal isEqual:@"1"]) {
        
    }else{
        model.deal =[NSString stringWithFormat:@"%d",2];
        
    }
    vc.isDesignCaseListModel=NO;
    vc.artDesignModel = model;
    vc.row = path.row;
    vc.designId =model.designId;
    vc.packageId=model.packageId;
    vc.nodeImgStr = model.imgUrl;
    vc.companyId = [NSString stringWithFormat:@"%ld",(long)self.companyId.integerValue];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma  mark cell的delegate actions
-(void)moveCellToUp:(NSIndexPath *)path{
    _bottomCellHidden = YES;
    [_hiddenDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [_hiddenDict setObject:@(1) forKey:key];
    }
    
    DesignCaseListMidCell *cell = [self.tableView cellForRowAtIndexPath:path];
    
    CGRect rect = [cell convertRect:cell.bounds toView:self.tableView];
    DesignCaseListMidCell *cellTwo = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:path.row - 1 inSection:1]];
    
    CGRect rectTwo = [cellTwo convertRect:cellTwo.bounds toView:self.tableView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        cell.frame = rectTwo;
        cellTwo.frame = rect;
    } completion:^(BOOL finished) {
        [self.dataArray exchangeObjectAtIndex:path.row withObjectAtIndex:path.row-1];
        [self.tableView reloadData];
    }];
}

-(void)moveCellToDown:(NSIndexPath *)path{
    _bottomCellHidden = YES;
    [_hiddenDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [_hiddenDict setObject:@(1) forKey:key];
    }
    
    DesignCaseListMidCell *cell = [self.tableView cellForRowAtIndexPath:path];
    
    CGRect rect = [cell convertRect:cell.bounds toView:self.tableView];
    DesignCaseListMidCell *cellTwo = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:path.row + 1 inSection:1]];
    
    CGRect rectTwo = [cellTwo convertRect:cellTwo.bounds toView:self.tableView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        cell.frame = rectTwo;
        cellTwo.frame = rect;
    } completion:^(BOOL finished) {
        [self.dataArray exchangeObjectAtIndex:path.row withObjectAtIndex:path.row+1];
        [self.tableView reloadData];
    }];
}
#pragma  mark tableview   添加text. photo. video.
//tableview 自带的+号方法 作为viewFooter形势存在。同样添加三个cell的方法。加上cell代理的3个添加text，photo，video三个，总共6个
-(void)addtextToBottom{
    _isHaveDefaultLogo = NO;
    _bottomCellHidden = YES;
    [_hiddenDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [_hiddenDict setObject:@(1) forKey:key];
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    NewDesignImageController *vc = [[NewDesignImageController alloc]init];
    vc.fromTag = 3;
    vc.editOrAdd = 0;
    vc.nodeImgStr = @"";
    vc.type = @"2";
    vc.companyId = [NSString stringWithFormat:@"%ld",self.companyId];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)addVideoToBottom{
    _isHaveDefaultLogo = NO;
    _bottomCellHidden = YES;
    [_hiddenDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [_hiddenDict setObject:@(1) forKey:key];
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
    addVidelTag = -1;
    [self upLoadVideo];
    
    
}
-(void)addPhotosToBottom{

    _isHaveDefaultLogo = YES;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
             //  [self uploadImgWith:photos type:4];
        
        SetwWatermarkController *vc = [[SetwWatermarkController alloc]init];
        vc.fromTag = 2;
        vc.editTag = 4;
        vc.imgArray = photos;
        vc.companyName = self.companyName;
        vc.comanyLogoStr = self.companyLogo;
        
        vc.setWaterBlock = ^(NSMutableArray *dataArray, NSInteger a) {
            [self replaceDataWith:dataArray type:a];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
  

}
#pragma mark 添加视频的选择方法 三个choice
-(void)videojudge
{
    NSMutableArray *videoarr = [NSMutableArray array];
    for (int i = 0; i<self.dataArray.count; i++) {
        BLEJPackageArticleDesignModel*model = [[BLEJPackageArticleDesignModel alloc] init];
        model = [self.dataArray objectAtIndex:i];
        if (model.videoUrl.length==0) {
            
        }
        else
        {
            [videoarr addObject:model.videoUrl];
        }
    }
    NSString *textstr = [videoarr componentsJoinedByString:@","];
    //    if ([videoarr containsObject:@"bilinerju.com"]) {
    //        return NO;
    //    }
    if ([textstr containsString:@"bilinerju.com"]) {
        isFirstCamera = NO;
    }
    else
    {
        isFirstCamera = YES;
    }
}
-(void)upLoadVideo{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选取视频" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"本地视频", @"拍摄视频",@"网络视频", nil];
    
    [actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        upTag = 1;
        [self selectVideo];
        
    } else if (buttonIndex == 1) {
        upTag = 2;
          [self selectVideo];

        
    }else if (buttonIndex==2)
    {
        [self uploadvideofromweb];
    }
    else {
        
        
    }
}

-(void)selectVideo{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.videoMaximumDuration = 30;
    imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    NSString *requiredMediaType1 = (NSString *)kUTTypeMovie;
    //    NSString *requiredMediaType1 = @"public.movie";
    imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects:requiredMediaType1, nil];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)takeVideo{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.videoMaximumDuration = 30;
    imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    imagePicker.showsCameraControls = YES;
    //    imagePicker.cameraOverlayView
    NSString *requiredMediaType1 = (NSString *)kUTTypeMovie;
    //    //    NSString *requiredMediaType1 = @"public.movie";
    imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects:requiredMediaType1, nil];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)uploadvideofromweb
{
    AddVideoLinkViewController *vc = [[AddVideoLinkViewController alloc]init];
    
    vc.AddLinkCompletionBlock = ^(NSString *coverImgStr, UIImage *coverImg, NSString *linkUrl, NSString *unionURL) {
        BLEJPackageArticleDesignModel *model = [[ BLEJPackageArticleDesignModel alloc]init];
       model.deal =[NSString stringWithFormat:@"%@",@"1"];
        model.imgUrl = coverImgStr;
        model.videoUrl = linkUrl;
        model.currencyUrl = unionURL;
        model.content = @"";
        model.htmlContent = @"";
        if (addVidelTag==-1) {
            [self.dataArray addObject:model];
        }
        else{
            [self.dataArray insertObject:model atIndex:addVidelTag];
        }
        _bottomCellHidden = YES;
        [_hiddenDict removeAllObjects];
        NSInteger count = self.dataArray.count;
        for (int i = 0; i<count; i++) {
            NSString *key = [NSString stringWithFormat:@"%d",i];
            [_hiddenDict setObject:@(1) forKey:key];
        }
        
        
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [UIView animateWithDuration:0 animations:^{
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark  tableviewFooter的点击事件

-(void)bottomaddBtnClick{
    _bottomCellHidden = !_bottomCellHidden;
    
    
    [_hiddenDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [_hiddenDict setObject:@(1) forKey:key];
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
}

#pragma mark - 添加全景
-(void)addToVR{
    _bottomCellHidden = YES;
    
    AddDesignFullLook *vc = [[AddDesignFullLook alloc]init];
    vc.coverImgStr = self.coverImgStr;
    vc.nameStr = self.nameStr;
    vc.linkUrl = self.linkUrl;
    vc.FullBlock = ^(NSString *coverImgStr, NSString *nameStr, NSString *linkUrl) {
      
        self.coverImgStr = coverImgStr;
        self.nameStr = nameStr;
        self.linkUrl = linkUrl;
        
        isHaveVR = YES;
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
        [UIView animateWithDuration:0 animations:^{
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
        
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)deleteVr{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否确认删除全景？"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.tag = 300;
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
       if (alertView.tag==300) {
             if (buttonIndex==1) {
             isHaveVR = NO;
        
            self.coverImgStr = @"";
            self.nameStr = @"";
           self.linkUrl = @"";
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
        [UIView animateWithDuration:0 animations:^{
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}
}
#pragma mark  tableviewFooter的点击事件
-(void)backGroundVGes:(UITapGestureRecognizer *)ges{
    
    
    if (!_bottomCellHidden) {
        _bottomCellHidden = YES;
        
        [_hiddenDict removeAllObjects];
        NSInteger count = self.dataArray.count;
        for (int i = 0; i<count; i++) {
            NSString *key = [NSString stringWithFormat:@"%d",i];
            [_hiddenDict setObject:@(1) forKey:key];
        }
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [UIView animateWithDuration:0 animations:^{
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
    
}

#pragma mark Add Data To Model 使用通知添加cell的文字的三种模式
-(void)receiveAddTextData:(NSNotification *)not{
    YSNLog(@"%@",not);
    _isHaveDefaultLogo = NO;
    NSDictionary *dict = not.userInfo;
    NSString *htmlStr = [dict objectForKey:@"htmlStr"];
    NSString *textStr = [dict objectForKey:@"textStr"];
    
//    NSString *link = [dict objectForKey:@"link"];
//    NSString *linkDescribe = [dict objectForKey:@"linkDescribe"];
    
    
    NSInteger row = [[dict objectForKey:@"row"] integerValue];
    
    BLEJPackageArticleDesignModel *model = [[BLEJPackageArticleDesignModel alloc]init];
    model.deal =[NSString stringWithFormat:@"%@",@"1"];
    model.imgUrl = @"";
    model.content = textStr;
    model.htmlContent = htmlStr;
    model.videoUrl=nil;
    model.updateBy=self.agencyId;
    [self.dataArray insertObject:model atIndex:row];
    NSString *key = [NSString stringWithFormat:@"%lu",self.dataArray.count-1];
    [_hiddenDict setObject:@(1) forKey:key];
    //一个section刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
}

-(void)receiveEditTextData:(NSNotification *)not{
    YSNLog(@"%@",not);
    _isHaveDefaultLogo = NO;
    NSDictionary *dict = not.userInfo;
    NSString *htmlStr = [dict objectForKey:@"htmlStr"];
    NSString *textStr = [dict objectForKey:@"textStr"];
    NSInteger row = [[dict objectForKey:@"row"] integerValue];
    
    BLEJPackageArticleDesignModel *model = self.dataArray[row];;
    model.content = textStr;
    model.htmlContent = htmlStr;
    if ([model.deal isEqual:@"1"]) {
        
    }else{
    model.deal =[NSString stringWithFormat:@"%@",@"2"];
    }

    
    [self.dataArray replaceObjectAtIndex:row withObject:model];
    //一个section刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
}

-(void)receiveAddTextToBottomData:(NSNotification *)not{
    
    _isHaveDefaultLogo = NO;
    
    YSNLog(@"%@",not);
    NSDictionary *dict = not.userInfo;
    NSString *htmlStr = [dict objectForKey:@"htmlStr"];
    NSString *textStr = [dict objectForKey:@"textStr"];
    BLEJPackageArticleDesignModel *model = [[BLEJPackageArticleDesignModel alloc]init];
    model.deal =[NSString stringWithFormat:@"%@",@"1"];
    model.imgUrl = @"";
    model.content = textStr;
    model.htmlContent = htmlStr;
    model.createBy =self.agencyId;
    [self.dataArray addObject:model];
    NSString *key = [NSString stringWithFormat:@"%lu",self.dataArray.count-1];
    [_hiddenDict setObject:@(1) forKey:key];
    
    //一个section刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
}

#pragma mark - 添加完水印之后，替换数组

-(void)replaceDataWith:(NSMutableArray *)dataArray type:(NSInteger)type{
    if (type==2) {
         BLEJPackageArticleDesignModel *model  = self.dataArray[modifyPath.row];
        model.imgUrl = dataArray.firstObject;
        if ([model.deal isEqualToString:@"1"]) {
        }else{
            model.deal =[NSString stringWithFormat:@"%@",@"2"];
        }
        [self.dataArray replaceObjectAtIndex:modifyPath.row withObject:model];
        
        _bottomCellHidden = YES;
        [_hiddenDict removeAllObjects];
        NSInteger count = self.dataArray.count;
        for (int i = 0; i<count; i++) {
            NSString *key = [NSString stringWithFormat:@"%d",i];
            [_hiddenDict setObject:@(1) forKey:key];
        }
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [UIView animateWithDuration:0 animations:^{
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
    
    if (type==3) {
        for (int i = 0; i<dataArray.count; i++) {
         BLEJPackageArticleDesignModel *model = [[BLEJPackageArticleDesignModel alloc]init];
           model.deal =[NSString stringWithFormat:@"%@",@"1"];
            model.imgUrl = dataArray[i];
            model.content = @"";
            model.htmlContent = @"";
            model.createBy =self.agencyId;
            [self.dataArray insertObject:model atIndex:addPath.row];
        }
        
        
        
        _bottomCellHidden = YES;
        [_hiddenDict removeAllObjects];
        NSInteger count = self.dataArray.count;
        for (int i = 0; i<count; i++) {
            NSString *key = [NSString stringWithFormat:@"%d",i];
            [_hiddenDict setObject:@(1) forKey:key];
        }
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [UIView animateWithDuration:0 animations:^{
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
    
    if (type==4) {
        for (int i = 0; i<dataArray.count; i++) {
            BLEJPackageArticleDesignModel *model = [[BLEJPackageArticleDesignModel alloc]init];
            model.deal =[NSString stringWithFormat:@"%@",@"1"];
            model.imgUrl = dataArray[i];
            model.createBy =self.agencyId;
            model.content = @"";
            model.htmlContent = @"";
            [self.dataArray addObject:model];
        }
        
        _bottomCellHidden = YES;
        [_hiddenDict removeAllObjects];
        NSInteger count = self.dataArray.count;
        for (int i = 0; i<count; i++) {
            NSString *key = [NSString stringWithFormat:@"%d",i];
            [_hiddenDict setObject:@(1) forKey:key];
        }
        
        [self.tableView reloadData];
    }
}

#pragma mark  上传编辑好的

-(void)successBtnClick:(UIButton *)btn{
    [self pushDataToServer];
}

#pragma mark pushData 推送数据

-(void)pushDataToServer{

    NSMutableDictionary *designDict = [NSMutableDictionary dictionary];
    NSMutableArray *detailsArray = [NSMutableArray array];

    if (self.dataArray.count<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"至少要有一项有内容" controller:self sleep:2.0];
        return;
    }
    ZCHSimpleBottomCell *cell =  (ZCHSimpleBottomCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        self.price =cell.unitPrice.text;
 
    NSString *strPrice = [self.price stringByAppendingString:@"套餐"];
       if (self.isPackage699) {
           [designDict setObject:self.packageId699?:@"" forKey:@"packageId"];
           [designDict setObject:strPrice?strPrice: @"699.0套餐" forKey:@"packageName"];
          
       
       }else{
            [designDict setObject:self.packageId999?:@"" forKey:@"packageId"];
            [designDict setObject:strPrice?strPrice: @"999.0套餐" forKey:@"packageName"];

        }
    [designDict setObject:self.type?:@"0" forKey:@"type"];
    [designDict setObject:self.companyIdConstant?self.companyIdConstant:@"0" forKey:@"companyId"];
    [designDict setObject:self.price?self.price:@"" forKey:@"price"];
    [designDict setObject:@"平方米" forKey:@"unit"];
    [designDict setObject:self.textView.text?self.textView.text:self.introduction forKey:@"introuction"];
    [designDict setObject:@"0" forKey:@"displayPosition"];
    [designDict setObject:[self FormatDateString] forKey:@"createDate"];
    [designDict setObject:[self FormatDateString] forKey:@"updateDate"];//1531811423000
    [designDict setObject:_agencyId? _agencyId:@"" forKey:@"updateBy"];
    [designDict setObject:@"" forKey:@"cover"];
    [designDict setObject:self.coverImgStr?self.coverImgStr:@"" forKey:@"picUrl"];
    [designDict setObject:self.linkUrl?self.linkUrl:@"" forKey:@"picHref"];
    [designDict setObject:self.nameStr?self.nameStr:@"" forKey:@"picTitle"];
    if (self.isFistr ==YES) {

    // 第一次添加，不需要对比数据
    NSInteger arrayCount = self.dataArray.count;
    for (int i = 0; i<arrayCount; i++) {
        BLEJPackageArticleDesignModel *model =self.dataArray[i];
        NSMutableDictionary *temDetailDict = [NSMutableDictionary dictionary];
        [temDetailDict setObject:model.designId ?model.designId:@"" forKey:@"designId"];
        [temDetailDict setObject:model.deal?:@"1" forKey:@"deal"];
        [temDetailDict setObject:model.sort?model.sort:@"" forKey:@"sort"];
        [temDetailDict setObject:model.imgUrl?:@"" forKey:@"imgUrl"];
        [temDetailDict setObject:model.videoUrl?model.videoUrl:@"" forKey:@"videoUrl"];
        [temDetailDict setObject:model.currencyUrl?model.currencyUrl:@"" forKey:@"currencyUrl"];
        [temDetailDict setObject:_agencyId  forKey:@"updateBy"];
        [temDetailDict setObject:model.createBy?model.createBy:_agencyId forKey:@"createBy"];
        [temDetailDict setObject:[self FormatDateString] forKey:@"createDate"];
        [temDetailDict setObject:[self FormatDateString] forKey:@"updateDate"];
        [temDetailDict setObject:model.content.length>0 ?model.content:@"" forKey:@"content"];
        [temDetailDict setObject:model.htmlContent ?model.htmlContent:@"" forKey:@"htmlContent"];
        [detailsArray addObject:temDetailDict];
    }
    }else{//*************不是第一次添加 fistr =no****************

        //给数组排序
        
        NSInteger arrCount = self.dataArray.count;
                for (int i = 0; i<arrCount; i++) {
                    BLEJPackageArticleDesignModel *model = self.dataArray[i];
                    model.sort = [NSString stringWithFormat:@"%d",i];
                    [self.dataArray replaceObjectAtIndex:i withObject:model];
                }
        
                // 先获取新增的detail
                NSMutableArray *temAddDetailArray = [NSMutableArray array];
                for (BLEJPackageArticleDesignModel *model in self.dataArray) {
                    if ([model.deal isEqual:@"1"]) {
                        
                        [temAddDetailArray addObject:model];
                    }
                }
                //获取删除的
        
                NSMutableArray *temDeleteDetailArray = [NSMutableArray array];
                for (BLEJPackageArticleDesignModel *model in self.orialArray) {
                  //  if (![self.dataArray containsObject:model]) {
                    if ([model.deal isEqualToString:@"3"]) {
                        
                   
                        model.content = @"";
                        model.imgUrl = @"";
                        model.videoUrl = @"";
                        model.currencyUrl = @"";
                  
                        model.deal =[NSString stringWithFormat:@"%d",3];;
                        [temDeleteDetailArray addObject:model];
                    }else{
                        [self.orialArray removeAllObjects];
                    }
                }
           
                //获取修改的或者没有改动的
                NSMutableArray *temModifyDetailArray = [NSMutableArray array];
                for (BLEJPackageArticleDesignModel *model in self.dataArray) {
                    if ([model.deal isEqual:@"2"]||[model.deal isEqual:@"0"]) {
                        [temModifyDetailArray addObject:model];
                    }
                }
       
          if (temModifyDetailArray.count>0) {
                for (BLEJPackageArticleDesignModel *model in temModifyDetailArray){
                    NSMutableDictionary *temDetailDict = [NSMutableDictionary dictionary];
                    [temDetailDict setObject:model.designId forKey:@"designId"];
                    [temDetailDict setObject:model.deal forKey:@"deal"];
                     [temDetailDict setObject:model.sort?model.sort:@"" forKey:@"sort"];
                    
                    [temDetailDict setObject:model.imgUrl forKey:@"imgUrl"];
                    [temDetailDict setObject:model.videoUrl?model.videoUrl:@"" forKey:@"videoUrl"];
                    [temDetailDict setObject:model.currencyUrl?model.currencyUrl:@"" forKey:@"currencyUrl"];
                    [temDetailDict setObject:_agencyId forKey:@"updateBy"];
                    [temDetailDict setObject:model.createBy?model.createBy:@"" forKey:@"createBy"];
                    [temDetailDict setObject:[self FormatDateString] forKey:@"createDate"];
                    [temDetailDict setObject:[self FormatDateString] forKey:@"updateDate"];
                    [temDetailDict setObject:model.content.length>0 ?model.content:@"" forKey:@"content"];
                    [temDetailDict setObject:model.htmlContent ?model.htmlContent:@"" forKey:@"htmlContent"];
                    
                    if (self.isPackage699) {
                     
                      [temDetailDict setObject:self.packageId699?:@"" forKey:@"packageId"];
                     
                    }else{
                        [temDetailDict setObject:self.packageId999?:@"" forKey:@"packageId"];
                    }
                    [detailsArray addObject:temDetailDict];
                }
                }
                if (temDeleteDetailArray.count>0) {
                    for (BLEJPackageArticleDesignModel *model in temDeleteDetailArray) {
                        NSMutableDictionary *temDetailDict = [NSMutableDictionary dictionary];
                        [temDetailDict setObject:model.designId forKey:@"designId"];
                        [temDetailDict setObject:model.deal forKey:@"deal"];
                        [temDetailDict setObject:model.sort?model.sort:@"" forKey:@"sort"];
                        
                        [temDetailDict setObject:model.imgUrl forKey:@"imgUrl"];
                        [temDetailDict setObject:model.videoUrl?model.videoUrl:@"" forKey:@"videoUrl"];
                        [temDetailDict setObject:model.currencyUrl?model.currencyUrl:@"" forKey:@"currencyUrl"];
                        [temDetailDict setObject:_agencyId forKey:@"updateBy"];
                        [temDetailDict setObject:model.createBy?model.createBy:@"" forKey:@"createBy"];
                        [temDetailDict setObject:[self FormatDateString] forKey:@"createDate"];
                        [temDetailDict setObject:[self FormatDateString] forKey:@"updateDate"];
                        [temDetailDict setObject:model.content.length>0 ?model.content:@"" forKey:@"content"];
                        [temDetailDict setObject:model.htmlContent ?model.htmlContent:@"" forKey:@"htmlContent"];
                        if (self.isPackage699) {
                            
                            [temDetailDict setObject:self.packageId699?:@"" forKey:@"packageId"];
                          
                        }else{
                            
                            [temDetailDict setObject:self.packageId999?:@"" forKey:@"packageId"];
                        }
                        [detailsArray addObject:temDetailDict];
                    }
                }
                if (temAddDetailArray.count>0) {
                    for (BLEJPackageArticleDesignModel *model in temAddDetailArray) {
                        NSMutableDictionary *temDetailDict = [NSMutableDictionary dictionary];
                        [temDetailDict setObject:@"0" forKey:@"designId"];
                        [temDetailDict setObject:model.deal forKey:@"deal"];
                        [temDetailDict setObject:model.sort?model.sort:@"" forKey:@"sort"];
                        
                        [temDetailDict setObject:model.imgUrl forKey:@"imgUrl"];
                        [temDetailDict setObject:model.videoUrl?model.videoUrl:@"" forKey:@"videoUrl"];
                        [temDetailDict setObject:model.currencyUrl?model.currencyUrl:@"" forKey:@"currencyUrl"];
                        [temDetailDict setObject:_agencyId forKey:@"updateBy"];
                        [temDetailDict setObject:model.createBy?model.createBy:@"" forKey:@"createBy"];
                        [temDetailDict setObject:[self FormatDateString] forKey:@"createDate"];
                        [temDetailDict setObject:[self FormatDateString] forKey:@"updateDate"];
                        [temDetailDict setObject:model.content.length>0 ?model.content:@"" forKey:@"content"];
                        [temDetailDict setObject:model.htmlContent ?model.htmlContent:@"" forKey:@"htmlContent"];
                        if (self.isPackage699) {
                            
                            [temDetailDict setObject:self.packageId699?:@"" forKey:@"packageId"];
                        }else{
                            [temDetailDict setObject:self.packageId999?:@"" forKey:@"packageId"];
                            }
                        [detailsArray addObject:temDetailDict];
                    }
                }
        }
    NSString *designStr;
    NSString *detailStr;
    NSData *data = [NSJSONSerialization dataWithJSONObject:designDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    designStr= [dataStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSData *datas = [NSJSONSerialization dataWithJSONObject:detailsArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *dataStrs = [[NSString alloc]initWithData:datas encoding:NSUTF8StringEncoding];
    detailStr = [dataStrs stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"calculatorpackage/update.do"];
    NSString *agencysId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    NSDictionary *paramDic = @{@"agencyId":agencysId,
                                   @"companyId":@(self.companyId.integerValue),
                                   @"packageModel":designStr,
                                   @"designs":detailStr
                                };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if ([responseObj[@"code"]  isEqual: @"1000"]) {
       [[PublicTool defaultTool]publicToolsHUDStr:@"上传成功" controller:self sleep:2];
            NSMutableDictionary *dic =[NSMutableDictionary dictionary];
            [dic setObject:self.type?self.type:@"" forKey:@"type"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"EditPackageCalculatorFinished" object:nil userInfo:dic];
            
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[BLEJBudgetTemplateController class]]) {
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                    if ([vc isKindOfClass:[MyCompanyViewController class]]) {
                 
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }

        }else if ([responseObj[@"code"]  isEqual: @"1001"]){
            [[PublicTool defaultTool]publicToolsHUDStr:@"参数错误" controller:self sleep:2];
        } else if([responseObj[@"code"]  isEqual: @"2000"]){
            [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
         }else if([responseObj[@"code"]  isEqual: @"1003"]){
            [[PublicTool defaultTool] publicToolsHUDStr:@"金额输入有误" controller:self sleep:1.5];
         }else if([responseObj[@"code"]  isEqual: @"1002"]){
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"您的保证金余额不足，请充值" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"去充值" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                CompanyMarginController *vc = [[CompanyMarginController alloc ] initWithNibName:@"CompanyMarginController" bundle:nil];
                vc.companyId = [NSString stringWithFormat:@"%ld", (long)self.companyId.integerValue];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            [alertC addAction:action];
            [alertC addAction:action2];
            [self presentViewController:alertC animated:YES completion:nil];
         }else{
             [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
         }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

#pragma mark - 上传视频的接口 （新接口,上传一个视频和视频的第一帧图片）

-(void)upLoadVideoWith:(NSData*)data img:(UIImage *)img{
    //此段代码如果需要修改，可以调整的位置
    //1. 把upload.php改成网站开发人员告知的地址
    //2. 把name改成网站开发人员告知的字段名
    
    // 查询条件
    //    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", idNum, @"idNumber", nil];
    
    // 基于AFN3.0+ 封装的HTPPSession句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    
    //    NSString *defaultApi = [BASEURL stringByAppendingString:@"file/videoImg.do"];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"file/uploadViode.do"];
    
    
    [self.view addSubview:self.backShadowV];
    [self.view addSubview:self.progress];
    self.backShadowV.alpha = 0.5f;
    self.progress.progress = 0.0;
    
    // 在parameters里存放照片以外的对象
    __weak typeof(self) weakSelf = self;
    [manager POST:defaultApi parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        // 这里的_photoArr是你存放图片的数组
        
        
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString  stringWithFormat:@"%@.video.mov", dateString];
        /*
         *该方法的参数
         1. appendPartWithFileData：要上传的照片[二进制流]
         2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
         3. fileName：要保存在服务器上的文件名
         4. mimeType：上传的文件的类型
         */
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"video/quicktime"];
        
        
        UIImage *uploadImage = img;
        if (uploadImage == nil) {
            uploadImage = [weakSelf getImage:_videoPath];
        }
        //        else {
        //            uploadImage = image;
        //        }
        NSData *imageData = [NSObject imageData:uploadImage];
        NSString *imageDateString = [formatter stringFromDate:[NSDate date]];
        NSString *imageFileName = [NSString  stringWithFormat:@"%@.jpg", imageDateString];
        [formData appendPartWithFileData:imageData name:@"file" fileName:imageFileName mimeType:@"image/jpeg"]; //
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSString *temStr = [NSString stringWithFormat:@"%.2f",uploadProgress.fractionCompleted];
        CGFloat progress = [temStr floatValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progress setProgress:progress animated:YES];
        });
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.progress removeFromSuperview];
        self.backShadowV.alpha = 0.0f;
        [self.backShadowV removeAllSubViews];
        
        [[NSFileManager defaultManager] removeItemAtPath:_videoPath error:nil];//取消之后就删除，以免占用手机硬盘空间（沙盒）
        
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        if (code==1000) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"视频上传成功" controller:self sleep:1.5];
            
            
            
            //            NSString *imgUrl = [responseObject objectForKey:@"imgUrl"];
            
            
            NSString *imgUrl = [responseObject objectForKey:@"imgUrl"];
            NSString *viodeUrl = [responseObject objectForKey:@"videoUrl"];
            
            
            
            BLEJPackageArticleDesignModel *model = [[BLEJPackageArticleDesignModel alloc]init];
            model.deal =[NSString stringWithFormat:@"%@",@"1"];
            model.imgUrl = imgUrl;
            model.videoUrl = viodeUrl;
            model.content = @"";
            model.htmlContent = @"";
            if (addVidelTag==-1) {
                [self.dataArray addObject:model];
            }
            else{
                [self.dataArray insertObject:model atIndex:addVidelTag];
            }
      
            _bottomCellHidden = YES;
            [_hiddenDict removeAllObjects];
            NSInteger count = self.dataArray.count;
            for (int i = 0; i<count; i++) {
                NSString *key = [NSString stringWithFormat:@"%d",i];
                [_hiddenDict setObject:@(1) forKey:key];
            }
            [self.tableView reloadData];
            
        }
        else{
            [[PublicTool defaultTool] publicToolsHUDStr:@"视频上传失败" controller:self sleep:1.5];
            
        }
        
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        YSNLog(@"xxx上传失败xxx %@", error);
        [self.progress removeFromSuperview];
        self.backShadowV.alpha = 0.0f;
        [self.backShadowV removeAllSubViews];
        
        
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        [[NSFileManager defaultManager] removeItemAtPath:_videoPath error:nil];//取消之后就删除，以免占用手机硬盘空间（沙盒）
    }];
}

// 获取视频的第一张图
-(UIImage *)getImage:(NSString *)videoURL{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return thumb;
}
#pragma mark - 图片上传
- (void)uploadImgWith:(NSArray *)imgArray type:(NSInteger)type{
    //1:修改封面图片 2:修改cell上的图片  3:插入图片  4:添加图片到最后
    
    //    NSLog(@"名字:%@ 和身份证号:%@", name, idNum);
    // －－－－－－－－－－－－－－－－－－－－－－－－－－－－上传图片－－－－
    /*
     此段代码如果需要修改，可以调整的位置
     1. 把upload.php改成网站开发人员告知的地址
     2. 把name改成网站开发人员告知的字段名
     */
    // 查询条件
    //    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", idNum, @"idNumber", nil];
    
    // 基于AFN3.0+ 封装的HTPPSession句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"file/uploadFiles.do"];
    
    
    
    
    // 在parameters里存放照片以外的对象
    [manager POST:defaultApi parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        // 这里的_photoArr是你存放图片的数组
        for (int i = 0; i < imgArray.count; i++) {
            
            UIImage *image = imgArray[i];
            //            NSData *imageData = UIImageJPEGRepresentation(image, PHOTO_COMPRESS);
            NSData *imageData = [NSObject imageData:image];
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"]; //
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        YSNLog(@"---上传进度--- %@",uploadProgress);
        YSNLog(@"%f",uploadProgress.fractionCompleted);
        
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *arr = [responseObject objectForKey:@"imgList"];
        
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dict in arr) {
            [dataArray addObject:[dict objectForKey:@"imgUrl"]];
        }
        
        if (type==1) {
           // self.coverImgUrl = dataArray.firstObject;
//            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
//            [UIView animateWithDuration:0 animations:^{
//                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
//            }];
        }
        
        if (type==2) {
            BLEJPackageArticleDesignModel *model = self.dataArray[modifyPath.row];
            if ([model.deal isEqualToString:@"1"]) {
            }else{
                model.deal =[NSString stringWithFormat:@"%@",@"2"];
            }
            model.imgUrl = dataArray.firstObject;
            [self.dataArray replaceObjectAtIndex:modifyPath.row withObject:model];
            
            
            
            _bottomCellHidden = YES;
            [_hiddenDict removeAllObjects];
            NSInteger count = self.dataArray.count;
            for (int i = 0; i<count; i++) {
                NSString *key = [NSString stringWithFormat:@"%d",i];
                [_hiddenDict setObject:@(1) forKey:key];
            }
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [UIView animateWithDuration:0 animations:^{
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            }];
        }
        
        if (type==3) {
            for (int i = 0; i<dataArray.count; i++) {
                BLEJPackageArticleDesignModel *model = [[BLEJPackageArticleDesignModel alloc]init];
                model.deal = [NSString stringWithFormat:@"%@",@"1"];
                model.imgUrl = dataArray[i];
                model.content = @"";
                model.htmlContent = @"";
                [self.dataArray insertObject:model atIndex:addPath.row];
            }
            
            
            
            _bottomCellHidden = YES;
            [_hiddenDict removeAllObjects];
            NSInteger count = self.dataArray.count;
            for (int i = 0; i<count; i++) {
                NSString *key = [NSString stringWithFormat:@"%d",i];
                [_hiddenDict setObject:@(1) forKey:key];
            }
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [UIView animateWithDuration:0 animations:^{
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            }];
        }
        
        if (type==4) {
            for (int i = 0; i<dataArray.count; i++) {
                BLEJPackageArticleDesignModel *model = [[BLEJPackageArticleDesignModel alloc]init];
       
                model.deal =[NSString stringWithFormat:@"%@",@"1"];
                model.imgUrl = dataArray[i];
                model.content = @"";
                model.htmlContent = @"";
                [self.dataArray addObject:model];
            }
            
            
            
           _bottomCellHidden = YES;
            [_hiddenDict removeAllObjects];
            NSInteger count = self.dataArray.count;
            for (int i = 0; i<count; i++) {
                NSString *key = [NSString stringWithFormat:@"%d",i];
                [_hiddenDict setObject:@(1) forKey:key];
            }
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [UIView animateWithDuration:0 animations:^{
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            }];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        YSNLog(@"xxx上传失败xxx %@", error);
        
        
        
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        
    }];
}

#pragma mark //图片选择完成

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeMovie]) {
        NSURL *sourceUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        NSString *videoPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        NSData *fileData = [NSData dataWithContentsOfFile:videoPath];
        CGFloat fileF = fileData.length/1024.f/1024.f;
        //压缩前的大小
        YSNLog(@"%f",fileF);
        
        
        
        [self.view addSubview:self.backShadowV];
        [self.view addSubview:self.progress];
        self.backShadowV.alpha = 0.5f;
        self.progress.progress = 0.0;
        //压缩地址保存到沙盒
        NSString *outPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld_compressedVideo.mp4",time(NULL)]];
        YSNLog(@"compressedVideoSavePath : %@",outPath);
        
        _videoPath = outPath;
        
        //转码配置
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];
        AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputURL = [NSURL fileURLWithPath:outPath];
        //转换后的格式
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            // 如果导出的状态为完成
            if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                YSNLog(@"sucess");
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    
                    NSData *outData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:outPath]];
                    
                    CGFloat outDataF = outData.length/1024.f/1024.f;
                    YSNLog(@"float%f",outDataF);
                    
                    UIImage *temImage = [self getImage:_videoPath];
                    
                    [self.progress removeFromSuperview];
                    self.backShadowV.alpha = 0.0f;
                    [self.backShadowV removeAllSubViews];
                    
                    [self upLoadVideoWith:outData img:temImage];
                    
                });
                
                
                
            }
            else if([exportSession status] == AVAssetExportSessionStatusFailed){
                YSNLog(@"%@",exportSession.error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progress removeFromSuperview];
                    self.backShadowV.alpha = 0.0f;
                    [self.backShadowV removeAllSubViews];
                });
            }
            else{
                YSNLog(@"当前压缩进度:%f",exportSession.progress);
                
                NSString *temStr = [NSString stringWithFormat:@"%.2f",exportSession.progress];
                CGFloat progress = [temStr floatValue];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progress setProgress:progress animated:YES];
                });
            }
            
            
        }];
        
        [picker dismissViewControllerAnimated:YES completion:^{}];
    }
    
    else{
        //自定义裁剪方式
        UIImage*image = [self turnImageWithInfo:info];
        CGSize tempSize = CGSizeMake(kSCREEN_WIDTH, 150);
        HKImageClipperViewController *clipperVC = [[HKImageClipperViewController alloc]initWithBaseImg:image
                                                                                         resultImgSize:tempSize clipperType:ClipperTypeImgMove];
        
        __weak typeof(self)weakSelf = self;
        clipperVC.cancelClippedHandler = ^(){
            [picker dismissViewControllerAnimated:YES completion:nil];
        };
        clipperVC.successClippedHandler = ^(UIImage *clippedImage){
            __strong typeof(self)strongSelf = weakSelf;
            NSArray *arr = @[clippedImage];
            [strongSelf uploadImgWith:arr type:1];
            [picker dismissViewControllerAnimated:YES completion:nil];
        };
        [picker pushViewController:clipperVC animated:YES];
    }
}

//取消选择图片
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (UIImage *)turnImageWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    //类型为 UIImagePickerControllerOriginalImage 时调整图片角度
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImageOrientation imageOrientation=image.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp) {
            // 原始图片可以根据照相时的角度来显示，但 UIImage无法判定，于是出现获取的图片会向左转90度的现象。
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    return image;
    
}

#pragma mark --通过时间戳得到日期字符串
-(NSString*)getDateFormatStrFromTimeStamp:(NSString*)timeStamp{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]/ 1000.0];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

#pragma mark - ASProgressPopUpView dataSource

- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress
{
    NSString *s;
    NSString *temStr = [NSString stringWithFormat:@"%.2f",progress];
    NSInteger temInt = [temStr integerValue]*100;
    
    
    s = [NSString stringWithFormat:@"%ld",(long)temInt];
    s = [s stringByAppendingString:@"%"];
    s = [NSString stringWithFormat:@"%f",progress];
    return s;
}

// by default ASProgressPopUpView precalculates the largest popUpView size needed
// it then uses this size for all values and maintains a consistent size
// if you want the popUpView size to adapt as values change then return 'NO'
- (BOOL)progressViewShouldPreCalculatePopUpViewSize:(ASProgressPopUpView *)progressView;
{
    return NO;
}

-(ASProgressPopUpView *)progress{
    if (!_progress) {
        _progress = [[ASProgressPopUpView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/4, kSCREEN_HEIGHT/2, kSCREEN_WIDTH/2, 10)];
        _progress.font = [UIFont systemFontOfSize:16];
        _progress.popUpViewAnimatedColors = @[Main_Color];
        _progress.dataSource = self;
        [_progress showPopUpViewAnimated:YES];
    }
    return _progress;
}

-(UIView *)backShadowV{
    if (!_backShadowV) {
        _backShadowV = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, kSCREEN_HEIGHT, kSCREEN_HEIGHT-64)];
        _backShadowV.backgroundColor = COLOR_BLACK_CLASS_0;
        _backShadowV.alpha = 0.5;
    }
    return _backShadowV;
}

#pragma mark - 新增或者修改新闻资讯

-(NSString *)FormatDateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
}

#pragma mark 懒加载

-(UIView *)bottombackGroundV{
    if (!_bottombackGroundV) {
        _bottombackGroundV = [[UIView alloc]initWithFrame:CGRectMake(0,0,kSCREEN_WIDTH,25)];
        _bottombackGroundV.backgroundColor = RGB(241, 242, 245);
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backGroundVGes:)];
        _bottombackGroundV.userInteractionEnabled = YES;
        [_bottombackGroundV addGestureRecognizer:ges];
    }
    return _bottombackGroundV;
}

-(UIButton *)bottomaddBtn{
    if (!_bottomaddBtn) {
        _bottomaddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomaddBtn.frame = CGRectMake(kSCREEN_WIDTH/2-13, 5, 26, 15);
        [_bottomaddBtn setImage:[UIImage imageNamed:@"edit_insert_normal"] forState:UIControlStateNormal];
        [_bottomaddBtn addTarget:self action:@selector(bottomaddBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomaddBtn;
}

-(UIView *)hiddenV{
    if (!_hiddenV) {
        _hiddenV = [[UIView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/2-54*3/2, 5, 54*3, 30)];
        _hiddenV.layer.masksToBounds = YES;
        _hiddenV.layer.cornerRadius = 15;
    }
    return _hiddenV;
}

-(UIButton *)addTextBtn{
    if (!_addTextBtn) {
        _addTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addTextBtn.frame = CGRectMake(0, 0, self.hiddenV.width/3, self.hiddenV.height);
        [_addTextBtn setImage:[UIImage imageNamed:@"edit_add_text_normal"] forState:UIControlStateNormal];
        [_addTextBtn setImage:[UIImage imageNamed:@"edit_add_text_pressed"] forState:UIControlStateHighlighted];
        [_addTextBtn addTarget:self action:@selector(addtextToBottom) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addTextBtn;
}

-(UIButton *)addPhotoBtn{
    if (!_addPhotoBtn) {
        _addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addPhotoBtn.frame = CGRectMake(self.addTextBtn.right, 0, self.hiddenV.width/3, self.hiddenV.height);
        [_addPhotoBtn setImage:[UIImage imageNamed:@"edit_add_image_normal"] forState:UIControlStateNormal];
        [_addPhotoBtn setImage:[UIImage imageNamed:@"edit_add_image_pressed"] forState:UIControlStateHighlighted];
        [_addPhotoBtn addTarget:self action:@selector(addPhotosToBottom) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addPhotoBtn;
}

-(UIButton *)addVideoBtn{
    if (!_addVideoBtn) {
        _addVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addVideoBtn.frame = CGRectMake(self.addPhotoBtn.right, 0, self.hiddenV.width/3, self.hiddenV.height);
        [_addVideoBtn setImage:[UIImage imageNamed:@"edit_add_video_normal"] forState:UIControlStateNormal];
        [_addVideoBtn setImage:[UIImage imageNamed:@"edit_add_videl_pressed"] forState:UIControlStateHighlighted];
        [_addVideoBtn addTarget:self action:@selector(addVideoToBottom) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addVideoBtn;
}

#pragma mark - TEXTFILED delegate

- (void)textFieldDidEndEditing:( UITextField *)textField
{
    self.price = textField.text;
}

@end
