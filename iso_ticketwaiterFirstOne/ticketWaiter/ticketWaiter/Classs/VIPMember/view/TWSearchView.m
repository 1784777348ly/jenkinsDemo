//
//  TWSearchView.m
//  ticketWaiter
//
//  Created by LY on 17/1/11.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWSearchView.h"

@interface TWSearchView ()<UITextFieldDelegate>
{
    BOOL _isAu;

}

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *delBtn;


//适配

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w3;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l2;




@end

@implementation TWSearchView

-(void)awakeFromNib
{
    if (!_isAu) {
        _isAu = 1;

        NSArray *arr = @[_h1,_h2,_h3,_w1,_w2,_w3,_l1,_l2,_cancelBtn,_textField];
        
        for (int i=0; i<arr.count; i++) {
            
            if (i<8) {
                
                ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);
                
                
            }else if(i==8) {
                
                ((UIButton *)arr[i]).titleLabel.font = NormalFont(((UIButton *)arr[i]).titleLabel.font.pointSize);
                
            }else{
            
                ((UITextField *)arr[i]).font = NormalFont(((UITextField *)arr[i]).font.pointSize);

            }
            
        }

        [_textField becomeFirstResponder];
        _textField.delegate = self;
        
        _textField.tintColor = HexRGB(0xcccccc);
        
        
    }


}





+(instancetype)searchView
{
    TWSearchView *searchView = [[[NSBundle mainBundle] loadNibNamed:@"TWSearchView" owner:self options:0] lastObject];

    return searchView;
    
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);

}




#pragma mark - 点击事件

//搜素
- (IBAction)searchClick:(UIButton *)sender {
    
    //没有啥用
    
}


//删除
- (IBAction)clearClick:(UIButton *)sender {
    
    self.textField.text = @"";
    sender.hidden = YES;
    
    if (_siBlock) {
        
        _siBlock(@"");
    }

    
}


//取消
- (IBAction)cancelClick:(UIButton *)sender {
    
    if (_scBlock) {
        _scBlock();
    }
    
    
}

//有输入值
- (IBAction)valueChanged:(UITextField *)sender {
    
    
    if(sender.text.length>0){
    
        self.delBtn.hidden = NO;
    }else{
    
        self.delBtn.hidden = YES;
    }
    
    if (_siBlock) {
        
        _siBlock(sender.text);
    }
    
    
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    //先改变试一试，如果结果超过6，返回NO
    NSMutableString * str = [NSMutableString stringWithString:textField.text];
    //str替换
    [str replaceCharactersInRange:range withString:string];
    //'\b'
    return  str.length <= 11;

    
}










@end
