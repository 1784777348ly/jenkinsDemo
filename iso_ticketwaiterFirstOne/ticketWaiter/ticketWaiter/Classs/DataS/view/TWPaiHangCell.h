//
//  TWPaiHangCell.h
//  ticketWaiter
//
//  Created by LY on 16/12/29.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^TWPaiHangCellBlock)(NSString *pics,NSInteger picNum);

typedef void(^TWPaiHangPositionBlock)(NSDictionary *params);

@class TWPaiHangModel;
@interface TWPaiHangCell : UITableViewCell

@property(nonatomic,copy)TWPaiHangCellBlock block;

@property(nonatomic,copy)TWPaiHangPositionBlock pBlock;

@property(nonatomic)TWPaiHangModel *model;

@end
