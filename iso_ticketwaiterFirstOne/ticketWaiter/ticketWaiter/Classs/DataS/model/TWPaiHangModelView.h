//
//  TWPaiHangModelView.h
//  ticketWaiter
//
//  Created by LY on 16/12/30.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TWMyPaybackVC,HGPlaceholderView;
@interface TWPaiHangModelView : NSObject

/*
 * 获取排行数据 
 */
-(void)obtainDataWithTableView:(UITableView *)myTableView andPalceHolderView:(HGPlaceholderView *)placeHolder andDataArr:(NSMutableArray *)dataArr andViewType:(NSInteger)types andRefshType:(NSInteger)freshType;



/*
 *
 * 获取奖励数据
 */
-(void)obtainPaybackDataWithTableViewVC:(TWMyPaybackVC *)myTableViewVC andDataArr:(NSMutableArray *)dataArr  andRefshType:(NSInteger)type;


@end
