//
//  TWOrderUpView.h
//  ticketWaiter
//
//  Created by LY on 17/1/16.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWOrderUpView : UIView

+(instancetype)OrderUpView:(CGRect)frame;

-(void)refreshOrderWithNum1:(NSInteger)num1 andNum2:(NSInteger)num2;

-(void)dismiss;

@end
