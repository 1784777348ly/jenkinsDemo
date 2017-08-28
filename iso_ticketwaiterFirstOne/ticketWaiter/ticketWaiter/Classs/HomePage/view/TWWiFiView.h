//
//  TWWiFiView.h
//  ticketWaiter
//
//  Created by LY on 17/1/11.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWWiFiView : UIView

@property(nonatomic)NSTimer *timer;

@property(nonatomic,assign)BOOL  isOk;

@property(nonatomic,assign)BOOL  isHaveMac;

+(instancetype)wifiView;

-(void)refreshWifiWithWeight:(CGFloat)weight;

-(void)addTimer;

-(void)startTimer;

-(void)stopTimer;




@end
