//
//  CustomCalloutViewController.h
//  MKMapPop
//
//  Created by zuxi li on 2017/9/15.
//  Copyright © 2017年 lizuxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCalloutViewController : UIViewController{
    UILabel *labTitle;
}

@property (weak, nonatomic) IBOutlet UILabel *companyNametitle;
@property (weak, nonatomic) IBOutlet UILabel *companyAddresstitle;

@property (weak, nonatomic) IBOutlet UIButton *navButton;

@end
