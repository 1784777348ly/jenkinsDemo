//
//  TWOpenAndPayVC.m
//  ticketWaiter
//
//  Created by LY on 16/12/29.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "TWOpenAndPayVC.h"
#import "TWOpenAndPayCell.h"
#import "TWOpenAndPay2Cell.h"

#import "TWMineModel.h"

#import "TWMineViewModel.h"

//支付成功
#import "TWPayResultVC.h"
#import "TWBoundCardVC.h"

#import "HGSaveNoticeTool.h"

#import "NSDate+Methods.h"


@interface TWOpenAndPayVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property(nonatomic)NSMutableArray *dataArr;

@property(nonatomic)TWMineViewModel *viewModel;

@end

@implementation TWOpenAndPayVC

-(void)viewWillAppear:(BOOL)animated
{
    
    NSInteger  isHaveCard = [[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"bankcard"] integerValue];
    if (isHaveCard == 1) {
        //有卡 查询卡信息
        TWMineViewModel *viewModel = [[TWMineViewModel alloc] init];
        
        [viewModel obtainCardInfoWithReturnBlock:^(id result) {
            
            NSDictionary *cardDic = (NSDictionary *)result;
            
            if ([cardDic[@"success"] integerValue] == 1) {
                
                NSDictionary *dic = [cardDic[@"result"] firstObject];
                
                TWOpenAccountModel *model = [self.dataArr[0] objectAtIndex:0];

                model.title = dic[@"bankname"];
                model.subTitle = [NSString stringWithFormat:@"尾号 %@",dic[@"card"]];
                model.bindid = dic[@"bindid"];
                model.mid = dic[@"mid"];
                model.payid = dic[@"payid"];
                model.isAccount = 1;
                
                [SVProgressHUD dismiss];
                
                [HGSaveNoticeTool updateCatheWithKey:@"getbindingquickpay" andValue:dic];
                
            }else{
                
                [SVProgressHUD showErrorWithStatus:cardDic[@"em"]];
                
                
            }
            
            [self.myTableView reloadData];
            
            
        }];
        
        
    }else{
        
        //没有卡
        
    }



}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationBar];
    
    self.myTableView.tableFooterView = [[UIView alloc] init];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"TWOpenAndPayCell" bundle:nil] forCellReuseIdentifier:@"TWOpenAndPayCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"TWOpenAndPay2Cell" bundle:nil] forCellReuseIdentifier:@"TWOpenAndPay2Cell"];
    
    
    //查询银行卡信息
//    NSInteger  isHaveCard = [[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"bankcard"] integerValue];
//    if (isHaveCard == 1) {
//        //有卡 查询卡信息
//        TWMineViewModel *viewModel = [[TWMineViewModel alloc] init];
//        
//        [viewModel obtainCardInfoWithReturnBlock:^(id result) {
//            
//            NSDictionary *cardDic = (NSDictionary *)result;
//            
//            if ([cardDic[@"success"] integerValue] == 1) {
//                
//                NSDictionary *dic = [cardDic[@"result"] firstObject];
//                
//                TWOpenAccountModel *model = [self.dataArr[0] objectAtIndex:0];
//#warning ------- 银行名字还没有
    //            model.title = dic[@"bankname"];
//                model.subTitle = [NSString stringWithFormat:@"尾号 %@",dic[@"card"]];
//                model.bindid = dic[@"bindid"];
//                model.mid = dic[@"mid"];
//                model.payid = dic[@"payid"];
//
//                [SVProgressHUD dismiss];
//                
//                [HGSaveNoticeTool updateCatheWithKey:@"getbindingquickpay" andValue:dic];
//                
//            }else{
//                
//                [SVProgressHUD showErrorWithStatus:cardDic[@"em"]];
//                
//                
//            }
//            
//            [self.myTableView reloadData];
//
//            
//        }];
//        
//        
//    }else{
//    
//        //没有卡
//    
//    }
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yinlianPayDidPay:) name:@"yinlianPayReslut" object:nil];

}



#pragma mark - 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArr count];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArr[section] count];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        return FitValue(91);
    }else{
    
        return FitValue(57);
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if(section == 0){
    
        return 0.01;
    }
    
    return FitValue(90);
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if(section == 0){
        
        return FitValue(42);
    }
    
    return FitValue(67);
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if (section == 1) {
        
        
        UIView *viewx = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FitValue(67))];
        viewx.backgroundColor = HexRGB(0xf5f5f5);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, FitValue(10), SCREEN_WIDTH, FitValue(57))];
        view.backgroundColor = [UIColor whiteColor];
        
        [viewx addSubview:view];
        
        UIView *viewss = [[UIView alloc] initWithFrame:CGRectMake(0, FitValue(56.5), SCREEN_WIDTH, FitValue(0.5))];
        viewss.backgroundColor = HexRGB(0xcccccc);
        
        [view addSubview:viewss];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(FitValue(28), FitValue(18.5), SCREEN_WIDTH, FitValue(20))];
        
        lable.text = @"首次年费300.00元，次年100.00元";
        lable.font = NormalFont(16);
        lable.textColor = HexRGB(0x282828);
        
        [view addSubview:lable];
        
        return viewx;

    }else{
    
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FitValue(42))];
        view.backgroundColor = HexRGB(0xf5f5f5);
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(FitValue(28), FitValue(11), 200, FitValue(20))];
        
        lable.text = @"使用快捷支付";
        lable.textColor = HexRGB(0xcccccc);
        
        lable.font = NormalFont(16);
        
        [view addSubview:lable];
        
        return view;
    
    
    }
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
            
        if (section == 1) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FitValue(90))];
            view.backgroundColor = MainBackgroundColor;
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(FitValue(28), 44, FitValue(319), FitValue(45))];
            
            
            TWOpenAccountModel *model = [self.dataArr[0] objectAtIndex:0];
            
            if (!model.isAccount) {
                
                //点击绑定银行卡
                btn.backgroundColor = HexRGB(0xcccccc);
                btn.userInteractionEnabled = NO;
                
            }else{
            
                 btn.backgroundColor = HexRGB(0xEF3535);
                 btn.userInteractionEnabled = YES;
            }

            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = FitValue(4);
            
            
            NSString *isZhenShi = [HGSaveNoticeTool obtainPersonInfoDataWithKey:@"leveltype"];
            if ([isZhenShi isEqualToString:@"1"]) {
            
                [btn setTitle:@"升级或开通正式版权限" forState:UIControlStateNormal];

            
            }else if ([isZhenShi isEqualToString:@"3"]){
            
                [btn setTitle:@"去续费" forState:UIControlStateNormal];

            
            }
            
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [btn setTitleColor:COLOR(255, 255, 255, 0.5) forState:UIControlStateHighlighted];
            
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_login_c"] forState:UIControlStateHighlighted];
            

            [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:btn];
            
            return view;
            
        }

    
    return nil;

    
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        
        TWOpenAndPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWOpenAndPayCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = ((TWOpenAccountModel *)[self.dataArr[indexPath.section] objectAtIndex:indexPath.row]);
        
        return cell;
    }else{
    
        
        TWOpenAndPay2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWOpenAndPay2Cell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = ((TWOpenAccountModel *)[self.dataArr[indexPath.section] objectAtIndex:indexPath.row]);
        
        return cell;
    
    }
    

    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        TWOpenAccountModel *model = [self.dataArr[0] objectAtIndex:0];
        
        if (!model.isAccount) {
            
            //点击绑定银行卡
            TWBoundCardVC *vc = [[TWBoundCardVC alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
    
    
    
    
}




#pragma mark - 点击事件 支付
-(void)onClick:(UIButton *)btn
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"所需支付 300.00 元" message:@"确定支付并开通正式版权限" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 21;
    
    [alertView show];
    
}



#pragma mark - 确认支付
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 21) {
        
        if (buttonIndex == 1) {
            
            //升级为正式版
            TWMineViewModel *viewmodel = [[TWMineViewModel alloc] init];
            
            [viewmodel becomeFormalMember];
            
            viewmodel.successBlock = ^(BOOL success){
            
                if (success) {
                    
                    
                    [self successBack];
                    
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"恭喜您已成功开通正式版权限" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                    alertView.tag = 22;
//                    
//                    [alertView show];
                }
            
            };

//            if (!self.viewModel) {
//                
//                //调起银联支付
//                TWMineViewModel *vm = [[TWMineViewModel alloc] init];
//                
//                self.viewModel = vm;
//                
//            }
//
//            NSString *orderId = [NSString stringWithFormat:@"jhdsah%zddk%zdjhajd%zd",arc4random()%100,arc4random()%100,arc4random()%100];
//            
//            [self.viewModel startPayWith:self andMoney:300*100 andOrderId:orderId andPayType:1];
//            
//            [UserDefaults setObject:orderId forKey:@"orderId"];
//            [UserDefaults synchronize];
            
        }
    }
    
    
    if (alertView.tag == 22) {
        
        if (buttonIndex == 0) {
        
            
            [HGSaveNoticeTool updatePersonInfodataWithKey:@"leveltype" andValue:@"2"];
            
            NSString *timeStr = [HGSaveNoticeTool obtainPersonInfoDataWithKey:@"expirydate"];
            
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
            NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]/1000.0];
            [dateFormatter setTimeZone:timeZone];
            [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
            [date dateByAddingYears:1];

            
            [HGSaveNoticeTool updatePersonInfodataWithKey:@"expirydate" andValue:[NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]*1000]];

            
            [self.navigationController popViewControllerAnimated:YES];
            
//            [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
        
        }
    }

}

-(void)successBack
{
    
    [HGSaveNoticeTool updatePersonInfodataWithKey:@"leveltype" andValue:@"2"];
    
    NSString *timeStr = [HGSaveNoticeTool obtainPersonInfoDataWithKey:@"expirydate"];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]/1000.0];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    [date dateByAddingYears:1];
    
    
    [HGSaveNoticeTool updatePersonInfodataWithKey:@"expirydate" andValue:[NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]*1000]];
    
    
    [self.navigationController popViewControllerAnimated:YES];


}



#pragma mark - 银联支付完成
-(void)yinlianPayDidPay:(NSNotification *)notify
{
    
    //刷新该页面
    
    NSDictionary *dic = notify.userInfo;

//    if (dic[@""]) {
//
//    }
    
//     TWPayResultVC *vc = [[TWPayResultVC alloc] init];
//    
//    [self.navigationController pushViewController:vc animated:YES];


}


#pragma mark - 设置导航栏
- (void)setNavigationBar{
    
    [self setNaviBarBackgroundColor:nil andStatusBarColor:nil];
    [self setNaviBarTitle:@"我的账号" color:WHITECOLOR];
    [self setNaviBarLeftTitle:nil image:@"icon_bar_back"];
    
   // [self setNaviBarRightTitle:@"ApplePay" image:nil];
    
}

- (void)leftAction:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



#pragma mark - 苹果支付

- (void)rightAction:(UIButton *)button{
    
    //环境
    //调起苹果支付
    if (!self.viewModel) {
        
        //调起银联支付
        TWMineViewModel *vm = [[TWMineViewModel alloc] init];
        
        self.viewModel = vm;
        
    }

    
    NSString *orderId = [NSString stringWithFormat:@"jhdsah%zddk%zdjhajd%zd",arc4random()%100,arc4random()%100,arc4random()%100];
    
    [self.viewModel startPayWith:self andMoney:300*100 andOrderId:orderId andPayType:2];
    
    [UserDefaults setObject:orderId forKey:@"ApplePayOrderId"];
    [UserDefaults synchronize];
    
    
}







#pragma mark - 懒加载
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
        
        
         NSDictionary *dic = [HGSaveNoticeTool obtainCatheDictionaryWithKey:@"getbindingquickpay"];
#warning --------------------名字还没有
        NSArray *titles = @[@"招商银行",@"您需支付的年费"];
        
        NSArray *detailTitles = @[[NSString stringWithFormat:@"尾号 %@",dic[@"card"]],@"300元"];
        
        NSArray *accountArr = @[@([[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"bankcard"] integerValue]),@(1)];
        
        NSMutableArray *numArr = [[NSMutableArray alloc] initWithObjects:@(1),@(1), nil];
        
        
        //判断有没有绑卡
    
        for (int i=0; i<numArr.count; i++) {
            
            NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
            for (int k=0; k<[numArr[i] intValue]; k++) {
                
                TWOpenAccountModel *model = [[TWOpenAccountModel alloc] init];
                
                model.title = [titles objectAtIndex:i*1+k];
                model.subTitle = [detailTitles objectAtIndex:i*1+k];
                model.isAccount = [accountArr[i*1+k] boolValue];
                
                [tmpArr addObject:model];
            }
            
            [_dataArr addObject:tmpArr];
            
        }
        
    }
    
    return _dataArr;
}


-(void)dealloc
{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"yinlianPayReslut" object:nil];

}







@end
