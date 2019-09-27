//
//  newaddcommunityVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/29.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "newaddcommunityVC.h"
#import "addcommunityCell0.h"
#import "addcommunityCell1.h"
#import "addcommunityCell2.h"
#import "TZImagePickerController.h"

@interface newaddcommunityVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UIButton *submitBtn;
@property (nonatomic,assign) BOOL isshow;
@property (nonatomic,copy) NSString *covermap;
@end


static NSString *newaddidentfid0 = @"newaddidentfid0";
static NSString *newaddidentfid1 = @"newaddidentfid0";
static NSString *newaddidentfid2 = @"newaddidentfid0";


@implementation newaddcommunityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"创建小区";
    
    [self.view addSubview:self.table];
    self.table.tableFooterView = self.footView;
    
}

#pragma mark - getters

-(UITableView *)table
{
    if(!_table)
    {
        CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom);
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, naviBottom) style:UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
    }
    return _table;
}

-(UIView *)footView
{
    if(!_footView)
    {
        _footView = [[UIView alloc] init];
        _footView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 88);
        [_footView addSubview:self.submitBtn];
    }
    return _footView;
}

-(UIButton *)submitBtn
{
    if(!_submitBtn)
    {
        _submitBtn = [[UIButton alloc] init];
        _submitBtn.backgroundColor = [UIColor hexStringToColor:@"25B764"];
        [_submitBtn setTitle:@"完成" forState:normal];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_submitBtn setTitleColor:White_Color forState:normal];
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.layer.cornerRadius = 4;
        _submitBtn.frame = CGRectMake(kSCREEN_WIDTH/2-226/2, 20, 226, 50);
        [_submitBtn addTarget:self action:@selector(submitbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}


#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        addcommunityCell0 *cell = [tableView dequeueReusableCellWithIdentifier:newaddidentfid0];
        cell = [[addcommunityCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newaddidentfid0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.bgImg.tag = 201;
        if (self.isshow) {
            [cell.addBtn setHidden:YES];
            [cell.bgImg sd_setImageWithURL:[NSURL URLWithString:self.covermap]];
        }
        else
        {
            [cell.addBtn setHidden:NO];
        }
        cell.contentLab.text = @"添加图标";
        [cell.addBtn addTarget:self action:@selector(addimg) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    if (indexPath.row==1) {
        addcommunityCell1 *cell = [tableView dequeueReusableCellWithIdentifier:newaddidentfid1];
        cell = [[addcommunityCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newaddidentfid1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftLab.text = @"小区名称";
        cell.commnuityText.tag = 202;
        return cell;
    }
    if (indexPath.row==2) {
        addcommunityCell2 *cell = [tableView dequeueReusableCellWithIdentifier:newaddidentfid2];
        cell = [[addcommunityCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newaddidentfid2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftLab.text = @"小区地址";
        cell.commnuityText.tag = 203;
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 240;
    }
    if (indexPath.row==1) {
        return 49;
    }
    if (indexPath.row==2) {
        return 49;
    }
 
    return 0.01f;
}

-(void)addimg
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        UIImage *img = [photos firstObject];
        UIImageView *imgv = [self.table viewWithTag:201];
        imgv.image = img;
        self.isshow = YES;
        [self uploaddata:img];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - 实现方法

-(void)uploaddata:(UIImage *)img
{
    // 基于AFN3.0+ 封装的HTPPSession句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"file/uploadFiles.do"];
    
    // 在parameters里存放照片以外的对象
    [manager POST:defaultApi parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        UIImage *image = img;
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
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        YSNLog(@"---上传进度--- %@",uploadProgress);
        YSNLog(@"%f",uploadProgress.fractionCompleted);
        // NSString *temStr = [NSString stringWithFormat:@"%.2f",uploadProgress.fractionCompleted];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // [self.progress setProgress:progress animated:YES];
            
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        YSNLog(@"```上传成功``` %@",responseObject);
        if ([[responseObject objectForKey:@"code"] intValue]==1000) {
            NSArray *arr = [responseObject objectForKey:@"imgList"];
            NSDictionary *dic = [arr firstObject];
            self.covermap = [dic objectForKey:@"imgUrl"];
            [[PublicTool defaultTool] publicToolsHUDStr:@"图片上传成功" controller:self sleep:1.5];
            [self.table reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        YSNLog(@"xxx上传失败xxx %@", error);
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
    
}


-(void)submitbtnclick
{
    if (self.covermap.length==0) {
         [[PublicTool defaultTool] publicToolsHUDStr:@"请添加图标" controller:self sleep:1.5];
        return;
    }
    
    UITextField *text0 = [self.table viewWithTag:202];
    if (text0.text.length==0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入小区名称" controller:self sleep:1.5];
        return;
    }
    
    NSString *communityName = text0.text?:@"";
    
    UITextField *text1 = [self.table viewWithTag:203];
    if (text1.text.length==0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入小区地址" controller:self sleep:1.5];
        return;
    }
    
    NSString *address = text1.text?:@"";
    
    NSString *newcovermap = self.covermap?:@"";
    NSString *newcompanyId = self.companyId?:@"";
    
    NSString *lng = [[NSUserDefaults standardUserDefaults] objectForKey:@"lng"];
    NSString *lat = [[NSUserDefaults standardUserDefaults] objectForKey:@"lat"];
    NSDictionary *para = @{@"companyId":newcompanyId,@"covermap":newcovermap,@"address":address,@"communityName":communityName,@"communityId":@"0",@"lng":lng?:@"0",@"lat":lat?:@"0"};
    
    NSString *url = [BASEURL stringByAppendingString:@"cblejCommunity/insert.do"];
    
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            
            __weak typeof(self) weakself = self;
            
            if (weakself.returnValueBlock) {
                
                weakself.returnValueBlock([NSString new]);
            }
      
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSString *hud = [responseObj objectForKey:@"msg"];
            [[PublicTool defaultTool] publicToolsHUDStr:hud controller:self sleep:1.5];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
    
}

@end
