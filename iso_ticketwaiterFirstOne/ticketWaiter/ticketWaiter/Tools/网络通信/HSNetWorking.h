//
//  HSNetWorking.h
//  HuiShiApp
//
//  Created by hui10 on 16/8/2.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HSNetWorking : AFHTTPSessionManager

+ (instancetype)shareManager;
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
                 failure:(void (^)(NSError *error))failure;
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
                  failure:(void (^)(NSError *error))failure;



+ (void)postUploadInfoWithURLString:(NSString *)URLString
                         parameters:(id)parameters
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;


/**
 *  发送post请求 (游戏页面专用)
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)gamePostWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

@end






















