//
//  BLEJFloorBrickViewController.m
//  iDecoration
//
//  Created by john wall on 2018/8/28.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "BLEJFloorBrickViewController.h"
#import "floorBrickTableViewCell.h"
#import "BLEJChoosecommodityViewController.h"
#import "PellTableViewSelect.h"
#import "BLEJBudgetTemplateController.h"
#import "BLEJBrickChooseCommodityCell.h"

@interface BLEJFloorBrickViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIPopoverPresentationControllerDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSMutableArray *arrName;
@property(nonatomic,strong)NSMutableArray *arrNameCal;
@property(nonatomic,strong)NSMutableArray *arrTag;
@property(nonatomic,strong)NSArray *arrNameOther;
@property(nonatomic,strong)NSArray *arrTagOther;
@property(nonatomic,strong)NSMutableArray *arrSelectBrickLenth;
@property(nonatomic,strong)NSMutableArray *arrSelectWoodLenth;
@property(nonatomic,strong)NSMutableArray *arrSelectLineLenth;

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSString*lenthandwidth;
@property(nonatomic,strong)NSString*lenth;
@property(nonatomic,strong)NSString*width;
@property(nonatomic,strong)NSString*price;
@property(nonatomic,strong)NSString*picURl;
@property(nonatomic,strong)NSString*merchantName;
@property(nonatomic,assign)NSInteger goodId;
@end



@implementation BLEJFloorBrickViewController{
   
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _arrTag=[NSMutableArray array];
    _arrName=[NSMutableArray array];
    _arrNameCal=[NSMutableArray array];
    _arrSelectBrickLenth=[NSMutableArray array];
    _arrSelectWoodLenth=[NSMutableArray array];
    _arrSelectLineLenth=[NSMutableArray array];
    [_arrName addObjectsFromArray:@[@"标准规格的地板",@"地板长度",@"地板宽度",@"单价",@"选择商品"]];
    [_arrNameCal addObjectsFromArray:@[@"标准规格的棚板",@"棚板长度",@"棚板宽度",@"单价",@"选择商品"]];
    [_arrTag addObjectsFromArray:@[@"",@"毫米",@"毫米",@"元/块",@""]];
    _arrNameOther=[NSArray arrayWithObjects:@"名称",@"单价",@"选中商品", nil];
    _arrTagOther=[NSArray arrayWithObjects:@"",@"元",@"", nil];
    [_arrSelectBrickLenth addObjectsFromArray:@[@"自定义",@"300×300",@"300×600",@"330×330",@"400×400",@"400×800",@"450×450",@"450×900",@"500×500",@"600×600",@"600×900",@"800×800",@"1000×1000",@"1200×1200"]];
    [_arrSelectWoodLenth addObjectsFromArray:@[@"自定义",@"100×100",@"100×200",@"100×250",@"150×250",@"200×300",@"250×300",@"250×400",@"300×450",@"300×600",@"400×800"]];
    [_arrSelectLineLenth addObjectsFromArray:@[@"自定义",@"300×90",@"300×150",@"800×100"]];
    
    
    if ([self.calcaulatorType isEqualToString:@"3"]) {
        self.title = @"瓷砖计算器";
    }else if(([self.calcaulatorType isEqualToString:@"4"]) ){
        self.title = @"地板计算器";
    }
    if (self.Contrlollertitle.length>0) {
        self.title =self.Contrlollertitle;
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kBackgroundColor;
    
    
    self.tableView=[[UITableView alloc]initWithFrame:  CGRectMake(0, 0, BLEJWidth, BLEJHeight-self.navigationController.navigationBar.bottom)style:UITableViewStyleGrouped ];

    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([floorBrickTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([floorBrickTableViewCell class])];

     [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BLEJBrickChooseCommodityCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BLEJBrickChooseCommodityCell class])];
  
   

    UIButton *moreBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    moreBtn.frame = CGRectMake(0, 0, 44, 44);
    [moreBtn setTitle:@"完成" forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(finishedClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    
    
    [self getdata];
}
-(void)finishedClicked:(NSIndexPath *)indexPath {
    
    NSArray *arr=@[@"请输入标准规格的长度",@"请输入地板长度",@"请输入地板宽度",@"请输入单价",@""];
    
    if (self.isLastRowSelected) {
        for (int i=0; i<3; i++) {
            floorBrickTableViewCell *floorBrickcell= [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (i==0) {
                if ([floorBrickcell.lenthAndWidthlength.text isEqual:@""]) {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"请输入名称" controller:self sleep:1];
                    return;
                }else{
                    self.lenthandwidth=floorBrickcell.lenthAndWidthlength.text;
                    continue;
                }
            }
            if (i==1) {
                if ([floorBrickcell.lenthAndWidthlength.text isEqual:@""]) {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"请输入单价" controller:self sleep:1];
                    return;
                }else{
                    self.lenth=floorBrickcell.lenthAndWidthlength.text;
                    
                    break;
                }
            }
        }
    }else{
        for (int i=0; i<5; i++) {

            floorBrickTableViewCell *floorBrickcell= [ self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (i==0) {
                if ([floorBrickcell.lenthAndWidthlength.text isEqual:@""]) {
                    [[PublicTool defaultTool] publicToolsHUDStr:arr[i] controller:self sleep:1];
                    return;
                }else{
                    self.lenthandwidth=floorBrickcell.lenthAndWidthlength.text;
                    continue;
                }
                
            }
            if (i==1) {
                if ([floorBrickcell.lenthAndWidthlength.text isEqual:@""]) {
                    [[PublicTool defaultTool] publicToolsHUDStr:arr[i] controller:self sleep:1];
                      return;
                }else{
                    self.lenth=floorBrickcell.lenthAndWidthlength.text;
                    continue;
                }
            }
            if (i==2) {
                if ([floorBrickcell.lenthAndWidthlength.text isEqual:@""]) {
                    [[PublicTool defaultTool] publicToolsHUDStr:arr[i] controller:self sleep:1];
                    return;
                }else{
                     self.width=floorBrickcell.lenthAndWidthlength.text;
                    continue;
                }
            }
            if (i==3) {
                if ([floorBrickcell.lenthAndWidthlength.text isEqual:@""]) {
                    [[PublicTool defaultTool] publicToolsHUDStr:arr[i] controller:self sleep:1];
                    return;
                }else{
                    self.price=floorBrickcell.lenthAndWidthlength.text;
                    continue;
                }
            }
      }
   
    }
    NSString *merchantid = [[NSNumber numberWithInteger:self.goodId] stringValue];
    NSDictionary *dic =@{@"lenthandwidth":self.lenthandwidth?:@"",
                         @"lenth":self.lenth?:@"",
                         @"width":self.width?:@"",
                         @"price":self.price?:@"",
                         @"goodid":merchantid?:@"",
                         @"merchandname":self.merchantName?:@""};
    if (self.isClickplusBtn)  {
         
    if (self.blockBrick) {
      
        self.blockBrick(dic);
    }
    }else{
        
         [[NSNotificationCenter defaultCenter ]postNotificationName:@"didClickCalculatorBottomViewConfirmBtnReplace" object:nil userInfo:dic];
     }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView           {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        if (_isLastRowSelected) {
            return 3;
        }
            return 5;
        }
   return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section ==0) {
  
    NSString *   cellID=NSStringFromClass([floorBrickTableViewCell class]);
    floorBrickTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle=UITableViewCellSeparatorStyleNone;
        if ([self.calcaulatorType isEqualToString:@"5"]) {
            cell.nameLA.text = _arrNameCal[indexPath.row];
        }
        else
        {
            cell.nameLA.text = _arrName[indexPath.row];
        }
        
    [cell.rightBtn setTitle:_arrTag[indexPath.row] forState:UIControlStateNormal];
        
    if (_isLastRowSelected) {// 是只有三行的section
        
            cell.nameLA.text =_arrNameOther[indexPath.row];
            [cell.rightBtn setTitle:_arrTagOther[indexPath.row] forState:UIControlStateNormal];
            if (indexPath.row ==0 ) {
                cell.rightBtn.hidden=YES;
                if ([self.calcaulatorType isEqualToString:@"7"]) {
                    if (self.section==0) {
                        cell.nameLA.text = @"规格";
                        cell.lenthAndWidthlength.placeholder = @"请输入规格 ";
                    }
                    else
                    {
                        cell.lenthAndWidthlength.placeholder=@"请输入名称 ";
                    }
                }
                else
                {
                    cell.lenthAndWidthlength.placeholder=@"请输入名称 ";
                }
                if (self.isFromLastController)  {
                    cell.lenthAndWidthlength.text =[NSString stringWithFormat:@"%@", self.model.supplementName ];
                }
                }else if(indexPath.row ==1){
                    cell.lenthAndWidthlength.placeholder=@"请输入单价 ";
                    if (self.isFromLastController)  {
                       cell.lenthAndWidthlength.text =[NSString stringWithFormat:@"%@", self.model.supplementPrice ];
                    }
                }else if(indexPath.row ==2){
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    cell.lenthAndWidthlength.hidden=YES;
                    cell.rightBtn.hidden=YES;
                    if (self.isFromLastController)  {
                      cell.lenthAndWidthlength.text =[NSString stringWithFormat:@"%@", self.model.supplementName ];
                    }

                   }
  
    
    }else{// 不是三行的section
        
        
        if (indexPath.row==0) {
            cell.lenthAndWidthlength.delegate=self;
            
            [cell.rightBtn setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];
            [cell.rightBtn addTarget:self action:@selector(oponTableView) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.lenthAndWidthlength sizeToFit];
            if (self.isFromLastController) {
                NSString *newstr = [NSString stringWithFormat:@"%ld", (long)self.model.length ];
                NSString *stringcombine=   [ newstr stringByAppendingString: [NSString stringWithFormat:@"%@%ld", @"×",(long)self.model.width ]];
                cell.lenthAndWidthlength.text= stringcombine;
            }else{
                cell.lenthAndWidthlength.placeholder=@"自定义";
            }
            
        }
        if (indexPath.row ==1 ) {
            if (self.isFromLastController)  {
                cell.lenthAndWidthlength.text =[NSString stringWithFormat:@"%ld", (long)self.model.length ];
            }
        }else if(indexPath.row ==2){
            if (self.isFromLastController)  {
                cell.lenthAndWidthlength.text =[NSString stringWithFormat:@"%ld", (long)self.model.width ];
            }
        }else if(indexPath.row ==3){
              cell.lenthAndWidthlength.placeholder=@"请输入单价 ";
            if (self.isFromLastController)  {
                cell.lenthAndWidthlength.text =[NSString stringWithFormat:@"%.2f", [self.model.supplementPrice  doubleValue] ];
            }
        }else if (indexPath.row==4){
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.rightBtn.hidden=YES;
            cell.lenthAndWidthlength.hidden=YES;
            
          
        }
    }
        
        return cell;
    }
    if (indexPath.section ==1) {
      
        BLEJBrickChooseCommodityCell *cellcom =[tableView dequeueReusableCellWithIdentifier:@"BLEJBrickChooseCommodityCell"];
        cellcom.nameLA.text =self.merchantName;
        cellcom.DesciptionLA.text=self.price;
        if (self.picURl) {
       cellcom.imageV.layer.borderColor=[UIColor lightGrayColor].CGColor;
        cellcom.imageV.layer.borderWidth=1;
        cellcom.imageV.layer.cornerRadius=  cellcom.imageV.width/2;
         cellcom.imageV.layer.masksToBounds=YES;
        cellcom.imageV.contentMode=UIViewContentModeScaleToFill;
        }
        [cellcom.imageV sd_setImageWithURL:[NSURL URLWithString:self.picURl] placeholderImage:nil];//[UIImage imageNamed:@"shareDefaultIcon"]
        return cellcom;
    }

    return nil;

}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        
 
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
     BLEJChoosecommodityViewController *chooseCommodity =[[BLEJChoosecommodityViewController alloc]init];
     chooseCommodity.companyID =self.companyID;
     chooseCommodity.blockchoose = ^(NSInteger goodID, NSString *picurl, NSString *merchanName,NSString *goodPrice) {
     
            self.merchantName =merchanName;
            self.price=goodPrice;
            self.picURl=picurl;
            self.goodId=goodID;
            [self.tableView reloadData];
            
        };
        if (indexPath.row ==4) {
    [self.navigationController pushViewController:chooseCommodity animated:YES];
                }
    if (_isLastRowSelected) {
        if (indexPath.row ==2) {
        [self.navigationController pushViewController:chooseCommodity animated:YES];
        }
    }

    }else if(indexPath.section ==1){

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return 60;
    }
    return 160;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [[UIView alloc]init];
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    return [UIView new];
}

#pragma mark textFiled
-(void)textFieldDidBeginEditing:(UITextField *)textField{

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //写你要实现的：页面跳转的相关代码
    
    floorBrickTableViewCell *floorBrickcell=(floorBrickTableViewCell *)
    self.tableView.visibleCells.firstObject;
  
    NSMutableArray *tempArr =[NSMutableArray array];
    if (self.section ==0) {
        [tempArr addObjectsFromArray:self.arrSelectBrickLenth];
        
    }else if (self.section ==1) {
        [tempArr addObjectsFromArray:self.arrSelectWoodLenth];
        
    }else if (self.section ==2) {
        [tempArr addObjectsFromArray:self.arrSelectLineLenth];
        
    }else if (self.section ==3) {
        
    }
    
    __weak typeof (self)weakself =self;
        [PellTableViewSelect  addPellTableViewSelectWithWindowFrame:CGRectMake(BLEJWidth-100, 64, 150, 0) selectData:tempArr images:nil action:^(NSInteger index) {
            floorBrickcell.lenthAndWidthlength.text=tempArr[index];
            NSString *lenthWidthStr =floorBrickcell.lenthAndWidthlength.text;
           
            NSArray *arrSeparated=[lenthWidthStr componentsSeparatedByString:@"×"];
            
            floorBrickTableViewCell *floorBrick=[weakself.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            floorBrick.lenthAndWidthlength.text = [arrSeparated objectAtIndex:0];
            self.width=floorBrick.lenthAndWidthlength.text;
            
            
            floorBrickTableViewCell *floorBic=
            [weakself.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            if (arrSeparated.count>1) {
                 floorBic.lenthAndWidthlength.text =[arrSeparated objectAtIndex:1];
            }
            self.lenth =floorBic.lenthAndWidthlength.text;
            [self.tableView reloadData];
            
            
        } animated:YES];
  
    
    return NO;
}

-(void)oponTableView{
    
    NSMutableArray *tempArr =[NSMutableArray array];
    if (self.section ==0) {
        [tempArr addObjectsFromArray:self.arrSelectBrickLenth];
         
    }else if (self.section ==1) {
         [tempArr addObjectsFromArray:self.arrSelectWoodLenth];
      
    }else if (self.section ==2) {
       [tempArr addObjectsFromArray:self.arrSelectLineLenth];

    }else if (self.section ==3) {
        
    }
    floorBrickTableViewCell *floorBrickcell=(floorBrickTableViewCell *)
    self.tableView.visibleCells.firstObject;
    __weak typeof (self)weakself =self;
    
    [PellTableViewSelect  addPellTableViewSelectWithWindowFrame:CGRectMake(BLEJWidth-100, 64, 150, 20) selectData:tempArr images:nil action:^(NSInteger index) {
            floorBrickcell.lenthAndWidthlength.text=tempArr[index];
            NSString *lenthWidthStr =floorBrickcell.lenthAndWidthlength.text;
            NSArray *arrSeparated=[lenthWidthStr componentsSeparatedByString:@"×"];
            floorBrickTableViewCell *floorBrick=[weakself.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            floorBrick.lenthAndWidthlength.text = [arrSeparated objectAtIndex:1];
            
            floorBrickTableViewCell *floorBic=
            [weakself.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            floorBic.lenthAndWidthlength.text =[arrSeparated objectAtIndex:0];
            [self.tableView reloadData];

    } animated:YES];
    
    
}



-(void)getdata{

    NSString *strURL=[  BASEURL stringByAppendingString:@"calRoomItems/getAllMerchands.do"];

    NSNumber *uid = [NSNumber numberWithInteger:self.model.merchandId];//self.model.merchandId
    NSArray*arrs=  [NSArray arrayWithObjects:uid,nil];
    NSDictionary *prama =@{
                           @"merchands": arrs,
                           @"companyId":self.companyID,
                           @"type":self.calcaulatorType
                           
                           };
 
    AFURLSessionManager *manager =[[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    NSMutableURLRequest *urlReq =[[AFJSONRequestSerializer serializer]requestWithMethod:@"POST" URLString:strURL parameters:prama error:nil];
    
    urlReq.timeoutInterval=10.0f;
    [urlReq setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlReq setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSURLSessionDataTask *task =[manager dataTaskWithRequest:urlReq uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict =responseObject[@"data"];
                for (NSDictionary *dic in dict[@"list"]) {
                   
                        self.picURl =    dic[@"faceImg"];
                        self.goodId = [dic[@"merchandId"] integerValue];
                        self.price = dic[@"price"];
                        self.merchantName= dic[@"name"];
                    
                   
                }
               
                
                [self.tableView reloadData];
            }else{
                
            }
        }else{
            //请求失败
        }
    }];
    [task resume];

}

@end
