//
//  BLEJCalculatePackageDetailCell.m
//  iDecoration
//
//  Created by john wall on 2018/8/2.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "BLEJCalculatePackageDetailCell.h"
#import "CompanyDetailViewController.h"

@implementation BLEJCalculatePackageDetailCell{
    NSMutableArray *videoUrlArr;
    NSDictionary *dictVideo ;
}

- (void)awakeFromNib {
    [super awakeFromNib];
   
 //   self.userInteractionEnabled=YES;
}
-(void)setArticleDesignModel:(BLEJPackageArticleDesignModel *)ArticleDesignModel{
    _ArticleDesignModel= ArticleDesignModel;
 
    
      if (self.ArticleDesignModel.imgUrl.length>0 && self.ArticleDesignModel.videoUrl.length ==0) {
         [self.imageShow sd_setImageWithURL:[NSURL URLWithString:ArticleDesignModel.imgUrl]];
        
          self.Name.text=ArticleDesignModel.content;

            self.player.hidden=YES;
          self.plachoderVideoImgV.hidden =YES;
          self.textView.hidden=YES;
          self.imageShow.hidden=NO;
         
          
     
    }
    if (self.ArticleDesignModel.imgUrl.length >0&&self.ArticleDesignModel.videoUrl.length >0) {
      [self.plachoderVideoImgV sd_setImageWithURL:[NSURL URLWithString:ArticleDesignModel.imgUrl]];
        self.Name.text=ArticleDesignModel.content;
      //  self.player.url =[NSURL URLWithString:ArticleDesignModel.videoUrl];
        
       self.plachoderVideoImgV.hidden = NO;
        self.imageShow.hidden =YES;
        self.textView.hidden=YES;
        self.player.hidden=YES;
        
       
        
    }
    
    if (self.ArticleDesignModel.content.length >0 &&self.ArticleDesignModel.imgUrl.length==0 &&self.ArticleDesignModel.videoUrl.length ==0) {
  
        self.textView.text =ArticleDesignModel.content;
        self.Name.text=@"";
     //  self.Name.text =[ArticleDesignModel.content isEqualToString:@""]?[NSString stringWithFormat:@"%@",@"请添加说明"]:ArticleDesignModel.content;
        
        self.imageShow.hidden=YES;
        self.plachoderVideoImgV.hidden=YES;
        self.textView.hidden=NO;
        self.player.hidden=YES;
        
    }
   

}
-(CGFloat)cellHeight{

    _cellHeight =0;
    CompanyDetailViewController *company=[CompanyDetailViewController new];
    CGSize sizeImage;
    if (self.ArticleDesignModel.imgUrl.length>0 && self.ArticleDesignModel.videoUrl.length ==0) {
        
        CGSize textSize = [self.Name.text boundingRectWithSize:CGSizeMake(BLEJWidth-20 ,MAXFLOAT)options:(NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin)attributes:@{NSFontAttributeName:AdaptedFontSize(16)}context:nil].size;
        
        CGRect rectName = self.Name.frame;
        rectName.size.height = ceil(textSize.height);
        self.Name.frame = rectName ;
        sizeImage= [company calculateImageSizeWithSize:[company getImageSizeWithURL:  [NSURL URLWithString:self.ArticleDesignModel.imgUrl]] andType:0];
        

        CGRect rect = self.Name.frame;
        rect.size.height = ceil(sizeImage.height);
        rect.origin.y =rectName.size.height+10;
        self.imageShow.frame =rect;
        
        _cellHeight =sizeImage.height;
        _cellHeight =self.Name.frame.size.height+10+_cellHeight;
    }
    if (self.ArticleDesignModel.imgUrl.length >0&&self.ArticleDesignModel.videoUrl.length >0) {
       
        _cellHeight =self.plachoderVideoImgV.frame.size.height;
     
        CGSize textSize = [self.Name.text boundingRectWithSize:CGSizeMake(BLEJWidth-20 ,MAXFLOAT)options:(NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin)attributes:@{NSFontAttributeName:AdaptedFontSize(16)}context:nil].size;
        
        CGRect rectname = self.Name.frame;
        rectname.size.height = ceil(textSize.height);
        self.Name.frame = rectname ;
        
        CGRect rect = self.plachoderVideoImgV.frame;
        rect.origin.y =rectname.size.height+10;
        self.plachoderVideoImgV.frame =rect;
        self.player.frame=rect;
        
        _cellHeight = _cellHeight+  ceil(textSize.height);
    }
    
    if (self.ArticleDesignModel.content.length >0 &&self.ArticleDesignModel.imgUrl.length==0 &&self.ArticleDesignModel.videoUrl.length ==0) {
      
         _cellHeight =self.Name.frame.size.height+10;
        CGSize textSize = [self.textView.text boundingRectWithSize:CGSizeMake(BLEJWidth-20 ,MAXFLOAT)
                                                           options:(NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin)

                                                   attributes:@{NSFontAttributeName:AdaptedFontSize(16)}
                                                      context:nil].size;



    
       
        CGRect rect = self.textView.frame;
        rect.size.height = ceil(textSize.height)+5;
         self.textView.frame = rect ;
       
         _cellHeight = _cellHeight+   ceil(textSize.height);
  
    }
   
   
    return _cellHeight;
}

-(UIImageView *)imageShow{
    if (_imageShow==nil) {
        _imageShow =[[UIImageView alloc]initWithFrame:CGRectMake(10, self.Name.bottom, BLEJWidth-20, BLEJWidth *0.6)];
        self.imageShow.backgroundColor =[UIColor purpleColor];
        [self addSubview:_imageShow];
    }
    return _imageShow;
}
-(UIImageView *)plachoderVideoImgV{
     if (_plachoderVideoImgV==nil) {
         _plachoderVideoImgV=[[UIImageView alloc]init];
         _plachoderVideoImgV.frame = CGRectMake(10, self.Name.bottom, BLEJWidth-20, BLEJWidth *0.6);
        [self addSubview:_plachoderVideoImgV];
        _plachoderVideoImgV.contentMode = UIViewContentModeScaleAspectFill;
         _plachoderVideoImgV.layer.masksToBounds=YES;
         UIImageView *imageButtonVideo =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"video_play"]];
         imageButtonVideo.frame =CGRectMake(self.plachoderVideoImgV.frame.size.width/2-30, self.plachoderVideoImgV.frame.size.height/2-30, 60, 60);
         imageButtonVideo.userInteractionEnabled =YES;
         [self.plachoderVideoImgV addSubview:imageButtonVideo];
         self.plachoderVideoImgV.backgroundColor=RGBA(108, 108, 108, 0.4);

         
         UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didselectVideoButtonClickAtIndexPath:)];
         [imageButtonVideo addGestureRecognizer:ges];

         _plachoderVideoImgV.layer.masksToBounds = YES;
         _plachoderVideoImgV.userInteractionEnabled=YES;
      
       
     }
    return _plachoderVideoImgV;
}
-(UITextView *)textView{
    
    if (!_textView) {
        _textView =[[UITextView alloc]initWithFrame: CGRectMake(10, self.Name.bottom, BLEJWidth-20, 200)];
   
        _textView.editable =NO;
        _textView.scrollEnabled = YES;
      
        self.textView.backgroundColor=[UIColor lightGrayColor];
      
          [self addSubview:_textView];


    }
    return _textView;
}

-(UILabel *)Name{
    
    if (_Name==nil) {
        _Name =[[UILabel alloc]initWithFrame: CGRectMake(10, 8, BLEJWidth-20, 30)];
        _Name.numberOfLines=0;
      
        [self addSubview:_Name];
    }
    return _Name;
}

-(CLPlayerView *)player{
    if (_player==nil) {
        
    
    CLPlayerView *playerView = [[CLPlayerView alloc] init];
     [self addSubview:playerView];
    self.player =playerView;
    playerView.frame =CGRectMake(0, self.Name.bottom+10, BLEJWidth, BLEJWidth *0.6);
    playerView.repeatPlay = NO;
    playerView.isLandscape = NO;
    playerView.videoFillMode = VideoFillModeResizeAspect;
    playerView.topToolBarHiddenType=TopToolBarHiddenSmall;
    playerView.strokeColor = [UIColor lightGrayColor];
    playerView.toolBarDisappearTime = 3;
        [playerView backButton:^(UIButton *button) {
            
            [playerView pausePlay];
            playerView.hidden = YES;
            
//            [playerView destroyPlayer];
            [playerView removeFromSuperview];
//            self.plachoderVideoImgV.hidden=NO;
        }];
        [playerView endPlay:^{
            [playerView pausePlay];
          //  playerView.hidden = YES;
            
           // [playerView destroyPlayer];
            self.plachoderVideoImgV.hidden=NO;
//            [playerView removeFromSuperview];
        }];
  
//    [playerView playVideo];
//    packageCell.plachoderVideoImgV.hidden=YES;
 
   
    }
    return _player;
}
-(void)didselectVideoButtonClickAtIndexPath:(NSIndexPath *)path{

    if ([self.PackageCellDelegate respondsToSelector:@selector(didselectVideoButtonClickAtIndexPath:)]) {
        [self.PackageCellDelegate didselectVideoButtonClickAtIndexPath:self.pathVideoSelected];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//
//        return YES;
//
//    }
//
//
//    return YES;
//}
@end
