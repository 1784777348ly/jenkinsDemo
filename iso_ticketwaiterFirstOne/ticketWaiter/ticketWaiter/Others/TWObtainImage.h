//
//  TWObtainImage.h
//  ticketWaiter
//
//  Created by LY on 16/12/30.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWObtainImage : NSObject


/*
 * 返回图片
 */
+ (void)LocalHaveImageWithImageName:(NSString *)name andReturnBlock:(void (^)(UIImage *image))block;



@end
