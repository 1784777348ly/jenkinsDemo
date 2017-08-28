//
//  TWOrderModel.h
//  ticketWaiter
//
//  Created by LY on 17/1/16.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWOrderModel : NSObject

@property(nonatomic)NSString *userphone;
@property(nonatomic)NSString *username;
@property(nonatomic)NSString *orderno;
@property(nonatomic)NSString *ordertime;
@property(nonatomic,assign)NSInteger amount;

//@property(nonatomic,assign)NSInteger total;


@end

