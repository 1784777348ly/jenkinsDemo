//
//  TWVIPModelView.m
//  ticketWaiter
//
//  Created by LY on 16/12/30.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "TWVIPModelView2.h"
#import "TWVIPModel.h"
#import "TWVIPViewController.h"

#import "TWSendMoneyVC.h"

#import "HGSaveNoticeTool.h"
#import "HGPlaceholderView.h"


#define PAGESIZES  12

@implementation TWVIPModelView2

#pragma mark - 获取会员列表  会员管理
-(void)obtainPaybackDataWithTableView:(TWVIPViewController *)myTableViewVC  andFreshType:(NSInteger)freshType
{

    
    if (freshType==1&&myTableViewVC.dataArr.count>0) {
        
        [myTableViewVC.dataArr removeAllObjects];
    }
    
    if (freshType == 1 && myTableViewVC.dataArr.count ==0) {
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
        [SVProgressHUD showWithStatus:@"查询中..."];
    }
    
    
    
    //历史数据
    NSArray *hisArr = [HGSaveNoticeTool obtainCatheArrayWithKey:@"querystationbinduserlist"];

#warning --------  保证会员的实时有效性  不管上拉 下拉都要先更新数据
    
    NSDictionary *param = @{@"token":LYTOKEN};
    
    [HSNetWorking postWithURLString:@"v*/lotterymanager/querystationbinduserlist" parameters:param success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        NSLog(@"%@",dic);

        if ([dic[@"success"] integerValue] == 1) {
            
            NSArray *allArr = dic[@"result"];
            
            if (allArr.count > 0) {
                
                NSInteger num = PAGESIZES;
                
                if (allArr.count > PAGESIZES) {
                    
                    //先判断类型
                    if (freshType == 1) {
                        //正常加载
                        num = PAGESIZES;
                        
                    }else if (freshType == 2){
                        //下拉刷新
                        [myTableViewVC.dataArr removeAllObjects];
                        num = PAGESIZES;
                        
                    }else{
                        //上拉加载
                        NSInteger nowNum = myTableViewVC.dataArr.count;
                        
                        [myTableViewVC.dataArr removeAllObjects];
                        
                        if (allArr.count > nowNum) {
                            
                            if (allArr.count - nowNum > PAGESIZES) {
                                
                                num = nowNum+PAGESIZES;
                            }else{
                                
                                num = allArr.count;
                            }
                            
                        }else{
                            
                            num = allArr.count;
                            
                        }
                        
                    }
                    
                }else{
                    
                    [myTableViewVC.dataArr removeAllObjects];
                    
                    num = allArr.count;
                }
                
                
                
                for (int i=0; i<num; i++) {
                    
                    NSMutableDictionary *dicc = [allArr[i] mutableCopy];
                    
                    NSArray *dictKeysArray = [dicc allKeys];
                    for (int i = 0; i<dictKeysArray.count; i++) {
                        
                        NSString *key = dictKeysArray[i];
                        
                        if ([[dicc objectForKey:key] isEqual:[NSNull null]]) {
                            
                            [dicc setValue:@"" forKey:key];
                        }

                    }

                    TWVIPModel *model = [[TWVIPModel alloc] init];
                    
                    [model setValuesForKeysWithDictionary:dicc];
                    
                    [myTableViewVC.dataArr addObject:model];
                }
                
                //把会员都存起来
                [HGSaveNoticeTool updateCatheWithKey:@"querystationbinduserlist" andValue:dic[@"result"]];
                
            }else{
                //会员列表空 没有数据
                [self showPlaceholderView:myTableViewVC andPtype:2];
            }

            [myTableViewVC.myTableView reloadData];
            
            [myTableViewVC.myTableView.mj_header endRefreshing];
            [myTableViewVC.myTableView.mj_footer endRefreshing];
        }else{
            
            if (myTableViewVC.dataArr.count > 0) {
                
                
            }else{
                
                //系统有问题  并且还没有数据
                if (hisArr.count >0 ) {
                    
                    NSInteger num = PAGESIZES;
                     if (hisArr.count > PAGESIZES) {
                         
                         num = PAGESIZES;
                     }else{
                     
                         num = hisArr.count;
                     }
                    
                    for (int i=0; i<num; i++) {
                        
                        NSDictionary *dicc = hisArr[i];
                        
                        TWVIPModel *model = [[TWVIPModel alloc] init];
                        
                        [model setValuesForKeysWithDictionary:dicc];
                        
                        [myTableViewVC.dataArr addObject:model];
                    }

                }else{
                
                    //会员列表空 没有数据
                    [self showPlaceholderView:myTableViewVC andPtype:3];
                
                }
                
                [myTableViewVC.myTableView reloadData];

            }
            
            [myTableViewVC.myTableView.mj_header endRefreshing];
            [myTableViewVC.myTableView.mj_footer endRefreshing];

            // [SVProgressHUD showErrorWithStatus:dic[@"em"]];
            
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        
        if (error.code == -1009) {
            
            //  NSLog(@"您已经断网了的");
            if (myTableViewVC.dataArr.count > 0) {
                
            }else{
                //系统有问题  并且还没有数据
                if (hisArr.count >0 ) {
                    
                    NSInteger num = PAGESIZES;
                    if (hisArr.count > PAGESIZES) {
                        
                        num = PAGESIZES;
                    }else{
                        
                        num = hisArr.count;
                    }
                    
                    for (int i=0; i<num; i++) {
                        
                        NSDictionary *dicc = hisArr[i];
                        
                        TWVIPModel *model = [[TWVIPModel alloc] init];
                        
                        [model setValuesForKeysWithDictionary:dicc];
                        
                        [myTableViewVC.dataArr addObject:model];
                    }
                    
                }else{
                    
                    //会员列表空 没有数据
                    [self showPlaceholderView:myTableViewVC andPtype:1];
                    
                }
                
                [myTableViewVC.myTableView reloadData];
                
            }

            
        }else{
            
            if (myTableViewVC.dataArr.count > 0) {
                
            }else{
                //系统有问题  并且还没有数据
                if (hisArr.count >0 ) {
                    
                    NSInteger num = PAGESIZES;
                    if (hisArr.count > PAGESIZES) {
                        
                        num = PAGESIZES;
                    }else{
                        
                        num = hisArr.count;
                    }
                    
                    for (int i=0; i<num; i++) {
                        
                        NSDictionary *dicc = hisArr[i];
                        
                        TWVIPModel *model = [[TWVIPModel alloc] init];
                        
                        [model setValuesForKeysWithDictionary:dicc];
                        
                        [myTableViewVC.dataArr addObject:model];
                    }
                    
                }else{
                    
                    //会员列表空 没有数据
                    [self showPlaceholderView:myTableViewVC andPtype:3];
                    
                }
                
                [myTableViewVC.myTableView reloadData];
                
            }

            // NSLog(@"服务器异常");
            
        }
        
    
     
     [myTableViewVC.myTableView reloadData];

     
     [myTableViewVC.myTableView.mj_header endRefreshing];
     [myTableViewVC.myTableView.mj_footer endRefreshing];
     
     
     // [SVProgressHUD showErrorWithStatus:@"网络异常"];
        [SVProgressHUD dismiss]; 
    }];
    

    
    
    
    

}

#pragma mark - 会员列表展示占位图
-(void)showPlaceholderView:(TWVIPViewController *)myTableViewVC andPtype:(NSInteger)pType
{
     myTableViewVC.placeHolderView.hidden = NO;
     [myTableViewVC.placeHolderView setPlaceHolderViewWithType:pType];

}




#pragma mark - 获得会员列表    赠送彩金的时候
-(void)obtainVIPListWithTableView:(TWSendMoneyVC *)myTableViewVC andFreshType:(NSInteger)freshType
{
    
    
    
    if (freshType==1&&myTableViewVC.dataArr.count>0) {
        
        [myTableViewVC.dataArr removeAllObjects];
    }
    

    //历史数据
    NSArray *hisArr = [HGSaveNoticeTool obtainCatheArrayWithKey:@"querystationbinduserlist"];
    
#warning --------  保证会员的实时有效性  不管上拉 下拉都要先更新数据
    
    NSDictionary *param = @{@"token":LYTOKEN};
    
    [HSNetWorking postWithURLString:@"v*/lotterymanager/querystationbinduserlist" parameters:param success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        NSLog(@"%@",dic);
        
        if ([dic[@"success"] integerValue] == 1) {
            
            NSArray *allArr = dic[@"result"];
            
            if (allArr.count > 0) {
                
                NSInteger num = PAGESIZES;
                
                if (allArr.count > PAGESIZES) {
                    
                    //先判断类型
                    if (freshType == 1) {
                        //正常加载
                        num = PAGESIZES;
                        
                    }else if (freshType == 2){
                        //下拉刷新
                        [myTableViewVC.dataArr removeAllObjects];
                        num = PAGESIZES;
                        
                    }else{
                        //上拉加载
                        NSInteger nowNum = myTableViewVC.dataArr.count;
                        
                        [myTableViewVC.dataArr removeAllObjects];
                        
                        if (allArr.count > nowNum) {
                            
                            if (allArr.count - nowNum > PAGESIZES) {
                                
                                num = nowNum+PAGESIZES;
                            }else{
                                
                                num = allArr.count;
                            }
                            
                        }else{
                            
                            num = allArr.count;
                            
                        }
                        
                    }
                    
                }else{
                    
                    [myTableViewVC.dataArr removeAllObjects];
                    
                    num = allArr.count;
                }
                
                
                
                for (int i=0; i<num; i++) {
                    
                    NSMutableDictionary *dicc = [allArr[i] mutableCopy];
                    
                    NSArray *dictKeysArray = [dicc allKeys];
                    for (int i = 0; i<dictKeysArray.count; i++) {
                        
                        NSString *key = dictKeysArray[i];
                        
                        if ([[dicc objectForKey:key] isEqual:[NSNull null]]) {
                            
                            [dicc setValue:@"" forKey:key];
                        }
                        
                    }
                    
                    TWVIPModel *model = [[TWVIPModel alloc] init];
                    
                    [model setValuesForKeysWithDictionary:dicc];
                    
                    [myTableViewVC.dataArr addObject:model];
                }
                
                //把会员都存起来
                [HGSaveNoticeTool updateCatheWithKey:@"querystationbinduserlist" andValue:dic[@"result"]];
                
            }else{
                //会员列表空 没有数据
                [self showPlaceholderViewX:myTableViewVC andPtype:2];
            }
            
            [myTableViewVC.myTableView reloadData];
            
            [myTableViewVC.myTableView.mj_header endRefreshing];
            [myTableViewVC.myTableView.mj_footer endRefreshing];
        }else{
            
            if (myTableViewVC.dataArr.count > 0) {
                
                
            }else{
                
                //系统有问题  并且还没有数据
                if (hisArr.count >0 ) {
                    
                    NSInteger num = PAGESIZES;
                    if (hisArr.count > PAGESIZES) {
                        
                        num = PAGESIZES;
                    }else{
                        
                        num = hisArr.count;
                    }
                    
                    for (int i=0; i<num; i++) {
                        
                        NSDictionary *dicc = hisArr[i];
                        
                        TWVIPModel *model = [[TWVIPModel alloc] init];
                        
                        [model setValuesForKeysWithDictionary:dicc];
                        
                        [myTableViewVC.dataArr addObject:model];
                    }
                    
                }else{
                    
                    //会员列表空 没有数据
                    [self showPlaceholderViewX:myTableViewVC andPtype:3];
                    
                }
                
                [myTableViewVC.myTableView reloadData];
                
            }
            
            [myTableViewVC.myTableView.mj_header endRefreshing];
            [myTableViewVC.myTableView.mj_footer endRefreshing];
            
            //[SVProgressHUD showErrorWithStatus:dic[@"em"]];
            
        }
        
    } failure:^(NSError *error) {
        
        if (error.code == -1009) {
            
            //  NSLog(@"您已经断网了的");
            if (myTableViewVC.dataArr.count > 0) {
                
            }else{
                //系统有问题  并且还没有数据
                if (hisArr.count >0 ) {
                    
                    NSInteger num = PAGESIZES;
                    if (hisArr.count > PAGESIZES) {
                        
                        num = PAGESIZES;
                    }else{
                        
                        num = hisArr.count;
                    }
                    
                    for (int i=0; i<num; i++) {
                        
                        NSDictionary *dicc = hisArr[i];
                        
                        TWVIPModel *model = [[TWVIPModel alloc] init];
                        
                        [model setValuesForKeysWithDictionary:dicc];
                        
                        [myTableViewVC.dataArr addObject:model];
                    }
                    
                }else{
                    
                    //会员列表空 没有数据
                    [self showPlaceholderViewX:myTableViewVC andPtype:1];
                    
                }
                
                [myTableViewVC.myTableView reloadData];
                
            }
            
            
        }else{
            
            if (myTableViewVC.dataArr.count > 0) {
                
            }else{
                //系统有问题  并且还没有数据
                if (hisArr.count >0 ) {
                    
                    NSInteger num = PAGESIZES;
                    if (hisArr.count > PAGESIZES) {
                        
                        num = PAGESIZES;
                    }else{
                        
                        num = hisArr.count;
                    }
                    
                    for (int i=0; i<num; i++) {
                        
                        NSDictionary *dicc = hisArr[i];
                        
                        TWVIPModel *model = [[TWVIPModel alloc] init];
                        
                        [model setValuesForKeysWithDictionary:dicc];
                        
                        [myTableViewVC.dataArr addObject:model];
                    }
                    
                }else{
                    
                    //会员列表空 没有数据
                    [self showPlaceholderViewX:myTableViewVC andPtype:3];
                    
                }
                
                [myTableViewVC.myTableView reloadData];
                
            }
            
            // NSLog(@"服务器异常");
            
        }
        
        
        
        [myTableViewVC.myTableView reloadData];
        
        
        [myTableViewVC.myTableView.mj_header endRefreshing];
        [myTableViewVC.myTableView.mj_footer endRefreshing];
        
        
       // [SVProgressHUD showErrorWithStatus:@"网络异常"];
        
    }];
    



}


#pragma mark - 会员列表展示占位图  赠送彩金
-(void)showPlaceholderViewX:(TWSendMoneyVC *)myTableViewVC andPtype:(NSInteger)pType
{
    myTableViewVC.placeHolderView.hidden = NO;
    [myTableViewVC.placeHolderView setPlaceHolderViewWithType:pType];
    
}






//获取英泰的操作令牌
-(void)obtainIWTTokenWithReturnBlock:(void(^)(id result))block
{

    
    NSDictionary *param = @{@"token":LYTOKEN,@"stationno":[[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"stationno"] description],@"stationprovince":[[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"stationprovince"] description]};
    
    [HSNetWorking postWithURLString:@"v*/lottery/getchanneltoken" parameters:param success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        NSLog(@"%@",dic);
        
        block(dic);
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
        
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        
    }];




}

#pragma mark - 修改备注
-(void)modifyRemarkWithDic:(NSDictionary *)memberDic andReturnBlock:(void(^)(id result))block
{
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD showWithStatus:@"修改中..."];
    
    [HSNetWorking postWithURLString:@"v1/lottery/updatemerchantmember" parameters:memberDic success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        NSLog(@"%@",dic);
        
        block(dic);
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
        
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        
    }];


}

#pragma mark - 同步更新用户
-(void)addMemberWithDic:(NSDictionary *)dic andReturnBlock:(void(^)(id result))block
{
    
    [HSNetWorking postWithURLString:@"v*/lottery/bindmerchantusersync" parameters:dic success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        NSLog(@"%@",dic);
        
        block(dic);
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
        
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        
    }];




}








@end
