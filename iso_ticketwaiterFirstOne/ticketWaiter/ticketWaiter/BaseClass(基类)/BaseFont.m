//
//  BaseFont.m
//  HuiShiApp
//
//  Created by hui10 on 16/8/29.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "BaseFont.h"

@implementation BaseFont
//#define Font(s) [UIFont fontWithName:@"PingFangSC-Light" size:s]
//#define ThinFont(s) [UIFont fontWithName:@"PingFangSC-Thin" size:s]
//#define BoldFont(s) [UIFont fontWithName:@"PingFangSC-Regular" size:s]

+ (UIFont *)baseFont:(CGFloat)size{
    
    if (IOS_VERSION >= 9.0) {
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Light" size:size*ScaleY];
        return font;
    } else {
        UIFont *font = [UIFont systemFontOfSize:size*ScaleY];
        return font;
    }
}
+ (UIFont *)thinFont:(CGFloat)size{
    
    if (IOS_VERSION >= 9.0) {
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Thin" size:size*ScaleY];
        return font;
    } else {
        UIFont *font = [UIFont systemFontOfSize:size*ScaleY];
        return font;
    }
}
+ (UIFont *)boldFont:(CGFloat)size{
    
    if (IOS_VERSION >= 9.0) {
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:size*ScaleY];
        return font;
    } else {
        UIFont *font = [UIFont boldSystemFontOfSize:size*ScaleY];
        return font;
    }
}
+ (UIFont *)normalFont:(CGFloat)size{
    
    if (IOS_VERSION >= 9.0) {
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:size*ScaleY];
        return font;
    } else {
        UIFont *font = [UIFont systemFontOfSize:size*ScaleY];
        return font;
    }
}


+ (UIFont *)normalFontWithNoScale:(CGFloat)size
{
    
    if (IOS_VERSION >= 9.0) {
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:size];
        return font;
    } else {
        UIFont *font = [UIFont systemFontOfSize:size];
        return font;
    }


}
+ (UIFont *)boldFontWithNoScale:(CGFloat)size
{
    if (IOS_VERSION >= 9.0) {
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:size];
        return font;
    } else {
        UIFont *font = [UIFont boldSystemFontOfSize:size];
        return font;
    }

}


@end











