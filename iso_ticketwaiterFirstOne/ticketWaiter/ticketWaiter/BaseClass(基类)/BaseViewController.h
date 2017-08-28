//
//  BaseViewController.h
//  HuiShiApp
//
//  Created by hui10 on 16/6/27.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (strong, nonatomic) UILabel *naview;


- (void)setSubViews;
/**
 *  设置导航条标题
 *
 *  @param title 标题
 */
- (void)setNaviBarTitle:(NSString *)title color:(UIColor *)color;
/**
 *  设置导航条中间view
 *
 *  @param titleView UIView
 */
- (void)setNaviBarTitleView:(UIView *)titleView;
/**
 *  设置左侧button文字和图片
 *
 *  @param title   文字
 *  @param imgName 图片
 */
- (void)setNaviBarLeftTitle:(NSString *)title image:(NSString *)imgName;
/**
 *  设置右侧button文字和图片
 *
 *  @param title   文字
 *  @param imgName 图片
 */
- (void)setNaviBarRightTitle:(NSString *)title image:(NSString *)imgName;
/**
 *  设置导航条背景颜色
 *
 *  @param color 颜色
 *  @param topColor 状态栏颜色
 */
- (void)setNaviBarBackgroundColor:(UIColor *)color andStatusBarColor:(UIColor *)topColor;
/**
 *  设置左侧button的文字颜色
 *
 *  @param color 颜色
 */
- (void)setLeftTitleColor:(UIColor *)color;
/**
 *  设置右侧button的颜色
 *
 *  @param color 颜色
 */
- (void)setRightTitleColor:(UIColor *)color;
- (void)setNavtiLineHidden:(BOOL)hidden;

-(NSString *)getLeftTitle;


@end




