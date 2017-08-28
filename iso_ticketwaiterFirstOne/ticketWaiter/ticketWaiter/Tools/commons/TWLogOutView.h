//
//  TWLogOutView.h
//  ticketWaiter
//
//  Created by LY on 17/2/7.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TWLogOutViewBlock)();
@interface TWLogOutView : UIView

@property(nonatomic,copy)TWLogOutViewBlock  logoutBlock;

+(instancetype)logoutView;

-(void)show;

@end
