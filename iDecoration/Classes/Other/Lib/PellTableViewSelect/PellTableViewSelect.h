// 下拉框

#import <UIKit/UIKit.h>

typedef void(^PellTableViewSelectBlock)(NSInteger index);
@interface PellTableViewSelect : UIView
@property (nonatomic,copy) PellTableViewSelectBlock blockDidTouchCell;
@property (nonatomic,copy) PellTableViewSelectBlock blockDidTouchBG;
@property (nonatomic,copy) PellTableViewSelectBlock action;
@property (assign, nonatomic) BOOL isHome;

+ (instancetype)sharedInstance;
/**
 *  创建一个弹出下拉控件
 *
 *  @param frame      尺寸
 *  @param selectData 选择控件的数据源
 *  @param action     点击回调方法
 *  @param animate    是否动画弹出
 */
+ (void)addPellTableViewSelectWithWindowFrame:(CGRect)frame
                                   selectData:(NSArray *)selectData
                                       images:(NSArray *)images
                                       action:(void(^)(NSInteger index))action animated:(BOOL)animate;
/**
 *  手动隐藏
 */
+ (void)hiden;

- (void)addViewWithFrame:(CGRect)frame
              selectData:(NSArray *)selectData
                  images:(NSArray *)images
             selectIndex:(NSInteger)index
                  action:(void(^)(NSInteger index))action animated:(BOOL)animate;
@end
