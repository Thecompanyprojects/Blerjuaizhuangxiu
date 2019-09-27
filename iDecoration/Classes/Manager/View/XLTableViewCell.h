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

#import <UIKit/UIKit.h>

@interface XLTableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView cellStyle:(NSInteger)cellStyle;
- (void)configCell:(id )data;
@end
