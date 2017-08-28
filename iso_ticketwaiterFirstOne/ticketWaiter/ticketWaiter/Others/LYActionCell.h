//
//  LYActionCell.h
//  HuiShiApp
//
//  Created by LY on 16/8/25.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LYActionCellBlock)(NSInteger tag);
@class LYActionMoel;
@interface LYActionCell : UITableViewCell

@property(nonatomic,copy)LYActionCellBlock block;

@property(nonatomic)LYActionMoel *model;

@end
