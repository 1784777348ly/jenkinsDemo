//
//  TWVIPCell.h
//  ticketWaiter
//
//  Created by LY on 16/12/30.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TWVIPModel;
@interface TWVIPCell : UITableViewCell

@property(nonatomic)TWVIPModel *model;

@property(nonatomic,assign)NSInteger  cellType;

@end
