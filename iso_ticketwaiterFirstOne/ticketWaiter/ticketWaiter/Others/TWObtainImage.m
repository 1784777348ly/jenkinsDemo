//
//  TWObtainImage.m
//  ticketWaiter
//
//  Created by LY on 16/12/30.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "TWObtainImage.h"

@implementation TWObtainImage

//判断用哪张图片
+ (void)LocalHaveImageWithImageName:(NSString *)name andReturnBlock:(void (^)(UIImage *image))block{
    
    
    if (name.length  == 0) {
        
        UIImage *imagess = [UIImage imageNamed:@"icon_nopic-0"];
        block(imagess);
        return;
    }
    
    UIImage *imagex = nil;
    
    NSString *nameStr = nil;
    
    if ([name containsString:@"http"]) {
        
        nameStr = name;
        
    }else{
        
        if ([name containsString:@"png"]||[name containsString:@"jpg"]) {
            
            nameStr = [NSString stringWithFormat:@"http://wwwhui10.b0.upaiyun.com/%@",name];
            
        }else{
        
            nameStr = [NSString stringWithFormat:@"http://wwwhui10.b0.upaiyun.com/%@.png",name];

        }
        
        
    }
    
    //上传的图片
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:nameStr]];
    
    SDImageCache* cache = [SDImageCache sharedImageCache];
    
    imagex = [cache imageFromDiskCacheForKey:key];
    
    if (imagex == nil) {
        
        SDWebImageDownloader *loader = [SDWebImageDownloader sharedDownloader];
        [loader downloadImageWithURL:[NSURL URLWithString:nameStr] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                block(image);
                
                [[SDImageCache sharedImageCache] storeImage:image forKey:nameStr];
                
            }];
            
        }];
        
    }else{
        
        block(imagex);
        
    }
    
}



@end
