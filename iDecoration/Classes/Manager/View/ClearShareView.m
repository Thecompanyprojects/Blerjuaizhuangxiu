//
//  ClearShareView.m
//  iDecoration
//
//  Created by RealSeven on 17/3/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ClearShareView.h"
#import "ClearShareTableViewCell.h"

@implementation ClearShareView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.codeView];
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.shareView];
        [self.shareView addSubview:self.shareTableView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView:)];
        tap.delegate = self;
        tap.numberOfTapsRequired = 1;
        [self.bottomView addGestureRecognizer:tap];
    }
    return self;
}

-(UIView*)shareView{
    
    if (!_shareView) {
        _shareView = [[UIView alloc]initWithFrame:CGRectMake((kSCREEN_WIDTH/3)*2, 0, kSCREEN_WIDTH/3, 150)];
        _shareView.backgroundColor = [UIColor whiteColor];
    }
    return _shareView;
}

-(UIView*)bottomView{
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _bottomView.backgroundColor = [UIColor clearColor];
    }
    return _bottomView;
}

-(QRCodeView*)codeView{
    
    __weak ClearShareView *weakSelf = self;
    
    if (!_codeView) {
        _codeView = [[QRCodeView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _codeView.backgroundColor = White_Color;
        _codeView.hidden = YES;
        _codeView.hideBlock = ^{
            
            weakSelf.codeView.hidden = YES;
        };
    }
    return _codeView;
}

-(UITableView*)shareTableView{
    
    if (!_shareTableView) {
        _shareTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH/3, 150) style:UITableViewStylePlain];
        _shareTableView.delegate = self;
        _shareTableView.dataSource = self;
        _shareTableView.backgroundColor = [UIColor whiteColor];
        _shareTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _shareTableView.showsVerticalScrollIndicator = NO;
        _shareTableView.showsHorizontalScrollIndicator = NO;
        _shareTableView.scrollEnabled = NO;
        
        [_shareTableView registerNib:[UINib nibWithNibName:@"ClearShareTableViewCell" bundle:nil] forCellReuseIdentifier:@"ClearShareTableViewCell"];
    }
    return _shareTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *titleArr = [NSArray arrayWithObjects:@"微信好友",@"微信朋友圈",@"QQ",@"QQ空间",@"查看二维码", nil];
    NSArray *imgArr = [NSArray arrayWithObjects:@"xweixin",@"xpengyouquan",@"xqq",@"xkongjian",@"erweima", nil];

    ClearShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClearShareTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = titleArr[indexPath.row];
    cell.titleLabel.adjustsFontSizeToFitWidth = YES;
    cell.logoImageView.image = [UIImage imageNamed:imgArr[indexPath.row]];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
        {
            [self shareToWXSession];
        }
            break;
            
        case 1:
        {
            [self shareToTimeLine];
        }
            break;
            
        case 2:
        {
            [self shareToQQSession];
        }
            break;
            
        case 3:
        {
            [self shareToQQZone];
        }
            break;
            
        case 4:
        {
            self.codeView.hidden = NO;
            self.shareTableView.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;//关闭手势
    }//否则手势存在
    return YES;
}

//分享到对话
-(void)shareToWXSession{
    
    WXMediaMessage *message = [WXMediaMessage message];
    
    message.title = @"爱装修";
    message.description = @"爱装修";
    //    [message setThumbImage:[UIImage imageNamed:@""]];
    
    WXWebpageObject *webPageObject = [WXWebpageObject object];
    webPageObject.webpageUrl = [BASEHTML stringByAppendingString:@"resources/html/fenxiang.jsp?a=a"];
    message.mediaObject = webPageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

//分享到朋友圈
-(void)shareToTimeLine{
    
    WXMediaMessage *message = [WXMediaMessage message];
    
    message.title = @"爱装修";
    message.description = @"爱装修";
    //    [message setThumbImage:[UIImage imageNamed:@""]];
    
    WXWebpageObject *webPageObject = [WXWebpageObject object];
    webPageObject.webpageUrl = [BASEHTML stringByAppendingString:@"resources/html/fenxiang.jsp?a=a"];
    message.mediaObject = webPageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}

//分享到QQ
-(void)shareToQQSession{
    
    if ([TencentOAuth iphoneQQInstalled]) {
        
        //声明一个新闻类对象
        self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
        //从contentObj中传入数据，生成一个QQReq
        NSURL *url = [NSURL URLWithString:[BASEHTML stringByAppendingString:@"resources/html/fenxiang.jsp?a=a"]];
        QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:@"爱装修" description:@"爱装修" previewImageURL:nil];
        //向QQ发送消息，查看是否可以发送
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
        QQApiSendResultCode code = [QQApiInterface sendReq:req];
        NSLog(@"%d",code);
        
    }
    
}

//分享到QQ空间
-(void)shareToQQZone{
    
    if ([TencentOAuth iphoneQQInstalled]){
        
        //声明一个新闻类对象
        self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
        //从contentObj中传入数据，生成一个QQReq
        NSURL *url = [NSURL URLWithString:[BASEHTML stringByAppendingString:@"resources/html/fenxiang.jsp?a=a"]];
        QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:@"爱装修" description:@"爱装修" previewImageURL:nil];
        //向QQ发送消息，查看是否可以发送
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
        QQApiSendResultCode code = [QQApiInterface SendReqToQZone:req];
        NSLog(@"%d",code);
    }
}

-(void)closeView:(UITapGestureRecognizer*)sender{
    
    if (self.closeBlock) {
        self.closeBlock();
    }
}

@end
