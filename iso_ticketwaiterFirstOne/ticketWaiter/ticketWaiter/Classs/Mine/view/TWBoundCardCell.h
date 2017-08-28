//
//  TWBoundCardCell.h
//  ticketWaiter
//
//  Created by LY on 17/1/13.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^TextfieldChangeBlock)();

@class TWCardModel;
@interface TWBoundCardCell : UITableViewCell

@property(nonatomic,copy)TextfieldChangeBlock tfBlock;

@property(nonatomic)TWCardModel *model;

@end
