//
//  BaseViewController.m
//  HuiShiApp
//
//  Created by hui10 on 16/6/27.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "BaseViewController.h"
//#import "UMMobClick/MobClick.h"
#import "TWLoginViewController.h"
#import "HSNavigationController.h"

#import "TWLogOutView.h"

@interface BaseViewController ()<UIAlertViewDelegate>

@property (strong, nonatomic) UIView  *faceView;

@property (strong, nonatomic) UIButton *left;
@property (strong, nonatomic) UIButton *right;
@property (strong, nonatomic) UIView  *bottomView;
@property (strong, nonatomic) UIView  *line;

@end

CGFloat x = 0;
@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self startMornitingNet];

}
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}



/**
 *  监控网络
 */
- (void)startMornitingNet{
    
    __weak BaseViewController *weakself = self;
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
                
            case AFNetworkReachabilityStatusNotReachable:
                [weakself netWorkNotReachable];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [weakself netWorkGetWWAN];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [weakself netWorkGetWiFi];
                break;
            default:
                break;
        }
        
    }];
    [manager startMonitoring];
}

/**
 *  网络监控
 */
//连着wifi
- (void)netWorkGetWiFi{}
//断网
- (void)netWorkNotReachable{}
//连着
- (void)netWorkGetWWAN{}



- (void)testifyToken{
    
    NSDictionary *dict = [NSDictionary dictionary];
    
    if (LYTOKEN) {
        dict = @{@"token":LYTOKEN};
        
        [HSNetWorking postWithURLString:@"user/checktesttoken" parameters:dict success:^(id responseObject) {
            
            NSNumber *num = responseObject[@"ec"];
            NSString * code = [num stringValue];
            

            if ([code isEqualToString:@"1010000002"]) {

                
                TWLogOutView *view = [TWLogOutView logoutView];
                
                __weak typeof(self) weakSelf = self;
                
                view.logoutBlock = ^(){
                    
                    [weakSelf changeRootViewController];
                    
                };
                
                [view show];
                
                
                [UserDefaults removeObjectForKey:@"token"];
                
                
                
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"福彩小二温馨提示" message:@"您的帐号登录已过期，请重新登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                alert.tag = 56;
//                [alert show];
                
                
            }
            
        } failure:^(NSError *error) {
            
            
        }];
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        
    }
    
}

-(void)changeRootViewController
{
    
    TWLoginViewController *logController = [TWLoginViewController new];
    
    logController.isPushed = 1;
    
    [self.navigationController pushViewController:logController animated:YES];

//    TWLoginViewController *logController = [TWLoginViewController new];
//    HSNavigationController *loginNav = [[HSNavigationController alloc] initWithRootViewController:logController];
//    
   // [UIApplication sharedApplication].keyWindow.rootViewController = loginNav;
}






- (void)setSubViews{
    
}
- (UIView *)bottomView{
    if (!_bottomView) {
   
        _bottomView = [UIView new];
        _bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAV_BAR_HEIGHT+20);
        self.line = [UIView new];
        self.line.frame = CGRectMake(0, 63.5, SCREEN_WIDTH, 1);
       // self.line.backgroundColor = MainGrayColor;
        [_bottomView addSubview:self.line];
       
    
    }
    return _bottomView;
}
- (UILabel *)naview{
    if (!_naview) {
        _naview = [UILabel new];
        _naview.frame           = CGRectMake(0, 20, SCREEN_WIDTH, NAV_BAR_HEIGHT);
        _naview.font            = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        _naview.textAlignment   = NSTextAlignmentCenter;
        _naview.userInteractionEnabled = YES;
    }
    return _naview;
}
- (void)setNaviBarTitle:(NSString *)title color:(UIColor *)color{
    
    self.fd_prefersNavigationBarHidden = YES;
    self.naview.text                   = title;
    self.naview.textColor              = color;
    [self.bottomView addSubview:self.naview];
    [self.view addSubview:self.bottomView];
}

- (void)setNaviBarTitleView:(UIView *)titleView{
    
    self.fd_prefersNavigationBarHidden = YES;
    [self.naview addSubview:titleView];
    [self.bottomView addSubview:self.naview];
    [self.view addSubview:self.bottomView];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.naview);
        make.centerY.equalTo(self.naview);
        make.width.mas_equalTo(titleView.width);
        make.height.mas_equalTo(titleView.height);
        if (titleView.height > NAV_BAR_HEIGHT) {
            make.height.mas_equalTo(NAV_BAR_HEIGHT);
        }
        if (titleView.width > SCREEN_WIDTH-30) {
            make.width.mas_equalTo(SCREEN_WIDTH-30);
        }
    }];
}

/**
 *  设置左侧button文字和图片
 *
 *  @param title   文字
 *  @param imgName 图片
 */
- (void)setNaviBarLeftTitle:(NSString *)title image:(NSString *)imgName{
    
    
    if (!self.left) {
        
        self.left = [UIButton buttonWithType:UIButtonTypeCustom];
        self.left.backgroundColor = CLEARCOLOR;
        if (!title && !imgName) {
            @throw [NSException exceptionWithName:@"警告" reason:@"文字和图片不能同时为空!" userInfo:nil];
        }
        
        if (!imgName) {
            
            [self.left setTitle:title forState:UIControlStateNormal];
            self.left.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [self.left.titleLabel setTextColor:WHITECOLOR];
            self.left.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        } else {
            [self.left setImage:ImageNamed(imgName)
                       forState:UIControlStateNormal];
            
            self.left.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
        
        [self.naview addSubview:self.left];
        
        [self.left addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.left mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(21);
            make.centerY.equalTo(self.naview);
            
            if (imgName) {
                
                make.height.mas_equalTo(44);
                make.width.mas_equalTo(44);
                
            }else{
                
                make.height.mas_equalTo(44);
                make.width.mas_equalTo(100);
            }
            
            
        }];

    }else{
       
        [self.left setTitle:title forState:UIControlStateNormal];

    
    }
    
    
   // self.left.imageEdgeInsets = UIEdgeInsetsMake(0, -21, 0, 0);
    
}
/**
 *  设置右侧button文字和图片
 *
 *  @param title   文字
 *  @param imgName 图片
 */
- (void)setNaviBarRightTitle:(NSString *)title image:(NSString *)imgName{
    
    self.right = [UIButton buttonWithType:UIButtonTypeCustom];
    self.right.backgroundColor = CLEARCOLOR;
    if (!title && !imgName) {
        @throw [NSException exceptionWithName:@"警告" reason:@"文字和图片不能同时为空!" userInfo:nil];
    }
    
    if (!imgName) {
        [self.right setTitle:title forState:UIControlStateNormal];
        self.right.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.right.titleLabel setTextColor:WHITECOLOR];
        self.right.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    } else {
        [self.right setImage:ImageNamed(imgName)
                   forState:UIControlStateNormal];
    }
    [self.naview addSubview:self.right];
    [self.right addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.equalTo(self.naview);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
}

/**
 *  设置右侧button文字和图片们
 *
 *  @param title   文字
 *  @param imgName 图片
 */

- (void)setNaviBarRightTitle:(NSString *)title images:(NSArray *)imgNames{
    
    //靠右的
    self.right = [UIButton buttonWithType:UIButtonTypeCustom];
    self.right.backgroundColor = CLEARCOLOR;
    [self.right setImage:ImageNamed(imgNames[1])
                forState:UIControlStateNormal];
    
    
    
    UIButton *btns = [UIButton buttonWithType:UIButtonTypeCustom];
    btns.backgroundColor = CLEARCOLOR;
    [btns setImage:ImageNamed(imgNames[0])
                forState:UIControlStateNormal];
    
     self.right.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
   
    [self.naview addSubview:self.right];
    [self.naview addSubview:btns];
    
    //搜索
    [self.right addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self.naview);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];

    
    //删除
    [btns addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    [btns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self.naview);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    
    
    
}



/**
 *  设置导航条背景颜色
 *
 *  @param color 颜色
 *  @param topColor 状态栏背景颜色
 */
- (void)setNaviBarBackgroundColor:(UIColor *)color andStatusBarColor:(UIColor *)topColor{

    self.bottomView.backgroundColor =  (color == nil)?NavigatorColor:color;

//    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
//    topView.backgroundColor = (topColor == nil)?StatusBarColor:topColor;;
//    [_bottomView addSubview:topView];
    
}
/**
 *  设置左侧button的文字颜色
 *
 *  @param color 颜色
 */
- (void)setLeftTitleColor:(UIColor *)color{
    
    [self.left setTitleColor:color forState:UIControlStateNormal];
}
/**
 *  设置右侧button的颜色
 *
 *  @param color 颜色
 */
- (void)setRightTitleColor:(UIColor *)color{
    
    [self.right setTitleColor:color forState:UIControlStateNormal];
}
- (void)setNavtiLineHidden:(BOOL)hidden{
    
    self.line.hidden = hidden;
}

- (void)leftAction:(UIButton *)button{
    
    NSLog(@"点击了左侧button!");
    
}
- (void)rightAction:(UIButton *)button{
    
    NSLog(@"点击了右侧button!");
    
}


-(NSString *)getLeftTitle
{
    return self.left.titleLabel.text;
}



- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

  //  [MobClick beginLogPageView:NSStringFromClass([self class])];
    
    Class class = NSClassFromString(@"TWLoginViewController");
    
    if (![self isKindOfClass:class]) {
        [self testifyToken];
    }

    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
   // [MobClick endLogPageView:NSStringFromClass([self class])];
    
    HSNetWorking *manager = [HSNetWorking shareManager];
    [manager.operationQueue cancelAllOperations];
    
    [SVProgressHUD dismiss];
    
  
}


-(void)logoutView:(NSNotification *)notify
{
    NSDictionary *userInfo = notify.userInfo;
    
    if ([userInfo[@"islogout"] integerValue ] == 1) {
        
        
        TWLogOutView *view = [TWLogOutView logoutView];
        
        __weak typeof(self) weakSelf = self;
        
        view.logoutBlock = ^(){
            
            [weakSelf changeRootViewController];
            
        };
        
        [view show];
        
        
        [UserDefaults removeObjectForKey:@"token"];

        
    }

}



- (void)dealloc{
    
    NSLog(@" ******** %@ ******** 销毁了 ********",self);
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Logout" object:nil];
}

@end






























