//
//  PanoShowViewController.h
//  PanoramaViewDemo
//
//  Created by baidu on 15/4/10.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    PanoShowTypePID,
    PanoShowTypeGEO,
    PanoShowTypeXY,
    PanoShowTypeUID
} PanoShowType;
@interface TWMapViewController : BaseViewController

@property(assign, nonatomic) PanoShowType showType;

@property(nonatomic)NSString *positionStr;

@property(nonatomic)NSString *mid;

@property(nonatomic)NSString *nameStr;


@end
