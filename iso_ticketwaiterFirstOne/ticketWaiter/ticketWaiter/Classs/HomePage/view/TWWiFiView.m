//
//  TWWiFiView.m
//  ticketWaiter
//
//  Created by LY on 17/1/11.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWWiFiView.h"
#import "HGSaveNoticeTool.h"

//获取wifi地址
#import <SystemConfiguration/CaptiveNetwork.h>

@interface TWWiFiView ()
{
    BOOL _isAutolayout;
    
}

@property (weak, nonatomic) IBOutlet UIView *greenView;

@property (weak, nonatomic) IBOutlet UIImageView *wifiCloseView;


//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t1;


@property(nonatomic,assign)CGRect  wifiRect;

@property(nonatomic,assign)CGFloat weight;

@property(nonatomic,assign)NSInteger  runtimes;



@end


@implementation TWWiFiView


-(void)awakeFromNib
{
    if (!_isAutolayout) {
        
        _h1.constant = FitValue(_h1.constant);
        _w1.constant = FitValue(_w1.constant);
        
//        [self addTimer];
        
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popClick)];
        
        [self addGestureRecognizer:tapGr];
    }
    
    
}


+(instancetype)wifiView
{
    TWWiFiView *wiFiView = [[[NSBundle mainBundle] loadNibNamed:@"TWWiFiView" owner:self options:0] lastObject];

    [wiFiView refreshWifiWithWeight:0];
    

    
    return wiFiView;
    
    
}


-(void)addTimer
{
    //_runtimes = 1;
    
    
    if (!self.timer) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkWifi:) userInfo:nil repeats:YES];
    }else{
    
        [self.timer fire];
    }
    
    

    if (LYTOKEN) {
        
       [self.timer fire];
    }
    
    
    
}

-(void)checkWifi:(NSTimer *)timer
{

    //获取wifi地址
   // NSLog(@"macmacmac-----------%@",[self obtainWifimacAddress]);
    
    if ([[[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"stationno"] description] length] == 0) {
        return;
    }
    
    NSString *macc = [self obtainWifimacAddress];
    
    if (macc.length<12) {
        
        _isHaveMac = 0;
        [self refreshWifiWithWeight:0];
        return;
    }
    
    _isHaveMac = 1;
    
//    if ([LYAccount isEqualToString:@"0000000003"]) {
//        
//        macc = MacAddress3;
//    }else if ([LYAccount isEqualToString:@"0000012172"]){
//        
//        macc = MacAddress4;
//        
//    }else{
//        
//        macc = MacAddress;
//    }
    
    
    if (!LYTOKEN) {
        
        return;
    }
    
    
    NSDictionary *param = @{@"token":LYTOKEN,@"stationno":[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"stationno"],@"stationprovince":[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"stationprovince"],@"wifimac":macc};

    
    [HSNetWorking postWithURLString:@"v1/lottery/checkbetarea" parameters:param success:^(id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        NSLog(@"%@",dic);
        
        if ([dic[@"success"] integerValue] == 1) {
            
            NSInteger result = [dic[@"result"] integerValue];
            
#warning ------------------
            [self refreshWifiWithWeight:result];
            
            
        }else{
            
             [self refreshWifiWithWeight:0];
            //[SVProgressHUD showErrorWithStatus:dic[@"em"]];
            
        }
        
        
    } failure:^(NSError *error) {
        
        [self refreshWifiWithWeight:0];

        NSLog(@"error---------%@",error);
        
        
    }];
 


}


//停止timer
-(void)stopTimer
{
    self.timer.fireDate = [NSDate distantFuture];

}

//打开timer
-(void)startTimer
{
    self.timer.fireDate = [NSDate distantPast];

}


//提示在不在购彩区域里面
-(void)popClick
{
    
    self.userInteractionEnabled = NO;
    
    [self performSelector:@selector(delayClick:) withObject:self afterDelay:1.5];
    
    if (self.isOk) {
        //在里面
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您已在购彩区域内" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }else{
    
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您未在购彩区域内" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }


}


-(void)delayClick:(UIView *)view
{

    view.userInteractionEnabled = YES;
}







-(void)refreshWifiWithWeight:(CGFloat)weight
{

    if (weight>0) {
        
        _isOk = 1;
    }else{
    
        _isOk = 0;
    }
    
    CGRect frame = self.frame;

    
    _t1.constant =  (1 - weight) * frame.size.height;
    
    if (weight>0) {
        
        self.wifiCloseView.hidden = YES;
        
    }else{
        
        self.wifiCloseView.hidden =  NO;
    }

    
}


-(NSString *)obtainWifimacAddress
{
    NSString *ssid = @"";
    NSString *mac = @"";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
  
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            
            ssid = [dict valueForKey:@"SSID"];
            mac = [dict valueForKey:@"BSSID"];
           // NSDictionary *ssidData = [dict valueForKey:@"SSIDDATA"];
            
        }
    }
    
    NSArray *tmpArr = [mac componentsSeparatedByString:@":"];
    
    NSMutableArray *bssidArr = [[NSMutableArray alloc] init];
    
    for (int i=0; i<tmpArr.count; i++) {
        
        NSMutableString *strr = [NSMutableString stringWithString:tmpArr[i]];
        
        if (strr.length<2) {
            
            [strr insertString:@"0" atIndex:0];
        }
        
        [bssidArr addObject:strr];
        
    }

    return [bssidArr componentsJoinedByString:@":"];

}






-(void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;

}








@end
