//
//  ConstructionImageTableViewCell.m
//  iDecoration
//
//  Created by RealSeven on 2017/4/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ConstructionImageTableViewCell.h"
#import "ConsImageCollectionViewCell.h"
#import <Photos/PHImageManager.h>
#import "CaseDesignModel.h"

@implementation ConstructionImageTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path
{
    static NSString *TextFieldCellID = @"ConstructionImageTableViewCell";
    ConstructionImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFieldCellID];
    if (cell == nil) {
        cell =[[ConstructionImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextFieldCellID];
    }
//    cell.path = path;
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubview:self.photosView];
        [self addSubview:self.addLabel];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    return self;
}

-(void)configWith:(id)data isHavePower:(BOOL)isPower isEdit:(BOOL)isEdit{
    if ([data isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray *tempArray = [NSMutableArray array];
        NSMutableArray *array = data;
        NSInteger count = array.count;
        if (count<=0) {
            
            if (!isPower) {
                _photosView.hidden = YES;
                _photosView.collectionView.height = 0;
                self.cellH = 10;
            }
            else{
                if (!isEdit) {
                    _photosView.hidden = YES;
                    _photosView.collectionView.height = 0;
                    self.cellH = 10;
                }
                else{
                    _photosView.hidden = NO;
                    _addLabel.hidden = NO;
                    
                    [tempArray addObject:[UIImage imageNamed:@"jia1"]];
                    [_photosView setYPPhotosView:tempArray];
                    _photosView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH/3);
                    _photosView.collectionView.height = _photosView.height;
                    _addLabel.frame =CGRectMake(15, self.photosView.bottom+5, kSCREEN_WIDTH-15, 20);
                    
                    self.cellH = _addLabel.bottom+10;
                }
            }
            
            

            
           
        }
        else{
            _photosView.hidden = NO;
            _addLabel.hidden = NO;
            for (CaseDesignModel *model in array) {
                
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                
                NSString *key = [manager cacheKeyForURL:[NSURL URLWithString:model.cdPicture]];
                SDImageCache *cache = [SDImageCache sharedImageCache];
                UIImage *cachedImage = [cache imageFromDiskCacheForKey:key];
                
                if (cachedImage) {
                    [tempArray addObject:cachedImage];
                }
                
                else{
                    
                    NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:model.cdPicture]];
                    UIImage *image = [[UIImage alloc]initWithData:data];
                    if (!image) {
                        image = [UIImage imageNamed:DefaultIcon];
                    }
                    
                    [tempArray addObject:image];
                    
                    [[SDImageCache sharedImageCache] storeImage:image forKey:key];
                    //                    [SDImageCache sharedImageCache] remove
                }
            }
            NSInteger row = 0;
            if (_photosView.isShowZongAddBtn) {
                //show
                [tempArray addObject:[UIImage imageNamed:@"jia1"]];
                
            }
            
            
            [_photosView setYPPhotosView:tempArray];
            
            if (tempArray.count<=3) {
                row=1;
            }
            else{
                NSInteger yu = tempArray.count%3;
                if (yu==0) {
                    row = tempArray.count/3;
                }
                else{
                    row = tempArray.count/3+1;
                }
            }
//            row = (tempArray.count-1)/3+1;
            
            _photosView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH/3*row);
            _photosView.collectionView.height = kSCREEN_WIDTH/3*row;
            _addLabel.frame =CGRectMake(15, self.photosView.bottom+5, kSCREEN_WIDTH-15, 20);
            self.cellH = _addLabel.bottom+10;
        }
        
        
    }
}

//-(void)delete

-(YPPhotosView *)photosView{
    if (!_photosView) {
        _photosView = [[YPPhotosView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH/3)];
    }
//    _photosView.collectionView.height = kSCREEN_WIDTH/3;
    __weak ConstructionImageTableViewCell *weakSelf=self;
    _photosView.clickcloseImage = ^(NSInteger index){
        if ([weakSelf.delegate respondsToSelector:@selector(deletePhotoWith:)]) {
            [weakSelf.delegate deletePhotoWith:index];
        }
    };
    
    _photosView.clicklookImage = ^(NSInteger index , NSArray *imageArr){
        
        
        if ([weakSelf.delegate respondsToSelector:@selector(lookPhoto:imgArray:)]) {
            [weakSelf.delegate lookPhoto:index imgArray:imageArr];
        }
        
    };
    
    _photosView.clickChooseView = ^{
        // 调用相册
        
        
        if ([weakSelf.delegate respondsToSelector:@selector(addPhoto)]) {
            [weakSelf.delegate addPhoto];
        }
        
        
        
        
    };
    
    return _photosView;
}

-(UILabel*)addLabel{
    
    if (!_addLabel) {
        _addLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.photosView.bottom+5, kSCREEN_WIDTH-15, 20)];
        _addLabel.text = @"请添加所有施工图...";
        _addLabel.font = [UIFont systemFontOfSize:13.0f];
        _addLabel.textColor = [UIColor grayColor];
    }
    return _addLabel;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
