//
//  ImageUploadTool.m
//  Hui10Game
//
//  Created by Spider on 16/11/24.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "ImageUploadTool.h"

@implementation ImageUploadTool

+ (NSString *)imageMD5Name:(UIImage *)image{
    
    NSString *md5 = [UIImagePNGRepresentation(image) md5String]; //md5编码
    md5 = [md5 substringWithRange:NSMakeRange(8, 16)]; //9-24位
    return md5;
}
+ (NSString *)base64Image:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    while (imageData.length > 300 * 1024) {
        imageData = UIImageJPEGRepresentation(image, 0.8);
        image = [[UIImage alloc] initWithData:imageData];
    }
    NSString *base64Image = [imageData base64EncodedStringWithOptions:0]; //base64图片
    return base64Image;
}

+ (UIImage *)compressImage:(UIImage *)sourceImage targetWidth:(CGFloat)targetWidth{
    
    CGSize imageSize = sourceImage.size;
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    
    // 1.图片裁剪 (图片是宽大于高)
    if (width != height) {
        CGFloat radius = MIN(width, height)/2;
        CGFloat x = (width - 2 *radius)/2;
        CGFloat y = 0;
        CGFloat w = 2 * radius;
        CGFloat h = w;
        //获取屏幕缩放比   //图片是从Asserts里需要scale吧，从相册里不需要
//        CGFloat scale = [UIScreen mainScreen].scale;
//        x *= scale;
//        y *= scale;
//        w *= scale;
//        h *= scale;
        //裁剪图片
        CGImageRef imageRef = CGImageCreateWithImageInRect(sourceImage.CGImage, CGRectMake(x, y, w, h));
        sourceImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
    }
    // 2.图片压缩
    //    CGFloat targetHeight = (targetWidth / width) * height;
    CGFloat targetHeight = targetWidth;
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end























