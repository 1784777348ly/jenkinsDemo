//
//  HSNavigationController.m
//  HuiShiApp
//
//  Created by hui10 on 16/7/11.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "HSNavigationController.h"
//#import "HSLoginViewController.h"

@interface HSNavigationController ()

@end

@implementation HSNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count != 0) {
        // push页面时隐藏tabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}





@end



















