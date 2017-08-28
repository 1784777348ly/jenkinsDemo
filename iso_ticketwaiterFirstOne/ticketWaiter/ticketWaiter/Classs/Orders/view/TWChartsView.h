//
//  TWChartsView.h
//  ticketWaiter
//
//  Created by LY on 17/1/17.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChartsViewBlock)(NSInteger type);


@interface TWChartsView : UIView

@property(nonatomic,copy)ChartsViewBlock chartBlock;

-(void)setChartsValue:(NSArray *)valueArr andxShowInfoTextArr:(NSArray *)xArr;


-(void)refreshViewWithDatas:(NSDictionary *)dic;

+(instancetype)ChartsViewWithRect:(CGRect)rect;

//刷新 上 下的注解
-(void)setupLbaleWithStr:(NSString *)upStr andBottomLable:(NSString *)bottomStr;


@end
