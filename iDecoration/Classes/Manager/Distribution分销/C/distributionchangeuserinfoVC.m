//
//  distributionchangeuserinfoVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/10.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "distributionchangeuserinfoVC.h"
#import "changeuserinfoCell0.h"
#import "changeuserinfoCell1.h"
#import "changeuserinfoCell2.h"
#import "TZImagePickerController.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface distributionchangeuserinfoVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UIButton *saveBtn;
@property (nonatomic,copy)   NSString *imgUrl;
@property (nonatomic,strong) UIImage *headimg;
@property (nonatomic,strong) UILabel *typelab;
@end

static NSString *changeuserinfoidentfid0 = @"changeuserinfoidentfid0";
static NSString *changeuserinfoidentfid1 = @"changeuserinfoidentfid1";
static NSString *changeuserinfoidentfid2 = @"changeuserinfoidentfid2";

@implementation distributionchangeuserinfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"编辑资料";
    self.imgUrl = @"";
    self.headimg = [UIImage new];
    [self.view addSubview:self.table];
    self.table.tableFooterView = self.footView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 150)];
        _footView.backgroundColor = [UIColor clearColor];
        [_footView addSubview:self.saveBtn];
        [_footView addSubview:self.typelab];
    }
    return _footView;
}

-(UIButton *)saveBtn
{
    if(!_saveBtn)
    {
        _saveBtn = [[UIButton alloc] init];;
        [_saveBtn setTitle:@"确认修改" forState:normal];
        _saveBtn.frame = CGRectMake(kSCREEN_WIDTH/2-140, 80, 280, 42);
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_saveBtn setTitleColor:[UIColor hexStringToColor:@"FFFFFF"] forState:normal];
        _saveBtn.backgroundColor = [UIColor hexStringToColor:@"24B764"];
        [_saveBtn addTarget:self action:@selector(savebtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

-(UILabel *)typelab
{
    if(!_typelab)
    {
        _typelab = [[UILabel alloc] init];
        _typelab.frame = CGRectMake(0, 20, kSCREEN_WIDTH, 20);
        _typelab.textAlignment = NSTextAlignmentCenter;
        _typelab.font = [UIFont systemFontOfSize:12];
        _typelab.textColor = [UIColor hexStringToColor:@"868686"];
        _typelab.text = @"*你所获得的补贴佣金，将自动会打到你所绑定的账号";
    }
    return _typelab;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    if (section==1) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        changeuserinfoCell0 *cell  = [tableView dequeueReusableCellWithIdentifier:changeuserinfoidentfid0];
        if (!cell) {
            cell = [[changeuserinfoCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:changeuserinfoidentfid0];
            cell.iconBtn.tag = 201;
        }
        [cell.iconBtn addTarget:self action:@selector(addimg) forControlEvents:UIControlEventTouchUpInside];
        [cell.submitBtn addTarget:self action:@selector(uploaddata) forControlEvents:UIControlEventTouchUpInside];
        [cell.iconBtn sd_setImageWithURL:[NSURL URLWithString:self.imgUrl] forState:normal placeholderImage:[UIImage imageNamed:@"touxiang"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            changeuserinfoCell1 *cell  = [tableView dequeueReusableCellWithIdentifier:changeuserinfoidentfid1];
            if (!cell) {
                cell = [[changeuserinfoCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:changeuserinfoidentfid1];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.row==1) {
            changeuserinfoCell2 *cell  = [tableView dequeueReusableCellWithIdentifier:changeuserinfoidentfid2];
            if (!cell) {
                cell = [[changeuserinfoCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:changeuserinfoidentfid2];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
 
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 210;
    }
    if (indexPath.section==1) {
        return 55;
    }
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return 10;
    }
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 10)];
        view.backgroundColor = [UIColor hexStringToColor:@"F0F0F0"];
        return view;
    }
    return nil;
}

#pragma mark - 实现方法
//确认修改
-(void)savebtnclick
{
    
}

-(void)addimg
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        UIImage *img = [photos firstObject];
        UIButton *imgbtn = [self.table viewWithTag:201];
        //imgv.image = img;
        [imgbtn setImage:img forState:normal];
        self.headimg = img;
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


-(void)uploaddata
{
    // 基于AFN3.0+ 封装的HTPPSession句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"file/uploadFiles.do"];
    
    // 在parameters里存放照片以外的对象
    [manager POST:defaultApi parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        UIImage *image = self.headimg;
        
        
        CGImageRef cgref = [image CGImage];
        CIImage *cim = [image CIImage];
        
        if (cim == nil && cgref == NULL)
        {
            NSLog(@"no image");
        } else {
            NSLog(@"imageView has a image");
            
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
        // NSString *temStr = [NSString stringWithFormat:@"%.2f",uploadProgress.fractionCompleted];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // [self.progress setProgress:progress animated:YES];
            
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        YSNLog(@"```上传成功``` %@",responseObject);
        if ([[responseObject objectForKey:@"code"] intValue]==1000) {
            NSArray *arr = [responseObject objectForKey:@"imgList"];
            NSDictionary *dic = [arr firstObject];
            self.imgUrl = [dic objectForKey:@"imgUrl"];
            [[PublicTool defaultTool] publicToolsHUDStr:@"图片上传成功" controller:self sleep:1.5];
            [self.table reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        YSNLog(@"xxx上传失败xxx %@", error);
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
    
}

@end
