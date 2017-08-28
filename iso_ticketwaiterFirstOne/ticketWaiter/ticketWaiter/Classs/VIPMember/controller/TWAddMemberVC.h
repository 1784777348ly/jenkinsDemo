//
//  TWAddMemberVC.h
//  ticketWaiter
//
//  Created by LY on 16/12/30.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "BaseViewController.h"

@class TWVIPModel;
@interface TWAddMemberVC : BaseViewController

@property(nonatomic)NSInteger  vcType;

@property(nonatomic)TWVIPModel *model;

@property(nonatomic)NSMutableArray *dataArr;

@property(nonatomic,assign)BOOL  isSearchToAdd;


@end
