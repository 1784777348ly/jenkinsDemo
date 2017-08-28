//
//  TWModifyLoginCodeVC.m
//  ticketWaiter
//
//  Created by LY on 16/12/29.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "TWModifyLoginCodeVC.h"
#import "TWJudgeRulesTool.h"
#import "TWMineViewModel.h"


@interface TWModifyLoginCodeVC ()<UIAlertViewDelegate >

@property (weak, nonatomic) IBOutlet UITextField *oldCode;
@property (weak, nonatomic) IBOutlet UITextField *lnewCode;

@property (weak, nonatomic) IBOutlet UITextField *ensureCode;
@property (weak, nonatomic) IBOutlet UILabel *left1;
@property (weak, nonatomic) IBOutlet UILabel *left2;
@property (weak, nonatomic) IBOutlet UILabel *left3;


//确认按钮
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;

//适配

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l6;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l7;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l8;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l9;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l10;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l11;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l12;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w2;






@end

@implementation TWModifyLoginCodeVC



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBar];
    [self shiPei];
    
}





//确认修改
- (IBAction)ensureClick:(UIButton *)sender {

    
    //点击确认修改
     [self.view endEditing:YES];
    
#warning ------不能为空00000000
    //判断各种规则
    if (![TWJudgeRulesTool judgePasswordIsOk:_oldCode.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"旧密码输入格式错误"];
        return;
        
    }
    
    
    if (![TWJudgeRulesTool judgePasswordIsOk:_lnewCode.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"新密码输入格式错误"];
        return;
        
    }
    
    if (![_lnewCode.text isEqualToString:_ensureCode.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"两次输入密码不一致"];
        return;
        
    }
    
    TWMineViewModel *viewModel = [[TWMineViewModel alloc] init];
    
    [viewModel mofifyloginCode:_oldCode.text andNewPassword:_lnewCode.text andReturnBlock:^(id result) {
        
        NSDictionary *dic = (NSDictionary *)result;
        
        if ([dic[@"success"] integerValue] == 1) {
            
            [SVProgressHUD dismiss];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"修改密码成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
            alertView.tag = 31;
            [alertView show];
            
            [UserDefaults setObject:[dic[@"result"] description] forKey:@"token"];
            
        }else{
        
            [SVProgressHUD showErrorWithStatus:dic[@"em"]];
        
        }

    }];

    
    
    
    
}


#pragma mark - 监听输入
- (IBAction)tfChanged:(UITextField *)sender {
    
    
    NSInteger aNum = 0;
    NSInteger bNum = 0;
    NSInteger cNum = 0;
    
    
    /*
     HexRGB(0xc02a2b);
     HexRGB(0xe87071)
     HexRGB(0xcccccc)*/
    
    if (_oldCode.text.length > 0) {
        
         aNum = 1;
    }else{
        
         aNum = 0;
        
    }
    
    if (_lnewCode.text.length > 0) {
        
        bNum = 1;
    }else{
        
        bNum = 0;
        
    }


    if (_ensureCode.text.length > 0) {
        
        cNum = 1;
    }else{
        
        cNum = 0;
        
    }
    

    if (aNum+bNum+cNum == 0) {
        
        _ensureBtn.backgroundColor = HexRGB(0xcccccc);
        _ensureBtn.userInteractionEnabled = NO;
        
    }else if (aNum+bNum+cNum == 3){
    
        _ensureBtn.backgroundColor = HexRGB(0xef3535);
        _ensureBtn.userInteractionEnabled = YES;

    
    }else{
    
        _ensureBtn.backgroundColor = HexRGB(0xe87071);
        _ensureBtn.userInteractionEnabled = NO;

    }

    
    
}





#pragma mark - 设置导航栏
- (void)setNavigationBar{
    
    [self setNaviBarBackgroundColor:nil andStatusBarColor:nil];
    [self setNaviBarTitle:@"修改登录密码" color:WHITECOLOR];
    [self setNaviBarLeftTitle:nil image:@"icon_bar_back"];
}

- (void)leftAction:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}









-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 31 && buttonIndex==0) {
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count - 2)] animated:YES];
        
    }


}


-(void)shiPei
{
    NSArray *arr = @[_h1,_h2,_w2,_l1,_l2,_l3,_l4,_l5,_l6,_l7,_l8,_l9,_l10,_l11,_l12,_t1,_left1,_left2,_left3,_oldCode,_lnewCode,_ensureCode,_ensureBtn];
    
    for (int i=0; i<arr.count; i++) {
        
        if (i<16) {
            
            ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);
            
        }else if(i<=18){
            
            ((UILabel *)arr[i]).font = NormalFont(((UILabel *)arr[i]).font.pointSize);
            
        }else if(i<=21){
            
            ((UITextField *)arr[i]).font = NormalFont(((UITextField *)arr[i]).font.pointSize);
            
        }else{
            
            ((UIButton *)arr[i]).titleLabel.font = NormalFont(((UIButton *)arr[i]).titleLabel.font.pointSize);
            
        }
        
    }
    
    
    _ensureBtn.layer.cornerRadius = FitValue(4);
    _ensureBtn.layer.masksToBounds = YES;
    [_ensureBtn setTitleColor:COLOR(255, 255, 255, 0.5) forState:UIControlStateHighlighted];

    
}





@end
