//
//  NSString+Methods.h
//  HuiShiApp
//
//  Created by hui10 on 16/8/4.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Methods)
/**
 *  以data初始化string
 *
 *  @param data data
 *
 *  @return string
 */
+ (NSString *)stringWithData:(NSData *)data;
/**
 *  将整形 浮点型数字用","每千位分割 且以"¥"符号开头(可选)
 *
 *  @param string 数字字符串
 *  @param symbol 人民币符号
 *
 *  @return 分割好的字符串
 */
- (NSString *)separateString:(NSString *)string withRmbSymbol:(BOOL)symbol;

/**
 *  将整形 浮点型数字用","每千位分割 且以"¥"符号开头(可选)
 *
 *  @param string 数字字符串  传100 －> 实际是1.00元
 *  @param symbol 人民币符号
 *
 *  @return 分割好的字符串
 */
- (NSString *)separateWithFenString:(NSString *)string withRmbSymbol:(BOOL)symbol;

/**
 *  文本高度
 *
 *  @param font  字体
 *  @param width 宽度
 *
 *  @return 高度
 */
- (float)heightWithFont:(UIFont *)font withinWidth:(float)width;
/**
 *  文本宽度
 *
 *  @param font 字体
 *
 *  @return 宽度
 */
- (float)widthWithFont:(UIFont *)font;
/**
 *  判断date是今天 昨天 还是明天
 *
 *  @param date date
 *
 *  @return 判断结果
 */
-(NSString *)compareDate:(NSDate *)date;
/**
 *  判断 "刚刚" "XX分钟之前" "XX月XX日"....
 *
 *  @param dateString dateString
 *  @param formate    formate description
 *
 *  @return 判断结果
 */
+ (NSString *)formateDateWithTimeinterval:(NSTimeInterval)interval;
/**
 *  判断当前手机型号 e.g return iPhone 6 / iPhone 6Plus
 *
 *  @return 手机型号
 */
+ (NSString*)deviceVersion;
/**
 *  根据时间戳判断是对应的周几
 *
 *  @param data 时间戳
 *
 *  @return 周几weekday
 */
+ (NSString *)getWeekDayFordate:(long long)data;

@end





























