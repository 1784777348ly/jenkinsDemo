//
//  HSRefreshHeader.m
//  Hui10Game
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "HSRefreshHeader.h"

@implementation HSRefreshHeader

- (void)prepare
{
    [super prepare];
    
    // 设置刷新状态属性
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    // 设置颜色、大小
    self.stateLabel.textColor = HexRGB(0x999999);
    self.stateLabel.font = NormalFont(26);
    NSMutableArray *startImages = [NSMutableArray array];
    @autoreleasepool {
        for (int i = 0; i < 6; i++) {
            NSString *name = [NSString stringWithFormat:@"p%d.png",i+1];
            NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
            UIImage *img = [UIImage imageWithContentsOfFile:path];
            [startImages addObject:img];
        }
    }

    [self setImages:@[startImages[0]] duration:0.5 forState:MJRefreshStateIdle];
    [self setImages:startImages duration:0.5 forState:MJRefreshStatePulling];
    [self setImages:startImages duration:0.5 forState:MJRefreshStateRefreshing];
//
    [self setTitle:@"        下拉更新..." forState:MJRefreshStateIdle];
    [self setTitle:@"        下拉更新..." forState:MJRefreshStatePulling];
    [self setTitle:@"        下拉更新..." forState:MJRefreshStateRefreshing];
}


@end
