//
//  TWLoginViewModel.h
//  ticketWaiter
//
//  Created by LY on 17/1/19.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TWLoginViewModel : NSObject

//登录
-(void)fetchLoginRequest:(NSString *)name  andCode:(NSString *)code returnback:(void(^)(id result))block;


//查询用户信息
-(void)fetchMergentInfoWithToken:(NSString *)token returnBack:(void(^)(id result))block;



@end
