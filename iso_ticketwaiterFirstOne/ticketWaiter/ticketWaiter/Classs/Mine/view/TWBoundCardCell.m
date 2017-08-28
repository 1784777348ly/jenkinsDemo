//
//  TWBoundCardCell.m
//  ticketWaiter
//
//  Created by LY on 17/1/13.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWBoundCardCell.h"
#import "TWMineModel.h"

@interface TWBoundCardCell ()<UITextFieldDelegate>
{

    BOOL _isAu;

}

@property (weak, nonatomic) IBOutlet UILabel *leftname;
@property (weak, nonatomic) IBOutlet UITextField *inputTf;

@property (weak, nonatomic) IBOutlet UIButton *testCodeBtn;

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w1;


//为了现实不同

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftDis;

@end

@implementation TWBoundCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if (!_isAu) {
        _isAu = 1;
        
        NSArray *arr = @[_l1,_l2,_l3,_h1,_w1,_leftname,_inputTf,_testCodeBtn];
        
        for (int i=0; i<arr.count; i++) {
            
            if (i<=4) {
                
                ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);
                
            }else if (i<=5) {
                
                ((UILabel *)arr[i]).font = NormalFont(((UILabel *)arr[i]).font.pointSize);
                
                
            }else if (i<=6) {
                
                ((UITextField *)arr[i]).font = NormalFont(((UITextField *)arr[i]).font.pointSize);
                
                
            }else{
                
                ((UIButton *)arr[i]).titleLabel.font = NormalFont(((UIButton *)arr[i]).titleLabel.font.pointSize);
                
            }
        }
        
        _inputTf.delegate = self;
        
        _testCodeBtn.layer.cornerRadius = FitValue(3);
        _testCodeBtn.layer.masksToBounds = 1;
        _testCodeBtn.layer.borderWidth = 1;
        _testCodeBtn.layer.borderColor = HexRGB(0x686868).CGColor;

    }
    
    
    
    
}

-(void)setModel:(TWCardModel *)model
{
    _model = model;
    
    _leftname.text = model.lefttitle;
    _inputTf.text = model.tfContent;
    
    _inputTf.placeholder = model.placeHolders;
    
    if (model.isEdited) {
        
        _inputTf.userInteractionEnabled = YES;
        
    }else{
    
        _inputTf.userInteractionEnabled = NO;
    
    }

    _testCodeBtn.hidden = !model.isHaveBtn;
    
    if ([model.lefttitle isEqualToString:@"验证码"]) {
        
        _leftDis.constant = -_l1.constant;
        
    }else{
        
        _leftDis.constant = 0;
    }
    
    
    [self customedSet];
    
    
    

}


-(void)customedSet
{
  
    
    if ([self.model.lefttitle isEqualToString:@"身份证号码"]) {
        
        _inputTf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        
    }else if ([self.model.lefttitle isEqualToString:@"银行预留手机"]){
    
        _inputTf.keyboardType = UIKeyboardTypeNumberPad;
    
    }else if ([self.model.lefttitle isEqualToString:@"验证码"]){
        
        _inputTf.keyboardType = UIKeyboardTypeNumberPad;
        
    }

    
    

}

#pragma mark - 代理方法
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([self.model.lefttitle isEqualToString:@"身份证号码"]) {
 
        //先改变试一试，如果结果超过6，返回NO
        NSMutableString * str = [NSMutableString stringWithString:textField.text];
        //str替换
        [str replaceCharactersInRange:range withString:string];
        //'\b'
        return  str.length <= 18;
        
    }else if ([self.model.lefttitle isEqualToString:@"银行预留手机"]){
    
        //先改变试一试，如果结果超过6，返回NO
        NSMutableString * str = [NSMutableString stringWithString:textField.text];
        //str替换
        [str replaceCharactersInRange:range withString:string];
        //'\b'
        return  str.length <= 11;
    
    }
    
    return YES;
    

}







- (IBAction)tfChanged:(UITextField *)sender {
    
    
    if (sender.text.length > 0) {
        
        if ([self.model.lefttitle isEqualToString:@"银行预留手机"]) {
            
            _testCodeBtn.backgroundColor = HexRGB(0xef3535);

        }
        
        self.model.tfContent = sender.text;
        
        
    }else{
    
        if ([self.model.lefttitle isEqualToString:@"银行预留手机"]) {
            
            _testCodeBtn.backgroundColor = WHITECOLOR;
            
        }

        
         self.model.tfContent = @"";

    }
    
    if (_tfBlock) {
        _tfBlock();
    }
    
    
    
}








- (IBAction)BtnClick:(UIButton *)sender {
    
    
    //判断号码对不对的
    
    [self startTime:sender];
    
    
    
}

- (void)startTime:(UIButton *)button{
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示
                
                [button setTitle:@"重新获取" forState:UIControlStateNormal];
                [button setTitleColor:HexRGB(0xcccccc) forState:UIControlStateNormal];
                
                button.layer.borderColor = HexRGB(0x0099ff).CGColor;
                button.userInteractionEnabled = YES;
            });
        }else{
            
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                
                [button setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                [button setTitleColor:WHITECOLOR forState:UIControlStateNormal];
                
                button.layer.borderColor = HexRGB(0x999999).CGColor;
                
                [UIView commitAnimations];
                button.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}








@end
