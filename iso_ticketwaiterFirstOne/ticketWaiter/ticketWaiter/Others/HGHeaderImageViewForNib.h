//
//  HGHeaderImageViewForNib.h
//  Hui10Game
//
//  Created by LY on 16/12/2.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGHeaderImageViewForNib : UIView

-(void)headerViewWithBackgroundColor:(UIColor *)bColor andImageName:(NSString *)name;

-(void)headerViewImageName:(NSString *)name;

-(void)normalViewWithImageName:(NSString *)name;

-(void)headerViewImage:(UIImage *)image;

@end
