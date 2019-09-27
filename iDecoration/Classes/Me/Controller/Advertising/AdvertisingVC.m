//
//  AdvertisingVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/8.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "AdvertisingVC.h"
#import "AdvertisingCell0.h"
#import "AdvertisingCell1.h"
#import "TZImagePickerController.h"

@interface AdvertisingVC ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isfirst;
}
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,copy)   NSString *picUrl;
@property (nonatomic,copy)   NSString *picHref;
@property (nonatomic,strong) NSDictionary *listdic;
@property (nonatomic,copy)   NSString *picId;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UILabel *contentLab;
@end

static NSString *Advertisingidentfid0 = @"Advertisingidentfid0";
static NSString *Advertisingidentfid1 = @"Advertisingidentfid1";

@implementation AdvertisingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"广告位";
    self.picUrl = @"";
    self.picHref = @"";
    self.picId = @"";
    isfirst = YES;
    self.listdic = [NSDictionary dictionary];
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"完成" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    [self loaddata];
    [self.view addSubview:self.table];
    self.table.tableFooterView = self.footView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loaddata
{
    NSString *url = [BASEURL stringByAppendingString:GET_IMGGUANGGAO];
    NSDictionary *para = @{@"type":self.type,@"relId":self.relId};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            isfirst = NO;
            NSDictionary *data = [responseObj objectForKey:@"data"];
            NSArray *listarr = [data objectForKey:@"list"];
            if (listarr.count!=0) {
                self.listdic = [listarr firstObject];
                self.picUrl = [self.listdic objectForKey:@"picUrl"];
                self.picHref = [self.listdic objectForKey:@"picHref"];
                self.picId = [self.listdic objectForKey:@"picId"];
                [self.table reloadData];
            }
        }
        if ([[responseObj objectForKey:@"code"] intValue]==1002) {
            isfirst = YES;
        }
    } failed:^(NSString *errorMsg) {
         isfirst = YES;
    }];
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
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200)];
        [_footView addSubview:self.contentLab];
    }
    return _footView;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.numberOfLines = 0;
        _contentLab.textColor = [UIColor darkGrayColor];
        _contentLab.text = @"1、同一个公司内，公司美文一个广告位，个人美文一个广告位 \n2、公司美文广告位总经理和执行经理可编辑，个人美文广告位作者自己可编辑 \n3、广告位在美文正文下方，留言区域上方显示";
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.frame = CGRectMake(14, 14, kSCREEN_WIDTH-28, 100);
    }
    return _contentLab;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        AdvertisingCell0 *cell = [tableView dequeueReusableCellWithIdentifier:Advertisingidentfid0];
        if (!cell) {
            cell = [[AdvertisingCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Advertisingidentfid0];
            cell.bgimg.tag = 201;
        }
        if (isfirst) {
            [cell.addBtn setHidden:NO];
        }
        else
        {
            [cell.addBtn setHidden:YES];
            cell.bgimg.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addimg)];
            [cell.bgimg addGestureRecognizer:tap];
        }
        [cell.bgimg sd_setImageWithURL:[NSURL URLWithString:self.picUrl]];
        [cell.addBtn addTarget:self action:@selector(addimg) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row==1) {
        AdvertisingCell1 *cell = [tableView dequeueReusableCellWithIdentifier:Advertisingidentfid1];
        if (!cell) {
            cell = [[AdvertisingCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Advertisingidentfid1];
            cell.urlText.tag = 202;
        }
        cell.urlText.text = self.picHref;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 200;
    }
    if (indexPath.row==1) {
        return 50;
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
            self.picUrl = [dic objectForKey:@"imgUrl"];
            [[PublicTool defaultTool] publicToolsHUDStr:@"图片上传成功" controller:self sleep:1.5];
            [self.table reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        YSNLog(@"xxx上传失败xxx %@", error);
       [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
    
}

-(void)BtnClick
{
    if (isfirst) {
        UITextField *picHref = [self.table viewWithTag:202];
        self.picHref = picHref.text;
        if (self.picHref.length!=0&&self.picUrl.length!=0) {
            NSDictionary *para = @{@"picHref":self.picHref,@"relId":self.relId,@"picUrl":self.picUrl,@"type":self.type};
            NSString *url = [BASEURL stringByAppendingString:POST_imgsave];
            [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
                if ([[responseObj objectForKey:@"code"] intValue]==1000) {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"上传成功" controller:self sleep:1.5];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } failed:^(NSString *errorMsg) {
                [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
            }];
        }
        else
        {
            [[PublicTool defaultTool] publicToolsHUDStr:@"您还没有填写链接" controller:self sleep:1.5];
        }
    }
    else
    {
        UITextField *picHref = [self.table viewWithTag:202];
        self.picHref = picHref.text;
        if (self.picHref.length!=0&&self.picUrl.length!=0&&self.picId.length!=0) {
            NSDictionary *para = @{@"picHref":self.picHref,@"picId":self.picId,@"picUrl":self.picUrl};
            NSString *url = [BASEURL stringByAppendingString:POST_uploadimg];
            [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
                if ([[responseObj objectForKey:@"code"] intValue]==1000) {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"上传成功" controller:self sleep:1.5];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } failed:^(NSString *errorMsg) {
                [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
            }];
        }
        else
        {
            [[PublicTool defaultTool] publicToolsHUDStr:@"您还没有填写链接" controller:self sleep:1.5];
        }
    }

}

@end
