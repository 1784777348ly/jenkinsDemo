//
//  TwOrderViewModel.m
//  ticketWaiter
//
//  Created by LY on 17/1/16.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TwOrderViewModel.h"
#import "TWOrderModel.h"

#import "HGSaveNoticeTool.h"
#import "TWOrderViewController.h"
#import "HGPlaceholderView.h"

//获取wifi地址
#import <SystemConfiguration/CaptiveNetwork.h>

#import "NSDate+Methods.h"

#define pageSize  15

@implementation TwOrderViewModel

#pragma mark - 查询未投注订单
-(void)obtainDataWithTableView:(UITableView *)tableView andDataArr:(NSMutableArray *)dataArr andViewType:(NSInteger)viewType andRefreshType:(NSInteger)rType andVC:(TWOrderViewController *)vc
{
    

    if (!LYTOKEN) {
        return;
    }
    NSInteger  pageNum = 1;
    
    if(rType == 1){
        //正常
        pageNum = 1;
    
    }else if (rType == 2){
        //下拉刷新
        pageNum = 1;
        
    }else{
        //上拉加载
        
        if (dataArr.count<pageSize) {
            //没有20条数据 没有第二页的数据
            [tableView.mj_footer endRefreshing];
            [tableView reloadData];
            return;
        }else if(dataArr.count==pageSize){
            
            pageNum = 2;
            
        }else{
        
            pageNum = ceil(dataArr.count*1.0/pageSize)+1;

        }
        

    }
    
    NSString *urlStr = @"v*/lottery/queryunbetorderlist";
    if (viewType == 2) {
        
        urlStr = @"v*/lottery/getlotteryorderrecordlist";
    }
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjects:
                                        @[LYTOKEN,
                                          [HGSaveNoticeTool obtainPersonInfoDataWithKey:@"stationno"],
                                          [HGSaveNoticeTool obtainPersonInfoDataWithKey:@"stationprovince"],
                                          @(pageNum),
                                          @(pageSize)
                                          ]
                                  forKeys:
                                    @[@"token",
                                      @"stationno",
                                      @"stationprovince",
                                      @"pagenum",
                                      @"pagesize"
                                      ]
                                   ];
    if (viewType == 2) {
        
        [params removeObjectForKey:@"stationprovince"];
        [params removeObjectForKey:@"pagenum"];
        [params removeObjectForKey:@"pagesize"];
        [params setObject:@(pageSize) forKey:@"pagesize"];
        
        if (dataArr.count>0&&rType == 3) {
            
            TWOrderModel *model = [dataArr lastObject];
            
            [params setObject:[NSNumber numberWithDouble:[model.ordertime doubleValue]] forKey:@"lasttime"];
        }else{
        
           // [params setObject:@(0) forKey:@"lasttime"];
        }
        
        
    }

    if (viewType == 1 && rType == 1) {
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
        [SVProgressHUD showWithStatus:@"订单查询中..."];
    }
 
    
    [HSNetWorking postWithURLString:urlStr parameters:params success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        if (viewType == 2) {
           
            NSLog(@"==============================%@",dic);

        }
        
        
        
        if ([dic[@"success"] integerValue] == 1) {
            
            if (viewType == 1) {
                
                NSDictionary *result = dic[@"result"];
                
                //刷新总共订单数
                [vc refreshOrderNumberWithNum:[NSString stringWithFormat:@"%@",[result[@"total"] stringValue]]];
                NSArray *dataArrs = result[@"items"];
                
                //有数据信息
                if (dataArrs.count > 0) {
                    
                    if(rType == 1){
                        //正常
                        [dataArr removeAllObjects];
                        [self showBottomWithVC:vc];

                        
                    }else if (rType == 2){
                        //下拉刷新
                        [dataArr removeAllObjects];
                        
                    }else{
                        //上拉加载
                    }
                    
                    for (int i=0; i<dataArrs.count; i++) {
                        NSDictionary *tmpDic = dataArrs[i];
                        NSMutableDictionary *dataDic = [tmpDic mutableCopy];
                        
                        NSArray *dictKeysArray = [dataDic allKeys];
                        for (int i = 0; i<dictKeysArray.count; i++) {
                            
                            NSString *key = dictKeysArray[i];
                            
                            if ([[dataDic objectForKey:key] isEqual:[NSNull null]]) {
                                
                                [dataDic setValue:@"" forKey:key];
                            }
                        }
                        
                        TWOrderModel *model = [[TWOrderModel alloc] init];
                        [model setValuesForKeysWithDictionary:tmpDic];
                        [dataArr addObject:model];
                    }
                    
                }else{

                    //上拉加载没有数据 不管
                    if (rType != 3){
                        //没有数据
                        [self showPlaceholderView:vc andViewType:viewType andPtype:2];
                    }
                    
                    
                }

            }else{
                
                NSArray *arr = dic[@"result"];
                
                //有数据信息
                if (arr.count > 0) {
                    
                    if(rType == 1){
                        //正常
                        [dataArr removeAllObjects];
                        
                        [self showBottomWithVC:vc];

                        
                        
                        
                    }else if (rType == 2){
                        //下拉刷新
                        [dataArr removeAllObjects];
                        
                        
                    }else{
                        //上拉加载
                        
                    }
                    
                    for (int i=0; i<arr.count; i++) {
                        NSDictionary *tmpDic = arr[i];
                        
                        NSMutableDictionary *dataDic = [tmpDic mutableCopy];
                        
                        NSArray *dictKeysArray = [dataDic allKeys];
                        for (int i = 0; i<dictKeysArray.count; i++) {
                            
                            NSString *key = dictKeysArray[i];
                            
                            if ([[dataDic objectForKey:key] isEqual:[NSNull null]]) {
                                
                                [dataDic setValue:@"" forKey:key];
                            }
                            
                        }
                        TWOrderModel *model = [[TWOrderModel alloc] init];
                        [model setValuesForKeysWithDictionary:dataDic];
                        [dataArr addObject:model];
                    }
                    
                }else{
                    
                    if (rType != 3){
                    
                        //没有数据
                        [self showPlaceholderView:vc andViewType:viewType andPtype:2];
                    }
                   
                }
            }

            [tableView.mj_header endRefreshing];
            [tableView.mj_footer endRefreshing];
            [tableView reloadData];

        }else{
            
            //服务器异常
            if (dataArr.count > 0) {
                
                [self showBottomWithVC:vc];

                
                
            }else{
                
                if ([[dic[@"ec"] description] isEqualToString:@"103010009"]) {
                    
                    [self showPlaceholderView:vc andViewType:viewType andPtype:2];
                   
                }else if ([[dic[@"ec"] description] isEqualToString:@"103010017"]){
                    
                    [self showPlaceholderView:vc andViewType:viewType andPtype:2];

                    
                }else{
                
                    [self showPlaceholderView:vc andViewType:viewType andPtype:3];
                    
                    //  [SVProgressHUD showErrorWithStatus:dic[@"em"]];

                }
                
                
            }

          
            
        }
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshing];
        [tableView reloadData];

        //if (viewType == 1 && rType == 1) {
        
         [SVProgressHUD dismiss];
        
       // }
    } failure:^(NSError *error) {
        
        NSLog(@"error---------%@",error);
        
        if(dataArr.count >0){
            
            [self showBottomWithVC:vc];
            
    
        }else{
        
            if (error.code == -1009) {
                
                 [self showPlaceholderView:vc andViewType:viewType andPtype:2];
                //  NSLog(@"您已经断网了的");
            }else{
                
                 [self showPlaceholderView:vc andViewType:viewType andPtype:3];
                // NSLog(@"服务器异常");
                
            }
        }
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshing];
        [tableView reloadData];

        
        [SVProgressHUD dismiss];


    }];
    

}

-(void)showBottomWithVC:(TWOrderViewController *)vc
{
    [vc showBottomView];
    
    vc.holderViewL.placeholderBtn.hidden = 1;

}



#pragma mark - 添加占位图
-(void)showPlaceholderView:(TWOrderViewController *)myTableViewVC andViewType:(NSInteger)vType andPtype:(NSInteger)pType
{
    if (vType==1) {
        //左
        myTableViewVC.holderViewL.hidden = NO;
        [myTableViewVC.holderViewL setPlaceHolderViewWithType:pType];
        
        if (pType == 2) {
            
            [myTableViewVC.holderViewL setOrderSTitle:@"没有更多订单了的...."];
            [myTableViewVC hidBottomView];
            
            myTableViewVC.holderViewL.placeholderBtn.hidden = 0;
            
            
        }else{
        
            myTableViewVC.holderViewL.placeholderBtn.hidden = 0;

            [myTableViewVC hidBottomView];

        }
        
        
    }else if(vType==2) {
        //中间
        myTableViewVC.holderViewM.hidden = NO;
        myTableViewVC.middleView.bounces = NO;
        
        [myTableViewVC.holderViewM setPlaceHolderViewWithType:pType];
    }

}

-(void)findIWTOrderWithSerialNumber:(NSString *)serialNumber
{
    
    if (!LYTOKEN) {
        return;
    }
    
    NSDictionary *param = @{@"serialnumber":serialNumber,@"stationno":[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"stationno"],@"stationprovince":[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"stationprovince"],@"token":LYTOKEN};
    
    [HSNetWorking postWithURLString:@"v*/lottery/querysubstitutebetorderresult" parameters:param success:^(id responseObject) {

    } failure:^(NSError *error) {
        
    }];

}








#pragma mark - 比较两个天的大小
- (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    NSInteger aa;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd"];
    NSDate *dta = [self caculateDateWithStr:aDate];
    NSDate *dtb = [self caculateDateWithStr:bDate];
    
    dta = [dateformater dateFromString:[dateformater stringFromDate:dta]];
    dtb = [dateformater dateFromString:[dateformater stringFromDate:dtb]];
    NSComparisonResult result = [dta compare:dtb];
    if (result == NSOrderedSame)
    {
        aa=0;
    }else if (result==NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else if (result==NSOrderedDescending)
    {
        //bDate比aDate小
        aa=-1;
        
    }
    
    return aa;
}

#pragma mark - 比较两个月份的大小
-(NSInteger)compareMonth:(NSString*)aMonth withDate:(NSString*)bMonth
{
    
    NSInteger aa;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM"];
    NSDate *dta = [self caculateDateWithStr:aMonth];
    NSDate *dtb = [self caculateDateWithStr:bMonth];
    
    dta = [dateformater dateFromString:[dateformater stringFromDate:dta]];
    dtb = [dateformater dateFromString:[dateformater stringFromDate:dtb]];
    NSComparisonResult result = [dta compare:dtb];
    if (result == NSOrderedSame)
    {
        aa=0;
    }else if (result==NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else if (result==NSOrderedDescending)
    {
        //bDate比aDate小
        aa=-1;
    }
    return aa;
}

#pragma mark - 按月查询  按天查询
-(void)obtainOrderMoneyWithTableView:(UITableView *)tableView andDataArr:(NSMutableArray *)dataArr andViewType:(NSInteger)viewType andListType:(NSInteger)listType  andAllMoneyOrderDic:(NSMutableDictionary *)moneyDic  andChartsDic:(NSMutableDictionary *)chartsDic andFreshType:(NSInteger)freshType
{
    
    if (!LYTOKEN) {
        return;
    }
    NSString *urlStr = @"v*/lottery/getcountbydays";
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"stationno":[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"stationno"],
                                                                                    @"token":LYTOKEN,@"days":@(10)}];
    
    if (listType == 2) {
        
        [params removeObjectForKey:@"days"];
        [params setObject:@(12) forKey:@"months"];
        
        urlStr = @"v*/lottery/getcountbymonths";
    }
    
    
    //上拉加载
    if (freshType == 3) {
        
        if (![chartsDic[@"items"] isEqual:[NSNull null]]&&[chartsDic[@"items"] count]>0&&listType == 1) {

            [params setObject:[NSNumber numberWithDouble:[[[moneyDic[@"items"] lastObject] objectForKey:@"orderdate"] doubleValue]] forKey:@"lastdate"];
            
            
                NSInteger aa=[self compareDate:[[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"createtime"] description] withDate:[[[moneyDic[@"items"] lastObject] objectForKey:@"orderdate"] description]];
                
                //之前还有时间 没有交易单号
                if (aa == 1) {

                }else{
                    
                    [tableView reloadData];
                    [tableView.mj_footer endRefreshing];
                    return ;
                    
                }

        }else if (![chartsDic[@"items"] isEqual:[NSNull null]]&&[chartsDic[@"items"] count]>0&&listType == 2){
        
            [params setObject:[NSNumber numberWithDouble:[[[moneyDic[@"items"] lastObject] objectForKey:@"orderdate"] doubleValue]] forKey:@"lastdate"];
        
            NSInteger aa=[self compareMonth:[[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"createtime"] description] withDate:[[[moneyDic[@"items"] lastObject] objectForKey:@"orderdate"] description]];
            
            //之前还有时间 没有交易单号
            if (aa == 1) {
                
            }else{
                
                [tableView reloadData];
                [tableView.mj_footer endRefreshing];
                return ;
                
            }

        
        }
        
    }

    
    [HSNetWorking postWithURLString:urlStr parameters:params success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        
        NSLog(@"%@",dic);
        
        if ([dic[@"success"] integerValue] == 1) {
            
            
            if (freshType != 3) {
                [moneyDic  removeAllObjects];
                [chartsDic removeAllObjects];
            }
            
            NSDictionary *tmpDic = dic[@"result"];
            
            NSMutableArray *arrs = [[NSMutableArray alloc] initWithArray:tmpDic[@"items"]];
            
            NSMutableDictionary *diccc = [NSMutableDictionary dictionary];
            
            if(arrs.count>0){
            
                //倒叙的数组
                arrs = (NSMutableArray *)[[arrs reverseObjectEnumerator] allObjects];
                
                [diccc addEntriesFromDictionary:@{@"items":arrs,@"type":[NSString stringWithFormat:@"%zd",listType],@"total":tmpDic[@"total"]}];
            
            }
            
            if (freshType==3) {
                
                if (listType==2) {
                    
                    NSMutableArray *allShunArr = [[NSMutableArray alloc] initWithArray:chartsDic[@"items"]];
                    
                    [allShunArr insertObjects:[self createAllDatasWithInialDic:diccc andChartsType:listType andRefreshType:freshType andLastDate:[[[moneyDic[@"items"] lastObject] objectForKey:@"orderdate"] description]] atIndex:0];
                    
                    //表格展示的 是顺序的
                    [chartsDic setObject:allShunArr forKey:@"items"];
                    [chartsDic setObject:@([tmpDic[@"total"] integerValue]) forKey:@"total"];
                    [chartsDic setObject:[NSString stringWithFormat:@"%zd",listType] forKey:@"type"];
                    NSMutableArray *allNiArr = [[NSMutableArray alloc] init];
                    
                    [allNiArr addObjectsFromArray:[self createAllDatasWithInialDic:diccc andChartsType:listType andRefreshType:freshType andLastDate:[[[moneyDic[@"items"] lastObject] objectForKey:@"orderdate"] description]]];
                    //下面的列表展示的 是倒叙的
                    allNiArr = (NSMutableArray *)[[allNiArr reverseObjectEnumerator] allObjects];
                    
                    [allNiArr insertObjects:moneyDic[@"items"] atIndex:0];
                    [moneyDic setObject:allNiArr forKey:@"items"];
                    [moneyDic setObject:[NSString stringWithFormat:@"%zd",listType] forKey:@"type"];
                    [moneyDic setObject:@([tmpDic[@"total"] integerValue]) forKey:@"total"];

                    
                }else{
                
                NSMutableArray *allShunArr = [[NSMutableArray alloc] initWithArray:chartsDic[@"items"]];
                
                [allShunArr insertObjects:[self createAllDatasWithInialDic:diccc andChartsType:listType andRefreshType:freshType andLastDate:[[[moneyDic[@"items"] lastObject] objectForKey:@"orderdate"] description]] atIndex:0];

                //表格展示的 是顺序的
                [chartsDic setObject:allShunArr forKey:@"items"];
                [chartsDic setObject:@([tmpDic[@"total"] integerValue]) forKey:@"total"];
                [chartsDic setObject:[NSString stringWithFormat:@"%zd",listType] forKey:@"type"];
                NSMutableArray *allNiArr = [[NSMutableArray alloc] init];
                
                [allNiArr addObjectsFromArray:[self createAllDatasWithInialDic:diccc andChartsType:listType andRefreshType:freshType andLastDate:[[[moneyDic[@"items"] lastObject] objectForKey:@"orderdate"] description]]];
                //下面的列表展示的 是倒叙的
                allNiArr = (NSMutableArray *)[[allNiArr reverseObjectEnumerator] allObjects];
                
                [allNiArr insertObjects:moneyDic[@"items"] atIndex:0];
                [moneyDic setObject:allNiArr forKey:@"items"];
                [moneyDic setObject:[NSString stringWithFormat:@"%zd",listType] forKey:@"type"];
                [moneyDic setObject:@([tmpDic[@"total"] integerValue]) forKey:@"total"];
                
            }
            
            }else{
             
                if (arrs.count==0) {
                    NSMutableArray *allShunArr = [[NSMutableArray alloc] init];
                    allShunArr = [[self createDatesAndMoneyWithDateNowAndCreatetime:listType] mutableCopy];
                    //表格展示的 是顺序的
                    [chartsDic setObject:allShunArr forKey:@"items"];
                    [chartsDic setObject:[tmpDic[@"total"] description] forKey:@"total"];
                    [chartsDic setObject:[NSString stringWithFormat:@"%zd",listType] forKey:@"type"];
                    
                    //下面的列表展示的 是倒叙的
                    allShunArr = (NSMutableArray *)[[allShunArr reverseObjectEnumerator] allObjects];
                    [moneyDic setObject:allShunArr forKey:@"items"];
                    [moneyDic setObject:[NSString stringWithFormat:@"%zd",listType] forKey:@"type"];
                    [moneyDic setObject:[tmpDic[@"total"] description] forKey:@"total"];
                    
                }else{
                
                    NSMutableArray *allShunArr = [[NSMutableArray alloc] init];
                    allShunArr = [[self createAllDatasWithInialDic:diccc andChartsType:listType andRefreshType:freshType andLastDate:@"0"] mutableCopy];
                    //表格展示的 是顺序的
                    [chartsDic setObject:allShunArr forKey:@"items"];
                    [chartsDic setObject:tmpDic[@"total"] forKey:@"total"];
                    [chartsDic setObject:[NSString stringWithFormat:@"%zd",listType] forKey:@"type"];
                    //下面的列表展示的 是倒叙的
                    allShunArr = (NSMutableArray *)[[allShunArr reverseObjectEnumerator] allObjects];
                    
                    
                    if (listType == 2) {
                        
                        NSInteger num = 1;
                        num = [self offMonthWithFirstDate:[[allShunArr firstObject] objectForKey:@"orderdate"] andLastDate:[[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"createtime"] description]];
                        
                        if (num <= 0) {
                            num = 1;
                        }
                        
                        allShunArr = [[allShunArr subarrayWithRange:NSMakeRange(0, num)] mutableCopy];

                    }
                    
                    [moneyDic setObject:allShunArr forKey:@"items"];
                    [moneyDic setObject:[NSString stringWithFormat:@"%zd",listType] forKey:@"type"];
                    [moneyDic setObject:tmpDic[@"total"] forKey:@"total"];
                
                }

            }

            //补全数据字典
            
            if (_chartsBlock) {
                
                _chartsBlock();
            }
            
        }else{
            
            if ([[dic[@"ec"] description] isEqualToString:@"103010009"]) {
                
//                [[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"createtime"] description]
//                [[moneyDic[@"items"] lastObject] objectForKey:@"orderdate"] description]
                
                if ([moneyDic[@"items"] count]>0) {
              
                    NSMutableArray *allShunArr = [[NSMutableArray alloc] initWithArray:chartsDic[@"items"]];
                    
                    [allShunArr insertObjects:[self createDatesAndMoneyWithDateLast:[[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"createtime"] description] andCreateTime:[[[moneyDic[@"items"] lastObject] objectForKey:@"orderdate"] description] ] atIndex:0];
                    
                    //表格展示的 是顺序的
                    [chartsDic setObject:allShunArr forKey:@"items"];

                    NSMutableArray *allNiArr = [[NSMutableArray alloc] init];
                    
                    [allNiArr addObjectsFromArray:[self createDatesAndMoneyWithDateLast:[[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"createtime"] description] andCreateTime:[[[moneyDic[@"items"] lastObject] objectForKey:@"orderdate"] description]]];
                    //下面的列表展示的 是倒叙的
                    allNiArr = (NSMutableArray *)[[allNiArr reverseObjectEnumerator] allObjects];
                    [allNiArr insertObjects:moneyDic[@"items"] atIndex:0];
                    
                  //  [allNiArr addObjectsFromArray:moneyDic[@"items"]];
                    [moneyDic setObject:allNiArr forKey:@"items"];

                    
                    if (_chartsBlock) {
                        
                        _chartsBlock();
                    }
                    
                }else{

                    
#warning ---------没有数据
                    NSMutableArray *allShunArr = [[NSMutableArray alloc] init];
                    
                    allShunArr = [[self createDatesAndMoneyWithDateNowAndCreatetime:listType] mutableCopy];
                    //表格展示的 是顺序的
                    [chartsDic setObject:allShunArr forKey:@"items"];
                    [chartsDic setObject:@"0" forKey:@"total"];
                    [chartsDic setObject:[NSString stringWithFormat:@"%zd",listType] forKey:@"type"];
                    
                    //下面的列表展示的 是倒叙的
                    allShunArr = (NSMutableArray *)[[allShunArr reverseObjectEnumerator] allObjects];
                    [moneyDic setObject:allShunArr forKey:@"items"];
                    [moneyDic setObject:[NSString stringWithFormat:@"%zd",listType] forKey:@"type"];
                    [moneyDic setObject:@"0" forKey:@"total"];

                }
                
               // [SVProgressHUD showErrorWithStatus:@"没有更多数据"];

            }else{
            
#warning ---------没有数据
                NSMutableArray *allShunArr = [[NSMutableArray alloc] init];
                
                allShunArr = [[self createDatesAndMoneyWithDateNowAndCreatetime:listType] mutableCopy];
                //表格展示的 是顺序的
                [chartsDic setObject:allShunArr forKey:@"items"];
                [chartsDic setObject:@"0" forKey:@"total"];
                [chartsDic setObject:[NSString stringWithFormat:@"%zd",listType] forKey:@"type"];
                
                //下面的列表展示的 是倒叙的
                allShunArr = (NSMutableArray *)[[allShunArr reverseObjectEnumerator] allObjects];
                [moneyDic setObject:allShunArr forKey:@"items"];
                [moneyDic setObject:[NSString stringWithFormat:@"%zd",listType] forKey:@"type"];
                [moneyDic setObject:@"0" forKey:@"total"];
                
                
               // [SVProgressHUD showErrorWithStatus:dic[@"em"]];

                
            }

        }
        
        [tableView reloadData];
        
        [tableView.mj_footer endRefreshing];


        
    } failure:^(NSError *error) {
        
#warning ---------没有数据        
        NSMutableArray *allShunArr = [[NSMutableArray alloc] init];
        
        allShunArr = [[self createDatesAndMoneyWithDateNowAndCreatetime:listType] mutableCopy];
        //表格展示的 是顺序的
        [chartsDic setObject:allShunArr forKey:@"items"];
        [chartsDic setObject:@"0" forKey:@"total"];
        [chartsDic setObject:[NSString stringWithFormat:@"%zd",listType] forKey:@"type"];
        
        //下面的列表展示的 是倒叙的
        allShunArr = (NSMutableArray *)[[allShunArr reverseObjectEnumerator] allObjects];
        [moneyDic setObject:allShunArr forKey:@"items"];
        [moneyDic setObject:[NSString stringWithFormat:@"%zd",listType] forKey:@"type"];
        [moneyDic setObject:@"0" forKey:@"total"];
        
       // [SVProgressHUD showErrorWithStatus:@"网络异常"];
         [tableView reloadData];
        [tableView.mj_footer endRefreshing];

        
    }];


}



#pragma mark - 造空白数据  一天数据都没有  都是构造的  注意：考虑第一天打开没有数据的情况
-(NSArray *)createDatesAndMoneyWithDateNowAndCreatetime:(NSInteger)listType
{
    NSString *createTime = [HGSaveNoticeTool obtainPersonInfoDataWithKey:@"createtime"];
    
    NSDate  *date1 = [self caculateDateWithStr:createTime];
    NSDate  *date2 = [NSDate date];
    
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    
    if (listType == 1) {
        //日期
        dateFomatter.dateFormat = @"yyyy-MM-dd";

        return [self createDatesAndMoneyWithDateLast:[NSString stringWithFormat:@"%.0f",(CGFloat)([date1 timeIntervalSince1970]*1000)] andCreateTime:[NSString stringWithFormat:@"%.0f",(CGFloat)([date2 timeIntervalSince1970]*1000)]];
        
    }else{
        dateFomatter.dateFormat = @"yyyy-MM-dd";
    
        return [self createDatesAndMoneyWithMonthLast:[NSString stringWithFormat:@"%.0f",(CGFloat)([date1 timeIntervalSince1970]*1000)] andCreateTime:[NSString stringWithFormat:@"%.0f",(CGFloat)([date2 timeIntervalSince1970]*1000)]];
    
    }

}



#pragma mark - 根据创建时间和结束时间 创建空数组 天的
-(NSArray *)createDatesAndMoneyWithDateLast:(NSString *)createTime andCreateTime:(NSString *)lastdate
{
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    NSInteger num = [self offDateWithFirstDate:createTime andLastDate:lastdate];
    NSDate  *date = [self caculateDateWithStr:lastdate];
    
    if (num == 0) {
        num = 1;
    }
    
    for (int i=0; i<num; i++) {
        NSString * times = [self caculateSecondsWithDate:date andlastDays:num - i];
        [dataArr addObject:@{@"orderdate":[NSNumber numberWithDouble:[times doubleValue]],@"amount":@(0)}];
    }
    return dataArr;
}

#pragma mark - 根据创建时间和结束时间 创建空数组 月的
-(NSArray *)createDatesAndMoneyWithMonthLast:(NSString *)createTime andCreateTime:(NSString *)lastdate
{
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    NSInteger num = [self offMonthWithFirstDate:createTime andLastDate:lastdate];
    NSDate  *date = [self caculateDateWithStr:lastdate];
    
    if (num == 0) {
        num = 1;
    }
    
    for (int i=0; i<num; i++) {
        NSString * times = [self caculateSecondsWithDate:date andlastDays:num - i];
        [dataArr addObject:@{@"orderdate":[NSNumber numberWithDouble:[times doubleValue]],@"amount":@(0)}];
    }
    return dataArr;
}



//传出去这10个月的数据
-(NSMutableArray *)createAllDatasWithInialDic:(NSMutableDictionary *)dic andChartsType:(NSInteger)chartsType  andRefreshType:(NSInteger)refreshType andLastDate:(NSString *)dateNumber
{
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    
    if (chartsType == 1) {
        //是天的图表
        NSInteger  num = 10;
        
        if ([dateNumber isEqualToString:@"0"]) {
            num = 10;
        }else{
            
            if([self offDateWithFirstDate:[[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"createtime"] description] andLastDate:dateNumber] > 10){
                
                num = 10;
                
            }else{
                
                num = [self offDateWithFirstDate:[[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"createtime"] description] andLastDate:dateNumber];
                
            }
        
        }

        NSString *dateStr = dateNumber;
        
        //要不要包含当天
        NSInteger  isLastOrFirst = 1;
        
        if (refreshType != 3) {
             //是第一次加载的
            dateStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]*1000];
        }else{
        
            isLastOrFirst = 0;
        }
        NSDate  *date = [self caculateDateWithStr:dateStr];
        if ([dic[@"items"] isEqual:[NSNull null]]) {
            for (int i=0; i<num; i++) {
                NSString *times = [self caculateSecondsWithDate:date andlastDays:num - i - isLastOrFirst];
                [dataArr addObject:@{@"orderdate":[NSNumber numberWithDouble:[times doubleValue]],@"amount":@(0)}];
            }
        }else{
            NSArray *arr = dic[@"items"];
            for (int i=0; i<num; i++) {
                NSString *dateStr = [self caculateTime:date  andlastDays:num - i - isLastOrFirst];
                NSString *times = [self caculateSecondsWithDate:date andlastDays:num - i - isLastOrFirst];
                int j=0;
                for (; j<arr.count; j++) {
                    NSDictionary *tmpDic = arr[j];
                    if ([dateStr isEqualToString:[self caculateTime:[tmpDic objectForKey:@"orderdate"]]]) {
                        [dataArr addObject:tmpDic];
                        break;
                    }
                }
                if (j>=arr.count) {
                    
                    NSDictionary *dic = @{@"orderdate":[NSNumber numberWithDouble:[times doubleValue]],@"amount":@(0)};
                    [dataArr addObject:dic];
                    
                }
            }
        }

    }else{
        //是月的图表
        NSInteger  num = 12;
        
        if ([dateNumber isEqualToString:@"0"]) {
            num = 12;
        }else{
            
            if([self offMonthWithFirstDate:[[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"createtime"] description] andLastDate:dateNumber]> 12){
                
                num = 12;
                
            }else{
                
                num = [self offMonthWithFirstDate:[[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"createtime"] description] andLastDate:dateNumber];
                
            }
        }
        
        NSString *dateStr = dateNumber;
        
        //要不要包含当天
        NSInteger  isLastOrFirst = 1;
        
        if (refreshType != 3) {
            //是第一次加载的
            dateStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]*1000];
        }else{
            
            isLastOrFirst = 0;
        }


        NSDate  *date = [self caculateDateWithStr:dateStr];

        if ([dic[@"items"] isEqual:[NSNull null]]) {
            for (int i=0; i<num; i++) {
                NSString *times = [self caculateSecondsWithMonth:date andlastMonth:num - i - isLastOrFirst];
                [dataArr addObject:@{@"orderdate":[NSNumber numberWithDouble:[times doubleValue]],@"amount":@(0)}];
            }
        }else{
            NSArray *arr = dic[@"items"];
            for (int i=0; i<num; i++) {
                NSString *dateStr = [self caculateTime:date  andlastMonth:num - i - isLastOrFirst];
                NSString * times = [self caculateSecondsWithMonth:date andlastMonth:num - i - isLastOrFirst];
                int j=0;
                for (; j<arr.count; j++) {
                    NSDictionary *tmpDic = arr[j];
                    if ([dateStr isEqualToString:[self caculateYearAndmonth:[tmpDic objectForKey:@"orderdate"]]]) {
                        [dataArr addObject:tmpDic];
                        break;
                    }
                }
                if (j>=arr.count) {
                    
                    NSDictionary *dic = @{@"orderdate":[NSNumber numberWithDouble:[times doubleValue]],@"amount":@(0)};
                    [dataArr addObject:dic];
                    
                }
            }
        }

    }

    return dataArr;
}


/************************************************************************/

#pragma mark - 计算天
-(NSString *)caculateTime:(NSString *)timeStr
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStr floatValue]/1000.0];
    
    [dateFormatter setTimeZone:timeZone];
    //[dateFormatter setDateFormat:@"MM-dd"];
    [dateFormatter setDateFormat:@"dd"];
    
    return [dateFormatter stringFromDate:date];
}

#pragma mark - 把时间戳转换成date类型
-(NSDate *)caculateDateWithStr:(NSString *)timeStr
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStr floatValue]/1000.0];
    return date;
}


#pragma mark - 计算前几天的日期
-(NSString *)caculateTime:(NSDate *)date andlastDays:(NSInteger)dates
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    NSDate *datex =  [date dateByMinusDays:dates];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"dd"];
    return [dateFormatter stringFromDate:datex];

}

#pragma mark - 计算前几天的日期的时间戳
-(NSString *)caculateSecondsWithDate:(NSDate *)date andlastDays:(NSInteger)dates
{
    NSDate *datex =  [date dateByMinusDays:dates];
    return [NSString stringWithFormat:@"%.0f",[datex timeIntervalSince1970]*1000];
}


#pragma mark - 计算前几个月的月份
-(NSString *)caculateTime:(NSDate *)date andlastMonth:(NSInteger)month
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    NSDate *datex =  [date dateByMinusMonths:month];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM"];
//    NSLog(@"PPPPPPP%zdPPPPPPP%@PPPPPPPP%@",month,[dateFormatter stringFromDate:datex],[dateFormatter stringFromDate:date]);
    return [dateFormatter stringFromDate:datex];
}

#pragma mark - 计算年月
-(NSString *)caculateYearAndmonth:(NSString *)timeStr
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStr floatValue]/1000.0];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    return [dateFormatter stringFromDate:date];
}



#pragma mark - 计算前几个月的月份
-(NSString *)caculateSecondsWithMonth:(NSDate *)date andlastMonth:(NSInteger)month{
    
    NSDate *datex =  [date dateByMinusMonths:month];
    return [NSString stringWithFormat:@"%.0f",[datex timeIntervalSince1970]*1000];

}



#pragma mark - 把时间戳转成月份
-(NSString *)caculateMonthTime:(NSString *)timeStr
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStr floatValue]/1000.0];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"MM"];
    return [dateFormatter stringFromDate:date];
}

#pragma mark - 把时间戳转成年份
-(NSString *)caculateYear:(NSString *)timeStr
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStr floatValue]/1000.0];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy"];
    return [dateFormatter stringFromDate:date];
}

#pragma mark - 计算两个日期的时间差几天
-(NSInteger)offDateWithFirstDate:(NSString *)firstDate  andLastDate:(NSString *)lastDate
{

    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:[firstDate floatValue]/1000.0];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:[lastDate floatValue]/1000.0];
    
    date1 = [dateFomatter dateFromString:[dateFomatter stringFromDate:date1]];
    date2 = [dateFomatter dateFromString:[dateFomatter stringFromDate:date2]];

    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitDay;
    // 对比时间差
  //  NSDateComponents *dateCom = [calendar components:unit fromDate:date1 toDate:date2 options:0];
    
    if (firstDate.doubleValue >= lastDate.doubleValue) {
        
        NSDateComponents *dateCom = [calendar components:unit fromDate:date2 toDate:date1 options:0];
        
        return dateCom.day;
    }else{
        
        NSDateComponents *dateCom = [calendar components:unit fromDate:date1 toDate:date2 options:0];
        
        return dateCom.day;
        
    }

    // 伪代码
//    年差额 = dateCom.year, 月差额 = dateCom.month, 日差额 = dateCom.day, 小时差额 = dateCom.hour, 分钟差额 = dateCom.minute, 秒差额 = dateCom.second

}

#pragma mark - 计算两个日期的时间差几个月
-(NSInteger)offMonthWithFirstDate:(NSString *)firstDate  andLastDate:(NSString *)lastDate
{
    
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM";
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:[firstDate floatValue]/1000.0];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:[lastDate floatValue]/1000.0];
    
    date1 = [dateFomatter dateFromString:[dateFomatter stringFromDate:date1]];
    date2 = [dateFomatter dateFromString:[dateFomatter stringFromDate:date2]];

    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit =   NSCalendarUnitMonth;
    // 对比时间差
    
    if (firstDate.doubleValue >= lastDate.doubleValue) {
        
        NSDateComponents *dateCom = [calendar components:unit fromDate:date2 toDate:date1 options:0];
        
        return dateCom.month;
    }else{
    
        NSDateComponents *dateCom = [calendar components:unit fromDate:date1 toDate:date2 options:0];
        
        return dateCom.month;
    
    }
    
    
   
    
    // 伪代码
    //    年差额 = dateCom.year, 月差额 = dateCom.month, 日差额 = dateCom.day, 小时差额 = dateCom.hour, 分钟差额 = dateCom.minute, 秒差额 = dateCom.second
    
}






/************************************************************************/


#pragma mark - 确定投放订单
-(void)besureToTouFangWithReturnBlock:(void(^)(id result))block
{
    if (!LYTOKEN) {
        return;
    }
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD showWithStatus:@"订单投注中..."];
    
    NSString *macc = [self obtainWifimacAddress];
    
    
    
//    if ([LYAccount isEqualToString:@"0000000003"]) {
//        
//        macc = MacAddress3;
//    }else if ([LYAccount isEqualToString:@"0000012172"]){
//    
//        macc = MacAddress4;
//    }else{
//    
//        macc = MacAddress;
//    }
    
    

    NSDictionary *params = @{
                             @"stationno":[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"stationno"],
                             @"stationprovince":[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"stationprovince"],
                             @"token":LYTOKEN,
                             @"wifimac":macc};
    //@"48:7a:da:4e:d4:70"
    //
    
    [HSNetWorking postWithURLString:@"v*/lottery/substitutebetorder" parameters:params success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        NSLog(@"%@",dic);
        
        block(dic);
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        
    }];

}


-(NSString *)obtainWifimacAddress
{
    NSString *ssid = @"";
    NSString *mac = @"";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            
            ssid = [dict valueForKey:@"SSID"];
            mac = [dict valueForKey:@"BSSID"];
            // NSDictionary *ssidData = [dict valueForKey:@"SSIDDATA"];
            
        }
    }
    
    NSArray *tmpArr = [mac componentsSeparatedByString:@":"];
    
    NSMutableArray *bssidArr = [[NSMutableArray alloc] init];
    
    for (int i=0; i<tmpArr.count; i++) {
        
        NSMutableString *strr = [NSMutableString stringWithString:tmpArr[i]];
        
        if (strr.length<2) {
            
            [strr insertString:@"0" atIndex:0];
        }
        
        [bssidArr addObject:strr];
        
    }
    
    return [bssidArr componentsJoinedByString:@":"];
    
}

#pragma mark - 查询订单投放结果
-(void)searchTouFangResultsWithSerialNumber:(NSString *)serialNumber withReturnBlock:(void(^)(id result))block
{
    if (!LYTOKEN) {
        return;
    }
    
    NSDictionary *params = @{
                             @"stationno":[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"stationno"],
                             @"stationprovince":[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"stationprovince"],
                             @"token":LYTOKEN,
                             @"serialnumber":serialNumber};
    
    [HSNetWorking postWithURLString:@"v*/lottery/getsubstitutebetordernum" parameters:params success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        NSLog(@"查询结果信息%@",dic);
        
        block(dic);
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        
    }];




}






@end
