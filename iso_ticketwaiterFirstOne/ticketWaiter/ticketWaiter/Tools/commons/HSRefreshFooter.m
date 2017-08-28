//
//  HSRefreshFooter.m
//  Hui10Game
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "HSRefreshFooter.h"

@implementation HSRefreshFooter

- (void)prepare
{
    [super prepare];
    
    [self setTitle:@"   正在加载更多数据..." forState:MJRefreshStateIdle];
    [self setTitle:@"   正在加载更多数据..." forState:MJRefreshStatePulling];
    [self setTitle:@"   正在加载更多数据..." forState:MJRefreshStateRefreshing];
    [self setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
    
    // 设置颜色、大小
//    self.stateLabel.textColor = HexRGB(0x999999);
//    self.stateLabel.font = [UIFont systemFontOfSize:FitValue(26)];
//    
//    NSString *imageName = [NSString stringWithFormat:@"ic_gengxin"];
//    UIImage *image = [UIImage imageNamed:imageName];
//    
//    
//    // 设置普通状态的动画图片
//    NSMutableArray *idleImages = [NSMutableArray array];
//    [idleImages addObject:image];
//    [self setImages:idleImages forState:MJRefreshStateIdle];
//    
//    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    NSMutableArray *refreshingImages = [NSMutableArray array];
//    [refreshingImages addObject:image];
//    [self setImages:refreshingImages forState:MJRefreshStatePulling];
//    
//    NSMutableArray *startImages = [NSMutableArray array];
//    [startImages addObject:image];
//    // 设置正在刷新状态的动画图片
//    [self setImages:startImages forState:MJRefreshStateRefreshing];
    
}

@end
