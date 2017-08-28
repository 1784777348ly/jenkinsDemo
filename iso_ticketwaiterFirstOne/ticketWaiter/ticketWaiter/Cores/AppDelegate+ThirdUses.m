//
//  AppDelegate+ThirdUses.m
//  ticketWaiter
//
//  Created by LY on 16/12/22.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "AppDelegate+ThirdUses.h"
#import "TWMineViewModel.h"

#import <UMSocialCore/UMSocialCore.h>


@implementation AppDelegate (ThirdUses)

- (void)thirdUsesApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setThirdLogin];

}

-(void)setThirdLogin{
    
    //设置微信AppId、appSecret，分享url
    
    
    
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMKey];
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WeChatAppID appSecret:WeChatAppSecret redirectURL:@"http://mobile.umeng.com/social"];
    //设置分享到QQ互联的appKey和appSecret
    // U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppID  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:WeiBoAppKey  appSecret:WeiBoAppSecret redirectURL:@"http://sns.whalecloud.com/sina2/callback"];

}


- (void)thirdUsesApplicationDidEnterBackground:(UIApplication *)application
{

}

- (void)thirdUsesApplicationWillEnterForeground:(UIApplication *)application
{

}

- (void)thirdUsesApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{


}

- (BOOL) thirdUsesApplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
 
    //如果需要支持支付完成后回到第三方应用使用下面注释代码
    if ([url.scheme isEqualToString:@"UPPayDemo"]) {
        
        TWMineViewModel *vm = [[TWMineViewModel alloc] init];
        
        [vm getPayResult];
    }
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
    
    

    return YES;
}

//ios9以后 从银联支付返回
- (BOOL)thirdUsesApplication:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    //如果需要支持支付完成后回到第三方应用使用下面注释代码
    if ([url.scheme isEqualToString:@"UPPayDemo"]) {
        
        TWMineViewModel *vm = [[TWMineViewModel alloc] init];
        
        [vm getPayResult];
        
        
    }
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
    
    

    return YES;
}



- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    
    if ([url.scheme isEqualToString:@"UPPayDemo"]) {
        
        TWMineViewModel *vm = [[TWMineViewModel alloc] init];
        
        [vm getPayResult];
        
        
    }
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
    
    
    

    return YES;
    
}






@end
