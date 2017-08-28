//
//  TWAddMemberVC.m
//  ticketWaiter
//
//  Created by LY on 16/12/30.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "TWAddMemberVC.h"
#import "TWJudgeRulesTool.h"
#import "TWVIPModel.h"
#import "LotteryManagerPlugin.h"

#import "TWVIPModelView2.h"
#import "HGSaveNoticeTool.h"

#import "TWSaveMemView.h"

//获取wifi地址
#import <SystemConfiguration/CaptiveNetwork.h>


@interface TWAddMemberVC ()<UITextFieldDelegate,lotteryManagerDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tf1;

@property (weak, nonatomic) IBOutlet UITextField *tf2;

@property (weak, nonatomic) IBOutlet UITextField *tf3;

@property (weak, nonatomic) IBOutlet UILabel *lable1;
@property (weak, nonatomic) IBOutlet UILabel *lable2;
@property (weak, nonatomic) IBOutlet UILabel *lable3;

@property (weak, nonatomic) IBOutlet UIView *llllView;



@property (weak, nonatomic) IBOutlet UIButton *clearBtn;

@property (weak, nonatomic) IBOutlet UIButton *openEyeBtn;

@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;

//适配

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l6;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l7;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w3;


@property(nonatomic)LotteryManagerPlugin *manager;

@property(nonatomic,assign)NSInteger errorCode;


//@property(nonatomic,assign)BOOL  isSubmit;



@end

@implementation TWAddMemberVC



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    
    if (self.vcType == 1) {
        
         [_tf1 becomeFirstResponder];

        
    }else{
    
        [_tf3 becomeFirstResponder];
    }
    
   
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    NSLog(@"111111111111111111111111");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self shiPei];
    
    [self setNavigationBar];
    
    self.manager = [LotteryManagerPlugin shareManager];
    
    self.manager.delegate = self;
    
    
    
    if (self.vcType == 1) {

        
        _tf3.hidden = YES;
        _llllView.hidden = YES;
        _lable3.hidden = YES;
        
    }

    

}


- (void)startShowLoadingView
{
    
    [SVProgressHUD showWithStatus:@"添加中....."];

}

- (void)endShowLoadingView
{

    [SVProgressHUD dismiss];

}




#pragma mark - 确认添加
- (IBAction)addClick:(UIButton *)sender {
    
    
    
    if (self.vcType == 1) {
#warning ======= 验证手机号码
        //判断各种规则
//        if (![TWJudgeRulesTool judgePhoneIsOk:_tf1.text]) {
//            
//            [SVProgressHUD showErrorWithStatus:@"手机号输入错误"];
//            return;
//            
//        }
        //判断有没有连接wifi
        if ([[self obtainWifimacAddress] length]<12) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"请在连接Wifi的情况下使用App" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            return;

        }

        //备注可以不设置
        //判断手机号 是否已经添加过了的
        for (int i=0; i<self.dataArr.count; i++) {
            TWVIPModel * model = self.dataArr[i];
            if ([model.phone isEqualToString:_tf1.text]) {
                [SVProgressHUD showErrorWithStatus:@"会员已存在"];
                return;
            }
        }

        TWVIPModelView2 *viewModel = [[TWVIPModelView2 alloc] init];
                [viewModel obtainIWTTokenWithReturnBlock:^(id result) {
        
                NSDictionary *dic = (NSDictionary *)result;
    
                if ([dic[@"success"] integerValue] == 1) {
    
                    NSDictionary *results = dic[@"result"];
    
                    NSDictionary *params = @{@"channelId":[[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"channelid"] description],
                                             @"stationNo":[[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"stationno"] description],
                                             @"stationProvince":[[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"stationprovince"] description],
                                             @"channelToken":results[@"channeltoken"],

                                             @"userPhoneNo":_tf1.text,
                                             };
                    
                    
                    [self.manager startBindUser:params resultBlock:^(NSInteger opreatResult, NSString *betPwd, NSString *resultMsg) {
                        
                        
                        //添加成功
                        if (opreatResult == 0) {
                            
                            NSLog(@"%@",resultMsg);
                            
//                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:resultMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                            
//                            alertView.tag = 93;
//                            
//                            [alertView show];
                            
                            
                                //添加成功 调同步接口
                                [self addMemberInfoWith:_tf1.text andPassword:betPwd];
                           
                            
                           
                            

                            
                            //给会员赠送彩金
#warning -----  保存完事以后赠送彩金
//                            TWSaveMemView *sview = [TWSaveMemView saveMemberViewWithRect:CGRectZero];
//                            
//                            sview.donateBlock = ^(BOOL success){
//                            
//                                if (success) {
//                                    
//                                    //赠送
//                                    
//                                    
//                                }else{
//                                
//                                    [self.navigationController popViewControllerAnimated:YES];
//
//                                    
//                                }
                            
//                            };
//                            
//                            [sview show];
                            
                            
                            
                            
                        }else if (opreatResult == 1) {
                        
                            
                            NSLog(@"%@",resultMsg);

                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:resultMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                            
                            alertView.tag = 91;
                            
                            [alertView show];

                        }else{
                            
                            NSLog(@"%@",resultMsg);
                        
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:resultMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                            
                            alertView.tag = 92;
                            
                            [alertView show];

                            
                        }
                  
                        
                    }];
 
                }else{

                    [SVProgressHUD showErrorWithStatus:dic[@"em"]];
                    
                }
    }];


        
        
    }else{
        

        //编辑完事   保存接口
        TWVIPModelView2 *viewModel = [[TWVIPModelView2 alloc] init];

        NSDictionary *dic = @{
                              @"memberid":_model.memberid,
                              @"remark":_tf3.text,
                              @"token":LYTOKEN
                              };
    
        [viewModel modifyRemarkWithDic:dic andReturnBlock:^(id result) {
            
            NSDictionary *dict = (NSDictionary *)result;
            
            if ([dict[@"success"] integerValue] == 1) {
                
                [SVProgressHUD dismiss];

                if (self.isSearchToAdd) {
                    
                    [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] animated:YES];
                    
                }else{
                
                    [self.navigationController popViewControllerAnimated:YES];

                    
                }
                
                

            }else{
            
                [SVProgressHUD showErrorWithStatus:dict[@"em"]];

            }

            
        } ];

    }

}


-(void)addMemberInfoWith:(NSString *)phone andPassword:(NSString *)password
{
    TWVIPModelView2 *viewModel = [[TWVIPModelView2 alloc] init];
    
    NSDictionary *dic = @{
                          @"paypwd":password,
                          @"phone":_tf1.text,
                          @"token":LYTOKEN
                          };

    [viewModel addMemberWithDic:dic andReturnBlock:^(id result) {
        
        NSDictionary *dic = (NSDictionary *)result;
        
        if ([dic[@"success"] integerValue] == 1) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"添加成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            
            alertView.tag = 93;

            [alertView show];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:dic[@"em"]];
        }

    }];



}







#pragma mark - 代理方法
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:_tf1]) {
        //先改变试一试，如果结果超过6，返回NO
        NSMutableString * str = [NSMutableString stringWithString:textField.text];
        //str替换
        [str replaceCharactersInRange:range withString:string];
        //'\b'
        return  str.length <= 11;
        
    }else if ([textField isEqual:_tf2]) {
        //先改变试一试，如果结果超过6，返回NO
        NSMutableString * str = [NSMutableString stringWithString:textField.text];
        //str替换
        [str replaceCharactersInRange:range withString:string];
        //'\b'
        return  str.length <= 18;
        
    }else{
        
        //先改变试一试，如果结果超过6，返回NO
        NSMutableString * str = [NSMutableString stringWithString:textField.text];
        //str替换
        [str replaceCharactersInRange:range withString:string];
        //'\b'
        return  str.length <= 20;

    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 91) {
        //添加失败
        _tf1.text = @"";
         _clearBtn.hidden = 1;
        [self refreshBtnState];
        
        
    }else if (alertView.tag == 92){
        //添加取消

        
    }else{
        //添加成功
        [self.navigationController popViewControllerAnimated:YES];

        
    }


}




-(void)refreshView
{
    _tf1.text = _model.phone;
    _tf2.text = _model.password;
    
    
    _tf1.userInteractionEnabled = NO;
    _tf2.userInteractionEnabled = NO;
    
    _tf3.text = _model.remark;


}



-(void)setModel:(TWVIPModel *)model
{
    _model = model;
}


#pragma mark - 点击事件

- (IBAction)clearAll:(UIButton *)sender {
    
    _tf1.text = @"";
    sender.hidden = 1;
    [self refreshBtnState];

    
}


- (IBAction)openEye:(UIButton *)sender {
    
    
    sender.selected = !sender.selected;
    
    _tf2.secureTextEntry = !sender.selected;
    
}


//监听是否有输入 手机号码和密码
- (IBAction)phoneEdited:(UITextField *)sender {
    
    
    if ([sender isEqual:_tf3]) {
        
        if (self.vcType == 1) {
            
        }else{
            
           //编辑会员
            if (sender.text.length > 0) {
                
                _ensureBtn.backgroundColor =  HexRGB(0xef3535);
                _ensureBtn.userInteractionEnabled = YES;
                
            }else{
                
                _ensureBtn.backgroundColor =  HexRGB(0xcccccc);
                _ensureBtn.userInteractionEnabled = NO;
            
            }
            
            
        }
        
        
        
    }else{
    
        [self refreshBtnState];
        
        
        if ([sender isEqual:_tf1]) {
            
            if (sender.text.length >0) {
                
                _clearBtn.hidden = 0;
                
            }else{
                
                _clearBtn.hidden = 1;
                
            }
            
        }
        
//        if ([sender isEqual:_tf2]) {
//            
//            
//            if (sender.text.length >0) {
//                
//                _openEyeBtn.hidden = NO;
//                
//            }else{
//                
//                _openEyeBtn.hidden = YES;
//                
//            }
//            
//            
//        }

        
    
    }
    

   
    
}




#pragma mark - 刷新btn状态

-(void)refreshBtnState{

    NSArray *arr = @[_tf1];
    int sum = 0;
    
    for (int i=0; i<arr.count; i++) {
        
        int a=0;
        UITextField *tf = arr[i];
        
        if (tf.text.length >0) {
            
            a++;
            
            sum +=a;
        }
        
    }

    
    if (sum == arr.count) {
        
        _ensureBtn.backgroundColor =  HexRGB(0xef3535);
        _ensureBtn.userInteractionEnabled = YES;
    }else if (sum == 0){
        
        _ensureBtn.backgroundColor =  HexRGB(0xcccccc);
        _ensureBtn.userInteractionEnabled = NO;
        
    }else{
        
        _ensureBtn.backgroundColor =  HexRGB(0xe87071);
        _ensureBtn.userInteractionEnabled = NO;
        
    }


}


#pragma mark - 判断有没有连接wifi
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



#pragma mark - 设置Navigation
- (void)setNavigationBar{
    
    NSString *titles = nil;
    
    if (self.vcType == 1) {
        
        titles = @"新增会员";
        
    }else{
        
        titles = @"编辑会员";
        
        [self refreshView];
    }

    
    [self setNaviBarBackgroundColor:nil andStatusBarColor:nil];
    [self setNaviBarTitle:titles color:WHITECOLOR];
    [self setNaviBarLeftTitle:nil image:@"icon_bar_back"];
}

- (void)leftAction:(UIButton *)button{
    
     self.manager = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)shiPei
{
    NSArray *arr = @[_l1,_l2,_l3,_l4,_l5,_l6,_l7,_h1,_h2,_h3,_h4,_w1,_w2,_w3,_lable1,_lable2,_lable3,_tf1,_tf2,_tf3,_ensureBtn];
    
    
    for (int i=0; i<arr.count; i++) {
        
        if (i<14) {
            
            ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);
            
            
        }else if(i<=16){
            
            ((UILabel *)arr[i]).font = NormalFont(((UILabel *)arr[i]).font.pointSize);
            
        }else if(i<=19){
            
            ((UITextField *)arr[i]).font = NormalFont(((UITextField *)arr[i]).font.pointSize);
            
        }else{
            
            ((UIButton *)arr[i]).titleLabel.font = NormalFont(((UIButton *)arr[i]).titleLabel.font.pointSize);
            
        }
        
    }
    
    
    _ensureBtn.layer.cornerRadius = FitValue(4);
    _ensureBtn.layer.masksToBounds = YES;
    [_ensureBtn setTitleColor:COLOR(255, 255, 255, 0.5) forState:UIControlStateHighlighted];

}

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
    
}







@end
