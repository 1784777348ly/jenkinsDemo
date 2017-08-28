//
//  AppDelegate+ThirdUses.h
//  ticketWaiter
//
//  Created by LY on 16/12/22.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (ThirdUses)

- (void)thirdUsesApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)thirdUsesApplicationDidEnterBackground:(UIApplication *)application;

- (void)thirdUsesApplicationWillEnterForeground:(UIApplication *)application;

- (void)thirdUsesApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;


//从银联支付返回
- (BOOL) thirdUsesApplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

//ios9以后 从银联支付返回
- (BOOL)thirdUsesApplication:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options;




@end
