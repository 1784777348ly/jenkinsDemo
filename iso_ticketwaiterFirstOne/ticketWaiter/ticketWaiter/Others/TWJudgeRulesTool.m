//
//  TWJudgeRulesTool.m
//  ticketWaiter
//
//  Created by LY on 16/12/29.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "TWJudgeRulesTool.h"

@implementation TWJudgeRulesTool

+(BOOL)judgeNameIsOk:(NSString *)nameStr
{
    NSString *nameRegEx = @"([\u4E00-\u9FA5]{2,5}(?:·[\u4E00-\u9FA5]{2,5})*)";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegEx];
    return [regExPredicate evaluateWithObject:nameStr];
}

+(BOOL)judgeQQIsOk:(NSString *)qqStr
{
    NSString *nameRegEx = @"([1-9][0-9]{4,})";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegEx];
    return [regExPredicate evaluateWithObject:qqStr];
}

+(BOOL)judgeEmailIsOk:(NSString *)emailStr
{
    NSString *nameRegEx = @"(^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$)";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegEx];
    return [regExPredicate evaluateWithObject:emailStr];
    
}


+(BOOL)judgePasswordIsOk:(NSString *)passwordStr
{
    NSString *nameRegEx = @"(^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,18}$)";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegEx];
    return [regExPredicate evaluateWithObject:passwordStr];
}

+(BOOL)judgePayPasswordIsOk:(NSString *)passwordStr
{
    if ( passwordStr.length != 6) {
        
        return NO;
    }else{
        
        return YES;
    }
    
    
}


+(BOOL)judgePhoneIsOk:(NSString *)phoneStr
{
    NSString *nameRegEx = @"[1][34578]\\d{9}";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegEx];
    return [regExPredicate evaluateWithObject:phoneStr];
}

//判断是否是登录状态
+(BOOL)judgeAccountIsLogin
{
    if ([UserDefaults objectForKey:@"token"]) {
        
        return 1;
    }else{
        
        return 0;
    }
    
}

//判断银行卡号
#pragma mark - 判断输入的银行卡号是否有效
+ (BOOL)judgeCardNo:(NSString*) cardNo{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}

//判断是不是都是整数
+(BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}



#pragma mark - 判断身份证号
+(BOOL)checkIdentityCardNo:(NSString*)cardNo
{
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}





@end
