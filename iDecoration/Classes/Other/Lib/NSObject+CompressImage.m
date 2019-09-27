//
//  NSObject+CompressImage.m
//  iDecoration
//
//  Created by zuxi li on 2017/7/11.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "NSObject+CompressImage.h"

@implementation NSObject (CompressImage)

+ (NSData *)imageData:(UIImage *)myimage{
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    YSNLog(@"原图大小 imageData = %f", data.length/1024.0);
//    if (data.length>100*1024) {
//        if (data.length>1024*1024) {//1M以及以上
//            data=UIImageJPEGRepresentation(myimage, 0.1);
//        }else if (data.length>1024*1024*0.7) {//0.7M-1M
//            data=UIImageJPEGRepresentation(myimage, 0.5);
//        }else if (data.length>512*1024) {//0.5M-0.7M
//            data=UIImageJPEGRepresentation(myimage, 0.7);
//        }else if (data.length>200*1024) {//0.25M-0.5M
//            data=UIImageJPEGRepresentation(myimage, 0.9);
//        }
//    }


    CGFloat size = 200.0f;
    CGFloat scale = size/(data.length/1024);
    data=UIImageJPEGRepresentation(myimage, scale);
    YSNLog(@"压缩后大小 imageData = %f, 压缩比例： %f", data.length/1024.0, scale);
    
    NSData *oneData = data;
    if (data.length / 1024.0 >=  500) {
        data = [self fitSamallImage:data];
    }
    YSNLog(@"重绘后大小 imageData = %f", data.length/1024.0);
    return data < oneData ? data : oneData;
    

}


+ (NSData *)fitSamallImage:(NSData *)data {
    UIImage *image= [UIImage imageWithData:data];
    if (nil == image) {
        return nil;
    }
    if (image.size.width < 414) {
        
        return UIImageJPEGRepresentation(image, 1.0);
    }
    YSNLog(@"图片宽image.size.width = %f", image.size.width);
    CGSize size = CGSizeMake(414, 414 *image.size.height/image.size.width);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(scaledImage, 1.0);
}


+ (UIImage *)imageCompressFromImage:(UIImage *)myImage {
    NSData *data=UIImageJPEGRepresentation(myImage, 1.0);
    YSNLog(@"imageData = %f", data.length/1024.0);
//    if (data.length>100*1024) {
//        if (data.length>1024*1024) {//1M以及以上
//            data=UIImageJPEGRepresentation(myImage, 0.1);
//        }else if (data.length>1024*1024*0.7) {//0.7M-1M
//            data=UIImageJPEGRepresentation(myImage, 0.5);
//        }else if (data.length>512*1024) {//0.5M-0.7M
//            data=UIImageJPEGRepresentation(myImage, 0.7);
//        }else if (data.length>200*1024) {//0.25M-0.5M
//            data=UIImageJPEGRepresentation(myImage, 0.9);
//        }
//    }
    
    CGFloat size = 200.0f;
    CGFloat scale = size/(data.length/1024);
    data=UIImageJPEGRepresentation(myImage, scale);
    YSNLog(@"imageData = %f", data.length/1024.0);
    NSData *oneData = data;
    if (data.length / 1024.0 >=  500) {
        data = [self fitSamallImage:data];
    }
    YSNLog(@"重绘后大小 imageData = %f", data.length/1024.0);
    data = data < oneData ? data : oneData;
    if (data == nil) {
        return myImage;
    }
    return [UIImage imageWithData:data];
}


+ (void)promptWithControllerName:(NSString *)controllerName {
    
    UserInfoModel *model = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *agencyId = [NSString stringWithFormat:@"%ld", (long)model.agencyId];
    
    if ([controllerName isEqualToString:@""] || [agencyId isEqualToString:@""]) {
        return;
    }
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"prompt.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        NSDictionary *dict = [NSDictionary dictionary];
        [dict writeToFile:path atomically:YES];
    }
    // 获取plist字典
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    // 控制器字典
    NSMutableDictionary *contolDict = [dict objectForKey:controllerName];
    if (contolDict == nil) {
        contolDict = [NSMutableDictionary dictionary];
        // 该用户下数量加1
        [contolDict setObject:@"1" forKey:agencyId];
        [dict setObject:contolDict forKey:controllerName];
        [dict writeToFile:path atomically:YES];
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"左滑可以删除"];
    } else {
        NSString *num = [contolDict objectForKey:agencyId];
        // 用户还没有存过
        if (num == nil) {
            [contolDict setObject:@"1" forKey:agencyId];
            [dict writeToFile:path atomically:YES];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"左滑可以删除"];
        } else {
            if (num.integerValue > 2) {
                return;
            }
            [contolDict setObject:[NSString stringWithFormat:@"%ld", (long)(num.integerValue + 1)] forKey:agencyId];
            [dict writeToFile:path atomically:YES];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"左滑可以删除"];
        }
    }

}




+ (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}

+ (UIImage*)getSubImage:(UIImage*)image mCGRect:(CGRect)mCGRect centerBool:(BOOL)centerBool{
    /*如若centerBool为Yes则是由中心点取mCGRect范围的图片*/
    
    float imgWidth = image.size.width;
    float imgHeight = image.size.height;
    float viewWidth = mCGRect.size.width;
    float viewHidth = mCGRect.size.height;
    CGRect rect;
    if(centerBool)
        rect = CGRectMake((imgWidth-viewWidth)/2, (imgHeight-viewHidth)/2, viewWidth, viewHidth);
    else{
        if (viewHidth < viewWidth) {
            if (imgWidth <= imgHeight) {
                rect = CGRectMake(0, 0, imgWidth, imgWidth*imgHeight/viewWidth);
            }else {
                float width = viewWidth*imgHeight/imgHeight;
                float x = (imgWidth - width)/2;
                if (x > 0) {
                    rect = CGRectMake(x, 0, width, imgHeight);
                }else {
                    rect = CGRectMake(0, 0, imgWidth, imgWidth*imgHeight/viewWidth);
                }
            }
        }else
        {
            if (imgWidth <= imgHeight)
            {
                float height = imgHeight*imgWidth/viewWidth;
                if (height < imgHeight) {
                    rect = CGRectMake(0, 0, imgWidth, height);
                } else {
                    rect = CGRectMake(0, 0,  viewWidth*imgHeight/imgHeight, imgHeight);
                }
            }else
            {
                float width = viewWidth*imgHeight/imgHeight;
                if (width  < imgWidth) {
                    float x = (imgWidth - width)/2 ;
                    rect = CGRectMake(x, 0, width, imgHeight);
                } else {
                    rect = CGRectMake(0, 0, imgWidth, imgHeight);
                }
            }
        }
    }
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    //CFRelease(subImageRef);
    
    return smallImage;
}

+ (NSString *)networkingStatesFromStatebar {
    // 状态栏是由当前app控制的，首先获取当前app
    // 这个方法在xcode的崩溃日志里出现， 不知道什么原因， 换成下面的方法判断网络状态
//    UIApplication *app = [UIApplication sharedApplication];
//
//    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
//
//    int type = 0;
//    for (id child in children) {
//        if ([child isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
//            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
//        }
//    }
//
//    NSString *stateString = @"";
//
//    switch (type) {
//        case 0:
//            stateString = @"";
//            break;
//
//        case 1:
//            stateString = @"2G";
//            break;
//
//        case 2:
//            stateString = @"3G";
//            break;
//
//        case 3:
//            stateString = @"4G";
//            break;
//
//        case 4:
//            stateString = @"LTE";
//            break;
//
//        case 5:
//            stateString = @"wifi";
//            break;
//
//        default:
//            break;
//    }
//
//    return stateString;
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    NSString *net = @"";
    switch (internetStatus) {
        case ReachableViaWiFi:
            net = @"WIFI";
            break;
            
        case ReachableViaWWAN:
            net = @"蜂窝数据";
            //net = [self getNetType ];   //判断具体类型
            break;
            
        case NotReachable:
            net = @"";
        default:
            break;
    }
    
    return net;
}



+ (void)companyShareStatisticsWithConpanyId:(NSString *)companyId {
    NSString *defaultApi = [BASEURL stringByAppendingString:@"company/addShareNumbers.do"];
    NSDictionary *paramDic = @{
                               @"companyId" : companyId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
    } failed:^(NSString *errorMsg) {
        
    }];
}

+ (void)contructionShareStatisticsWithConstructionId:(NSString *)constructionId {
    NSString *defaultApi = [BASEURL stringByAppendingString:@"construction/addShareNumbers.do"];
    
    NSDictionary *paramDic = @{
                               @"constructionId" : constructionId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
    } failed:^(NSString *errorMsg) {
    }];
}

+ (void)goodsShareStatisticsWithMerchandiesId:(NSString *)merchandiesId {
    NSString *defaultApi = [BASEURL stringByAppendingString:@"merchandies/addShareNumbers.do"];
    NSDictionary *paramDic = @{
                               @"merchandiesId" : merchandiesId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
    } failed:^(NSString *errorMsg) {
    }];
}

+ (void)needDecorationStatisticsWithConpanyId:(NSString *)companyId {
    NSString *defaultApi = [BASEURL stringByAppendingString:@"company/addCallDeNumbers.do"];
    NSDictionary *paramDic = @{
                               @"companyId" : companyId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
    } failed:^(NSString *errorMsg) {
    }];
}


+ (void)uploadImgWith:(NSArray *)imgArray completion:(void(^)(NSArray * imageURLArray))completion{
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
    
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    
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
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        NSArray *arr = [responseObject objectForKey:@"imgList"];
        NSMutableArray *multArray = [NSMutableArray array];
        for (NSDictionary *dict in arr) {
            NSString *imgUrl = [dict objectForKey:@"imgUrl"];
            [multArray addObject:imgUrl];
        }
        completion([multArray copy]);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        YSNLog(@"xxx上传失败xxx %@", error);
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
        
    }];
}


// 获取本地视频的第一张图
+ (UIImage *)getImageFromLocalVideoPath:(NSString *)videoURL{
    
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

+ (int)compareDate:(NSString*)date01 littlewithDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dt1 = [[NSDate alloc]init];
    NSDate *dt2 = [[NSDate alloc]init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case(NSOrderedAscending): ci=1;break;
            //date02比date01小
        case(NSOrderedDescending): ci=-1;break;
            //date02=date01
        case NSOrderedSame: ci=0;break;
        default: YSNLog(@"erorr dates %@, %@", dt2, dt1);break;
    }
    return ci;
}

+ (NSString*)timeStringFromTimeIntervalString:(NSTimeInterval)timerInterval WithFromatter:(NSString *)format {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate *datenow = [NSDate dateWithTimeIntervalSince1970:timerInterval];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
    
}

+ (void) timelessWithSecond:(NSInteger)s button:(UIButton *)btn {
    __block int timeout = (int)s; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout <= 0) { //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
                btn.userInteractionEnabled = YES;
                btn.backgroundColor = kMainThemeColor;
            });
            
        } else {
            
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [btn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                btn.userInteractionEnabled = NO;
                btn.backgroundColor = kDisabledColor;
            });
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
}
@end
