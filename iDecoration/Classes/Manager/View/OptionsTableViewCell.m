//
//  OptionsTableViewCell.m
//  iDecoration
//
//  Created by RealSeven on 17/3/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "OptionsTableViewCell.h"
#import "OptionsCollectionViewCell.h"

@implementation OptionsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.contentView addSubview:self.optionCollectionView];
}

-(UICollectionView*)optionCollectionView{
    
    if (!_optionCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
//        layout.itemSize = CGSizeMake((kSCREEN_WIDTH-74)/4, 30);
        if(self.fromTag == 1){
            layout.itemSize = CGSizeMake((kSCREEN_WIDTH)/5.0, 95);
        } else {
            layout.itemSize = CGSizeMake((kSCREEN_WIDTH)/4.0, 95);
        }
        
//        layout.sectionInset = UIEdgeInsetsMake(7, 10, 7, 10);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _optionCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 95) collectionViewLayout:layout];
        _optionCollectionView.delegate = self;
        _optionCollectionView.dataSource = self;
        _optionCollectionView.backgroundColor = White_Color;
        _optionCollectionView.scrollEnabled = NO;
        
        [_optionCollectionView registerNib:[UINib nibWithNibName:@"OptionsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"OptionsCollectionViewCell"];
    }
    return _optionCollectionView;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.fromTag == 1 ? 5 : 4;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return self.fromTag == 1 ?  CGSizeMake((kSCREEN_WIDTH)/5, 95): CGSizeMake((kSCREEN_WIDTH)/4, 95);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
        {
            if (self.designBlock) {
                self.designBlock();
                
            }
        }
            break;
            
        case 1:
        {
            if (self.memberBlock) {
                self.memberBlock();
            }
        }
            break;
            
        case 2:
        {
            if (self.holderBlock) {
                self.holderBlock();
            }
        }
            break;
            
        case 3:
        {
            if (self.supervisorBlock) {
                self.supervisorBlock();
            }
        }
            break;
        case 4:
        {
            if (self.fiveBlock) {
                self.fiveBlock();
            }
        }
        break;
        default:
            break;
    }
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    OptionsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OptionsCollectionViewCell" forIndexPath:indexPath];
    cell.titleLabel.hidden = YES;
    cell.optionBtn.userInteractionEnabled = NO;

    
    NSArray *conTitleArr = @[@"本案设计",@"参与人员",@"监理日志",@"业主日志",@"实景监控"];
    NSArray *conImageNameArr = @[@"icon_sheji_hi",@"icon_renyuan_hi",@"icon_jianli_hi",@"icon_yezhu_hi",@"icon_jiankong_hi"];
    NSArray *materialTitleArr = @[@"本案视频",@"参与人员",@"店长手记",@"全景VR"];
    NSArray *materialImageNameArr = @[@"icon_shiping_hi",@"icon_renyuan_hi",@"icon_shouji_hi",@"icon_vr_hi"];
    if (self.fromTag == 1) {
        [cell.optionBtn setTitle:conTitleArr[indexPath.row] forState:(UIControlStateNormal)];
        [cell.optionBtn setImage:[UIImage imageNamed:conImageNameArr[indexPath.row]] forState:(UIControlStateNormal)];
    }
    else{
        [cell.optionBtn setTitle:materialTitleArr[indexPath.row] forState:(UIControlStateNormal)];
        [cell.optionBtn setImage:[UIImage imageNamed:materialImageNameArr[indexPath.row]] forState:(UIControlStateNormal)];
    }
    [self setButtonImageTopAngTitleBottom:cell.optionBtn];

    
    return cell;
    
}

    // 设置按钮 图上字下
- (void)setButtonImageTopAngTitleBottom:(UIButton *)btn {
    CGFloat imageWith = btn.imageView.frame.size.width;
    CGFloat imageHeight = btn.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    labelWidth = btn.titleLabel.intrinsicContentSize.width;
    labelHeight = btn.titleLabel.intrinsicContentSize.height;
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-10/2.0, 0, 0, -labelWidth);
    labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-10/2.0, 0);
    btn.titleEdgeInsets = labelEdgeInsets;
    btn.imageEdgeInsets = imageEdgeInsets;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
