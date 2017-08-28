//
//  TWCardListVC.h
//  ticketWaiter
//
//  Created by LY on 17/1/13.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "BaseViewController.h"


@class HGPlaceholderView;
@interface TWCardListVC : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property(nonatomic)NSMutableArray *dataArr;

@property(nonatomic)HGPlaceholderView *placeHolderView;

@end
