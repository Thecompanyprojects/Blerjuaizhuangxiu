//
//  YPImagePreviewController.m
//  YPCommentDemo
//
//  Created by 朋 on 16/7/21.
//  Copyright © 2016年 杨朋. All rights reserved.
//

#import "YPImagePreviewController.h"
#import "YPProgressView.h"
#define KScreen_Size  [UIScreen mainScreen].bounds.size
@interface YPImagePreviewController ()<UIScrollViewDelegate>

@end

@implementation YPImagePreviewController
{
    UIScrollView * _scrollView;
    UIImageView * _imageView;
    UILabel *_titleLab;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self createUI];
    [self addImagesToScrollView];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}



- (void)createNav{
    self.view.backgroundColor = [UIColor blackColor];
//    _titleLab= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
//    _titleLab.text = [NSString stringWithFormat:@"%d/%d",(int)(self.index +1),(int)self.images.count];
//    _titleLab.textAlignment = NSTextAlignmentCenter ;
//    _titleLab.textColor = [UIColor whiteColor];
//    _titleLab.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:20];
//    
//    self.navigationItem.titleView = _titleLab;
//
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    
//    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(3, 0, 50, 44)];
//    [backButton setImage:[UIImage imageNamedFromMyBundle:@"navi_back.png"] forState:UIControlStateNormal];
//    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    [backButton addTarget:self action:@selector(popViewControllerAnimated) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    

}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)createUI {

    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    _scrollView.contentSize = CGSizeMake(KScreen_Size.width*self.images.count, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self ;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentOffset = CGPointMake(self.index*KScreen_Size.width,0);
    
    _scrollView.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissTap:)];
    [_scrollView addGestureRecognizer:ges];
    
    _titleLab= [[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/2-30, kSCREEN_HEIGHT-40, 60, 40)];
        _titleLab.text = [NSString stringWithFormat:@"%d/%d",(int)(self.index +1),(int)self.images.count];
        _titleLab.textAlignment = NSTextAlignmentCenter ;
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:_scrollView];
    
    [self.view addSubview:_titleLab];
}

-(void)addImagesToScrollView
{
    for (int i = 0;i < _images.count ;i ++) {
        
        
        
//        _imageView.userInteractionEnabled = YES;
//
//        _imageView = [[UIImageView alloc] init];
//
//        _imageView.frame = CGRectMake(i*(KScreen_Size.width),0,KScreen_Size.width, 500);
        
        
        UIImageView *temImgV = [[UIImageView alloc] init];
        
        temImgV.frame = CGRectMake(i*(KScreen_Size.width),0,KScreen_Size.width, 500);
        temImgV.userInteractionEnabled = YES;
        
        
        
        id isImg = _images[i];
        UIImage *temImg;
        if ([isImg isKindOfClass:[UIImage class]]) {
            temImg = isImg;
            temImgV.image = temImg;
            
            [temImgV sizeToFit];
            
            CGRect cellHeight = temImgV.frame;
            
            cellHeight.size.height = [self setImageHeightWithImage:temImgV.image];
            
            CGFloat imgTop = kSCREEN_HEIGHT/2-cellHeight.size.height/2;
            temImgV.frame = CGRectMake(i*(KScreen_Size.width),imgTop,KScreen_Size.width, cellHeight.size.height);
//            _imageView.frame = cellHeight;
//            
//            CGPoint point = _imageView.center;
//            
//            //        point.y = (KScreen_Size.height-64)/2.0;
//            point.y = (KScreen_Size.height)/2.0;
//            
//            _imageView.center = point;
            temImgV.userInteractionEnabled = YES;
            UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissTap:)];
            [temImgV addGestureRecognizer:ges];
            [_scrollView addSubview:temImgV];
            
            
        }
        if ([isImg isKindOfClass:[NSString class]]) {
            NSString *str = isImg;
            YPProgressView *progressView=[YPProgressView showHMProgressView:self.view :200];

            

            [temImgV sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:DefaultIcon] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                YSNLog(@"%ld",receivedSize);
                YSNLog(@"%ld",expectedSize);
                CGFloat floatSize = receivedSize/expectedSize;
//                progressView.progress = floatSize;
                [progressView setProgress:floatSize];
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                [progressView removeFromSuperview];
                if (!error) {
                    [temImgV sizeToFit];
                    CGRect cellHeight = temImgV.frame;
                    
                    cellHeight.size.height = [self setImageHeightWithImage:image];
                    
                    CGFloat imgTop = kSCREEN_HEIGHT/2-cellHeight.size.height/2;
                    temImgV.frame = CGRectMake(i*(KScreen_Size.width),imgTop,KScreen_Size.width, cellHeight.size.height);
                    
                    temImgV.userInteractionEnabled = YES;
                    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissTap:)];
                    [temImgV addGestureRecognizer:ges];
                    [_scrollView addSubview:temImgV];
                }
                else{
                    
//                    _imageView.image = [UIImage imageNamed:DefaultIcon];
//
//
//                    [_imageView sizeToFit];
//                    CGRect cellHeight = _imageView.frame;
//
//                    cellHeight.size.height = [self setImageHeightWithImage:image];
//
//                    CGFloat imgTop = kSCREEN_HEIGHT/2-cellHeight.size.height/2;
//                    _imageView.frame = CGRectMake(i*(KScreen_Size.width),imgTop,KScreen_Size.width, cellHeight.size.height);
//                    //                _imageView.frame = cellHeight;
//                    //
//                    //                CGPoint point = _imageView.center;
//                    //
//                    //                //        point.y = (KScreen_Size.height-64)/2.0;
//                    //                point.y = (KScreen_Size.height)/2.0;
//                    //
//                    //                _imageView.center = point;
//                    _imageView.userInteractionEnabled = YES;
//                    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissTap:)];
//                    [_imageView addGestureRecognizer:ges];
//                    [_scrollView addSubview:_imageView];
                }
                
            }];
//            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:str] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                CGFloat prov = receivedSize/expectedSize;
//                [progressView setProgress:prov];
//                
//            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                [progressView removeFromSuperview];
//                _imageView.image = image;
//                
//                [_imageView sizeToFit];
//                
//                CGRect cellHeight = _imageView.frame;
//                
//                cellHeight.size.height = [self setImageHeightWithImage:_imageView.image];
//                
//                _imageView.frame = cellHeight;
//                
//                CGPoint point = _imageView.center;
//                
//                point.y = (KScreen_Size.height-64)/2.0;
//                
//                _imageView.center = point;
//                
//                [_scrollView addSubview:_imageView];
//            }];
        }
//        [_imageView sizeToFit];
        
        
    }
}

- (CGFloat)setImageHeightWithImage:(UIImage *)img
{
    CGFloat height = img.size.height;
    CGFloat width = img.size.width;
    return height*KScreen_Size.width/width;
}

#pragma mark - 结束滚动代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
 
    _titleLab.text = [NSString stringWithFormat:@"%d/%d",(int)(scrollView.contentOffset.x / KScreen_Size.width)+1,(int)_images.count];
}


- (void)dismissTap:(UITapGestureRecognizer *)ges{
  
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
@implementation UIImage (MyBundle)

+ (UIImage *)imageNamedFromMyBundle:(NSString *)name {
    UIImage *image = [UIImage imageNamed:[@"TZImagePickerController.bundle" stringByAppendingPathComponent:name]];
    if (image) {
        return image;
    } else {
        image = [UIImage imageNamed:[@"Frameworks/TZImagePickerController.framework/TZImagePickerController.bundle" stringByAppendingPathComponent:name]];
        return image;
    }
}

@end


