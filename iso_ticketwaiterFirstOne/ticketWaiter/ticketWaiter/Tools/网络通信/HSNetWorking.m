//
//  HSNetWorking.m
//  HuiShiApp
//
//  Created by hui10 on 16/8/2.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "HSNetWorking.h"
//#import "StateCode.h"

#import "TWLogOutView.h"

@interface HSNetWorking ()<UIAlertViewDelegate>

@end

@implementation HSNetWorking

static id manager;
/**
 *  完整版单例
 *
 *  @return 实例对象
 */
+ (instancetype)shareManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [HSNetWorking new];
        
        [manager setNetworkBaseData:manager];
        
    });
    return manager;
}
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}
- (id)copyWithZone:(NSZone *)zone
{
    return manager;
}

- (void)setNetworkBaseData:(HSNetWorking *)manager{
    
    //http://web.webtest.hui10.com/api/
    //http://223.223.184.94:8080/api/
    //http://58.135.92.83:8080/api/
    //http://223.223.184.93 游戏页面
    //http://new.hui10games.com/api/
    //http://192.168.31.194:8080/api/
    
    //https://192.168.17.217/merchant/
    
    //http://223.223.184.94:8080/merchant/ 开发

    //测试地址  223.223.184.83:8080
    //开发地址  223.223.184.94:8080
    //http://lottery.webtest.hui10.com

    
    //https://caipiao.hui10.com

    NSURL *baseURL = [NSURL URLWithString:@"http://lottery.webtest.hui10.com/merchant/"];


    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 设置超时时间
    config.timeoutIntervalForRequest = 12;
    // 忽略缓存数据
    config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    NSSet *set = [NSSet setWithObjects:@"application/json",
                                       @"text/json",
                                       @"text/javascript",
                                       @"text/html",
                                       @"image/png", nil];
    
    manager = [[HSNetWorking alloc] initWithBaseURL:baseURL sessionConfiguration:config];
    manager.responseSerializer.acceptableContentTypes = set;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    
}

/**
 *  发送get请求
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure{
    
    HSNetWorking *manager = [HSNetWorking shareManager];
    NSDictionary *param = [manager getFinalParameters:parameters];
    
    [manager GET:URLString parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {

            
                success(responseObject);

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error) {
    
            failure(error);
        }
    }];
    
}

/**
 *  发送post请求
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure{
    
    HSNetWorking *manager = [HSNetWorking shareManager];
    
    NSDictionary *param = [manager getFinalParameters:parameters];

    [manager POST:URLString parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //1010000002
    
        if (success) {
            
                success(responseObject);

    }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error) {
            
            failure(error);
        }
    }];
    
}



/**
 *  发送post请求
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)postUploadInfoWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure{
    
    HSNetWorking *manager = [HSNetWorking shareManager];
    
   // NSDictionary *param = [manager getFinalParameters:parameters];
    
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //1010000002
        
        if (success) {
            
            success(responseObject);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error) {
            
            failure(error);
        }
    }];
    
}




+ (void)gamePostWithURLString:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure{
    
    
    HSNetWorking *manager = [HSNetWorking shareManager];
    
    NSDictionary *param = [manager getFinalParameters:parameters];
    
    [manager POST:URLString parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //1010000002
        
        if (success) {
            
            success(responseObject);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error) {
            
            failure(error);
        }
    }];
}



/**
 *  公共参数部分
 *
 *  @param parameters 传入的可变参数
 *
 *  @return 最终参数字典
 */
- (NSDictionary *)getFinalParameters:(NSDictionary *)parameters{
    
    //,@"deviceid":[StateCode obtainUUIDInKeyChain]
    
    NSMutableDictionary *dictOne = @{@"src":@"ios",@"ua":[self userAgentString],@"appversion":[NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]}.mutableCopy;
    [dictOne addEntriesFromDictionary:parameters];

    return dictOne;
}

- (NSString *)userAgentString
{
//    UIWebView *webView     = [[UIWebView alloc] initWithFrame:CGRectZero];
//    NSString  *secretAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
//    return secretAgent;
    
    return @"111111";
    
}






@end
































