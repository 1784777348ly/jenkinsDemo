//
//  TWSearchView.h
//  ticketWaiter
//
//  Created by LY on 17/1/11.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchCancelBlock)();

typedef void(^SearchInputeBlock)(NSString *str);

@interface TWSearchView : UIView

@property(nonatomic,copy)SearchCancelBlock  scBlock;

@property(nonatomic,copy)SearchInputeBlock  siBlock;




+(instancetype)searchView;





@end
