//
//  TWPayBackModel.h
//  ticketWaiter
//
//  Created by LY on 17/1/3.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWPayBackModel : NSObject

//手机号
@property(nonatomic)NSString *phone;

//名字
@property(nonatomic)NSString *name;

//钱
@property(nonatomic)NSString *amount;

//状态
@property(nonatomic,assign)NSInteger status;


@property(nonatomic)NSString *mid;

//交易号
@property(nonatomic)NSString *tradesn;

//理由
@property(nonatomic)NSString *payResons;

@property(nonatomic)NSString *memberid;

//更新时间  上拉加载传这个
@property(nonatomic,assign)NSTimeInterval updatetime;

@end
