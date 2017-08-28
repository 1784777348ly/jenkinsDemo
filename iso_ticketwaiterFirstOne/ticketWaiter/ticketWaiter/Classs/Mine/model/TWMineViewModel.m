//
//  TWMineViewModel.m
//  ticketWaiter
//
//  Created by LY on 16/12/29.
//  Copyright © 2016年 hui10. All rights reserved.
//

/* 银联快捷支付 */
#import "TWMineViewModel.h"
#import "UPPaymentControl.h"
#import "TWOpenAndPayVC.h"

#import "TWCardListVC.h"

#import "TWMineModel.h"

#import "HGSaveNoticeTool.h"
#import "HGPlaceholderView.h"


/* 苹果支付 */
#import "UPAPayPlugin.h"
#import <PassKit/PassKit.h>

// TODO 商户需要换用自己的mertchantID
#define kAppleMerchantID        @"merchant.com.hui10.mitu"


//00 线上模式  01 测试模式
#define tnMode             @"01"

@interface TWMineViewModel ()<UPAPayPluginDelegate,UIAlertViewDelegate>


@end

@implementation TWMineViewModel

#pragma mark - 调起银联支付
-(void)startPayWith:(TWOpenAndPayVC *)payVc andMoney:(NSInteger)money andOrderId:(NSString *)orderId andPayType:(NSInteger)payType
{

    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD showWithStatus:@"获取中..."];
   
#warning ---------------------------------------------------------------- 调起银联支付
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] initWithObjects:@[@(1),orderId,TOKEN,@(1)] forKeys:@[@"flag",@"orderid",@"token",@"totalfee"]];
    
    if (payType == 1) {
        
        [paraDic setValue:@"Q001" forKey:@"paytype"];
        
    }else{
    
         [paraDic setValue:@"Q002" forKey:@"paytype"];
        
    }

    //http://pay.webtest.hui10.com/payproxy/v1/unionpay/phonepaytn 开发
    //http://223.223.184.83:8082/payproxy/v1/unionpay/phonepaytn
    
    [HSNetWorking postWithURLString:@"http://223.223.184.83:8082/payproxy/v1/unionpay/phonepaytn" parameters:paraDic success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        NSLog(@"%@",dic);
        
        if ([dic[@"success"] boolValue] == 1) {
            
            [SVProgressHUD dismiss];
 
            [self uploadTn:[dic[@"result"] description] andCurrentVC:payVc andPayType:payType];
            
        }else{
            
            
         [SVProgressHUD showErrorWithStatus:dic[@"em"]];

            
        }
        
    } failure:^(NSError *error) {
        
         [SVProgressHUD dismiss];
        
        NSLog(@"%@",error);
        
        
    }];
    


}

-(void)uploadTn:(NSString *)tn andCurrentVC:(TWOpenAndPayVC *)vc andPayType:(NSInteger)payType{


    if (tn != nil && tn.length > 0)
    {
        
        //银联支付
        if (payType == 1) {
            
           // NSLog(@"tn=%@",tn);
            [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"UPPayDemo" mode:tnMode viewController:vc];
            
        }else{
        
            //苹果支付
        
            
            if(![PKPaymentAuthorizationViewController canMakePayments])
            {
                
                [SVProgressHUD showErrorWithStatus:@"你的手机不支持Apple pay"];
                NSLog(@"手机不支持Apple pay");
                return;
            }
            
            
            //        NSArray *supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard,PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay];
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue]>=9.2) {
                
                if([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkChinaUnionPay]])
                {
                    
                    [UPAPayPlugin startPay:tn mode:tnMode viewController:vc delegate:self andAPMechantID:kAppleMerchantID];
                }else{
                    
                    [SVProgressHUD showErrorWithStatus:@"你的帐户未绑定Apple pay账号"];
                    
                    NSLog(@"不好意思  你的帐户未绑定Apple pay账号");
                    
                }
                
            }
        
        }
        
        
        
    }



}

#pragma mark - 得到银联支付结果
-(void)getPayResult
{
    
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD showWithStatus:@"获取中..."];
    
    NSDictionary *paraDic = @{@"flag":@(1),@"orderid":[UserDefaults objectForKey:@"orderId"],@"token":TOKEN,@"paytype":@"Q001"};
    
    //开发 http://pay.webtest.hui10.com/payproxy/v1/unionpay/checkorderstatus
    
    //http://223.223.184.83:8082/payproxy/v1/unionpay/checkorderstatus
    
    [HSNetWorking postWithURLString:@"http://223.223.184.83:8082/payproxy/v1/unionpay/checkorderstatus" parameters:paraDic success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        NSLog(@"%@",dic);
        
        if ([dic[@"success"] boolValue] == 1) {
            
            [SVProgressHUD dismiss];
            
            //跳转到成功页面  原来的界面刷新成新的页面
            
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"yinlianPayReslut" object:nil userInfo:dic];
            
            
            
        }else{
            
            //ec = 102060037, 取消订单交易
            
            [SVProgressHUD showErrorWithStatus:dic[@"em"]];
            
            
        }
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        
    }];

}


#pragma mark - 苹果支付代理方法
#pragma mark -
#pragma mark 响应控件返回的支付结果
#pragma mark -
- (void)UPAPayPluginResult:(UPPayResult *)result
{
    
    
    if(result.paymentResultStatus == UPPaymentResultStatusSuccess) {
        NSString *otherInfo = result.otherInfo?result.otherInfo:@"";
        NSString *successInfo = [NSString stringWithFormat:@"支付成功\n%@",otherInfo];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付成功" message:otherInfo delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
        
        //[self showAlertMessage:successInfo];
    }
    else if(result.paymentResultStatus == UPPaymentResultStatusCancel){
        
        [SVProgressHUD showErrorWithStatus:@"支付取消"];
        
       // [self showAlertMessage:@"支付取消"];
    }
    else if (result.paymentResultStatus == UPPaymentResultStatusFailure) {
        
        NSString *errorInfo = [NSString stringWithFormat:@"%@",result.errorDescription];
        
        [SVProgressHUD showErrorWithStatus:errorInfo];
        
       // [self showAlertMessage:errorInfo];
    }
    else if (result.paymentResultStatus == UPPaymentResultStatusUnknownCancel)  {
        
        //TODO UPPAymentResultStatusUnknowCancel表示发起支付以后用户取消，导致支付状态不确认，需要查询商户后台确认真实的支付结果
        NSString *errorInfo = [NSString stringWithFormat:@"支付过程中用户取消了，请查询后台确认订单"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付成功" message:errorInfo delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
        
       // [self showAlertMessage:errorInfo];
        
    }
}

#pragma mark - ----------- 查看银行卡列表
-(void)fetchCardList:(TWCardListVC *)vc
{
//    NSArray *arr = @[@{@"cardname":@"招商",@"cardNumber":@"1242"},@{@"cardname":@"工商",@"cardNumber":@"7464"}];
//    
//    
//    for (int i=0; i<arr.count; i++) {
//        
//        NSDictionary *dic= arr[i];
//        
//        TWOpenAccountModel *model = [[TWOpenAccountModel alloc] init];
//        model.title =  dic[@"cardname"];
//        model.subTitle = dic[@"cardNumber"];
//        model.isAccount = 1;
//        
//        [vc.dataArr addObject:model];
//    }
//    
//    
//    [vc.myTableView reloadData];
    
    
    
    
    
    if (!LYTOKEN) {
        return;
    }
    
    
    //获得银行卡列表信息
    NSDictionary *dic = [HGSaveNoticeTool obtainCatheDictionaryWithKey:@"getbindingquickpay"];
    
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD showWithStatus:@"查询卡信息..."];

    NSDictionary *param = @{@"token":LYTOKEN};
    
    [HSNetWorking postWithURLString:@"v*/lottery/getbindingquickpay" parameters:param success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        NSLog(@"%@",dic);

        if([dic[@"success"] integerValue] == 1){
        
            NSDictionary *dataDic = [dic[@"result"] firstObject];

            TWOpenAccountModel *model = [[TWOpenAccountModel alloc] init];
            model.title = dataDic[@"bankname"];
            model.subTitle = [NSString stringWithFormat:@"尾号 %@",dataDic[@"card"]];
            model.bindid = dataDic[@"bindid"];
            model.mid = dataDic[@"mid"];
            model.payid = dataDic[@"payid"];
            model.isAccount = 1;

            
            [SVProgressHUD dismiss];
            
            [HGSaveNoticeTool updateCatheWithKey:@"getbindingquickpay" andValue:dataDic];
            
            [vc.dataArr addObject:model];

        }else{
        
            [SVProgressHUD showErrorWithStatus:dic[@"em"]];
            
            if (dic) {
                
                TWOpenAccountModel *model = [[TWOpenAccountModel alloc] init];

                model.title = dic[@"bankname"];
                model.subTitle = [NSString stringWithFormat:@"尾号 %@",dic[@"card"]];
                model.bindid = dic[@"bindid"];
                model.mid = dic[@"mid"];
                model.payid = dic[@"payid"];
                model.isAccount = 1;


                [vc.dataArr addObject:model];
                
            }else{
                //占位图
                [self setPlaceholderViewWithType:3 andVc:vc];
                
            
            }

        
        }
        
          [vc.myTableView reloadData];
        
        
        
        
    } failure:^(NSError *error) {
        
        
        if (dic) {
            
            TWOpenAccountModel *model = [[TWOpenAccountModel alloc] init];
            model.title = dic[@"bankname"];
            model.subTitle = [NSString stringWithFormat:@"尾号 %@",dic[@"card"]];
            model.bindid = dic[@"bindid"];
            model.mid = dic[@"mid"];
            model.payid = dic[@"payid"];
            model.isAccount = 1;
            
            [vc.dataArr addObject:model];
            [vc.myTableView reloadData];

            
        }else{
            //占位图
            if (error.code == -1009) {
                
                [self setPlaceholderViewWithType:1 andVc:vc];
                
                
                //  NSLog(@"您已经断网了的");
            }else{
                
                [self setPlaceholderViewWithType:3 andVc:vc];
                
                // NSLog(@"服务器异常");
                
            }

        }

        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        
    }];

    
    
    


}

-(void)setPlaceholderViewWithType:(NSInteger)type andVc:(TWCardListVC *)myTableViewVC
{
    myTableViewVC.placeHolderView.hidden = NO;
    
    [myTableViewVC.placeHolderView setPlaceHolderViewWithType:type];

}




#pragma mark - 修改登录密码
-(void)mofifyloginCode:(NSString *)oldPassword andNewPassword:(NSString *)newPassword andReturnBlock:(void(^)(id result))block
{
    NSDictionary *param = @{@"newpassword":newPassword,@"oldpassword":oldPassword,@"token":LYTOKEN};
    
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD showWithStatus:@"正在修改"];
    
    
    [HSNetWorking postWithURLString:@"v1/user/merchant/changpassword" parameters:param success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        block(dic);
        
    } failure:^(NSError *error) {
        
        if (error.code == -1009) {
            
            [SVProgressHUD showErrorWithStatus:@"请检查网络连接"];
            //  NSLog(@"您已经断网了的");
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"服务器异常"];
            // NSLog(@"服务器异常");
            
        }
        
    }];



}

#pragma mark - 查询卡信息
-(void)obtainCardInfoWithReturnBlock:(void(^)(id result))block
{
    
    if (!LYTOKEN) {
        return;
    }
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD showWithStatus:@"查询卡信息..."];

    
    
    NSDictionary *param = @{@"token":LYTOKEN};
    
    [HSNetWorking postWithURLString:@"v*/lottery/getbindingquickpay" parameters:param success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        NSLog(@"%@",dic);
        
        block(dic);
        
    } failure:^(NSError *error) {
        
 
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        
    }];




}

#pragma mark - 绑定银行卡
/*
 *   绑定银行卡
 */
-(void)boundCardWithParams:(NSDictionary *)params  andReturnBlock:(void(^)(id result))block
{
    
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD showWithStatus:@"绑卡中..."];
    
    [HSNetWorking postWithURLString:@"v*/lottery/bindquickpay" parameters:params success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        NSLog(@"%@",dic);
        
        block(dic);
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        
    }];




}

#pragma mark - 解除绑定银行卡
-(void)unboundCardWithParams:(NSDictionary *)params  andReturnBlock:(void(^)(id result))block
{
    
    [HSNetWorking postWithURLString:@"v*/lottery/unbindquickpay" parameters:params success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        NSLog(@"%@",dic);
        
        block(dic);

       
        
    } failure:^(NSError *error) {
        
        
    }];



}



#pragma mark - 升级为正式版
-(void)becomeFormalMember
{
    if (!LYTOKEN) {
        
        return;
    }
    
    NSDictionary *dic = [HGSaveNoticeTool obtainCatheDictionaryWithKey:@"getbindingquickpay"];
    
    NSString *payid = dic[@"payid"];
 
#warning --------------- 钱数
    NSDictionary *params = @{@"amount":@(300*100),@"payid":payid,@"token":LYTOKEN};
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD showWithStatus:@"处理中..."];
    
    
    [HSNetWorking postWithURLString:@"v*/lottery/pay" parameters:params success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        NSLog(@"%@",dic);
        
        if ([dic[@"success"] integerValue] == 1){
            
            [SVProgressHUD dismiss];
            
            if (_successBlock) {
                
                _successBlock(1);
            }
            
            
        }else{
        
            [SVProgressHUD showErrorWithStatus:dic[@"em"]];
        
        }

        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        
    }];

    
    




}



#pragma mark - 上传图片
-(void)uploadPicWithParams:(NSDictionary *)params  andReturnBlock:(void(^)(id result))block
{
    
  

    [HSNetWorking postWithURLString:@"v*/lottery/changhead" parameters:params success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
       // NSLog(@"%@",dic);
        
        block(dic);
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        
    }];


}


#pragma mark - 退出登录
/*
 *   退出登录
 */
-(void)logoutAndReturnBlock:(void(^)(id result))block
{
    if (!LYTOKEN) {
        return;
    }
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD showWithStatus:@"退出中..."];

    NSDictionary *param = @{@"token":LYTOKEN};
    
    [HSNetWorking postWithURLString:@"user/logout" parameters:param success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        

        block(dic);
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        
    }];
    


}

#pragma mark - 自动续费
-(void)autoPayWithType:(NSInteger)type ReturnBlock:(void(^)(id result))block
{
    if (!LYTOKEN) {
        return;
    }
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD showWithStatus:@"设置中..."];
    
    NSDictionary *param = @{@"token":LYTOKEN,@"autorenew":[NSString stringWithFormat:@"%zd",type]};
    
    [HSNetWorking postWithURLString:@"v*/lottery/updateautorenew" parameters:param success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        
        block(dic);
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        
    }];




}









@end
