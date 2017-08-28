//
//  TWSendMoneyVC.h
//  ticketWaiter
//
//  Created by LY on 17/1/16.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "BaseViewController.h"

@class HGPlaceholderView;
@interface TWSendMoneyVC : BaseViewController


@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property(nonatomic)NSMutableArray *dataArr;

@property(nonatomic,assign)NSInteger money;

@property(nonatomic)HGPlaceholderView *placeHolderView;


@end
