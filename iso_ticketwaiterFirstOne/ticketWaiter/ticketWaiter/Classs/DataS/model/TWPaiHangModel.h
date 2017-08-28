//
//  TWPaiHangModel.h
//  ticketWaiter
//
//  Created by LY on 16/12/30.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWPaiHangModel : NSObject

//@property(nonatomic)NSString *title;
//@property(nonatomic)NSString *headImage;
//@property(nonatomic)NSMutableArray *images;
//
//@property(nonatomic)NSInteger  numbers;
//
//@property(nonatomic)NSInteger  uid;
//
//@property(nonatomic)BOOL  isHaveJieJing;

//排行
//商户姓名
@property(nonatomic)NSString *merchantname;

//排名
@property(nonatomic)NSInteger rank;

//图片
@property(nonatomic)NSMutableArray *picArr;

//商家编号
@property(nonatomic)NSString *mid;

//全景地图位置
@property(nonatomic)NSString *position;

//更新时间
@property(nonatomic)NSString *updatetime;

@property(nonatomic)NSString *headImage;



@end


@interface TWMyPaybackModel : NSObject

//创建时间
@property(nonatomic,assign)NSTimeInterval  createtime;
//描述
@property(nonatomic,strong)NSString *descriptions;
//金额
@property(nonatomic,assign)NSInteger  amount;
//状态  0创建订单、1交易成功、2交易失败
@property(nonatomic)NSString *status;

//更新时间
//@property(nonatomic,assign)NSTimeInterval  updatetime;


@end





