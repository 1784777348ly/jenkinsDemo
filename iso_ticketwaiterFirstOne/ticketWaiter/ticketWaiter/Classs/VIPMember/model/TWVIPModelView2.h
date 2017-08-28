//
//  TWVIPModelView.h
//  ticketWaiter
//
//  Created by LY on 16/12/30.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TWVIPViewController,TWSendMoneyVC;

@interface TWVIPModelView2 : NSObject


/*
 *
 * 获取会员列表  在会员管理里面  freshType 1 正常 2 下拉刷新  3 上拉加载
 */
-(void)obtainPaybackDataWithTableView:(TWVIPViewController *)myTableViewVC andFreshType:(NSInteger)freshType;


/*
 *
 * 获取会员列表  在赠送彩金的时候
 */
-(void)obtainVIPListWithTableView:(TWSendMoneyVC *)myTableViewVC  andFreshType:(NSInteger)freshType;


/*
 * 获取英泰操作令牌
 *
 */
-(void)obtainIWTTokenWithReturnBlock:(void(^)(id result))block;



/*
 * 获取会员列表
 *
 */



/*
 * 修改备注
 *
 */
-(void)modifyRemarkWithDic:(NSDictionary *)memberDic andReturnBlock:(void(^)(id result))block;



/*
 *  同步更新用户
 */

-(void)addMemberWithDic:(NSDictionary *)dic andReturnBlock:(void(^)(id result))block;





@end
