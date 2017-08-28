//
//  TwOrderViewModel.h
//  ticketWaiter
//
//  Created by LY on 17/1/16.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OrderRefrashBlock)();

typedef void(^FreshChartsBlock)();

@class TWOrderViewController;
@interface TwOrderViewModel : NSObject

@property(nonatomic,copy)OrderRefrashBlock block;
@property(nonatomic,copy)FreshChartsBlock chartsBlock;


/*
 * 查询未投注订单
 */
-(void)obtainDataWithTableView:(UITableView *)tableView andDataArr:(NSMutableArray *)dataArr andViewType:(NSInteger)viewType andRefreshType:(NSInteger)rType andVC:(TWOrderViewController *)vc;


//获得订单总额 和  订单数  订单类型1日  2月
//
-(void)obtainOrderMoneyWithTableView:(UITableView *)tableView andDataArr:(NSMutableArray *)dataArr andViewType:(NSInteger)viewType andListType:(NSInteger)listType andAllMoneyOrderDic:(NSMutableDictionary *)moneyDic   andChartsDic:(NSMutableDictionary *)chartsDic andFreshType:(NSInteger)freshType;


//确认投放
-(void)besureToTouFangWithReturnBlock:(void(^)(id result))block;


//查询投放结果
-(void)searchTouFangResultsWithSerialNumber:(NSString *)serialNumber withReturnBlock:(void(^)(id result))block;


//延时  主动查询英泰订单数
-(void)findIWTOrderWithSerialNumber:(NSString *)serialNumber;








@end
