//
//  TWShareView.h
//  ticketWaiter
//
//  Created by LY on 17/1/17.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TWShareViewDelegate <NSObject>

-(void)secletedNum:(int)num;

@end

@interface TWShareView : UIView

@property(nonatomic,weak)id<TWShareViewDelegate>delegate;

+(instancetype)shareView;

-(void)show;


@end
