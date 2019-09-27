//
//  pushImageViewController.m
//  iDecoration
//
//  Created by john wall on 2018/10/8.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "pushImageViewController.h"

@interface pushImageViewController ()

@property(nonatomic,strong)UIImageView* imageViewGoodComment;
@end

@implementation pushImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self.navigationController pushViewController:VC animated:YES];
  //  self.navigationController.navigationBar.hidden =YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.imageViewGoodComment =[[UIImageView alloc]init];
    self.imageViewGoodComment.frame =CGRectMake(0, 64, BLEJWidth, BLEJHeight);
//    self.imageViewGoodComment.frame =self.view.frame;
    [self.imageViewGoodComment setImage:[UIImage imageNamed:@"GoodComment"]];
    self.imageViewGoodComment.userInteractionEnabled=YES;
   
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HiddenSelf)];
    [self.imageViewGoodComment addGestureRecognizer:tap];
    [self.view addSubview:self.imageViewGoodComment];
}
//-(void)HiddenSelf{
//
//   // self.navigationController.navigationBar.hidden =NO;
//    [self.imageViewGoodComment removeFromSuperview];
//    self.imageViewGoodComment =nil;
//
//
//
//}

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
