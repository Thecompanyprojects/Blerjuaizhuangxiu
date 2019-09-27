//
//  ExplainTableViewCell.m
//  iDecoration
//
//  Created by RealSeven on 2017/4/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ExplainTableViewCell.h"

@implementation ExplainTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = White_Color;
//        [self.contentView addSubview:self.addImageBtn];
        [self.contentView addSubview:self.explainImageView];
        [self.explainImageView addSubview:self.delImageBtn];
        
    }
    return self;
}

-(void)configWith:(NSString *)imgStr{
    if (imgStr.length>0) {
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        
        NSString *key = [manager cacheKeyForURL:[NSURL URLWithString:imgStr]];
        SDImageCache *cache = [SDImageCache sharedImageCache];
        UIImage *cachedImage = [cache imageFromDiskCacheForKey:key];
        
        if (cachedImage) {
            self.explainImageView.image = cachedImage;
            [self.explainImageView sizeToFit];
            
            CGFloat orgialW = self.explainImageView.width;
            CGFloat orgialH = self.explainImageView.height;
            CGFloat nowW = kSCREEN_WIDTH-20;
            CGFloat nowH = orgialH*nowW/orgialW;
            self.explainImageView.frame = CGRectMake(10, 10, kSCREEN_WIDTH-20, nowH);
            self.cellH = nowH+10;
        }
        
        else{
            
            NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imgStr]];
            UIImage *image = [[UIImage alloc]initWithData:data];
            if (!image) {
                image = [UIImage imageNamed:DefaultIcon];
            }
            self.explainImageView.image = image;
            [self.explainImageView sizeToFit];
            
            CGFloat orgialW = self.explainImageView.width;
            CGFloat orgialH = self.explainImageView.height;
            CGFloat nowW = kSCREEN_WIDTH-20;
            CGFloat nowH = orgialH*nowW/orgialW;
            self.explainImageView.frame = CGRectMake(10, 10, kSCREEN_WIDTH-20, nowH);
            self.cellH = nowH+10;
            
            [[SDImageCache sharedImageCache] storeImage:image forKey:key];
            //                    [SDImageCache sharedImageCache] remove
        }

        
        
    }
    else{
        self.explainImageView.image = [UIImage imageNamed:@"jia-kong.png"];
        self.cellH = 200;
    }
}

-(UIButton*)addImageBtn{
    
    if (!_addImageBtn) {
        _addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addImageBtn setFrame:CGRectMake(kSCREEN_WIDTH/2-40, 60, 80, 80)];
        [_addImageBtn setImage:[UIImage imageNamed:@"jia1"] forState:UIControlStateNormal];
//        [_addImageBtn addTarget:self action:@selector(addImg) forControlEvents:UIControlEventTouchUpInside];
        [_addImageBtn setBackgroundColor: White_Color];
    }
    return _addImageBtn;
}

-(UIImageView*)explainImageView{
    
    if (!_explainImageView) {
        _explainImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, kSCREEN_WIDTH-20, 190)];
        _explainImageView.userInteractionEnabled = YES;
//        _explainImageView.hidden = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImg)];
        [_explainImageView addGestureRecognizer:ges];
        _explainImageView.backgroundColor = White_Color;
        
    }
    return _explainImageView;
}

-(UIButton*)delImageBtn{
    
    if (!_delImageBtn) {
        _delImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delImageBtn setFrame:CGRectMake(self.explainImageView.frame.size.width-20, -10, 20, 20)];
        [_delImageBtn setImage:[UIImage imageNamed:@"colse"] forState:UIControlStateNormal];
        [_delImageBtn addTarget:self action:@selector(delImg:) forControlEvents:UIControlEventTouchUpInside];
        _delImageBtn.hidden = YES;
    }
    return _delImageBtn;
}

-(void)addImg{
 
    if (self.addBlock) {
        self.addBlock();
    }
}

-(void)delImg:(UIButton*)sender{
    
    if (self.delBlock) {
        self.delBlock();
    }
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
