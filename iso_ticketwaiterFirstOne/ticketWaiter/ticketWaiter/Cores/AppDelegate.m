//
//  AppDelegate.m
//  ticketWaiter
//
//  Created by LY on 16/12/20.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+ThirdUses.h"
#import "TWHomeViewController.h"
#import "HSNavigationController.h"
#import "TWLoginViewController.h"
#import "IQKeyboardManager.h"

#import "NewPageView.h"


@interface AppDelegate ()

@property (strong, nonatomic)NewPageView *newview;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    TWHomeViewController *homeVC = [TWHomeViewController new];
//    HSNavigationController *nav = [[HSNavigationController alloc] initWithRootViewController:homeVC];
//    self.window.rootViewController = nav;
//    [self.window makeKeyAndVisible];
    

    [self chooseGuideSwitchMain];
    
    [self thirdUsesApplication:application didFinishLaunchingWithOptions:launchOptions];

    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].shouldToolbarUsesTextFieldTintColor = YES;

    //设置百度地图
    [self setBaiDuMap];
    
    //监听网络状态

    return YES;
}

-(void)setBaiDuMap{
    
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BaiDUKey  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    // Add the navigation controller's view to the window and display.
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];


}




//切换控制器
- (void)chooseGuideSwitchMain {
    //创建控制器
   // HSGuidCollectionViewController *guideVc = [[HSGuidCollectionViewController alloc]init];
    TWLoginViewController *logController = [TWLoginViewController new];
    HSNavigationController *loginNav = [[HSNavigationController alloc] initWithRootViewController:logController];
    
    TWHomeViewController *homeVC = [TWHomeViewController new];
    HSNavigationController *homeNav = [[HSNavigationController alloc] initWithRootViewController:homeVC];
    
    
    self.newview = [[NewPageView alloc] initWithFrame:NONE_NAV_FRAME];

    
    //沙盒中的版本  从沙盒中获取版本
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *curViewsion = [defaults objectForKey:@"app_ver"];
    
    
//    if (LYTOKEN) {
//        [self.window setRootViewController:homeNav]; //用户登录
//    } else {
//        [self.window setRootViewController:loginNav]; //用户未登录
//    }
//    
//     [self.window makeKeyAndVisible];
    
    
    
    if ([curViewsion isEqualToString:SystemVersion]) { //如果这两个版本一样不显示引导页
        if (LYTOKEN) {
            [self.window setRootViewController:homeNav]; //用户登录
        } else {
            [self.window setRootViewController:loginNav]; //用户未登录
        }
        [self.window makeKeyAndVisible];

    } else { //显示引导页
        if (LYTOKEN) {
            [self.window setRootViewController:homeNav]; //用户登录
        } else {
            [self.window setRootViewController:loginNav]; //用户未登录
        }
        
        [self.window makeKeyAndVisible];

        [self.window addSubview:self.newview];

    }
    
}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//支付成功回调 ios9
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return [self thirdUsesApplication:app openURL:url options:options];
}


- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{

    return [self thirdUsesApplication:application openURL:url sourceApplication:sourceApplication annotation:annotation];

}





@end


@implementation NSURLRequest(DataController)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}
@end




