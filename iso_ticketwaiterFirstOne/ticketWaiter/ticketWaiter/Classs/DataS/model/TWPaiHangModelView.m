//
//  TWPaiHangModelView.m
//  ticketWaiter
//
//  Created by LY on 16/12/30.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "TWPaiHangModelView.h"
#import "TWPaiHangModel.h"

#import "HGSaveNoticeTool.h"

#import "TWMyPaybackVC.h"
#import "HGTasksOfThreeVC.h"
#import "HGPlaceholderView.h"

@interface TWPaiHangModelView ()


@end

@implementation TWPaiHangModelView


/**********************************区域排行**************************************************/

-(void)obtainDataWithTableView:(UITableView *)myTableView andPalceHolderView:(HGPlaceholderView *)placeHolder andDataArr:(NSMutableArray *)dataArr andViewType:(NSInteger)types andRefshType:(NSInteger)freshType
{
    
   
    //types  1 2 3 左 中  右
    
    //freshType 1 2 3 第一次 下拉刷新 上拉加载
    
    //判断有没有TOKEN
    if(!LYTOKEN){
        
        [self endRefreshWith:myTableView];

        
        return;
    }
    
    
    NSMutableString *urlStr = [NSMutableString stringWithString:@"v*/lottery/rank/"];
    
    NSString *sufStr = nil;
    
    if (types == 1) {
        
        sufStr = @"amounttop";
    }else if (types == 2){
        sufStr = @"counttop";
    }else{
        sufStr = @"newmembertop";
    }
    
    
    
    NSString *tmpStr = [urlStr stringByAppendingString:sufStr];
    

    //读缓存
    NSArray *catheArr = [HGSaveNoticeTool obtainCatheArrayWithKey:sufStr];
    
    
    
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjects:@[LYTOKEN,[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"provinceid"],[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"cityid"]] forKeys:@[@"token",@"provinceid",@"cityid"]];
    
    
    
    if (freshType == 1 || freshType == 2) {
        
        
    }else{
        
        [self endRefreshWith:myTableView];
        
        return;
        
        TWPaiHangModel *model = [dataArr lastObject];
        
        [param setObject:[NSNumber numberWithDouble:[model.updatetime doubleValue]] forKey:@"lasttime"];
        
    }
    
    if (types == 1) {
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
        [SVProgressHUD showWithStatus:@"查询中..."];
    }

    [HSNetWorking postWithURLString:tmpStr parameters:param success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        if (types == 1) {
            
            NSLog(@"%@",dic);

        }
        
        
        if ([dic[@"success"] integerValue] == 1) {
            
            NSArray *result = dic[@"result"];
            
            
            
            //数据转换
            [self jieXiShuju:result andDataArr:dataArr andInsertType:freshType andPlaceHolderView:placeHolder andPlaceHolderView:1];
            
            [HGSaveNoticeTool updateCatheWithKey:sufStr andValue:result];
            
        }else{
            
            if (dataArr.count > 0) {
                
            }else{
                
                  [self jieXiShuju:catheArr andDataArr:dataArr andInsertType:1 andPlaceHolderView:placeHolder andPlaceHolderView:2];
                
            }
            [SVProgressHUD showErrorWithStatus:dic[@"em"]];
            
        }
        
        [myTableView reloadData];
        [SVProgressHUD dismiss];
        
        [self endRefreshWith:myTableView];

        
        
    } failure:^(NSError *error) {
        
        if (dataArr.count > 0) {
            
            
        }else{
            
            [self jieXiShuju:catheArr andDataArr:dataArr andInsertType:1 andPlaceHolderView:placeHolder andPlaceHolderView:3];
            
        }
        
        [myTableView reloadData];
        
        //连不上服务器
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        
        [self endRefreshWith:myTableView];
    }];


//    NSMutableArray *arr = [[NSMutableArray alloc] init];
//    
//    for (int i=0; i<9; i++) {
//    
//        NSArray *arrx = @[[NSString stringWithFormat:@"类型%zd大王彩票站%zd",types,i],
//                         @"img_logo_1",
//                         @[@"sss",@"ssss",@"sss"],
//                         @(i+1),
//                         @(arc4random()%1)
//                         ];
//        
//        NSDictionary *allDic = [[NSDictionary alloc] initWithObjects:arrx forKeys:@[@"title",@"headImage",@"images",@"numbers",@"isHaveJieJing"]];
//        
//        
//        [arr addObject:allDic];
//        
//    }
//    
//    
//    for (int i=0; i<arr.count; i++) {
//        
//        TWPaiHangModel *model = [[TWPaiHangModel alloc] init];
//        
//        [model setValuesForKeysWithDictionary:arr[i]];
//        
//        [dataArr addObject:model];
//
//    }
//    
//    [myTableView reloadData];
    

}

-(void)jieXiShuju:(NSArray *)arr andDataArr:(NSMutableArray *)dataArr andInsertType:(NSInteger)insertType  andPlaceHolderView:(HGPlaceholderView *)placeholder andPlaceHolderView:(NSInteger)placeHolderType
{
    
    if (arr.count==0) {
#warning  ========= 添加占位图
        //没有缓存数据
        
        placeholder.hidden = NO;
        //没有缓存数据
        if(dataArr.count == 0&&placeHolderType == 1){
            
            [placeholder setPlaceHolderViewWithType:2];
            
        }else if(placeHolderType == 2){
            
            [placeholder setPlaceHolderViewWithType:3];
            
        }else{
            
            [placeholder setPlaceHolderViewWithType:3];
            
            
        }
        
        
    }else{
        
        //insertType 插入方式  插在最前面2   插在最后面1/3
        
        if (insertType == 2) {
            
            [dataArr removeAllObjects];
        }
        for (int i=0; i<arr.count; i++) {
            
            NSMutableDictionary *dic = [arr[i] mutableCopy];
            
            NSArray *dictKeysArray = [dic allKeys];
            for (int i = 0; i<dictKeysArray.count; i++) {
                
                NSString *key = dictKeysArray[i];
                
                if ([[dic objectForKey:key] isEqual:[NSNull null]]) {
                    
                    [dic setValue:@"" forKey:key];
                }

            }
            
            //大图
            NSString *headImage = dic[@"head"];
            //小图
            NSString *litterImage = dic[@"pic"];
            
            NSMutableArray *litterImages = [[NSMutableArray alloc] init];
            
            if (headImage.length>0) {
               //有一张大图
                if (litterImage.length>0) {
                    //小图图片数组有值
                    if ([litterImage containsString:@","]) {
                        litterImages = [[litterImage componentsSeparatedByString:@","] mutableCopy];
                    }else{
                        [litterImages addObject:litterImage];
                    }
                }else{
                
                    //小图图片数组为空
                }
                
            }else{
            //没有大图
                if (litterImage.length>0) {
                    //小图图片数组有值
                    if ([litterImage containsString:@","]) {
                        headImage = [[litterImage componentsSeparatedByString:@","] objectAtIndex:0];
                        litterImages = [[litterImage componentsSeparatedByString:@","] mutableCopy];
                        [litterImages removeObjectAtIndex:0];
                    }else{
                        headImage = litterImage;
                    }
                }else{
                    //小图图片数组为空
                }

            }
                TWPaiHangModel *model = [[TWPaiHangModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dic];
            
                model.picArr = [litterImages mutableCopy];
                model.headImage = headImage;

                [dataArr addObject:model];

        }
        
        
        
        
    }
    
}



-(void)endRefreshWith:(UITableView *)tableView
{
    [tableView.mj_header endRefreshing];
    [tableView.mj_footer endRefreshing];

}





/*************************************我的奖励*******************************************/

-(void)obtainPaybackDataWithTableViewVC:(TWMyPaybackVC *)myTableViewVC andDataArr:(NSMutableArray *)dataArr  andRefshType:(NSInteger)type
{
    
    //type   1 2 第一次进来  下拉刷新  3 上拉加载
    //判断有没有TOKEN
    if(!LYTOKEN){
    
        [myTableViewVC.myTableView.mj_header endRefreshing];
        [myTableViewVC.myTableView.mj_footer endRefreshing];
        
        return;
    }

    //读缓存
    NSArray *catheArr = [HGSaveNoticeTool obtainCatheArrayWithKey:@"myreward"];
    
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjects:@[LYTOKEN,@(20)] forKeys:@[@"token",@"pagesize"]];
    
    if (type == 1 || type == 2) {
        
        
        
    }else{
        
        TWMyPaybackModel *model = [dataArr lastObject];
        
        [param setObject:[NSNumber numberWithDouble:model.createtime] forKey:@"lasttime"];
        
    }
    
    
    
    
    
    [HSNetWorking postWithURLString:@"v1/lottery/rank/myreward" parameters:param success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        NSLog(@"%@",dic);
        
        if ([dic[@"success"] integerValue] == 1) {
        
            NSArray *result = dic[@"result"];
            
            //数据转换
            [self jieXiShuju:result andDataArr:dataArr andInsertType:type andVc:myTableViewVC andPlaceholderType:2];
            
            
            if (type!=3) {
                
                [HGSaveNoticeTool updateCatheWithKey:@"myreward" andValue:result];
            }
            
            
        }else{
            
            if (dataArr.count > 0) {
                
            }else{
            
                [self jieXiShuju:catheArr andDataArr:dataArr andInsertType:1 andVc:myTableViewVC andPlaceholderType:2];

            }
            [SVProgressHUD showErrorWithStatus:dic[@"em"]];
            
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

-(void)jieXiShuju:(NSArray *)arr andDataArr:(NSMutableArray *)dataArr andInsertType:(NSInteger)insertType andVc:(TWMyPaybackVC *)myTableViewVC andPlaceholderType:(NSInteger)placeHolderType
{
    
    if (arr.count==0&&dataArr.count==0) {
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
            
            if ([dic[@"status"] integerValue] == 1) {
                
                TWMyPaybackModel *model = [[TWMyPaybackModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dic];
                
                model.descriptions = dic[@"description"];
                
                [dataArr addObject:model];
            }
            
        }
    
    }

}






@end
