//
//  BaseFont.h
//  HuiShiApp
//
//  Created by hui10 on 16/8/29.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseFont : UIFont

+ (UIFont *)baseFont:(CGFloat)size;
+ (UIFont *)thinFont:(CGFloat)size;
+ (UIFont *)boldFont:(CGFloat)size;
+ (UIFont *)normalFont:(CGFloat)size;
+ (UIFont *)normalFontWithNoScale:(CGFloat)size;
+ (UIFont *)boldFontWithNoScale:(CGFloat)size;

@end






