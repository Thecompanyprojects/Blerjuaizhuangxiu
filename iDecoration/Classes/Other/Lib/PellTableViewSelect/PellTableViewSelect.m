

#import "PellTableViewSelect.h"

@interface  PellTableViewSelect()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) NSArray *selectData;

@property (nonatomic,copy) NSArray * imagesData;
@end



PellTableViewSelect * backgroundView;
UITableView * tableView;
static NSInteger _selectedIndex;
@implementation PellTableViewSelect


+ (instancetype)sharedInstance {
    static PellTableViewSelect *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [PellTableViewSelect new];
    });
    return instance;
}

- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

+ (void)addPellTableViewSelectWithWindowFrame:(CGRect)frame
                                   selectData:(NSArray *)selectData
                                       images:(NSArray *)images
                                       action:(void(^)(NSInteger index))action animated:(BOOL)animate
{
    if (backgroundView != nil) {
        [PellTableViewSelect hiden];
    }
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    backgroundView = [[PellTableViewSelect alloc] initWithFrame:win.bounds];
    backgroundView.action = action;
    backgroundView.imagesData = images ;
    backgroundView.selectData = selectData;
    backgroundView.backgroundColor = [UIColor colorWithHue:0
                                                saturation:0
                                                brightness:0 alpha:0.2];
    [win addSubview:backgroundView];
    

    tableView = [[UITableView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - frame.size.width + (frame.size.width/2.0), 64 - (40 * selectData.count/2.0), frame.size.width , 40 * selectData.count) style:0];
    
    tableView.dataSource = backgroundView;
    tableView.delegate = backgroundView;
    tableView.layer.cornerRadius = 6;
    // 锚点
    tableView.layer.anchorPoint = CGPointMake(1.0, 0);
    tableView.transform =CGAffineTransformMakeScale(0.0001, 0.0001);
    
    tableView.rowHeight = 40;
    [win addSubview:tableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundClick)];
    [backgroundView addGestureRecognizer:tap];
    backgroundView.action = action;
    backgroundView.selectData = selectData;



    if (animate == YES) {
        backgroundView.alpha = 0;

        [UIView animateWithDuration:0.3 animations:^{
            backgroundView.alpha = 0.5;
           tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
           
        }];
    }
}

- (void)addViewWithFrame:(CGRect)frame
              selectData:(NSArray *)selectData
                  images:(NSArray *)images
             selectIndex:(NSInteger)index
                  action:(void(^)(NSInteger index))action
                animated:(BOOL)animate
{
    if (self != nil) {
        [self hidden];
    }
    self.isHome = true;
    _selectedIndex = index;
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    backgroundView = [[PellTableViewSelect alloc] initWithFrame:win.bounds];
    backgroundView.action = action;
    backgroundView.imagesData = images ;
    backgroundView.selectData = selectData;
    backgroundView.backgroundColor = [UIColor colorWithHue:0
                                                saturation:0
                                                brightness:0 alpha:0.2];
    [win addSubview:backgroundView];


    tableView = [[UITableView alloc] initWithFrame:frame style:0];

    tableView.dataSource = backgroundView;
    tableView.delegate = backgroundView;

    tableView.rowHeight = 40;
    [win addSubview:tableView];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchBackgroundClick)];
    [backgroundView addGestureRecognizer:tap];
    backgroundView.action = action;
    backgroundView.selectData = selectData;


    [tableView reloadData];

    if (animate == YES) {
        backgroundView.alpha = 0;

        [UIView animateWithDuration:0.3 animations:^{
            backgroundView.alpha = 0.5;
            tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);

        }];
    }
}

+ (void)tapBackgroundClick
{
    [PellTableViewSelect hiden];
}
- (void)didTouchBackgroundClick
{
    [self hidden];
}
- (void)hidden
{
    if (backgroundView != nil) {
        if (self.blockDidTouchBG) {
            self.blockDidTouchBG(0);
        }
        [UIView animateWithDuration:0.3 animations:^{

            tableView.transform = CGAffineTransformMakeScale(0.000001, 0.0001);
        } completion:^(BOOL finished) {
            [backgroundView removeFromSuperview];
            [tableView removeFromSuperview];
            tableView = nil;
            backgroundView = nil;
        }];
    }
   
}

+ (void)hiden
{
    if (backgroundView != nil) {

        [UIView animateWithDuration:0.3 animations:^{

            tableView.transform = CGAffineTransformMakeScale(0.000001, 0.0001);
        } completion:^(BOOL finished) {
            [backgroundView removeFromSuperview];
            [tableView removeFromSuperview];
            tableView = nil;
            backgroundView = nil;
        }];
    }

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selectData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"PellTableViewSelectIdentifier";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:Identifier];
    }
    cell.imageView.image = [UIImage imageNamed:self.imagesData[indexPath.row]];
    cell.textLabel.text = _selectData[indexPath.row];
    [cell.textLabel setTextColor:Black_Color];
    cell.textLabel.textAlignment = self.isHome?NSTextAlignmentLeft:NSTextAlignmentCenter;
    if (_selectedIndex == 1 && indexPath.row == 1) {
        [cell.textLabel setTextColor:basicColor];
    }else if (_selectedIndex == 2 && indexPath.row == 0) {
        [cell.textLabel setTextColor:basicColor];
    }else if (_selectedIndex == 5 && indexPath.row == 2) {
        [cell.textLabel setTextColor:basicColor];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.action) {
        self.action(indexPath.row);
    }
    if (self.blockDidTouchCell) {
        self.blockDidTouchCell(indexPath.row);
    }
    [self hidden];
}

#pragma mark 绘制三角形
- (void)drawRect:(CGRect)rect

{
    
    
//    //    [colors[serie] setFill];
//    // 设置背景色
//    [[UIColor whiteColor] set];
//    //拿到当前视图准备好的画板
//    
//    CGContextRef  context = UIGraphicsGetCurrentContext();
//    
//    //利用path进行绘制三角形
//    
//    CGContextBeginPath(context);//标记
//    CGFloat location = [UIScreen mainScreen].bounds.size.width;
//    CGContextMoveToPoint(context,
//                         location -  20, 80);//设置起点
//    
//    CGContextAddLineToPoint(context,
//                             location - 40 ,  80);
//    
//    CGContextAddLineToPoint(context,
//                            location - 30, 64);
//    
//    CGContextClosePath(context);//路径结束标志，不写默认封闭
//    
//    [[UIColor whiteColor] setFill];  //设置填充色
//    
//    [[UIColor whiteColor] setStroke]; //设置边框颜色
//    
//    CGContextDrawPath(context,
//                      kCGPathFillStroke);//绘制路径path
    

}

@end
