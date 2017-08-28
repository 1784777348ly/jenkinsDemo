//
//  LYCusActionSheet.h
//  HuiShiApp
//
//  Created by LY on 16/8/25.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYCusActionSheet;
@protocol LYCusActionSheetDelegate <NSObject>

-(void)actionSheet:(LYCusActionSheet *)cusActionSheet  andButtonIndex:(NSInteger )buttonIndex;

@end

@interface LYCusActionSheet : UIView

@property(nonatomic,weak)id<LYCusActionSheetDelegate>delagete;

-(instancetype)lyActionSheetWithTitle:(NSString *)title
                    andContentStrings:(NSArray *)stringArr
                            andImages:(NSArray *)imageNames
                        andTitleColor:(UIColor *)titleColor
                      andContentColor:(UIColor *)contentColor
                       andBorderColor:(UIColor *)borderColor
                       andCancelTitle:(NSString *)cancelStr;


-(void)show;

@end
