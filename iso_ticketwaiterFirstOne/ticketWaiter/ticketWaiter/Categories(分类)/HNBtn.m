//
//  HNBtn.m
//  设置
//
//  Created by LY on 16/7/4.
//  Copyright © 2016年 hui10. All rights reserved.
//

/*自定义button，可以设置button的图片，文字，图片大小，文字大小，图片与文字的相对位置**/
#import "HNBtn.h"

#define VIEWW self.frame.size.width
#define VIEWH self.frame.size.height
#define Ratio 0.7

@implementation HNBtn

-(id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
    
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    //用来调整button里图片的大小的
     return CGRectMake(0, 0, VIEWW, VIEWW*Ratio);
    
}

//返回titleLable的frame
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    
    return CGRectMake(0, VIEWH-30, VIEWW, 20);
    
}

@end