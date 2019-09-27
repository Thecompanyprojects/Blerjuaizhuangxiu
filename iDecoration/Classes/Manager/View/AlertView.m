//
//  AlertView.m
//  UIalertView
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AlertView.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenBounds [UIScreen mainScreen].bounds
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

@interface AlertView()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isright;
}
@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UIView *backView;

@end

@implementation AlertView

+(id)GlodeBottomView{
    return [self new];
}

-(void)show{
    UIWindow *current = [UIApplication sharedApplication].keyWindow;
    self.backgroundColor = RGBA(0, 0, 0, 0.2);
    [current addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationCurve:(UIViewAnimationCurveEaseOut)];
        self.backView.frame = CGRectMake(50, 0, ScreenWidth-100, ScreenHeight);
    }];
}

#pragma mark - 懒加载
-(UIView*)backView{
    if (_backView == nil) {
        self.backView = [UIView new];
        _backView.bounds = CGRectMake(50, 0, ScreenWidth-100, ScreenHeight);
        [self addSubview:_backView];
    }
    return _backView;
}

-(UILabel*)titleLabel{
    if (_titleLabel == nil) {
        self.titleLabel = [UILabel new];
        _titleLabel.bounds = CGRectMake(50, 0, ScreenWidth - 100, ScreenHeight);
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = RGB(83, 83, 83);
        [_backView addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;

        self.backView.frame = CGRectMake(50, ScreenHeight *1/3, ScreenWidth-100, ScreenHeight);
        
        self.tableView.frame = CGRectMake(50, ScreenHeight *1/3-150, ScreenWidth-100, ScreenHeight *3/4);
        self.titleLabel.center = CGPointMake(ScreenWidth/2, ScreenHeight *1/3);
        


}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dissMIssView];
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    self.frame = ScreenBounds;
    [self setUpCellSeparatorInset];
}
- (void)setUpCellSeparatorInset
{
    
}

-(void)dissMIssView{
    [UIView animateWithDuration:0.3 animations:^{
         [UIView setAnimationCurve:(UIViewAnimationCurveEaseIn)];
         self.backView.frame = CGRectMake(50, ScreenHeight, ScreenWidth-100, ScreenHeight);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma UITableView-delegate

-(UITableView*)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(50, 0, ScreenWidth-100, ScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.backView addSubview:_tableView];
    }
    return _tableView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.textLabel.frame = CGRectMake(50, 0, ScreenWidth-100, ScreenHeight);
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 0, ScreenWidth-100, 50)];
    view.backgroundColor = [UIColor whiteColor];
    
    self.leftBtn = [[UIButton alloc] init];
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.leftBtn setTitle:@"公司常用语" forState:normal];
    self.leftBtn.frame = CGRectMake(10, 15, 80, 20);
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor hexStringToColor:@"bcb9bd"];
    line.frame = CGRectMake(self.leftBtn.right+4, 15, 1, 20);
    
    self.rightBtn = [[UIButton alloc] init];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.rightBtn setTitle:@"系统常用语" forState:normal];
    self.rightBtn.frame = CGRectMake(self.leftBtn.right+10, 15, 80, 20);
    
    if (isright) {
        [self.rightBtn setTitleColor:[UIColor blackColor] forState:normal];
        [self.leftBtn setTitleColor:[UIColor hexStringToColor:@"BCB9BD"] forState:normal];
    }
    else
    {
        [self.leftBtn setTitleColor:[UIColor blackColor] forState:normal];
        [self.rightBtn setTitleColor:[UIColor hexStringToColor:@"BCB9BD"] forState:normal];
    }
    
    [view addSubview:self.leftBtn];
    [view addSubview:self.rightBtn];
    [view addSubview:line];
    
    self.imgbtn = [[UIButton alloc] init];
    [self.imgbtn addTarget:self action:@selector(imgbtnclick) forControlEvents:UIControlEventTouchUpInside];
    [self.imgbtn setImage:[UIImage imageNamed:@"edit_muchUse"] forState:normal];
    self.imgbtn.frame = CGRectMake(ScreenWidth-100-40, 10, 30, 30);
    [view addSubview:self.imgbtn];
    
    if (self.isshow) {

         [self.imgbtn setHidden:NO];
    }
    else
    {

        [self.imgbtn setHidden:YES];
    }
    
    [self.leftBtn addTarget:self action:@selector(leftbtnclick) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn addTarget:self action:@selector(rightbtnclick) forControlEvents:UIControlEventTouchUpInside];
    
    
   
    
    return view;
}

-(void)BT:(UIButton*)bt{
    [self dissMIssView];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(clickButton:)]) {
        [self.delegate clickButton:indexPath.row];
    }if (self.GlodeBottomView) {
        self.GlodeBottomView(indexPath.row,self.titleArray[indexPath.row]);
    }
    [self dissMIssView];
}


-(void)leftbtnclick
{
    isright = NO;
    [self.leftBtn setTitleColor:[UIColor blackColor] forState:normal];
    [self.rightBtn setTitleColor:[UIColor hexStringToColor:@"BCB9BD"] forState:normal];
    [self.delegate leftclick];
}


-(void)rightbtnclick
{
    isright = YES;
    [self.rightBtn setTitleColor:[UIColor blackColor] forState:normal];
    [self.leftBtn setTitleColor:[UIColor hexStringToColor:@"BCB9BD"] forState:normal];
    [self.delegate rightclick];
}

-(void)imgbtnclick
{
    [self.delegate pushclick];
}

@end
