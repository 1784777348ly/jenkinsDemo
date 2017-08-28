//
//  AppDelegate.h
//  ticketWaiter
//
//  Created by LY on 16/12/20.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{

    UINavigationController *navigationController;
    BMKMapManager* _mapManager;

}

@property (strong, nonatomic) UIWindow *window;


@end

