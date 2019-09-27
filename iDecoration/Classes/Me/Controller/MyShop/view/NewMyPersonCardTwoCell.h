//
//  NewMyPersonCardTwoCell.h
//  iDecoration
//
//  Created by sty on 2018/1/19.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewMyPersonCardTwoCell;

@protocol NewMyPersonCardTwoCellDelegate <NSObject>

@optional
-(void)careSomeThing:(NewMyPersonCardTwoCell *)cell;
-(void)flowerSomeThing:(NewMyPersonCardTwoCell *)cell ;
-(void)flagSomeThing:(NewMyPersonCardTwoCell *)cell;

-(void)callPhone;
-(void)goCompanyYellowVc;

-(void)goCompanyAddress;
-(void)goPersonAddress;
@end

@interface NewMyPersonCardTwoCell : UITableViewCell
typedef void(^NewMyPersonCardTwoCellBlock)(void);
@property (weak, nonatomic) IBOutlet UILabel *labelJobNameRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonMessageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonMessageWidth;
@property (copy, nonatomic) NewMyPersonCardTwoCellBlock blockDidTouchButtonMessage;
@property (weak, nonatomic) IBOutlet UILabel *labelJobName;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *trueNameL;
@property (weak, nonatomic) IBOutlet UIButton *buttonSendMessage;
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoImgV;
@property (weak, nonatomic) IBOutlet UILabel *telPhoneLineL;
@property (weak, nonatomic) IBOutlet UILabel *companyNameL;
@property (weak, nonatomic) IBOutlet UILabel *jobNameL;
@property (weak, nonatomic) IBOutlet UIImageView *weXinQrImgV;
@property (weak, nonatomic) IBOutlet UILabel *winXinL;
@property (weak, nonatomic) IBOutlet UILabel *emilL;
@property (weak, nonatomic) IBOutlet UILabel *addressL;//公司地址
@property (weak, nonatomic) IBOutlet UILabel *personAddressL;//个人地址

@property (weak, nonatomic) IBOutlet UILabel *lookPlaceHolderL;

@property (weak, nonatomic) IBOutlet UIView *careV;
@property (weak, nonatomic) IBOutlet UIView *flowerV;
@property (weak, nonatomic) IBOutlet UIView *flagV;


@property (weak, nonatomic) IBOutlet UILabel *adageL;

@property (weak, nonatomic) IBOutlet UIButton *companyAddressBtn;
@property (weak, nonatomic) IBOutlet UIButton *personAddressBtn;

- (IBAction)comAddressClick:(UIButton *)sender;

- (IBAction)perAddressClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *flowerNumberLabel; // 鲜花：0
@property (weak, nonatomic) IBOutlet UILabel *bannerNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeNumberLabel;

@property (nonatomic, weak) id<NewMyPersonCardTwoCellDelegate>delegate;
-(void)configData:(id)data;
@end
