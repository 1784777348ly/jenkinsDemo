//
//  TWLoginViewModel.m
//  ticketWaiter
//
//  Created by LY on 17/1/19.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWLoginViewModel.h"

@implementation TWLoginViewModel

-(void)fetchLoginRequest:(NSString *)name  andCode:(NSString *)code returnback:(void(^)(id result))block
{
    
    NSDictionary *param = @{@"password":code,@"username":name};
  
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD showWithStatus:@"正在登录"];
    
    
    [HSNetWorking postWithURLString:@"v1/user/merchant/login" parameters:param success:^(id responseObject) {
        

        NSDictionary *dic = (NSDictionary *)responseObject;
        
        NSLog(@"token--------%@",dic);
        
            block(dic);

    } failure:^(NSError *error) {
        
        
        NSLog(@"===%@",error);
        
        
        if (error.code == -1009) {

            [SVProgressHUD showErrorWithStatus:@"请检查网络连接"];
          //  NSLog(@"您已经断网了的");
        }else{
        
            [SVProgressHUD showErrorWithStatus:@"服务器异常"];
           // NSLog(@"服务器异常");

        }

    }];



}


-(void)fetchMergentInfoWithToken:(NSString *)token returnBack:(void(^)(id result))block
{

    NSDictionary *param = @{@"token":token};

    [HSNetWorking postWithURLString:@"v1/lottery/querymerchantuser" parameters:param success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        NSLog(@"%@",dic);

        block(dic);

    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        
    }];

    


}





@end
