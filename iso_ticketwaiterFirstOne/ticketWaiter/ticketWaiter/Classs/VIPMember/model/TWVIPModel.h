//
//  TWVIPModel.h
//  ticketWaiter
//
//  Created by LY on 16/12/30.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWVIPModel : NSObject

//电话号码
@property(nonatomic)NSString *phone;

//备注／别名
@property(nonatomic)NSString *remark;

//姓名
@property(nonatomic)NSString *fullname;

//时间
@property(nonatomic,assign)NSTimeInterval updatetime;

@property(nonatomic)NSString *password;

@property(nonatomic)BOOL  isDeleteState;

@property(nonatomic)NSString *memberid;

@property(nonatomic)NSInteger  inputStrLength;


@end
