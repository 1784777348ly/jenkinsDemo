//
//  TWVIPViewController.h
//  ticketWaiter
//
//  Created by LY on 16/12/30.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "BaseViewController.h"


@class HGPlaceholderView;
@interface TWVIPViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property(nonatomic)NSMutableArray *dataArr;

@property(nonatomic)HGPlaceholderView *placeHolderView;



@end
