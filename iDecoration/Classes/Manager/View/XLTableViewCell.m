/**
 *
 * 模块名: 通用TableViewCell
 * 文件名: XLTableViewCell
 * 相关文件:
 * 功能描述:
 *
 *
 * 作者: 
 * 日期: 2016-03-16
 * 备注:
 * 修改记录：
 * 日期             修改人                修改内容
 *  YYYY/MM/DD      <作者或修改者名>      <修改内容>
 */

#import "XLTableViewCell.h"

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface XLTableViewCell () <UITextViewDelegate>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) NSInteger myStyle;

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIImageView *leftImage;
@property (nonatomic, strong) UIImageView *rightImage;

@end

@implementation XLTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView cellStyle:(NSInteger)cellStyle
{
    static NSString *XLTableViewCellID = @"XLTableViewCell";
    XLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XLTableViewCellID];
    if (cell == nil) {
        cell =[[XLTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault cellStyle:cellStyle reuseIdentifier:XLTableViewCellID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style cellStyle:(NSInteger)cellStyle reuseIdentifier:(NSString *)reuseIdentifier
{
    self.myStyle = cellStyle;
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        if (cellStyle == 1)
        {
            /*
             *  style 1
             *  左右Label，右侧有图标
             */
            [self addSubview:self.bgView];
            [self.bgView addSubview:self.leftLabel];
            [self.bgView addSubview:self.rightLabel];
            [self.bgView addSubview:self.rightImage];
        }
        else if (cellStyle == 2)
        {
            [self addSubview:self.bgView];
            [self.bgView addSubview:self.leftLabel];
            [self.bgView addSubview:self.leftImage];
        }
        else if (cellStyle == 3)
        {
            [self addSubview:self.bgView];
            [self.bgView addSubview:self.leftLabel];
            [self.bgView addSubview:self.rightImage];
        }
        else
        {
        
        }
    }
    return self;
}

- (void)configCell:(id )data
{
    if ([data isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *infoDic = data;
        
        if (self.myStyle == 1)
        {
//            self.leftLabel.text = [infoDic objectForKey:@"leftLabel"];
//            self.rightLabel.text = [infoDic objectForKey:@"rightLabel"];
//            [self.rightImage setImage:UIIMAGE_STR( [infoDic objectForKey:@"rightImage"] )];
////            [self.rightImage sd_setImageWithURL:UIIMAGE_URL(@"") placeholderImage:PLACEHOLDER_BLOCK];
        }
        else if (self.myStyle == 2)
        {
////            [self.rightImage sd_setImageWithURL:UIIMAGE_URL(@"") placeholderImage:PLACEHOLDER_BLOCK];
//            [self.leftImage setImage:UIIMAGE_STR( [infoDic objectForKey:@"leftImage"] )];
//            self.leftLabel.text = [infoDic objectForKey:@"leftLabel"];
        }
        else if (self.myStyle == 3)
        {
            NSString *isShow = [infoDic objectForKey:@"rightImageShow"];
            [self.rightImage setImage:[UIImage imageNamed:[infoDic objectForKey:@"rightImage"]]];
            if ([isShow isEqualToString:@"yes"])
            {
                self.rightImage.hidden = NO;
            }
            else
            {
                self.rightImage.hidden = YES;
            }
            
            
            self.leftLabel.text = [infoDic objectForKey:@"leftLabel"];
        }
        else
        {
        
        }
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.myStyle == 1)
    {
        self.leftLabel.frame = CGRectMake(15, 0, SCREEN_WIDTH/3 - 20, 45);
        self.rightImage.frame = CGRectMake(SCREEN_WIDTH - 30 - 10, self.bgView.centerY - 30/2.0, 30, 30);
        self.rightLabel.frame = CGRectMake(SCREEN_WIDTH - 30 - 10 - 5 - SCREEN_WIDTH/4, self.bgView.centerY - 45/2.0, SCREEN_WIDTH/4 - 10, 45);
    }
    else if (self.myStyle == 2)
    {
        self.backgroundColor = Clear_Color;
        self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
//        self.bgView.layer.cornerRadius = 5.0;
//        self.bgView.clipsToBounds = YES;
        self.bgView.backgroundColor = White_Color;
        
        self.leftImage.frame = CGRectMake(15, self.bgView.center.y - 50/2.0, 50, 50);
        self.leftLabel.frame = CGRectMake(self.leftImage.right + 15, self.bgView.center.y - 30/2.0, SCREEN_WIDTH/2, 30);
    }
    else if (self.myStyle == 3)
    {
        self.backgroundColor = Clear_Color;
        self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        self.bgView.backgroundColor = White_Color;
        
        CGSize textSize = [self.leftLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                            context:nil].size;
        
        self.leftLabel.frame = CGRectMake(15, 0, textSize.width, 44);
        [self.rightImage sizeToFit];
        self.rightImage.frame = CGRectMake(SCREEN_WIDTH - self.rightImage.width - 15, self.bgView.centerY - self.rightImage.height/2.0, self.rightImage.width, self.rightImage.height);
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - 通用背景
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        _bgView.backgroundColor = White_Color;
    }
    return _bgView;
}

#pragma mark - 子控件
- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.font = NB_FONTSEIZ_NOR;
        _leftLabel.backgroundColor = Clear_Color;
        _leftLabel.textColor = COLOR_BLACK_CLASS_H;
    }
    return _leftLabel;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.font = NB_FONTSEIZ_NOR;
        _rightLabel.backgroundColor = Clear_Color;
        _rightLabel.textColor = COLOR_BLACK_CLASS_H;
    }
    return _rightLabel;
}

- (UIImageView *)leftImage
{
    if (!_leftImage) {
        _leftImage = [[UIImageView alloc] initWithFrame:CGRectZero];
//        _leftImage.layer.cornerRadius = 45/2.0;
//        _leftImage.clipsToBounds = YES;
    }
    return _leftImage;
}

- (UIImageView *)rightImage
{
    if (!_rightImage) {
        _rightImage = [[UIImageView alloc] initWithFrame:CGRectZero];
//        _rightImage.layer.cornerRadius = 45/2.0;
//        _rightImage.clipsToBounds = YES;
    }
    return _rightImage;
}
@end
