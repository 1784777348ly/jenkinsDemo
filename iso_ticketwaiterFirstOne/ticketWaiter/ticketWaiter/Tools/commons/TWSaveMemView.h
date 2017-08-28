//
//  TWSaveMemView.h
//  ticketWaiter
//
//  Created by LY on 17/1/25.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DonateBlock)(BOOL  success);

@interface TWSaveMemView : UIView

@property(nonatomic,copy)DonateBlock  donateBlock;


+(instancetype)saveMemberViewWithRect:(CGRect)rect;


-(void)show;

@end
