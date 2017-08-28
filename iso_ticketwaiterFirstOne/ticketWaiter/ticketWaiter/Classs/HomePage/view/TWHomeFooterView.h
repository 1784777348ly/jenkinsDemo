//
//  TWHomeFooterView.h
//  ticketWaiter
//
//  Created by LY on 16/12/22.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MapBlock)();

@interface TWHomeFooterView : UICollectionReusableView

@property(nonatomic,copy)MapBlock mapBlock;


@end
