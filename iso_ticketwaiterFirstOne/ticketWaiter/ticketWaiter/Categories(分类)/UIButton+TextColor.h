//
//  UIButton+TextColor.h
//  HuiShiApp
//
//  Created by hui10 on 16/6/29.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (TextColor)
/**
 *  button设置各种属性
 *
 *  @param title    文字
 *  @param color    文字颜色
 *  @param fontSize 普通字号
 *  @param state    状态
 */
- (void)setTitle:(NSString *)title
      titleColor:(UIColor *)color
   titleFontSize:(CGFloat)fontSize
        forState:(UIControlState)state;
/**
 *  button设置各种属性
 *
 *  @param title    文字
 *  @param color    文字颜色
 *  @param fontSize 粗体字号
 *  @param state    状态
 */
- (void)setTitle:(NSString *)title
      titleColor:(UIColor *)color
titleBoldFontSize:(CGFloat)fontSize
        forState:(UIControlState)state;
/**
 *  置灰不可用状态
 */
- (void)setGrayType;
/**
 *  正常高亮状态
 *
 *  @param color 正常状态title的颜色
 */
- (void)setNoramlTypeWithTitleColor:(UIColor *)color;
- (void)setNoramlTypeWithTitleColor:(UIColor *)color borderColor:(UIColor *)borColor;

@end








