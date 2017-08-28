//
//  TWBoundCardVC.m
//  ticketWaiter
//
//  Created by LY on 17/1/13.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWBoundCardVC.h"

#import "TWBoundCardAgainVC.h"
#import "TWJudgeRulesTool.h"


@interface TWBoundCardVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *toplable;
@property (weak, nonatomic) IBOutlet UILabel *left1;
@property (weak, nonatomic) IBOutlet UILabel *left2;
@property (weak, nonatomic) IBOutlet UITextField *tf1;
@property (weak, nonatomic) IBOutlet UITextField *tf2;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;



//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w1;




@end

@implementation TWBoundCardVC

-(void)shiPei
{
    NSArray *arr = @[_t1,_t2,_t3,_t4,_l1,_l2,_l3,_h1,_h2,_h3,_w1,_toplable,_left1,_left2,_tf1,_tf2,_nextBtn];


    for (int i=0; i<arr.count; i++) {
        
        if (i<11) {
            
            ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);
            
        }else if(i<=13){
            
            ((UILabel *)arr[i]).font = NormalFont(((UILabel *)arr[i]).font.pointSize);
            
        }else if(i<=15){
            
            ((UITextField *)arr[i]).font = NormalFont(((UITextField *)arr[i]).font.pointSize);
            
        }else{
            
            ((UIButton *)arr[i]).titleLabel.font = NormalFont(((UIButton *)arr[i]).titleLabel.font.pointSize);
            
        }
        
    }
    
    
    _nextBtn.layer.cornerRadius = FitValue(4);
    _nextBtn.layer.masksToBounds = YES;
    
    [_nextBtn setTitleColor:COLOR(255, 255, 255, 0.5) forState:UIControlStateHighlighted];


}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self shiPei];
    
    [self setNavigationBar];
    
}



#pragma mark - 下一步
- (IBAction)nextClick:(UIButton *)sender {

    //判断银行卡卡号
    if (![TWJudgeRulesTool judgeCardNo:self.tf2.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"银行卡格式错误"];

        return;
    }
    

    //判断银行卡号
    TWBoundCardAgainVC *vc = [[TWBoundCardAgainVC alloc] init];
    
    vc.placeHolder = self.tf1.text;
    vc.cardNum = self.tf2.text;
    vc.cardName = [self returnBankName:_tf2.text];
    
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - 判断银行名字 和 头像
- (NSString *)returnBankName:(NSString*) idCard{
    
//    if(idCard==nil || idCard.length<16 || idCard.length>19){
//        _resultLabel.text = @"卡号不合法";
//        return @"";
//        
//    }
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"bank" ofType:@"plist"];
    NSDictionary* resultDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *bankBin = resultDic.allKeys;
    
    //6位Bin号
    NSString* cardbin_6 = [idCard substringWithRange:NSMakeRange(0, 6)];
    //8位Bin号
    NSString* cardbin_8 = [idCard substringWithRange:NSMakeRange(0, 8)];
    
    if ([bankBin containsObject:cardbin_6]) {
        return [resultDic objectForKey:cardbin_6];
    }else if ([bankBin containsObject:cardbin_8]){
        return [resultDic objectForKey:cardbin_8];
    }else{
        //return @"plist文件中不存在请自行添加对应卡种";
        return @"";
    }
    return @"";
    
}



#pragma mark - 限制长度
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:_tf1]) {
        //先改变试一试，如果结果超过6，返回NO
        NSMutableString * str = [NSMutableString stringWithString:textField.text];
        //str替换
        [str replaceCharactersInRange:range withString:string];
        //'\b'
        return  str.length <= 20;
        
        
    }else if ([textField isEqual:_tf2]) {
        //先改变试一试，如果结果超过6，返回NO
        NSMutableString * str = [NSMutableString stringWithString:textField.text];
        //str替换
        [str replaceCharactersInRange:range withString:string];
        //'\b'
        return  str.length <= 19;
        
    }else{
        
        return YES;
    }
    
}







#pragma mark - 监控输入

- (IBAction)tfChanged:(UITextField *)sender {
    
    NSInteger aNum = 0;
    NSInteger bNum = 0;

    /*
     HexRGB(0xc02a2b);
     HexRGB(0xe87071)
     HexRGB(0xcccccc)*/
    
    if (_tf1.text.length > 0) {
        
        aNum = 1;
    }else{
        
        aNum = 0;
        
    }
    
    if (_tf2.text.length > 0) {
        
        bNum = 1;
    }else{
        
        bNum = 0;
        
    }

    if (aNum+bNum == 0) {
        
        _nextBtn.backgroundColor = HexRGB(0xcccccc);
        _nextBtn.userInteractionEnabled = NO;
        
    }else if (aNum+bNum == 2){
        
        _nextBtn.backgroundColor = HexRGB(0xef3535);
        _nextBtn.userInteractionEnabled = YES;
        
        
    }else{
        
        _nextBtn.backgroundColor = HexRGB(0xe87071);
        _nextBtn.userInteractionEnabled = NO;
        
    }

    
    
}





#pragma mark - 设置导航栏
- (void)setNavigationBar{
    
    [self setNaviBarBackgroundColor:nil andStatusBarColor:nil];
    [self setNaviBarTitle:@"绑定银行卡" color:WHITECOLOR];
    [self setNaviBarLeftTitle:nil image:@"icon_bar_back"];
}

- (void)leftAction:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
