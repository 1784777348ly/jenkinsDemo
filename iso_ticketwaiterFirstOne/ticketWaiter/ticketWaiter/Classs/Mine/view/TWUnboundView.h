//
//  TWUnboundView.h
//  ticketWaiter
//
//  Created by LY on 17/2/21.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^UnboundBlock)();

@interface TWUnboundView : UIView


@property(nonatomic)UnboundBlock block;

+(instancetype)unboundViewWithRect:(CGRect )rect;


-(void)dismiss;


@end
