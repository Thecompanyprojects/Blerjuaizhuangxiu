//
//  textScrollView.m
//  Created by C CP on 16/9/27.
//  Copyright © 2016年 C CP. All rights reserved.
//

#import "LRSTextScrollView.h"

@interface LRSTextScrollView ()<UIScrollViewDelegate>
/**
 *  滚动视图
 */
@property (nonatomic,strong) UIScrollView *textScrollView;

/**
 *滚动方向
 */
@property(nonatomic,assign)scrollingDirection textScrollingDirection;

/**
 *  label的宽度
 */
@property (nonatomic,assign) CGFloat label_Width;
/**
 *  label的高度
 */
@property (nonatomic,assign) CGFloat label_Height;
/**
 *  定时器
 */
@property (nonatomic,strong) NSTimer *timer;

/**
 *  文字数组
 */
@property (nonatomic,strong) NSArray *titleArray;

/**
 *  拼接后的文字数组
 */
@property (nonatomic,strong) NSMutableArray *titleNewArray;

/**
 *  记录滚动的页码
 */
@property (nonatomic,assign) int currentPage;

@property (assign, nonatomic) NSInteger loopCountSave;


@end

@implementation LRSTextScrollView

- (UIScrollView *)textScrollView {
    
    if (_textScrollView == nil) {
        
        _textScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _textScrollView.showsHorizontalScrollIndicator = NO;
        _textScrollView.showsVerticalScrollIndicator = NO;
        _textScrollView.scrollEnabled = NO;
        _textScrollView.pagingEnabled = YES;
        [self addSubview:_textScrollView];
        
        [_textScrollView setContentOffset:CGPointMake(0 , self.label_Height) animated:YES];
    }
    
    return _textScrollView;
}



- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.label_Width = frame.size.width;
        
        self.label_Height = frame.size.height;
        
        self.textScrollView.delegate = self;
        self.textScrollingDirection = UIDefaultScrollDirection;
        
        [self addTimer];
        
    }
    
    return self;
}


// 创建对应的label
- (void)setTitleArray:(NSArray *)titleArray andScrollDirection:(scrollingDirection)directionType{
    self.textScrollingDirection = directionType;
    _titleArray = titleArray;
    if (titleArray == nil || titleArray.count == 0) {
        [self removeTimer];
        return;
    }
    if (titleArray.count == 1) {
        [self removeTimer];
    }
    id lastObj = [titleArray lastObject];
    NSMutableArray *objArray = [[NSMutableArray alloc] init];
    [objArray addObject:lastObj];
    [objArray addObjectsFromArray:titleArray];
    self.titleNewArray = objArray;
    CGFloat content_W = ((_textScrollingDirection == 0 || _textScrollingDirection == 1)?self.label_Width * objArray.count:0.0);
    CGFloat content_H = ((_textScrollingDirection == 2)?self.label_Height * objArray.count:0.0);
    self.textScrollView.contentSize = CGSizeMake(content_W, content_H);
    CGFloat label_Width = self.textScrollView.frame.size.width;
    self.label_Width = label_Width;
    CGFloat label_Height = self.textScrollView.frame.size.height;
    self.label_Height = label_Height;
    //防止重复赋值数据叠加
    for (id label in self.textScrollView.subviews) {
        [label removeFromSuperview];
    }
    for (int i = 0; i < objArray.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        titleLabel.userInteractionEnabled = YES;
        titleLabel.numberOfLines = 2;
//        titleLabel.minimumFontSize = 12.0f;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.tag = 100 + i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTheLabel:)];
        [titleLabel addGestureRecognizer:tap];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        CGFloat labelY = ((_textScrollingDirection == 2)?i * label_Height:0.0);
        CGFloat labelX = ((_textScrollingDirection == 0 || _textScrollingDirection == 1)?i * label_Width:0.0);
        titleLabel.frame = CGRectMake(labelX, labelY, label_Width, label_Height);
        titleLabel.text = objArray[i];
        [self.textScrollView addSubview:titleLabel];
    }
    NSLog(@"%@",self.textScrollView.subviews);
}

- (void)clickTheLabel:(UITapGestureRecognizer *)tap {
    
    if (self.clickLabelBlock) {
        
        NSInteger tag = tap.view.tag - 1;
        
        if (tag < 100) {
            
            tag = 100 + (self.titleArray.count - 1);
            
        }
        
        self.clickLabelBlock(tag,self.titleArray[tag - 100]);
        
    }
    
}

- (void)clickTitleLabel:(clickLabelBlock) clickLabelBlock {
    
    self.clickLabelBlock = clickLabelBlock;
    
}

- (void)setIsCanManualScroll:(BOOL)isCanScroll {
    
    if (isCanScroll) {
        
        self.textScrollView.scrollEnabled = YES;
        
    } else {
        
        self.textScrollView.scrollEnabled = NO;
        
    }
    
}

- (void)setTitleColor:(UIColor *)titleColor {
    
    _titleColor = titleColor;
    
    for (UILabel *label in self.textScrollView.subviews) {
        
        label.textColor = titleColor;
        
    }
}

- (void)setTitleFont:(CGFloat )titleFont {
    
    _titleFont = titleFont;
    
    for (UILabel *label in self.textScrollView.subviews) {
        
        label.font = [UIFont systemFontOfSize: titleFont];;
        
    }
    
}

- (void)setBGColor:(UIColor *)BGColor {
    
    _BGColor = BGColor;
    
    self.backgroundColor = BGColor;
    
}

- (void)reloadLoopCount {
    self.loopCountSave = 0;
}

- (void)nextLabel {
    if (self.loopCountSave == self.loopCount) {
        return;
    }
    self.loopCountSave ++;
    CGPoint oldPoint = self.textScrollView.contentOffset;
    
    oldPoint.y += ((_textScrollingDirection == 2)?self.textScrollView.frame.size.height:self.textScrollView.contentOffset.y);
    
    oldPoint.x += ((_textScrollingDirection == 0 || _textScrollingDirection == 1)?self.textScrollView.frame.size.width:self.textScrollView.contentOffset.x);
    
    [self.textScrollView setContentOffset:oldPoint animated:YES];
    NetworkOfHomeBroadcast *model = self.model.phoneList[self.loopCountSave];
    [self.imageView setImage:[UIImage imageNamed:self.model.arrayImageName[model.type]]];
}


//当图片滚动时调用scrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if(_textScrollingDirection == 0 || _textScrollingDirection == 1){
        
        if (self.textScrollView.contentOffset.x == self.textScrollView.frame.size.width * (self.titleArray.count )) {
            
            [self.textScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
    
    }else if(_textScrollingDirection == 2){
    
        if (self.textScrollView.contentOffset.y == self.textScrollView.frame.size.height * (self.titleArray.count)) {
            
            [self.textScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
    }
    
//    NSLog(@"滚动到的位置：%@",[NSValue valueWithCGPoint:self.textScrollView.contentOffset]);
}


// 开始拖拽的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //开启定时器
    [self addTimer];
}

- (void)addTimer{
    
    /*
     scheduledTimerWithTimeInterval:  滑动视图的时候timer会停止
     这个方法会默认把Timer以NSDefaultRunLoopMode添加到主Runloop上，而当你滑tableView的时候，就不是NSDefaultRunLoopMode了，这样，你的timer就会停了。
     
     self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextLabel) userInfo:nil repeats:YES];
     [_timer fire];//在重复执行的定时器中调用此方法后立即触发该定时器，但不会中断其之前的执行计划；在不重复执行的定时器中调用此方法，立即触发后，就会使这个定时器失效。
     */
    self.timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(nextLabel) userInfo:nil repeats:YES];//当定时器创建完（不用scheduled的，添加到runloop中后，该定时器将在初始化时指定的timeInterval秒后自动触发。
    //不用scheduled方式初始化的，需要手动addTimer:forMode: 将timer添加到一个runloop中。
    //而scheduled的初始化方法将以默认mode直接添加到当前的runloop中.
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc {
    
    [self.timer invalidate];
    self.timer = nil;
    
}

@end
