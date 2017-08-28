//
//  TWLoginViewController.m
//  ticketWaiter
//
//  Created by LY on 17/1/15.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWLoginViewController.h"
#import "TWLoginViewModel.h"

#import "TWHomeViewController.h"
#import "HSNavigationController.h"
#import "TWJudgeRulesTool.h"
#import "HGSaveNoticeTool.h"

#import "TWHomeAllViewModel.h"


@interface TWLoginViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *accountPre;
@property (weak, nonatomic) IBOutlet UITextField *accountTf;
@property (weak, nonatomic) IBOutlet UILabel *passwordPre;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;

@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet UIButton *seeBtn;

@property (weak, nonatomic) IBOutlet UILabel *errorLable;



//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t6;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t7;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l2;

@property(nonatomic,assign)BOOL  isCanSideBack;

@end

@implementation TWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.fd_prefersNavigationBarHidden = YES;
    [self shiPei];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.fd_interactivePopDisabled = YES;

}


- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    self.fd_interactivePopDisabled = NO;

    
    
}








- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;
}


#pragma mark - 登录
- (IBAction)loginClick:(UIButton *)sender {
    
    
//    if (![TWJudgeRulesTool judgePhoneIsOk:_accountTf.text]) {
//        
//        _errorLable.hidden = 0;
//        return;
//        
//    }
    
    if (![TWJudgeRulesTool judgePasswordIsOk:_passwordTf.text]) {
        
        _errorLable.hidden = 0;
        return;
        
    }

     _errorLable.hidden = 1;
    
    
    TWLoginViewModel *vm = [[TWLoginViewModel alloc] init];
    
    [vm fetchLoginRequest:_accountTf.text andCode:_passwordTf.text returnback:^(id result) {
        
        NSDictionary *dic = (NSDictionary *)result;
        
        if ([dic[@"success"] integerValue] == 1) {
            
            //登录成功 在缓存一下用户数据
            
//            [UserDefaults setObject:dic[@"result"] forKey:@"token"];
//            
//            [UserDefaults setObject:_accountTf.text forKey:@"account"];
//
//            [UserDefaults synchronize];
            //建库
            
            [self createNoticeKu:_accountTf.text];
            
          //  [self changeRootViewController];
            
            //查询商户信息
            
            [self checkMergentInfoWithToken:dic[@"result"] andAccount:_accountTf.text];
            
        }else{
        

            [SVProgressHUD showErrorWithStatus:dic[@"em"]];

        
        }
        

    }];
}

-(void)checkMergentInfoWithToken:(NSString *)token andAccount:(NSString *)account
{
    
     TWLoginViewModel *vm = [[TWLoginViewModel alloc] init];
    
    [vm fetchMergentInfoWithToken:token returnBack:^(id result) {
        
        NSDictionary *dic = (NSDictionary *)result;
        
        if ([dic[@"success"] integerValue] == 1) {
            
            [UserDefaults setObject:account forKey:@"account"];
            
            [UserDefaults synchronize];
            
            
            NSMutableDictionary *dataDic = [dic[@"result"] mutableCopy];
            
            NSArray *dictKeysArray = [dataDic allKeys];
            for (int i = 0; i<dictKeysArray.count; i++) {
                
                NSString *key = dictKeysArray[i];
                
                if ([[dataDic objectForKey:key] isEqual:[NSNull null]]) {
                    
                    [dataDic setValue:@"" forKey:key];
                }
                
                [HGSaveNoticeTool updatePersonInfodataWithKey:key andValue:[dataDic objectForKey:key]];
            }

            
            [UserDefaults setObject:token forKey:@"token"];
            
            [UserDefaults synchronize];
            
            
            //跳到首页
            [self changeRootViewControllerWithDic:dataDic];
            
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            
            
        }else{
        
            [SVProgressHUD showErrorWithStatus:dic[@"em"]];

        
        }

    }];
    

//    //检查是否是可用支付
//    //判断支付环境是否OK
//    TWHomeAllViewModel *viewModel = [[TWHomeAllViewModel alloc] init];
//    
//    [viewModel  judgeZhiFuIsOk:^(id result) {
//        
//        NSDictionary *dic = (NSDictionary *)result;
//        if ([dic[@"success"] integerValue] == 1 ) {
//            
//            //设置数据源
//            if ([dic[@"result"] integerValue] == 1) {
//                // 需要隐藏
//                [HGSaveNoticeTool updatePersonInfodataWithKey:@"hidepay" andValue:@"1"];
//
//                
//            }else{
//                // 不需要隐藏
//                [HGSaveNoticeTool updatePersonInfodataWithKey:@"hidepay" andValue:@"0"];
//
//                
//            }
//            
//        }
//        
//    }];

    
    
    

}


-(void)createNoticeKu:(NSString *)account
{
    
    NSLog(@"------%@",account);
    
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




#pragma matk - 找回密码
- (IBAction)forgetClick:(UIButton *)sender {
    
    
    
}

#pragma mark - 密码可见
- (IBAction)seeClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    _passwordTf.secureTextEntry = !sender.selected;
    
    
}

#pragma mark - 清除账户
- (IBAction)clearClick:(UIButton *)sender {
    
    _accountTf.text = @"";
    sender.hidden = 1;
    
     [self refreshBtn];
    
    
}



#pragma mark - 跳转到首页
-(void)changeRootViewControllerWithDic:(NSDictionary *)dic
{
    
    if (_isPushed) {
        
        TWHomeViewController *homeVC = (TWHomeViewController *)self.navigationController.viewControllers[0];
        
        homeVC.isLoginTo = 1;
        homeVC.merchantDic = [dic mutableCopy];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
    
        TWHomeViewController *homeVC = [TWHomeViewController new];
        
        homeVC.isLoginTo = 1;
        homeVC.merchantDic = [dic mutableCopy];
        
        HSNavigationController *homeNav = [[HSNavigationController alloc] initWithRootViewController:homeVC];
        
      //  [self.navigationController pushViewController:homeVC animated:YES];
        [UIApplication sharedApplication].keyWindow.rootViewController = homeNav;
        
    }

//    HSNavigationController *homeNav = [[HSNavigationController alloc] initWithRootViewController:homeVC];

   
}




#pragma mark - 代理方法

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:_accountTf]) {
        //先改变试一试，如果结果超过6，返回NO
//        NSMutableString * str = [NSMutableString stringWithString:textField.text];
//        //str替换
//        [str replaceCharactersInRange:range withString:string];
//        //'\b'
//        return  str.length <= 11;
        
        return YES;
        
    }else if ([textField isEqual:_passwordTf]) {
        //先改变试一试，如果结果超过6，返回NO
        NSMutableString * str = [NSMutableString stringWithString:textField.text];
        //str替换
        [str replaceCharactersInRange:range withString:string];
        //'\b'
        return  str.length <= 18;
        
    }else{
        
        return YES;
    }
    
}





#pragma mark - 监控登录按钮变色
- (IBAction)tfChanged:(UITextField *)sender {
    
    
    if ([sender isEqual:_accountTf]) {
        
        if (sender.text.length>0) {
            
             _clearBtn.hidden = NO;
            
        }else{
            
            _clearBtn.hidden = YES;
        }

    }else{
    
        if (sender.text.length>0) {
            
            _seeBtn.hidden = NO;
            
        }else{
            
            _seeBtn.hidden = YES;
        }

        
    }

    
    [self refreshBtn];
    
    

    
}

#pragma mark - 刷新btn颜色
-(void)refreshBtn
{

    NSArray *arr = @[_accountTf,_passwordTf];
    
    int sum=0;
    
    for (int i=0; i<arr.count; i++) {
        
        int a=0;
        
        UITextField *tf = (UITextField *)arr[i];
        
        if (tf.text.length>0) {
            a=1;
        }else{
            a=0;
        }
        sum += a;
        
    }
    
    if (sum==0) {
        //全空
        _loginBtn.backgroundColor =  HexRGB(0xcccccc);
        _loginBtn.userInteractionEnabled = NO;
        
    }else if (sum==2){
        
        //
        //都有值
        _loginBtn.backgroundColor =  HexRGB(0xef3535);
        _loginBtn.userInteractionEnabled = YES;
        
    }else{
        
        //有的有值  有的没有值
        _loginBtn.backgroundColor =  HexRGB(0xe87071);
        _loginBtn.userInteractionEnabled = NO;
        _errorLable.hidden = 1;

        
    }

    

}



-(void)shiPei
{
    NSArray *arr = @[_t1,_t2,_t3,_t4,_t5,_t6,_h1,_h2,_w1,_w2,_l1,_l2,_accountPre,_passwordPre,_errorLable, _accountTf,_passwordTf,_loginBtn,_forgetBtn];
    
    for (int i=0; i<arr.count; i++) {
        
        if (i<12) {
            
            ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);
            
            
        }else if(i<=14){
            
            ((UILabel *)arr[i]).font = NormalFont(((UILabel *)arr[i]).font.pointSize);
            
        }else if(i<=16){
            
            ((UITextField *)arr[i]).font = NormalFont(((UITextField *)arr[i]).font.pointSize);
            
        }else{
            
            ((UIButton *)arr[i]).titleLabel.font = NormalFont(((UIButton *)arr[i]).titleLabel.font.pointSize);
            
        }
        
    }
    
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = FitValue(4);

    
    //设置高亮状态的颜色
    [_loginBtn setTitleColor:COLOR(255, 255, 255, 0.5) forState:UIControlStateHighlighted];
    
    
}







@end
