//
//  TWHomeViewController.m
//  ticketWaiter
//
//  Created by LY on 16/12/22.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "TWHomeViewController.h"
#import "TWHomeViewModel.h"
#import "TWHomeViewCell.h"
#import "TWHomeFooterView.h"
#import "TWWiFiView.h"

#import "TWHomeAllViewModel.h"


//子页面
#import "TWMapViewController.h"
#import "HGMineViewController.h"
#import "HGTasksOfThreeVC.h"
#import "TWVIPViewController.h"
#import "TWPayBackVC.h"
#import "TWOrderViewController.h"

//登录
#import "TWLoginViewController.h"
#import "HGSaveNoticeTool.h"


#import "TWOpenAndPayVC.h"

@interface TWHomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *myFlowlayout;

@property(nonatomic)NSMutableArray *dataArr;

@property(nonatomic)TWWiFiView *wifiView;


@property(nonatomic,assign)BOOL  isNeedPayHide;

@end

@implementation TWHomeViewController

-(void)viewWillAppear:(BOOL)animated
{
        
    [super viewWillAppear:animated];
    //self.fd_prefersNavigationBarHidden = YES;

    if (self.wifiView) {
        
        [self.wifiView startTimer];
    }
    
    if (_isLoginTo) {
        
        [self setHomeViewWithDictionary:self.merchantDic];
        _isLoginTo = 0;
        
    }else{
    
        //拉取用户信息
        [self fetchMergentInfo];
        
    }
    
    //判断支付环境是否OK
    TWHomeAllViewModel *viewModel = [[TWHomeAllViewModel alloc] init];
    
    [viewModel  judgeZhiFuIsOk:^(id result) {
        
        NSDictionary *dic = (NSDictionary *)result;
        if ([dic[@"success"] integerValue] == 1 ) {
            
            //设置数据源
            if ([dic[@"result"] integerValue] == 1) {
                // 需要隐藏
                [HGSaveNoticeTool updatePersonInfodataWithKey:@"hidepay" andValue:@"1"];
                
                if (self.dataArr.count == 6) {
                    [self.dataArr removeObjectAtIndex:2];
                }
                
                _isNeedPayHide = 1;
                
            }else{
                // 不需要隐藏
                [HGSaveNoticeTool updatePersonInfodataWithKey:@"hidepay" andValue:@"0"];

                if (self.dataArr.count == 5) {
                    
                    TWHomeViewModel *model = [[TWHomeViewModel alloc] init];
                    model.title = @"赠送彩金";
                    model.imageName = @"icon_zscj";
                    [self.dataArr insertObject:model atIndex:2];
                }

                _isNeedPayHide = 0;

            }
            
            
        }
        
        [self.myCollectionView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
        if ([[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"hidepay"] length]>0) {
            
            _isNeedPayHide = [[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"hidepay"] integerValue];
            
            if (_isNeedPayHide == 1) {
                
                if (self.dataArr.count == 6) {
                    [self.dataArr removeObjectAtIndex:2];
                }
                
            }else{
            
                if (self.dataArr.count == 5) {
                    
                    TWHomeViewModel *model = [[TWHomeViewModel alloc] init];
                    model.title = @"赠送彩金";
                    model.imageName = @"icon_zscj";
                    [self.dataArr insertObject:model atIndex:2];
                }
                
            }
            
        }else{
        
            [HGSaveNoticeTool updatePersonInfodataWithKey:@"hidepay" andValue:@"1"];
            
            if (self.dataArr.count == 6) {
                [self.dataArr removeObjectAtIndex:2];
            }
            
            _isNeedPayHide = 1;
        
        }
        
        [self setHomeViewWithHistoryData];
    
        [self.myCollectionView reloadData];

    }];
    


    //检测wifi环境
   // [self mornitorWifi];
    
    

}

//#pragma mark - 咩有网络状态
//- (void)netWorkNotReachable{
//    
//}
//
//
//#pragma mark - 有网络连接
//- (void)netWorkReachable{
//    
//    
//}




-(void)viewWillDisappear:(BOOL)animated
{
   
    [self.wifiView stopTimer];
    [super viewWillDisappear:animated];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBar];


    [_myCollectionView registerNib:[UINib nibWithNibName:@"TWHomeViewCell" bundle:nil] forCellWithReuseIdentifier:@"TWHomeViewCell"];
    [_myCollectionView registerNib:[UINib nibWithNibName:@"TWHomeFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"TWHomeFooterView"];
    
   // CGFloat f=FitValue(2);
    
    _myFlowlayout.itemSize = CGSizeMake(FitValue(374/2.0), FitValue(362/2.0));
  
    _myFlowlayout.sectionInset = UIEdgeInsetsMake(1, 0, 1, 0);
    // 设置最小行间距
    _myFlowlayout.minimumLineSpacing = 1;
    _myFlowlayout.minimumInteritemSpacing = 1;
    
    _myFlowlayout.footerReferenceSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64-FitValue(1*4 + 362*1.5));

}



-(void)netok
{
    #warning -----------------

}

#pragma mark - 拉取用户信息
-(void)fetchMergentInfo
{
    TWHomeAllViewModel *model = [[TWHomeAllViewModel alloc] init];
    
    [model fetchMergentInfoWithToken:LYTOKEN returnBack:^(id result) {
        
        NSDictionary *dic = (NSDictionary *)result;
        
        if ([dic[@"success"] integerValue] == 1) {
            
            NSMutableDictionary *dataDic = [dic[@"result"] mutableCopy];
            
            NSArray *dictKeysArray = [dataDic allKeys];
            for (int i = 0; i<dictKeysArray.count; i++) {
                
                NSString *key = dictKeysArray[i];
                
                if ([[dataDic objectForKey:key] isEqual:[NSNull null]]) {
                    
                    [dataDic setValue:@"" forKey:key];
                }
                
                [HGSaveNoticeTool updatePersonInfodataWithKey:key andValue:[dataDic objectForKey:key]];
            }
            
            //leveltype 是否是试用账号
            [self setHomeViewWithDictionary:dataDic];
   
            //[UserDefaults setObject:dic[@"result"] forKey:@"token"];
            
            // [UserDefaults setObject:_accountTf.text forKey:@"phone"];
            
            //跳到首页
            
            //  [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            
            
        }else{
            
                        
            //1010000002
            
            //  [SVProgressHUD showErrorWithStatus:dic[@"em"]];
            
            
        }
        
        
        
    }];



}

#pragma mark - 设置首页数据 刷新首页数据
-(void)setHomeViewWithDictionary:(NSDictionary *)dic
{

    
    [self.wifiView addTimer];
    
    self.fd_prefersNavigationBarHidden = YES;

    
    NSInteger  num = self.dataArr.count;
    
    //是否是试用账号
    TWHomeViewModel *model = self.dataArr[num-2];
    if ([dic[@"leveltype"] integerValue] == 1) {
        
        model.subTitle = @"升级或开通正式版";
        [self setNaviBarLeftTitle:@"试用账号" image:nil];
        
    }else if([dic[@"leveltype"] integerValue] == 2){
        
        //正式版
        model.subTitle = @"";
        [self setNaviBarLeftTitle:@"" image:nil];

    }else{
        //已过期
        model.subTitle = @"升级或开通正式版";
        [self setNaviBarLeftTitle:@"过期账号" image:nil];
    
    }
    //是否要更新
    //appversion
    TWHomeViewModel *model5 = self.dataArr[num-1];
    if ([[dic[@"appversion"] description] length] >0) {
         model5.subTitle = @"有新版本";
    }else{
    
        model5.subTitle = @"";
    }

 
}

#pragma mark - 用历史数据刷新首页
-(void)setHomeViewWithHistoryData
{
    self.fd_prefersNavigationBarHidden = YES;
    
    NSInteger  num = self.dataArr.count;

    //是否是试用账号
    TWHomeViewModel *model = self.dataArr[num-2];
    if ([[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"leveltype"] integerValue] == 1) {
        
        model.subTitle = @"升级或开通正式版";
        [self setNaviBarLeftTitle:@"试用账号" image:nil];
        
    }else if([[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"leveltype"] integerValue] == 2){
        
        //正式版
        model.subTitle = @"";
        [self setNaviBarLeftTitle:@"" image:nil];
        
    }else{
        //已过期
        model.subTitle = @"升级或开通正式版";
        [self setNaviBarLeftTitle:@"过期账号" image:nil];
        
    }
    //是否要更新
    //appversion
    TWHomeViewModel *model5 = self.dataArr[num-1];
    if ([[[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"appversion"] description] length] >0) {
        model5.subTitle = @"有新版本";
    }else{
        
        model5.subTitle = @"";
    }
    
    [self.myCollectionView reloadData];
    
}



#pragma mark - 弹出框代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11&&buttonIndex == 1) {
        //升级账号
        TWOpenAndPayVC *bb = [[TWOpenAndPayVC alloc] init];
        
        [self.navigationController pushViewController:bb animated:YES];
        
    }
    
    if (alertView.tag == 41&&buttonIndex == 1) {
#warning -----------------
        
        if ([[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"appversion"] description].length >0) {
            //更新版本
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"upgradeurl"]]];
        }
        
       
        
    }
    
    


}



#pragma mark - 代理方法

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
  
    if (kind == UICollectionElementKindSectionFooter)
    {
        TWHomeFooterView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"TWHomeFooterView" forIndexPath:indexPath];

        __weak typeof(self) weakSelf = self;
        
        footerview.mapBlock = ^(){
            
            NSMutableString *strr = [HGSaveNoticeTool obtainPersonInfoDataWithKey:@"position"];
            
            if (strr.length>0) {
                //推出地图页面
                TWMapViewController *psVC = [[TWMapViewController alloc]init];
                psVC.positionStr = [HGSaveNoticeTool obtainPersonInfoDataWithKey:@"position"];
                psVC.showType = PanoShowTypeGEO;
                psVC.nameStr = [HGSaveNoticeTool obtainPersonInfoDataWithKey:@"merchantname"];
                psVC.mid = [HGSaveNoticeTool obtainPersonInfoDataWithKey:@"mid"];

                //            switch (indexPath.row) {
                //                case 0:
                //                    psVC.showType = PanoShowTypePID;
                //                    break;
                //                case 1:
                //                    psVC.showType = PanoShowTypeGEO;
                //                    break;
                //                case 2:
                //                    psVC.showType = PanoShowTypeXY;
                //                    break;
                //                case 3:
                //                    psVC.showType = PanoShowTypeUID;
                //                    break;
                //                default:
                //                    psVC.showType = PanoShowTypePID;
                //                    break;
                //            }
                
                [self.navigationController pushViewController:psVC animated:YES];
            }else{
            
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"未找到您的位置信息" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertview show];
            
            }

        };
        reusableView = footerview;
    }
    return reusableView;


}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TWHomeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TWHomeViewCell" forIndexPath:indexPath];
    
    cell.model = (TWHomeViewModel *)self.dataArr[indexPath.row];

    return cell;

}

#pragma mark - 跳转方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    collectionView.userInteractionEnabled = NO;
    
    [self performSelector:@selector(delayClick:) withObject:collectionView afterDelay:1.0];
    
    
    NSInteger num = [[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"hidepay"] integerValue];

    if (num == 0) {
        
        switch (indexPath.row+1) {
            case 1:{
                
                //会员管理
                TWVIPViewController *vc = [[TWVIPViewController alloc] init];
                
                [self.navigationController pushViewController:vc animated:YES];
                
                break;
                
            }
            case 2:{
                //彩票订单
                
                TWOrderViewController *vc = [[TWOrderViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                
                break;
            }
            case 3:{
                
                //赠送彩金
                TWPayBackVC *vc = [[TWPayBackVC alloc] init];
                
                [self.navigationController pushViewController:vc animated:YES];
                
                break;
            }
            case 4:{
                
                //数据统计
                HGTasksOfThreeVC *vc = [[HGTasksOfThreeVC alloc] init];
                
                [self.navigationController pushViewController:vc animated:YES];
                
                break;
            }
            case 5:{
                
                //设置
                HGMineViewController *bb = [[HGMineViewController alloc] init];
                
                [self.navigationController pushViewController:bb animated:YES];
                
                break;
            }
            case 6:{
                
                
                if ([[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"appversion"] description].length > 0) {
                    //更新版本
                    //版本更新
                    [self createAlertView:nil andMessage:[NSString stringWithFormat:@"发现新版本%@，是否更新",[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"appversion"]] andCancel:@"取消" andSure:@"确定" andTag:41];
                    
                }else{
                    
                }
                
                break;
            }
                
            default:
                break;
        }

        
        
    }else{
        
        switch (indexPath.row+1) {
            case 1:{
                
                //会员管理
                TWVIPViewController *vc = [[TWVIPViewController alloc] init];
                
                [self.navigationController pushViewController:vc animated:YES];
                
                break;
                
            }
            case 2:{
                //彩票订单
                
                TWOrderViewController *vc = [[TWOrderViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                
                break;
            }
//            case 3:{
//                
//                //赠送彩金
//                TWPayBackVC *vc = [[TWPayBackVC alloc] init];
//                
//                [self.navigationController pushViewController:vc animated:YES];
//                
//                break;
//            }
            case 3:{
                
                //数据统计
                HGTasksOfThreeVC *vc = [[HGTasksOfThreeVC alloc] init];
                
                [self.navigationController pushViewController:vc animated:YES];
                
                break;
            }
            case 4:{
                
                //设置
                HGMineViewController *bb = [[HGMineViewController alloc] init];
                
                [self.navigationController pushViewController:bb animated:YES];
                
                break;
            }
            case 5:{
                
                
                if ([[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"appversion"] description].length > 0) {
                    //更新版本
                    //版本更新
                    [self createAlertView:nil andMessage:[NSString stringWithFormat:@"发现新版本%@，是否更新",[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"appversion"]] andCancel:@"取消" andSure:@"确定" andTag:41];
                    
                }else{
                    
                }
                
                break;
            }
                
            default:
                break;
        }

    
    
    
    
    }
    
    
    
    
}


-(void)createAlertView:(NSString *)title andMessage:(NSString *)message andCancel:(NSString *)cancel andSure:(NSString *)sure andTag:(NSInteger )tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:sure, nil];

    alertView.tag = tag;
    
    [alertView show];

}

-(void)delayClick:(UICollectionView *)collectionView
{

    collectionView.userInteractionEnabled = YES;

}





#pragma mark - 设置导航栏
- (void)setNavigationBar{
    
    [self setNaviBarBackgroundColor:nil andStatusBarColor:nil];
    [self setNaviBarTitle:@"福彩小二" color:WHITECOLOR];
    
    //设置右侧的wifi信号
    
    self.wifiView = [TWWiFiView wifiView];
    
    self.wifiView.frame = CGRectMake(SCREEN_WIDTH - FitValue(43.5), 15, FitValue(22.5), FitValue(16));
    
    [self.naview addSubview:self.wifiView];
    
    //查看当前位置是否为wifi信号可用区域
    
   // [self.wifiView refreshWifiWithWeight:0.7];
   
    
#warning -------------------正式时去掉
   //  [self createNoticeKu:LYAccount];
    
    
}


-(void)createNoticeKu:(NSString *)account
{

    //建库  登录成功建库 notice换成token
    DataManager *manger = [DataManager manager];
    [manger saveDataWithFilename:account];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:[manger obtainfilePathWithFileName:account]]) {
        
        NSDictionary *dic = [[NSDictionary alloc] init];
        
        NSMutableDictionary *tmpdic = [[NSMutableDictionary alloc] initWithDictionary:@{@"mergentInfoDic":dic}];
        //建库
        [manger object:tmpdic writeToFile:@"LYDetailInfomation.plist" superFile:account];
        NSLog(@"第一次建库");
        
    }else{
        
        
    }
    
    
}







- (void)leftAction:(UIButton *)button{
    
    if ([[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"leveltype"] integerValue] != 2) {
        
        if ([[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"hidepay"] integerValue] == 0 ) {
            
            [self accountUse];
            
        }
        
        
    }


}

-(void)accountUse
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"您当前是%@,是否升级为正式账号",[self getLeftTitle]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 11;
    [alert show];
    
}



#pragma mark - 懒加载

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
        
        NSArray *titleArr = @[@"会员管理",@"彩票订单",@"每月排行榜",@"我的设置",@"检查版本"];
        NSArray *imageArr = @[@"icon_hygl",@"icon_cpdd",@"icon_sjtj",@"icon_wdsz",@"icon_jcbb"];
        
        
        for (int i=0; i<titleArr.count; i++) {
            
            TWHomeViewModel *model = [[TWHomeViewModel alloc] init];
            model.title = titleArr[i];
            model.imageName = imageArr[i];
            
            [_dataArr addObject:model];
            
        }
        
    }
    return _dataArr;
}

-(NSMutableDictionary *)merchantDic
{
    if (!_merchantDic) {
        _merchantDic = [[NSMutableDictionary alloc] init];
    }

    return _merchantDic;

}





@end
