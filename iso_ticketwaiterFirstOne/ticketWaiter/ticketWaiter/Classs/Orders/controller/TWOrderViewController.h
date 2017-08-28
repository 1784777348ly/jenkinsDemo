//
//  TWOrderViewController.h
//  ticketWaiter
//
//  Created by LY on 17/1/16.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "BaseViewController.h"


@class HGPlaceholderView;
@interface TWOrderViewController : BaseViewController

@property(nonatomic)NSMutableArray *dataArrL;
@property(nonatomic)NSMutableArray *dataArrM;
@property(nonatomic)NSMutableArray *dataArrR;


@property(nonatomic)NSMutableDictionary *allOrderMoneyDic;
@property(nonatomic)NSMutableDictionary *allOrderAndMoneyChartsDic;


//21  22 23
@property (weak, nonatomic) IBOutlet UITableView *leftView;
@property (weak, nonatomic) IBOutlet UITableView *middleView;
@property (weak, nonatomic) IBOutlet UITableView *rightView;

@property(nonatomic)HGPlaceholderView *holderViewL;
@property(nonatomic)HGPlaceholderView *holderViewM;
@property(nonatomic)HGPlaceholderView *holderViewR;


//刷新订单数额
-(void)refreshOrderNumberWithNum:(NSString *)orderNum;

//隐藏订单数额视图
-(void)hidBottomView;

//显示订单数额
-(void)showBottomView;


@end
