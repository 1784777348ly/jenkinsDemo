//
//  NewPageView.m
//  HuiShiApp
//
//  Created by Spider on 16/10/19.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "NewPageView.h"

@interface NewPageView ()<UIScrollViewDelegate>
{
    BOOL _isOnce;

}
@property (strong, nonatomic) UIScrollView *mainScroll;
@property (assign, nonatomic) CGRect rect;
@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) NSMutableArray *imgVs;
@property (strong, nonatomic) UIPageControl *control;
@end


@implementation NewPageView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        
        [self setSubviewsWith:frame];
    }
    return self;
}

- (void)setSubviewsWith:(CGRect)frame{
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = WHITECOLOR;
    [self addSubview:view];
    
    self.mainScroll = [[UIScrollView alloc] initWithFrame:frame];
    self.mainScroll.bounces = NO;
    self.mainScroll.showsVerticalScrollIndicator = NO;
    self.mainScroll.showsHorizontalScrollIndicator = NO;
    self.mainScroll.pagingEnabled = YES;
    self.mainScroll.delegate = self;
    [self addSubview:self.mainScroll];
    [self setImageWithLocalImages:@[@"new1.png",@"new2.png",@"new3.png"]];
    
//    self.control = [[UIPageControl alloc] init];
//    self.control.numberOfPages = 3;
//    self.control.currentPage = 0;
//    self.control.currentPageIndicatorTintColor = MainColor;
//    self.control.pageIndicatorTintColor = [UIColor grayColor];
//   // [self addSubview:self.control];
//    [self.control mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.bottom.mas_equalTo(-30*ScaleY);
//        make.height.mas_equalTo(20);
//        make.width.mas_equalTo(200);
//    }];
}
/**
 *  引导页加载本地图片
 *
 *  @param names 本地图片的名字数组
 */
- (void)setImageWithLocalImages:(NSArray <NSString *>*)names{
    
    self.mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH*names.count, SCREEN_HEIGHT);
    self.imgVs = [NSMutableArray array];
    NSBundle *bundle = [NSBundle mainBundle];
    for (int i = 0; i < names.count; i++) {
        
        self.imgView = [UIImageView new];
        self.imgView.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.mainScroll addSubview:self.imgView];
        [self.imgVs addObject:self.imgView];
        NSString *path = [bundle pathForResource:names[i] ofType:nil];
        self.imgView.image =  [UIImage imageWithContentsOfFile:path];
        if (i == names.count - 1) {
           // [self addButtonToImageView:self.imgView];
        }
    }
}
- (void)addButtonToImageView:(UIImageView *)imgView{
    
    imgView.userInteractionEnabled = YES;
    self.getInBtn                  = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getInBtn.backgroundColor  = UICOLOR(blackColor);
    self.getInBtn.layer.cornerRadius = 25*ScaleY;
    self.getInBtn.layer.borderWidth = 0.5;
    self.getInBtn.layer.borderColor = UIColorHex(0099FF).CGColor;
    self.getInBtn.backgroundColor = WHITECOLOR;
    //[self.getInBtn setTitle:@"开启 汇拾·慧生活" titleColor:UIColorHex(0099FF) titleFontSize:20 forState:UIControlStateNormal];
    [imgView addSubview:self.getInBtn];
    
    [self.getInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(335*ScaleX);
        make.height.mas_equalTo(50*ScaleY);
        make.centerX.equalTo(imgView);
        make.bottom.mas_equalTo(-90*ScaleY);
    }];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX/SCREEN_WIDTH;
    self.control.currentPage = index;
    
    if (index == 2) {
        
        scrollView.bounces = 1;
    }else{
        
        scrollView.bounces = 0;
    }

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    NSLog(@"}}}}}}}}}}}}%@",NSStringFromCGPoint(scrollView.contentOffset));
    
    if (scrollView.contentOffset.x - SCREEN_WIDTH*2 >FitValue(30)) {
        
        if (!_isOnce) {
            
            [self removeNewPageView];
        }
        
    }
    

}

//移除掉引导页
- (void)removeNewPageView{
    
    @autoreleasepool {
   
       // [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [UIView animateWithDuration:1 animations:^{
            self.mainScroll.alpha = 0;
            [self.mainScroll layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.7];
            
        }];

        
    }
}

-(void)dismiss
{
    //保存当前版本app 值
    [UserDefaults setObject:SystemVersion forKey:@"app_ver"];
    [UserDefaults synchronize];
    
    [self removeFromSuperview];
}





@end




























