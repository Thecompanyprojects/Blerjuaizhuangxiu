//
//  OrdersDropdownSelection.m
//  CooperChimney
//
//  Created by Karthik Baskaran on 29/09/16.
//  Copyright © 2016 Karthik Baskaran. All rights reserved.
//

#import "SSPopup.h"

@interface SSPopup ()
{
    AppDelegate *appDelegate;
    
    NSArray *ordersarray;
    
    UIButton *ParentBtn;
}
@end
@implementation SSPopup

- (id)initWithFrame:(CGRect)frame delegate:(id<SSPopupDelegate>)delegate
{
    self = [super init];
    if ((self = [super initWithFrame:frame]))
    {
        self.SSPopupDelegate = delegate;
    }
    
    return self;
}


-(void)CreateTableview:(NSArray *)Contentarray withSender:(id)sender  withTitle:(NSString *)title setCompletionBlock:(VSActionBlock )aCompletionBlock{
    
    
    [self addTarget:self action:@selector(CloseAnimation) forControlEvents:UIControlEventTouchUpInside];
    
    self.alpha=0;
    self.backgroundColor=[UIColor colorWithWhite:0.00 alpha:0.5];
    self.completionBlock = aCompletionBlock;
    ParentBtn=(UIButton *)sender;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    Title=title;

    
   DropdownTable=[[UITableView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-(self.frame.size.width/1.2)/2,self.frame.size.height/2-(self.frame.size.height/3)/2,self.frame.size.width/1.2,self.frame.size.height/3)];
    DropdownTable.backgroundColor=[UIColor whiteColor];
    DropdownTable.dataSource=self;
    DropdownTable.showsVerticalScrollIndicator=NO;
    DropdownTable.delegate=self;
    DropdownTable.layer.cornerRadius=5.0f;
    DropdownTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self addSubview:DropdownTable];

    
    ordersarray=[[NSArray alloc]initWithArray:Contentarray];
    
    
    NormalAnimation(self.superview, 0.30f,UIViewAnimationOptionTransitionNone,
                    
                    self.alpha=1;
               
)completion:nil];
    
}

-(void)CreateTableview:(NSArray *)Contentarray withTitle:(NSString *)title setCompletionBlock:(VSActionBlock )aCompletionBlock{
    
    
    [self addTarget:self action:@selector(CloseAnimation) forControlEvents:UIControlEventTouchUpInside];
    
    self.alpha=0;
    self.backgroundColor=[UIColor colorWithWhite:0.00 alpha:0.5];
    self.completionBlock = aCompletionBlock;
//    ParentBtn=(UIButton *)sender;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    Title=title;
    
    CGFloat tableH = 50*Contentarray.count;
    if (tableH>self.frame.size.height/3) {
        tableH = self.frame.size.height/3;
    }
    if (title.length>0) {
        tableH = tableH+50;
    }
    
    DropdownTable=[[UITableView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-(self.frame.size.width/1.2)/2,self.frame.size.height/2-(self.frame.size.height/3)/2,self.frame.size.width/1.2,tableH)];
    DropdownTable.backgroundColor=[UIColor whiteColor];
    DropdownTable.dataSource=self;
    DropdownTable.showsVerticalScrollIndicator=NO;
    DropdownTable.delegate=self;
    DropdownTable.layer.cornerRadius=5.0f;
    DropdownTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self addSubview:DropdownTable];
    
    
    ordersarray=[[NSArray alloc]initWithArray:Contentarray];
    
    
    NormalAnimation(self.superview, 0.30f,UIViewAnimationOptionTransitionNone,
                    
                    self.alpha=1;
                    
                    )completion:nil];
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (Title&&Title.length>0) {
        return 50;
    }
    else{
        return 0.1;
    }
    
}



- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *myview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,50)];
//[myview setBackgroundColor:RGB(227, 9, 50)];
    [myview setBackgroundColor:White_Color];
    
    
    UILabel *headLbl=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, myview.frame.size.width-40, 50)];
    headLbl.backgroundColor=[UIColor clearColor];
    headLbl.textColor=[UIColor blackColor];
    headLbl.text=Title?Title:@"Select";
    headLbl.textAlignment=NSTextAlignmentLeft;
    headLbl.font=AvenirMedium(18);
    [myview addSubview:headLbl];
    
    
    return myview;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
//    return tableView.frame.size.height/4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [ordersarray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.backgroundColor=[UIColor whiteColor];
    
    
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    for (UILabel *lbl in cell.contentView.subviews)
    {
        if ([lbl isKindOfClass:[UILabel class]])
        {
            [lbl removeFromSuperview];
        }
    }
    
    
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    UILabel *Contentlbl =[[UILabel alloc]initWithFrame:CGRectMake(10,0,tableView.frame.size.width-20,50)];
    Contentlbl.backgroundColor=[UIColor clearColor];
    Contentlbl.text=[ordersarray objectAtIndex:indexPath.row];
    Contentlbl.textColor=[UIColor blackColor];
    Contentlbl.textAlignment=NSTextAlignmentCenter;
    Contentlbl.font=AvenirMedium(16);
    [cell.contentView addSubview:Contentlbl];

    
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(0, Contentlbl.frame.origin.y+Contentlbl.frame.size.height-2,self.frame.size.width, 1.2)];
    lineView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [Contentlbl addSubview:lineView];
    
    if(indexPath.row == [ordersarray count] -1){
        
        lineView.hidden=YES;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
//    cell.contentView.backgroundColor=RGB(248, 218, 218);
    

    [ParentBtn setTitle:[ordersarray objectAtIndex:indexPath.row] forState:UIControlStateNormal]; //Setting title for Button


    if (self.completionBlock) {
        
         self.completionBlock((int)indexPath.row);
    }
    if (self.blockDidTouchCell) {
        self.blockDidTouchCell(indexPath.row);
    }
    
    if ([self.SSPopupDelegate respondsToSelector:@selector(GetSelectedOutlet:)]) {
        
         [self.SSPopupDelegate GetSelectedOutlet:(int)indexPath.row];
    }
    
    
    [self CloseAnimation];
    

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f",DropdownTable.contentOffset.y);
    if (DropdownTable.contentOffset.y <= 100) {
        DropdownTable.bounces = NO;
    }
    else
    {
        DropdownTable.bounces = YES;
    }
}

-(void)CloseAnimation{
    
    NormalAnimation(self.superview, 0.30f,UIViewAnimationOptionTransitionNone,
                    
                    DropdownTable.alpha=0;
                    
                    
                    
                    )
completion:^(BOOL finished){
    
    [DropdownTable removeFromSuperview];
    [self removeFromSuperview];
    
    
}];
    
    if ([self.SSPopupDelegate respondsToSelector:@selector(disMissDoSomething)]) {
        [self.SSPopupDelegate disMissDoSomething];
    }
}

@end
