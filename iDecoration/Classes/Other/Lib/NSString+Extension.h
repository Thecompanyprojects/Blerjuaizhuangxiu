//
//  NSString+Extension.h
//  Easywork
//
//  Created by Kingxl on 11/4/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

#pragma mark - Tools

/** Remove spaces and line breaks */
- (NSString *)ew_removeSpacesAndLineBreaks;

/* Remove space */
- (NSString *)ew_removeSpaces;

/** A string has substring */
- (BOOL)ew_hasSubString:(NSString *)subStr;

/** Replace string with string */
- (NSString *)ew_replaceString:(NSString *)str withString:(NSString *)aStr;

/** According to the font size and line width calculation line high*/
- (CGFloat)ew_heightWithFont:(UIFont *)font lineWidth:(CGFloat)width;

- (CGFloat)ew_widthWithFont:(UIFont *)font lineHeight:(CGFloat)height;

/** According to the font size and line Max width calculation line width*/
- (CGFloat)ew_widthWithFont:(UIFont *)font lineWidth:(CGFloat)width;

/** Focus Substring in string */
- (NSMutableAttributedString *)ew_focusSubstring:(NSString *)subString color:(UIColor *)fontColor font:(UIFont *)font;

/** Seprator string with substring */
- (NSArray *)ew_sepratorwithString:(NSString *)str;

/** number of lines */
- (NSInteger)ew_numberOfLinesWithFont:(UIFont*)font lineWidth:(NSInteger)lineWidth;

/** Check 纯数字 */
-(BOOL)ew_checkNumber;


/** Check email */
- (BOOL)ew_checkEmail;

/** Check 座机 */
- (BOOL)ew_checkLinePhone;

- (BOOL)ew_checkFour;

/** Check phone number *///只检验手机号
-(BOOL)ew_justCheckPhone;

/** Check phone number *///手机号和座机号都检验
- (BOOL)ew_checkPhoneNumber;

/** Check ID number */
- (BOOL)ew_checkIDNumber;

/** Check TIME number */
-(BOOL)ew_checkTimeNumber;
#pragma mark - Encode & Decode

/** Check 数字字母混合*/
-(BOOL)ew_checkNumAndCharacter;

/** Check 英文字母开头，（6-12）*/
-(BOOL)ew_checkNumAndEnglishIsFisrt;

/** 只检测文字母开头*/
-(BOOL)ew_checkJustEnglishIsFisrt;

/** Check 是否有Emoj表情*/
-(BOOL)ew_checkeEmojCharacter:(NSString *)string;

/** MD5 encrypt */
- (NSString *)ew_md5Encrypt;

/** Base64 encode */
- (NSString *)ew_base64Encode;

/** Base64 decode*/
- (NSString *)ew_base64Decode;

/** URL encode*/
- (NSString *)ew_urlEncode;

/** URL decode*/
- (NSString *)ew_urlDecode;

/**
 判断地址是否合法

 @return YES / NO
 */
- (BOOL)ew_isUrlString ;


// 字典转json字符串方法

+(NSString *)convertToJsonData:(NSDictionary *)dict;


// 验证数字个数 是否是count
- (BOOL)ew_checkDegitalCountIs:(NSInteger)count;


//判断是否含有非法字符 yes 有  no没有
- (BOOL)ew_JudgeTheillegalCharacter:(NSString *)content;

@end
