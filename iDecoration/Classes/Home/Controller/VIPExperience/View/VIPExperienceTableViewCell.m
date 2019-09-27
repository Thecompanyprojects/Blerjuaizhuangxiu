//
//  VIPExperienceTableViewCell.m
//  iDecoration
//
//  Created by 张毅成 on 2018/6/22.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "VIPExperienceTableViewCell.h"

@implementation VIPExperienceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.delegate = self;
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:(UIControlEventEditingChanged)];
}

- (void)setModel:(VIPExperienceModel *)model andIndexPath:(NSIndexPath *)indexPath {
    self.model = model;
    self.textField.tag = indexPath.row;
    self.textView.tag = indexPath.row;

    NSArray *arrayTF = model.isCompany?@[@"2", @"3", @"6"]:@[@"2", @"5"];
    if ([arrayTF containsObject:@(indexPath.row).stringValue]) {
        self.textField.userInteractionEnabled = false;
    }else{
        self.textField.userInteractionEnabled = true;
    }
    NSArray *arrIm = model.isCompany?@[@"2", @"3", @"6", @"7"]:@[@"2", @"5", @"6"];
    if ([arrIm containsObject:@(indexPath.row).stringValue]) {
        if (self.model.isCompany && indexPath.row == 2) {
            self.imageView.hidden = TRUE;
        }else
            self.imageView.hidden = false;
        if (indexPath.row == (model.isCompany?7:6)) {
            [self.imageView setImage:[UIImage imageNamed:@"map"]];
        }else{
            [self.imageView setImage:[UIImage imageNamed:@"common_arrow_btn"]];
        }
    }else{
        self.imageView.hidden = true;
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIImageView *imageViewTmp = [UIImageView new];
        [imageViewTmp sd_setImageWithURL:[NSURL URLWithString:model.companyLogo]];
        if (model.imageLogo) {
            [self.button setImage:model.imageLogo forState:(UIControlStateNormal)];
        }else
            [self.button setImage:imageViewTmp.image forState:(UIControlStateNormal)];
    }
    self.labelTitle.text = model.arrayBasicTitle[indexPath.row];
    self.textField.text = model.arrayBasic[indexPath.row];
    self.textView.tag = indexPath.row;
    if (indexPath.row == (model.isCompany?4:3)) {
        self.textView.text = model.serviceScope;
        self.labelCount.hidden = false;
        self.labelCount.text = [NSString stringWithFormat:@"%ld/50",(long)self.textView.text.length];
    }else if (indexPath.row == (model.isCompany?11:10)) {
        self.textView.text = model.companyIntroduction;
        self.labelCount.hidden = true;
    }
    if ([model.arrayBasicTitle[indexPath.row] isEqualToString:@"座机"] || [model.arrayBasicTitle[indexPath.row] isEqualToString:@"业务经理电话"]) {
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    }else if ([model.arrayBasicTitle[indexPath.row] isEqualToString:@"邮箱"]) {
        self.textField.keyboardType = UIKeyboardTypeEmailAddress;
    }else if ([model.arrayBasicTitle[indexPath.row] isEqualToString:@"网址"]) {
        self.textField.keyboardType = UIKeyboardTypeURL;
    }else
        self.textField.keyboardType = UIKeyboardTypeDefault;
}

- (void)setModelInShow:(SubsidiaryModel *)model andIndexPath:(NSIndexPath *)indexPath {
    self.imageView.hidden = true;
    self.textField.userInteractionEnabled = false;
    self.textField.textAlignment = NSTextAlignmentRight;
    self.textField.tag = indexPath.row;
    if (indexPath.row - 1 != 5) {
        self.labelTitle.text = model.arrayBasicTitleInShow[indexPath.row - 1];
        self.textField.text = model.arrayBasicInShow[indexPath.row - 1];
    }
}

- (IBAction)didTouchButtonLogo:(UIButton *)sender {
    if (self.blockDidTouchButtonLogo) {
        self.blockDidTouchButtonLogo();
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView AndIndex:(NSInteger)index {
    NSString *ID = [NSString stringWithFormat:@"VIPExperienceTableViewCell%ld",(long)index];
    VIPExperienceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"VIPExperienceTableViewCell" owner:self options:nil][index];
    }
    cell.selectionStyle = UIAccessibilityTraitNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textFieldDidChange:(UITextField *)textfield {
    NSInteger tag = textfield.tag;
    if (tag > 1 && self.model.isCompany) {
        tag --;
    }
    switch (tag) {
        case 1:
            self.model.companyName = textfield.text;
            break;
        case 4:
            self.model.companyLandline = textfield.text;
            break;
        case 6:
            self.model.detailedAddress = textfield.text;
            break;
        case 7:
            self.model.companyPhone = textfield.text;
            break;
        case 8:
            self.model.companyEmail = textfield.text;
            break;
        case 9:
            self.model.companyUrl = textfield.text;
            break;
        default:
            break;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.tag < 5) {
        self.model.serviceScope = textView.text;
        NSString *s = textView.text;
        if (textView.text.length > 50) {
            s = [textView.text substringToIndex:50];
            textView.text = s;
            [textView resignFirstResponder];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"你输入的字数已经超过50字"];
          //  [[PublicTool defaultTool] publicToolsHUDStr:@"你输入的字数已经超过50字" controller:self.parentContainerViewController sleep:2];
        }
        self.model.serviceScope = s;
        self.labelCount.text = [NSString stringWithFormat:@"%ld/50",(long)textView.text.length];
       
    }else
        self.model.companyIntroduction = textView.text;
}
@end
