//
//  TWPayBackViewModel.m
//  ticketWaiter
//
//  Created by LY on 17/1/14.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWPayBackViewModel.h"
#import "TWPayBackModel.h"
#import "TWPayBackVC.h"

#import "HGSaveNoticeTool.h"
#import "HGPlaceholderView.h"

@implementation TWPayBackViewModel

-(void)fetchDonateListWith:(TWPayBackVC *)vc
{
    
//    NSArray *arr = @[
//                     @{@"phone":@"1324567890",@"nickname":@"小妹妹",@"money":@"12",@"payreason":@"赠送金额",@"time":@"2016－9－21"},
//                     @{@"phone":@"1324567890",@"nickname":@"小妹妹",@"money":@"12",@"payreason":@"赠送金额",@"time":@"2016－9－21"},
//                     @{@"phone":@"1324567890",@"nickname":@"小妹妹",@"money":@"12",@"payreason":@"赠送金额",@"time":@"2016－9－21"},
//                     @{@"phone":@"1324567890",@"nickname":@"小妹妹",@"money":@"12",@"payreason":@"赠送金额",@"time":@"2016－9－21"}
//                     
//                     ];
//    
//    for (int i=0; i<arr.count; i++) {
//        
//        NSDictionary *dic = arr[i];
//        
//        TWPayBackModel *model = [[TWPayBackModel alloc] init];
//        
//        model.phoneNum = dic[@"phone"];
//        model.nickName = dic[@"nickname"];
//        model.moneys = dic[@"money"];
//        model.payResons = dic[@"payreason"];
//        model.time = dic[@"time"];
//        
//        [vc.dataArr addObject:model];
//    }
//    
//    [vc.myTableView reloadData];

}


/*************************************我的奖励*******************************************/

-(void)obtainPaybackDataWithTableViewVC:(TWPayBackVC *)myTableViewVC andDataArr:(NSMutableArray *)dataArr  andRefshType:(NSInteger)type
{
    
    //type   1 2 第一次进来  下拉刷新  3 上拉加载
    //判断有没有TOKEN
    if(!LYTOKEN){
        
        [myTableViewVC.myTableView.mj_header endRefreshing];
        [myTableViewVC.myTableView.mj_footer endRefreshing];
        
        return;
    }
    
    //读缓存
    NSArray *catheArr = [HGSaveNoticeTool obtainCatheArrayWithKey:@"getgivemoneyrecordlist"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjects:@[LYTOKEN,@(20)] forKeys:@[@"token",@"pagesize"]];
    
    if (type == 1 || type == 2) {
        
        
        
    }else{
        
        TWPayBackModel *model = [dataArr lastObject];
        
        [param setObject:[NSNumber numberWithDouble:model.updatetime] forKey:@"lasttime"];
        
    }
    
    [HSNetWorking postWithURLString:@"v*/lottery/getgivemoneyrecordlist" parameters:param success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        NSLog(@"%@",dic);
        
        if ([dic[@"success"] integerValue] == 1) {
            
            NSMutableArray *result = [dic[@"result"] mutableCopy];
            
            for (int i=0; i<result.count; i++) {
                
                NSMutableDictionary *tmpDic = [result[i] mutableCopy];
                NSArray *dictKeysArray = [tmpDic allKeys];
                for (int i = 0; i<dictKeysArray.count; i++) {
                    
                    NSString *key = dictKeysArray[i];
                    if ([[tmpDic objectForKey:key] isEqual:[NSNull null]]) {
                        [tmpDic setValue:@"" forKey:key];
                    }
                    
                }
            }
            
            
            //数据转换
            [self jieXiShuju:result andDataArr:dataArr andInsertType:type andVc:myTableViewVC andPlaceholderType:2];
            
            [HGSaveNoticeTool updateCatheWithKey:@"getgivemoneyrecordlist" andValue:result];
            
        }else{
            
            if (dataArr.count > 0) {
                
            }else{
                
                [self jieXiShuju:catheArr andDataArr:dataArr andInsertType:1 andVc:myTableViewVC andPlaceholderType:2];
                
            }
          //  [SVProgressHUD showErrorWithStatus:dic[@"em"]];
            
        }
        
        [myTableViewVC.myTableView reloadData];
        
        [myTableViewVC.myTableView.mj_header endRefreshing];
        [myTableViewVC.myTableView.mj_footer endRefreshing];
        
        
    } failure:^(NSError *error) {
        
        if (dataArr.count > 0) {
            
            
        }else{
            
            
            if (error.code == -1009) {
                
                [self jieXiShuju:catheArr andDataArr:dataArr andInsertType:1 andVc:myTableViewVC andPlaceholderType:1];
                //  NSLog(@"您已经断网了的");
            }else{
                
                [self jieXiShuju:catheArr andDataArr:dataArr andInsertType:1 andVc:myTableViewVC andPlaceholderType:3];
                // NSLog(@"服务器异常");
                
            }
            
        }
        
        [myTableViewVC.myTableView reloadData];
        
        //连不上服务器
        //[SVProgressHUD showErrorWithStatus:@"网络异常"];
        
        [myTableViewVC.myTableView.mj_header endRefreshing];
        [myTableViewVC.myTableView.mj_footer endRefreshing];
    }];
    
    
    
    
    
    
    //如果没有网
    //    if (catheArr.count==0) {
    //
    //        //没有网 还没有数据
    //        [myTableViewVC.myTableView.mj_header endRefreshing];
    //        [myTableViewVC.myTableView.mj_footer endRefreshing];
    //
    //    }else if(!myTableViewVC.netRachable&&catheArr.count>0){
    //
    //        //没有网 有缓存数据
    //        //拿缓存数据  然后显示网络断开连接
    //        [self jieXiShuju:catheArr andDataArr:dataArr andInsertType:1];
    //
    //
    //        [myTableViewVC.myTableView.mj_header endRefreshing];
    //        [myTableViewVC.myTableView.mj_footer endRefreshing];
    //
    //
    //    }else if (myTableViewVC.netRachable&&catheArr.count>0){
    //
    //        //有网
    //
    //
    //
    //    }
    
    
}

-(void)jieXiShuju:(NSArray *)arr andDataArr:(NSMutableArray *)dataArr andInsertType:(NSInteger)insertType andVc:(TWPayBackVC *)myTableViewVC andPlaceholderType:(NSInteger)placeHolderType
{
    
    if (arr.count==0) {
#warning  ========= 添加占位图
        
        myTableViewVC.placeHolderView.hidden = NO;
        //没有缓存数据
        if(dataArr.count == 0&&placeHolderType == 2){
            
            [myTableViewVC.placeHolderView setPlaceHolderViewWithType:2];
            
        }else if(placeHolderType == 1){
            
            [myTableViewVC.placeHolderView setPlaceHolderViewWithType:1];
            
        }else{
            
            [myTableViewVC.placeHolderView setPlaceHolderViewWithType:3];
            
            
        }
        
        
    }else{
        
        //insertType 插入方式  插在最前面2   插在最后面1/3
        
        if (insertType == 2) {
            
            [dataArr removeAllObjects];
        }
        for (int i=0; i<arr.count; i++) {
            
            NSDictionary *dic = arr[i];

            
           // if ([dic[@"status"] integerValue] == 1) {
                
                TWPayBackModel *model = [[TWPayBackModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dic];
                
                [dataArr addObject:model];
            //}
            
        }
        
    }
    
}



#pragma mark - 赠送彩金
-(void)donateMoneyInfoWithMoney:(NSInteger )money andMemberId:(NSString *)memberId returnBack:(void(^)(id result))block
{
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD showWithStatus:@"支付中..."];
    
    NSDictionary *param = @{@"token":LYTOKEN,@"chargeamount":@(money),@"memberid":memberId,@"stationno":[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"stationno"],@"stationprovince":[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"stationprovince"]};
    
    [HSNetWorking postWithURLString:@"v*/lottery/usercharge" parameters:param success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSLog(@"%@",dic);
        block(dic);
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        
    }];


}








@end
