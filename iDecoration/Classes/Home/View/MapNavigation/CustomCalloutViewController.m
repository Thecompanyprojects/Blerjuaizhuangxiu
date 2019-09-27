//
//  CustomCalloutViewController.m
//  MKMapPop
//
//  Created by zuxi li on 2017/9/15.
//  Copyright © 2017年 lizuxi. All rights reserved.
//

#import "CustomCalloutViewController.h"

@implementation CustomCalloutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)navButtonAction:(id)sender {    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kSelectOtherMapFormNavigation" object:nil];
}





@end
