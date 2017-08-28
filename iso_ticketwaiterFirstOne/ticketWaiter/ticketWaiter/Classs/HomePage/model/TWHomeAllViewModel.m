//
//  TWHomeAllViewModel.m
//  ticketWaiter
//
//  Created by LY on 17/1/20.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWHomeAllViewModel.h"

@implementation TWHomeAllViewModel

-(void)fetchMergentInfoWithToken:(NSString *)token returnBack:(void(^)(id result))block
{
    if (!LYTOKEN) {
        
        return;
    }
    
    NSDictionary *param = @{@"token":LYTOKEN};
    
    [HSNetWorking postWithURLString:@"v1/lottery/querymerchantuser" parameters:param success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        NSLog(@"%@",dic);
        
        block(dic);
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        
    }];
    
    
    
    
}

-(void)judgeZhiFuIsOk:(void(^)(id result))block  andFailBlock:(void(^)(NSError *error))failBlock
{
    
    if (!LYTOKEN) {
        
        return;
    }

    NSDictionary *param = @{@"token":LYTOKEN};
    
    [HSNetWorking postWithURLString:@"system/hidepay" parameters:param success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        block(dic);
        
    } failure:^(NSError *error) {
        
        failBlock(error);
       // [SVProgressHUD showErrorWithStatus:@"网络异常"];
        
    }];

}






@end
