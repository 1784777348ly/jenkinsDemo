//
//  TWMyPaybackVC.h
//  ticketWaiter
//
//  Created by LY on 16/12/30.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "BaseViewController.h"

@class HGPlaceholderView;
@interface TWMyPaybackVC : BaseViewController

//判断网络状态
@property (assign, nonatomic) BOOL netRachable;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property(nonatomic)HGPlaceholderView *placeHolderView;


@end
