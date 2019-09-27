//
//  EditMyCompanyController.m
//  iDecoration
//
//  Created by Apple on 2017/5/24.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "EditMyCompanyController.h"
#import "MyCompanyHeadCell.h"
#import "MyCompanyMidCell.h"
#import "SubsidiaryModel.h"
#import "CreateCompanyViewController.h"
#import "EditShopViewController.h"
#import "AreaListModel.h"
#import "ShopDetailController.h"
#import "HeadquartersAreaController.h"
#import "EditMyCompanyBottomCell.h"
#import "MeViewController.h"
#import "UIBarButtonItem+Item.h"
#import "NSObject+CompressImage.h"



@interface EditMyCompanyController ()<UITableViewDelegate,UITableViewDataSource,MyCompanyHeadCellDelegate,MyCompanyMidCellDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate>{
    NSInteger _tag;
    
    NSInteger _defaultSelectTag;
}

@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyLogo;
@property (nonatomic, copy) NSString *companySlogan;



@end

@implementation EditMyCompanyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _defaultSelectTag = 0;
    [self creatUI];
    
//    self.dataArray = [NSMutableArray array];
}

-(void)creatUI{
    
    
    
    self.title = @"我的公司";
    self.view.backgroundColor = White_Color;
    
    self.companyName = [self.dict objectForKey:@"companyName"];
    self.companyLogo = [self.dict objectForKey:@"companyLogo"];
    self.companySlogan = [self.dict objectForKey:@"companySlogan"];
//    self.companyName = [self.dict objectForKey:@"companyName"];
    
    [self.view addSubview:self.tableView];
    [self ergodicDataArray];
    
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"完成" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(success:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    
    
    // 单独处理这里的返回按钮(因为需要返回到根控制器)
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
}

#pragma mark - 便利数组
-(void)ergodicDataArray{
    if (self.dataArray.count<=0) {
        _defaultSelectTag = -1;
    }
    else{
        BOOL isHaveZong = NO;
        NSInteger count = self.dataArray.count;
        for (int i = 0; i<count; i++) {
            SubsidiaryModel *model = self.dataArray[i];
            if ([model.headQuarters integerValue]==1) {
                isHaveZong = YES;
                _defaultSelectTag = i;
                break;
            }
            else{
                isHaveZong = NO;
            }
        }
        if (!isHaveZong) {
            _defaultSelectTag = -1;
        }
    }
    [self.tableView reloadData];
}

-(void)back{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出编辑"
                                                    message:@"是否确定退出编辑？"
                                                   delegate:self
                                          cancelButtonTitle:@"否"
                                          otherButtonTitles:@"是",nil];
    alert.tag = 2000;
    [alert show];
    
    
}

-(void)success:(UIButton *)btn{
    [self.view endEditing:YES];
    self.companyName = [self.companyName stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!self.companyName||self.companyName.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"公司名称不能为空" controller:self sleep:1.5];
        return;
    }
    
//    self.companySlogan = [self.companySlogan stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!self.companySlogan||self.companySlogan.length<=0) {
        self.companySlogan = @"";
    }
    
    if (self.companySlogan.length>50) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"公司标语字数不能超过50个" controller:self sleep:1.5];
        return;
    }
    NSString *temStr = @"";
    if (_defaultSelectTag == -1) {
        temStr = @"";
    }
    else
    {
        SubsidiaryModel *data = self.dataArray[_defaultSelectTag];
        temStr = [NSString stringWithFormat:@"%@",data.companyId];
    }
    NSString *defaultApi = [BASEURL stringByAppendingString:@"company/getUpdateByCompanyId.do"];
    NSDictionary *paramDic = @{@"companyName":self.companyName,
                               @"companyLogo":self.companyLogo,
                               @"companySlogan":self.companySlogan,
                               @"companyId":self.companyId,
                               @"companyId2":temStr
                               };
    [self.view hudShow];
    btn.userInteractionEnabled = NO;
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [self.view hiddleHud];
            btn.userInteractionEnabled = YES;
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"修改成功" controller:self sleep:1.5];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"requestCompanyList" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                case 1004:
                    
                {
                    NSString *msg = [responseObj objectForKey:@"msg"];
                    [[PublicTool defaultTool] publicToolsHUDStr:msg controller:self sleep:1.5];
                }
                    break;
                    
                default:
                    [[PublicTool defaultTool] publicToolsHUDStr:@"修改失败" controller:self sleep:1.5];
                    break;
            }
            
            
            
            
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [self.view hiddleHud];
        btn.userInteractionEnabled = YES;
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

#pragma mark - uitableviewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0||section == 1||section == 3) {
        return 1;
    }
    else{
        return self.dataArray.count+1;
    }
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        return 110;
//    }
//    else if (indexPath.section == 3){
//        return 150;
//    }
//    else
//    {
//        return 60;
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 110;
    }
    else if (indexPath.section == 3){
        return UITableViewAutomaticDimension;
    }
    else
    {
        return UITableViewAutomaticDimension;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MyCompanyHeadCell *cell = [MyCompanyHeadCell cellWithTableView:tableView];
        cell.companyName.frame = CGRectMake(90, 0, 200, 80);
        cell.companyName.text = @"点击更改公司LOGO";
        [cell.companyName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.photoImg.mas_right).equalTo(10);
            make.centerY.equalTo(cell.photoImg);
            make.width.equalTo(kSCREEN_WIDTH-cell.photoImg.right-10-40);
            make.height.equalTo(30);
        }];
//        NSString *url = [self.dict objectForKey:@"companyLogo"];
        [cell.photoImg sd_setImageWithURL:[NSURL URLWithString:self.companyLogo] placeholderImage:[UIImage imageNamed:DefaultIcon]];
        cell.companyName.font = [UIFont systemFontOfSize:15];
        cell.companyName.textColor = [UIColor lightGrayColor];
        cell.sloganL.hidden = YES;
        cell.editBtn.hidden = YES;
        return cell;
    }
    else if (indexPath.section == 1){
        MyCompanyMidCell *cell = [MyCompanyMidCell cellWithTableView:tableView cellForRowAtIndexPath:indexPath];
        cell.delegate = self;
        cell.leftImg.hidden = YES;
        cell.rightRow.hidden = YES;
        
        
        
        cell.companySign.hidden = YES;
        cell.deleteBtn.hidden = NO;
        // 判断子公司是否有会员， 如果有不显示删除按钮
        [self.dataArray enumerateObjectsUsingBlock:^(SubsidiaryModel *data, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([data.customizedVip isEqualToString:@"1"] || [data.appVip isEqualToString:@"1"] || [data.calVip isEqualToString:@"1"] || [data.conVip isEqualToString:@"1"]) {
                cell.deleteBtn.hidden = YES;
            }
        }];
        
        cell.contentL.text = @"公司名称";
        cell.contentL.frame = CGRectMake(10, 0, 80, 50);
        
        cell.textF.hidden = NO;
        cell.textF.frame = CGRectMake(120, 0, kSCREEN_WIDTH-120-50, 50);
        cell.textF.text = self.companyName;
        cell.textF.delegate = self;
        [cell.textF addTarget:self action:@selector(textfclick:) forControlEvents:UIControlEventEditingDidEnd];
        
        return cell;
    }
    
    else if (indexPath.section == 2) {
        MyCompanyMidCell *cell = [MyCompanyMidCell cellWithTableView:tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.row==0) {
            cell.contentL.text = @"公司架构(勾选设置总公司)";
            [cell.leftImg setImage:[UIImage imageNamed:@"comFrame-0"]];
            cell.rightRow.hidden = YES;
        }
        else{
            SubsidiaryModel *data = self.dataArray[indexPath.row-1];
            [cell configWith:data];
            cell.delegate = self;
            cell.tag = indexPath.row;
            cell.leftImg.hidden = YES;
            cell.rightRow.hidden = YES;
            cell.selectBtn.hidden = NO;
            
            
                if ([data.headQuarters integerValue]==1) {
                    cell.deleteBtn.hidden = YES; //默认的总公司的分公司不能删除
                }else{
                    cell.deleteBtn.hidden = NO;

                    // 在这里判断有没有开通会员，开通会员的隐藏删除按钮
                    if ([data.customizedVip isEqualToString:@"1"] || [data.appVip isEqualToString:@"1"] || [data.calVip isEqualToString:@"1"] || [data.conVip isEqualToString:@"1"]) {
                        cell.deleteBtn.hidden = YES;
                    }
                }
            
                cell.selectBtn.hidden = NO;
                if (indexPath.row==(_defaultSelectTag+1)) {
                    [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
                }
                else{
                    [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"meixuanzhong"] forState:UIControlStateNormal];
                }
            
        }
        return cell;
    }
        else{
            EditMyCompanyBottomCell *cell = [EditMyCompanyBottomCell cellWithTableView:tableView];
            cell.companySlognV.text = self.companySlogan;
            cell.companySlognV.font = [UIFont systemFontOfSize:16];
            cell.companySlognV.delegate = self;
            return cell;
        }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self imagePicker];
    }
    else{
        
    }
}

-(void)imagePicker{
    
    UIImagePickerController * photoAlbum = [[UIImagePickerController alloc]init];
    photoAlbum.delegate = self;
    photoAlbum.allowsEditing = YES;
    photoAlbum.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:photoAlbum animated:YES completion:^{}];
}

//图片选择完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage * chooseImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
//    NSData *imageData = UIImageJPEGRepresentation(chooseImage, PHOTO_COMPRESS);
    NSData *imageData = [NSObject imageData:chooseImage];
    
    if ([imageData length] >0) {
        imageData = [GTMBase64 encodeData:imageData];
    }
    NSString *imageStr = [[NSString alloc]initWithData:imageData encoding:NSUTF8StringEncoding];
    
    [self uploadImageWithBase64Str:imageStr];
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

//取消选择图片
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

-(void)uploadImageWithBase64Str:(NSString*)base64Str{
    
    UploadImageApi *uploadApi = [[UploadImageApi alloc]initWithImgStr:base64Str type:@"png"];
    
    [uploadApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSDictionary *dic = request.responseJSONObject;
        NSString *code = [dic objectForKey:@"code"];
        
        if ([code isEqualToString:@"1000"]) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"上传成功" controller:self sleep:1.5];
            self.companyLogo = [dic objectForKey:@"imageUrl"];
//
//            [self.logoImg sd_setImageWithURL:[NSURL URLWithString:_photoUrl] placeholderImage:[UIImage imageNamed:@"jia1"]];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
            
            
            //            [self.editInfoTableView reloadData];
            
        }
        else{
            [[PublicTool defaultTool] publicToolsHUDStr:@"上传失败" controller:self sleep:1.5];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

#pragma mark - uitextfieldDelegate

//-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    self.companyName = textField.text;
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//}

-(void)textfclick:(UITextField *)text{
    self.companyName = text.text;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    self.companySlogan = textView.text;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:3];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark - MyCompanyMidCellDelegate

-(void)deleteCompanyWith:(NSIndexPath *)path{
    if (path.section == 1) {
        NSString *str = [NSString stringWithFormat:@"是否确定删除%@公司，删除总公司以后将删除所有的数据",self.companyName];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除"
                                                        message:str
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        alert.tag = 1001;
        [alert show];
    }
    else{
    _tag = path.row;
//        SubsidiaryModel *model = self.dataArray[path.row-1];
        NSString *str = @"删除后所有店面信息将删除并不可恢复，是否确认删除";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:str
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
        alert.tag = 1000;
    [alert show];
    
    }
}

-(void)selectCompanyWith:(NSIndexPath *)path{
    YSNLog(@"%@",path);
//    MyCompanyMidCell *cell = [self.tableView cellForRowAtIndexPath:path];
    if ((path.row-1)==_defaultSelectTag) {
//        [cell.selectBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
        _defaultSelectTag = path.row-1;
    }
    else{
//        [cell.selectBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
        _defaultSelectTag = path.row-1;
    }
    [self.tableView reloadData];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            
            //删除单个公司
            [self.view hudShow];
            SubsidiaryModel *data = self.dataArray[_tag-1];
            NSString *requestString = [BASEURL stringByAppendingString:@"company/deleteByCompanyId.do"];
            NSDictionary *dic = @{@"companyIds":data.companyId
                                  };
            //    NSDictionary *dic = @{@"companyId":@267};
            [NetManager afPostRequest:requestString parms:dic finished:^(id responseObj) {
                [self.view hiddleHud];
                NSLog(@"%@",responseObj);
                if ([responseObj[@"code"] isEqualToString:@"1000"]) {
                    //                [self getCompanyList];
                    [[PublicTool defaultTool] publicToolsHUDStr:@"删除成功" controller:self sleep:1.5];
                    [self.dataArray removeObject:data];
                    //                if ((_tag-1)>_defaultSelectTag) {
                    //
                    //                }
                    //                [self.tableView reloadData];
                    [self ergodicDataArray];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"requestCompanyList" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SettingChangeNet" object:nil];
                }
                else if([responseObj[@"code"] isEqualToString:@"1003"]){
                    [[PublicTool defaultTool] publicToolsHUDStr:@"请先退出或解散联盟" controller:self sleep:1.5];
                }
                else{
                    [[PublicTool defaultTool] publicToolsHUDStr:@"删除失败" controller:self sleep:1.5];
                }
                //        [_mainTableView reloadData];
            } failed:^(NSString *errorMsg) {
                YSNLog(@"%@",errorMsg);
                [self.view hiddleHud];
                [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
            }];

        }
    }
    
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            
            //删除所有公司
            NSString *companyIdStr = self.companyId;
            if (self.dataArray.count<=0) {
                companyIdStr = self.companyId;
            }else{
                for (SubsidiaryModel *model in self.dataArray) {
                    companyIdStr = [NSString stringWithFormat:@"%@,%@",companyIdStr,model.companyId];
                }
            }
            //            SubsidiaryModel *data = self.dataArray[_tag-1];
            NSString *requestString = [BASEURL stringByAppendingString:@"company/deleteCompanyById.do"];
            
            UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
            NSDictionary *dic = @{@"agencysId":@(user.agencyId)
                                  };
            
            //    NSDictionary *dic = @{@"companyId":@267};
            [self.view hudShow];
            [NetManager afPostRequest:requestString parms:dic finished:^(id responseObj) {
                [self.view hiddleHud];
                NSLog(@"%@",responseObj);
                if ([responseObj[@"code"] isEqualToString:@"1000"]) {
                    //                [self getCompanyList];
                    [[PublicTool defaultTool] publicToolsHUDStr:@"删除成功" controller:self sleep:1.5];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SettingChangeNet" object:nil];
                    for (UIViewController *vc in self.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[MeViewController class]]) {
                            [self.navigationController popToViewController:vc animated:YES];
                        }
                    }
                } else if([responseObj[@"code"] isEqualToString:@"1003"]) {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"有公司/子公司开通会员，不能删除公司" controller:self sleep:1.5];
                }
                else if([responseObj[@"code"] isEqualToString:@"1004"]) {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"请先退出或解散联盟" controller:self sleep:1.5];
                }
                else{
                    [[PublicTool defaultTool] publicToolsHUDStr:@"删除失败" controller:self sleep:1.5];
                }
                //        [_mainTableView reloadData];
            } failed:^(NSString *errorMsg) {
                YSNLog(@"%@",errorMsg);
                [self.view hiddleHud];
                [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
            }];
            
        }
    }
    
    if (alertView.tag == 2000) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
}

#pragma mark - setter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64,kSCREEN_WIDTH,kSCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc]init];
        //        _tableView.backgroundColor = Black_Color;
        //        [_tableView addHeaderWithTarget:self action:@selector(loadData)];
        //        [_tableView addFooterWithTarget:self action:@selector(upLoadData)];
        
    }
    return _tableView;
}

@end
