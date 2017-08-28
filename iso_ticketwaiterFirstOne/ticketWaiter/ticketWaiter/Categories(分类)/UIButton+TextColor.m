//
//  UIButton+TextColor.m
//  HuiShiApp
//
//  Created by hui10 on 16/6/29.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "UIButton+TextColor.h"

@implementation UIButton (TextColor)
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
        forState:(UIControlState)state{
    
    [self setTitle:title
          forState:state];
    [self setTitleColor:color
               forState:state];
    self.titleLabel.font = Font(fontSize);
    
}
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
        forState:(UIControlState)state{
    
    [self setTitle:title
          forState:state];
    [self setTitleColor:color
               forState:state];
    self.titleLabel.font = BoldFont(fontSize);
}
/**
 *  置灰不可用状态
 */
- (void)setGrayType{
    
    [self setTitleColor:UIColorHex(B4B8BF)
               forState:UIControlStateNormal];
    self.backgroundColor   = UIColorHex(D4D9DF);
    self.layer.borderColor = UIColorHex(D4D9DF).CGColor;
    self.userInteractionEnabled = NO;
}
/**
 *  正常高亮状态
 */
- (void)setNoramlTypeWithTitleColor:(UIColor *)color{
    
    [self setTitleColor:color
               forState:UIControlStateNormal];
    //self.backgroundColor        = MainColor;
    self.userInteractionEnabled = YES;    
}
- (void)setNoramlTypeWithTitleColor:(UIColor *)color borderColor:(UIColor *)borColor{
    
    [self setTitleColor:color
               forState:UIControlStateNormal];
    self.backgroundColor        = WHITECOLOR;
    self.layer.borderColor      = borColor.CGColor;
    self.userInteractionEnabled = YES;
}
@end






