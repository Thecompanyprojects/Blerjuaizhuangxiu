//
//  BLEJGuideCollectionLayout.m
//  iDecoration
//
//  Created by john wall on 2018/9/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "BLEJGuideCollectionLayout.h"

@implementation BLEJGuideCollectionLayout

-(CGFloat)cellWidth{

    return  self.collectionView.bounds.size.width *0.7f;
}
//+(void)load{
//
//}
//+(void)initialize{
//
//}
//+(instancetype)allocWithZone:(struct _NSZone *)zone{
//NSException *exception =  [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
//NSAssert1(!exception, nil, @"出现了意外");
//[exception raise];
//    return self;
//}
//卡片间隔
- (CGFloat)cellMargin {
  //  return (self.collectionView.bounds.size.width - [self cellWidth])/10;
    return 0;
}

-(CGFloat)collectionInset{
    return  self.collectionView.bounds.size.width/2 -[self cellWidth]/2;
}
-(CGFloat)minimumLineSpacing{
    return  [self cellMargin];
}
-(CGFloat)minimumInteritemSpacing{
     return  [self cellMargin];
}
-(CGSize)itemSize{
    return CGSizeMake(self.collectionView.bounds.size.width *0.7f, self.collectionView.bounds.size.height );
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
-(void)prepareLayout{
    [super prepareLayout];
    
    self.scrollDirection=UICollectionViewScrollDirectionHorizontal;
   self.sectionInset =UIEdgeInsetsMake(0, [self collectionInset], 0, [self collectionInset]);
                                       
}

-(NSArray *)getcopyOfAttributes:(NSArray *)attributes{
    NSMutableArray *copy =[NSMutableArray arrayWithCapacity:2];
    for (UICollectionViewLayoutAttributes* attribute in attributes) {
        [copy addObject:attribute];
    }
    return copy;
}
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    CGRect bigRect =rect;
    bigRect.size.width =rect.size.width+2*[self cellWidth];
    bigRect.origin.x =rect.origin.x - [self cellWidth];
    
    
    
    NSArray *arr =[self getcopyOfAttributes:[super layoutAttributesForElementsInRect:bigRect]];
    
    CGFloat centerX =self.collectionView.contentOffset.x +self.collectionView.bounds.size.width/2;
    
    for (UICollectionViewLayoutAttributes *attribute in arr) {
        CGFloat distance= fabs(attribute.center.x - centerX);
        CGFloat apartScale =distance/self.collectionView.bounds.size.width;
        CGFloat scale =fabs(cos(apartScale *M_PI_4));
        attribute.transform =CGAffineTransformMakeScale(scale, scale);
    }
    return  arr;
}















@end
