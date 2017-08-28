//
//  TWSelMoneyView.h
//  ticketWaiter
//
//  Created by LY on 17/1/15.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sendMoneyBlock)(NSInteger money);

typedef void(^addViewBlock)(BOOL isAdded);


@interface TWSelMoneyView : UIView

@property(nonatomic,copy)sendMoneyBlock  sendBlock;

@property(nonatomic,copy)addViewBlock addBlock;

+(instancetype)selMoneyViewWithRect:(CGRect)rect;

@property (weak, nonatomic) IBOutlet UIButton *hongbaoBtn;


-(void)moneyDismiss;

@end
