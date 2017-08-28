//
//  TWPayBackViewModel.h
//  ticketWaiter
//
//  Created by LY on 17/1/14.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TWPayBackVC;
@interface TWPayBackViewModel : NSObject

// 获得赠送列表
-(void)fetchDonateListWith:(TWPayBackVC *)vc;



/*
 * 获得赠送列表
 */
-(void)obtainPaybackDataWithTableViewVC:(TWPayBackVC *)myTableViewVC andDataArr:(NSMutableArray *)dataArr  andRefshType:(NSInteger)type;


/*
 *  赠送彩金
 */
-(void)donateMoneyInfoWithMoney:(NSInteger )money andMemberId:(NSString *)memberId returnBack:(void(^)(id result))block;



@end
