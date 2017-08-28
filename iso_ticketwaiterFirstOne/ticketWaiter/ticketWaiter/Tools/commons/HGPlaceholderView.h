//
//  HGPlaceholderView.h
//  Hui10Game
//
//  Created by LY on 16/12/1.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^HGPlaceholderViewBlock)();

@interface HGPlaceholderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *placeholderBtn;

@property(nonatomic,copy)HGPlaceholderViewBlock block;

+(instancetype)placehoderView;

+(instancetype)placehoderViewWithFrame:(CGRect)rect;

-(void)setPlaceHolderViewWithType:(NSInteger)typeValue;

-(void)setOrderSTitle:(NSString *)title;

@end
