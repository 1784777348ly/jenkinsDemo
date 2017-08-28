//
//  TWJudgeRulesTool.h
//  ticketWaiter
//
//  Created by LY on 16/12/29.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWJudgeRulesTool : NSObject

//判断名字
+(BOOL)judgeNameIsOk:(NSString *)nameStr;

//判断qq
+(BOOL)judgeQQIsOk:(NSString *)qqStr;

//判断邮箱
+(BOOL)judgeEmailIsOk:(NSString *)emailStr;


//判断密码 6~18位 英文字母的混合
+(BOOL)judgePasswordIsOk:(NSString *)passwordStr;

//判断支付密码
+(BOOL)judgePayPasswordIsOk:(NSString *)passwordStr;

//判断手机号
+(BOOL)judgePhoneIsOk:(NSString *)phoneStr;


//判断是否是登录状态
+(BOOL)judgeAccountIsLogin;

//判断银行卡号
+ (BOOL)judgeCardNo:(NSString*) cardNo;

//信用卡号 是不是都是数字
+(BOOL)isPureInt:(NSString*)string;

//判断身份证号
+(BOOL)checkIdentityCardNo:(NSString*)cardNo;



@end
