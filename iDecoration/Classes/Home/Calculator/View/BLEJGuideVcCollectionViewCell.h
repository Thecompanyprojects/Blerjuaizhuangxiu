//
//  BLEJGuideVcCollectionViewCell.h
//  iDecoration
//
//  Created by john wall on 2018/9/10.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLEJGuideVcCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *IV;

-(void)MakeImagewithData:(NSString  *)picUrl;
@end
