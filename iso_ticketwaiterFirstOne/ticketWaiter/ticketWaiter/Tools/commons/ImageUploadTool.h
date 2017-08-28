//
//  ImageUploadTool.h
//  Hui10Game
//
//  Created by Spider on 16/11/24.
//  Copyright © 2016年 hui10. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface ImageUploadTool : NSObject
/**
 获取image的MD5字符串

 @param image 图片
 @return MD5字符串
 */
+ (NSString *)imageMD5Name:(UIImage *)image;
/**
 获取图片的base64字符串

 @param image 图片
 @return base64字符串
 */
+ (NSString *)base64Image:(UIImage *)image;
/**
 剪裁/压缩图片

 @param sourceImage 源图片
 @param targetWidth 目标宽度
 @return 裁剪后的图片
 */
+ (UIImage *)compressImage:(UIImage *)sourceImage targetWidth:(CGFloat)targetWidth;

@end






























