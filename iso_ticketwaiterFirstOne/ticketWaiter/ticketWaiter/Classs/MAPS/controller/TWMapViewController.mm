
//
//  PanoShowViewController.m
//  PanoramaViewDemo
//
//  Created by baidu on 15/4/10.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "TWMapViewController.h"

//全景地图
#import <BaiduPanoSDK/BaiduPanoramaView.h>
#import <BaiduPanoSDK/BaiduPanoUtils.h>
#import <BaiduPanoSDK/BaiduLocationPanoData.h>
#import <BaiduPanoSDK/BaiduPoiPanoData.h>
#import <BaiduPanoSDK/BaiduPanoDataFetcher.h>

//基础地图
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
//#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
//#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
//#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
//#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
//#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
//#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件





#import "PanoFpsLabel.h"

#import "TWShareView.h"
#import <UMSocialCore/UMSocialCore.h>

#import "TWObtainImage.h"
#import "HGSaveNoticeTool.h"



@interface TWMapViewController ()<BaiduPanoramaViewDelegate,TWShareViewDelegate,BMKMapViewDelegate>

@property(strong, nonatomic) BaiduPanoramaView  *panoramaView;
@property(strong, nonatomic) UITextField *panoPidTF;
@property(strong, nonatomic) UITextField *panoCoorXTF;
@property(strong, nonatomic) UITextField *panoCoorYTF;
@property(strong, nonatomic) PanoFpsLabel *fpsLabel;// 是否掉帧

@property(nonatomic)BMKMapView *mapView;

@property(nonatomic)BMKPointAnnotation *annoView;


@property(nonatomic)UIImage *streetPic;

@property(nonatomic)BOOL  isHaveJieJing;


@end

@implementation TWMapViewController


-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放

}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];

    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64,SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.mapView = mapView;
    
    _isHaveJieJing = 1;

    [self customPanoView];

   //  [self storePic];
    
    
   // [self customInputView];
  //  [self customPanoFPSLabel];


}

#pragma mark - 代理方法
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        
        //self.annoView = newAnnotationView;
       // newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.image = [UIImage imageNamed:@"icon_bz"];
        return newAnnotationView;
    }
    return nil;
}


- (void)dealloc {
    [self.panoramaView removeFromSuperview];
    self.panoramaView.delegate = nil;
    self.panoramaView = nil;
    
    [self.mapView removeFromSuperview];
    self.mapView.delegate = nil;
    self.mapView = nil;
    
}
- (void)customInputView {
    
    CGFloat offsety = 64;
    CGRect btnFrame = CGRectMake(260, offsety, 50, 30);
    UIButton *enterBtn = [self createButton:@"确定" target:@selector(refreshPanoViewData) frame:btnFrame];
    [self.view addSubview:enterBtn];
    
    CGFloat coffsety = 124;
    CGRect cbtnFrame = CGRectMake(260, coffsety, 50, 30);
    UIButton *testBtn = [self createButton:@"测试" target:@selector(onTestBtn) frame:cbtnFrame];
    [self.view addSubview:testBtn];
    if (self.showType == PanoShowTypePID) {
        self.panoPidTF = [[UITextField alloc]initWithFrame:CGRectMake(5, offsety, 250, 30)];
        self.panoPidTF.backgroundColor = [UIColor whiteColor];
        self.panoPidTF.placeholder     = @" 输入全景PID展示全景";
        [self.view addSubview:self.panoPidTF];
    }else if (self.showType == PanoShowTypeGEO) {
        self.panoCoorXTF = [[UITextField alloc]initWithFrame:CGRectMake(5, offsety, 250, 30)];
        self.panoCoorXTF.backgroundColor = [UIColor whiteColor];
        self.panoCoorXTF.placeholder     = @"输入地理坐标longitude";
        offsety += 35;
        self.panoCoorYTF = [[UITextField alloc]initWithFrame:CGRectMake(5, offsety, 250, 30)];
        self.panoCoorYTF.backgroundColor = [UIColor whiteColor];
        self.panoCoorYTF.placeholder     = @"输入地理坐标latitude";
        [self.view addSubview:self.panoCoorXTF];
        [self.view addSubview:self.panoCoorYTF];
    }else if (self.showType == PanoShowTypeUID) {
        self.panoPidTF = [[UITextField alloc]initWithFrame:CGRectMake(5, offsety, 250, 30)];
        self.panoPidTF.backgroundColor = [UIColor whiteColor];
        self.panoPidTF.placeholder     = @" 输入POI 的 UID展示全景";
        // uid 测试
        self.panoPidTF.text = @"881a28e7bbf2f45ef842b2f5";
//        self.panoPidTF.text = @"5c2dc21d1edf15046ec02caa";// 只有外景
//        self.panoPidTF.text = @"1a30c5f8cbb55eff71210b02";
//        self.panoPidTF.text = @"fd007c5e7df31675a8f729c0";
        [self.view addSubview:self.panoPidTF];
    }else {
        self.panoCoorXTF = [[UITextField alloc]initWithFrame:CGRectMake(5, offsety, 250, 30)];
        self.panoCoorXTF.backgroundColor = [UIColor whiteColor];
        self.panoCoorXTF.placeholder     = @"输入百度坐标X";
        self.panoCoorXTF.text = @"1293476325";
        offsety += 35;
        self.panoCoorYTF = [[UITextField alloc]initWithFrame:CGRectMake(5, offsety, 250, 30)];
        self.panoCoorYTF.backgroundColor = [UIColor whiteColor];
        self.panoCoorYTF.placeholder     = @"输入百度坐标Y";
        self.panoCoorYTF.text = @"485045009";
        [self.view addSubview:self.panoCoorXTF];
        [self.view addSubview:self.panoCoorYTF];
    }
}

- (void)customPanoView {
    CGRect frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    
    // key 为在百度LBS平台上统一申请的接入密钥ak 字符串
    self.panoramaView = [[BaiduPanoramaView alloc] initWithFrame:frame key:BaiDUKey];
    // 为全景设定一个代理
    self.panoramaView.delegate = self;
    [self.view addSubview:self.panoramaView];
    
    // 设定全景的清晰度， 默认为middle
    [self.panoramaView setPanoramaImageLevel:ImageDefinitionMiddle];
    
    NSString *strr = self.positionStr;
    
    if (strr.length>0) {
        
        NSArray *arr = [strr componentsSeparatedByString:@","];
        
        [self.panoramaView setPanoramaWithLon:[arr[0] floatValue] lat:[arr[1] floatValue]];
    }
    
   
    
}

- (void)customPanoFPSLabel {
    _fpsLabel = [ PanoFpsLabel new];
    [_fpsLabel sizeToFit];
    _fpsLabel.frame = CGRectMake(20.0f, self.view.frame.size.height-40, 60.0f, 25.0f);
    [self.view addSubview:_fpsLabel];
}

- (void)showPanoViewWithPID:(NSString *)pid {
    [self.panoramaView setPanoramaWithPid:pid];
}

- (void)showPanoViewWithLon:(double)lon lat:(double)lat {
    [self.panoramaView setPanoramaWithLon:lon lat:lat];
}

- (void)showPanoViewWithX:(int)x Y:(int)y {
    [self.panoramaView setPanoramaWithX:x Y:y];
}

- (void)showPanoViewWithUID:(NSString *)uid {
    [self.panoramaView setPanoramaWithUid:uid type:BaiduPanoramaTypeStreet];
}

- (void)onTestBtn {
    [self.panoramaView setPoiOverlayHidden:YES];
}

- (void)refreshPanoViewData {
    if ( self.showType == PanoShowTypePID ) {
        if (self.panoPidTF.text.length>0) {
            [self showPanoViewWithPID:self.panoPidTF.text];
        }
        [self.panoPidTF resignFirstResponder];
    } else if ( self.showType == PanoShowTypeGEO ) {
        if ( self.panoCoorXTF.text.length > 0 && self.panoCoorYTF.text.length > 0 ) {
            [self showPanoViewWithLon:[self.panoCoorXTF.text doubleValue] lat:[self.panoCoorYTF.text doubleValue]];
        }
        [self.panoCoorXTF resignFirstResponder];
        [self.panoCoorYTF resignFirstResponder];
    } else if ( self.showType == PanoShowTypeUID ) {
        if ( self.panoPidTF.text.length ) {
            [self showPanoViewWithUID:self.panoPidTF.text];
//              [self.panoramaView setPanoramaWithLon:121.454051 lat:31.267445];
        }
    } else {
        if ( self.panoCoorXTF.text.length > 0 && self.panoCoorYTF.text.length > 0 ) {
            [self showPanoViewWithX:[self.panoCoorXTF.text intValue] Y:[self.panoCoorYTF.text intValue]];
        }
        [self.panoCoorXTF resignFirstResponder];
        [self.panoCoorYTF resignFirstResponder];
    }

}

#pragma mark - panorama view delegate

- (void)panoramaWillLoad:(BaiduPanoramaView *)panoramaView {
   
}

- (void)panoramaDidLoad:(BaiduPanoramaView *)panoramaView descreption:(NSString *)jsonStr {
    
}


- (void)panoramaLoadFailed:(BaiduPanoramaView *)panoramaView error:(NSError *)error {
    
    
    _isHaveJieJing = 0;
    
    [self.view addSubview:self.mapView];
    
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    
    self.annoView  = annotation;
    CLLocationCoordinate2D coor;
    
    NSString *strr = self.positionStr;
    if (strr.length>0) {
        NSArray *arr = [strr componentsSeparatedByString:@","];
    
    coor.latitude = [arr[1] floatValue];
    coor.longitude = [arr[0] floatValue];
    annotation.coordinate = coor;
    annotation.title = [NSString stringWithFormat:@"%@彩票站",self.nameStr];
    annotation.subtitle = @"快过来投注吧!";
        
    [self.mapView addAnnotation:annotation];
    }
    self.mapView.centerCoordinate = self.annoView.coordinate;
    
}

- (void)panoramaView:(BaiduPanoramaView *)panoramaView overlayClicked:(NSString *)overlayId {
  
}

- (void)panoramaView:(BaiduPanoramaView *)panoramaView didReceivedMessage:(NSDictionary *)dict {
    
}


#pragma mark - other func 
- (UIButton *)createButton:(NSString *)title target:(SEL)selector frame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7 ) {
        [button setBackgroundColor:[UIColor whiteColor]];
    } else {
        [button setBackgroundColor:[UIColor clearColor]];
    }
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//获取设备bound方法
- (BOOL)isPortrait {
    UIInterfaceOrientation orientation = [self getStatusBarOritation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return YES;
    }
    return NO;
}
- (UIInterfaceOrientation)getStatusBarOritation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    return orientation;
}
- (CGRect)getFixedScreenFrame {
    CGRect mainScreenFrame = [UIScreen mainScreen].bounds;
#ifdef NSFoundationVersionNumber_iOS_7_1
    if(![self isPortrait]&& (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1)) {
        mainScreenFrame = CGRectMake(0, 0, mainScreenFrame.size.height, mainScreenFrame.size.width);
    }
#endif
    return mainScreenFrame;
}







#pragma mark - 设置Navigation
- (void)setNavigationBar{
 
     [self setNaviBarBackgroundColor:nil andStatusBarColor:nil];
     [self setNaviBarLeftTitle:nil image:@"icon_bar_back"];

    NSString *mid = [HGSaveNoticeTool obtainPersonInfoDataWithKey:@"mid"];
    
    if ([mid isEqualToString:self.mid]) {
        
        [self setNaviBarTitle:@"我的站点街景" color:WHITECOLOR];
        [self setNaviBarRightTitle:@"分享位置" image:nil];
    }else{
        
        [self setNaviBarTitle:[NSString stringWithFormat:@"%@站点街景",self.nameStr] color:WHITECOLOR];
    
    }
    
    
    
}

- (void)leftAction:(UIButton *)button{
 
     [self.navigationController popViewControllerAnimated:YES];
 
}

- (void)rightAction:(UIButton *)button{

    TWShareView *shareView = [TWShareView shareView];
    
    shareView.delegate = self;
    
    [shareView show];

    [self storePic];
    
}


-(void)secletedNum:(int)num
{
    
    UMSocialPlatformType platformtype = UMSocialPlatformType_Sina;
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"彩票小二站点分享" descr:[NSString stringWithFormat:@"%@",self.nameStr] thumImage:self.streetPic];
    //设置网页地址
    shareObject.webpageUrl = [self obtainShareLocation];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    
    if (num == 1) {
        
        platformtype  = UMSocialPlatformType_WechatSession;
        
    }else if (num == 2){
    
        platformtype  = UMSocialPlatformType_WechatTimeLine;
    
    }else if (num == 3){
        
        platformtype  = UMSocialPlatformType_QQ;
        
    }else if (num == 4){
        
        platformtype  = UMSocialPlatformType_Qzone;
        
    }else if (num == 5){
        
        platformtype  = UMSocialPlatformType_Sina;
        
        //设置文本
        messageObject.text = [NSString stringWithFormat:@"%@彩票小二位置分享 %@",self.nameStr,[self obtainShareLocation]];
        
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        //如果有缩略图，则设置缩略图
        shareObject.thumbImage = self.streetPic;
        [shareObject setShareImage:self.streetPic];
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;

    }

    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformtype messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
            
             [SVProgressHUD showErrorWithStatus:@"分享取消"];
            
            
        }else{
            NSLog(@"response data is %@",data);
            
            NSDictionary *dic = data;
            
            NSLog(@"++++++%@",dic);
            
            
            [SVProgressHUD showSuccessWithStatus:@"分享成功"];
            
        }
    }];


}

#pragma mark - 分享链接

-(NSString *)obtainShareLocation
{

    NSString *strr = self.positionStr;
    
    NSArray *arr = [strr componentsSeparatedByString:@","];

    
    return  [NSString stringWithFormat:@"http://lottery.webtest.hui10.com/map/panorama.html?lng=%f&lat=%f&flag=%@",[arr[0] floatValue],[arr[1] floatValue],_isHaveJieJing==1?@"true":@"false"];
   
}


#pragma mark - 截取当前图片
-(void)storePic
{
    
    NSString *strr = self.positionStr;
    
    NSArray *arr = [strr componentsSeparatedByString:@","];
    
    if (_isHaveJieJing) {
        
        
        if (strr.length>0) {
            
            [TWObtainImage LocalHaveImageWithImageName:[NSString stringWithFormat:@"http://api.map.baidu.com/panorama/v2?ak=%@&width=512&height=256&location=%f,%f&fov=180&mcode=%@",BaiDUKey,[arr[0] floatValue],[arr[1] floatValue],BundleId] andReturnBlock:^(UIImage *image) {
                
                if (image) {
                    
                    self.streetPic = [[UIImage alloc] initWithData:UIImagePNGRepresentation(image) scale:1];
                }else{
                    
                    self.streetPic = [UIImage imageNamed:@"img_logo_00"];
                    
                }
            }];
            
        }
    }else{
        
        [TWObtainImage LocalHaveImageWithImageName:[NSString stringWithFormat:@"http://api.map.baidu.com/staticimage/v2?ak=%@&mcode=%@&center=%f,%f&width=300&height=200&zoom=11",BaiDUKey,BundleId,[arr[0] floatValue],[arr[1] floatValue]] andReturnBlock:^(UIImage *image) {
            
            if (image) {
                
                self.streetPic = [[UIImage alloc] initWithData:UIImagePNGRepresentation(image) scale:1];
            }else{
                
                self.streetPic = [UIImage imageNamed:@"img_logo_00"];
                
            }
            
            
        }];
        
        
    }
    
    
    
}



//- (UIImage *) captureScreen {
//    
//    
//    
//     [self.mapView takeSnapshot];
//    
//    
//    
//    CGRect rect = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH);
//    
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//    UIRectClip(rect);
//
//    if (_isHaveJieJing) {
//        [self.panoramaView.layer renderInContext:context];
//        UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        return  theImage;
//    }else{
//        [self.mapView.layer renderInContext:context];
//        UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        return  theImage;
//    
//    }
//    
//    
//}





-(NSString *)positionStr
{
    if (!_positionStr) {
        _positionStr = [[NSString alloc] init];
    }
    return _positionStr;
}

-(NSString *)nameStr
{
    if (!_nameStr) {
        _nameStr = [[NSString alloc] init];
    }
    return _nameStr;
    
}

-(NSString *)titleStr
{
    if (!_mid) {
        _mid = [[NSString alloc] init];
    }
    return _mid;

}


@end
