//
//  TWSelMoneyView.m
//  ticketWaiter
//
//  Created by LY on 17/1/15.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWSelMoneyView.h"

@interface TWSelMoneyView ()
{

    BOOL _isAuto;

}

@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *tenBtn;

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoToHongbaoDis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tenToHongbaoDis;

@property(nonatomic,assign)CGRect rect;


@end


@implementation TWSelMoneyView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    if (!_isAuto) {
        _isAuto = 1;
        
        NSArray *arr = @[_w1,_w2,_w3,_h1,_h2,_h3,_twoBtn,_tenBtn];
        
        for (int i=0; i<arr.count; i++) {
            
            if (i>=6) {
                
                ((UIButton *)arr[i]).titleLabel.font = NormalFont(((UIButton *)arr[i]).titleLabel.font.pointSize);
                
            }else{
                
                ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);
            }
        }


        _twoBtn.layer.shadowOffset =  CGSizeMake(0, 4);
        _twoBtn.layer.shadowOpacity = 0.8;
        _twoBtn.layer.shadowColor = COLOR(0, 0, 0, 0.75).CGColor;
        

        
        _tenBtn.layer.shadowOffset =  CGSizeMake(0, 4);
        _tenBtn.layer.shadowOpacity = 0.8;
        _tenBtn.layer.shadowColor = COLOR(0, 0, 0, 0.75).CGColor;
        
        //设置阴影
        
        //正常状态
        _hongbaoBtn.layer.shadowOffset =  CGSizeMake(0, 4);
        _hongbaoBtn.layer.shadowOpacity = 0.8;
        _hongbaoBtn.layer.shadowColor = COLOR(0, 0, 0, 0.75).CGColor;

        
        
        
    }

}

-(void)ruleFrame:(CGRect)rect
{
    self.rect = rect;
}


+(instancetype)selMoneyViewWithRect:(CGRect)rect
{
    TWSelMoneyView *viewss = [[[NSBundle mainBundle] loadNibNamed:@"TWSelMoneyView" owner:self options:0] lastObject];
    viewss.rect = rect;
    return viewss;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = self.rect;
}




#pragma mark - 点击红包
- (IBAction)HongBaoClick:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    [self performSelector:@selector(delayClick:) withObject:sender afterDelay:1.5];
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        if (_addBlock) {
            _addBlock(1);
        }
        
        _hongbaoBtn.layer.shadowOffset =  CGSizeMake(0, 2);
        _hongbaoBtn.layer.shadowOpacity = 0.8;
        _hongbaoBtn.layer.shadowColor = COLOR(0, 0, 0, 0.75).CGColor;
        
        
        [UIView animateWithDuration:0.1 animations:^{
            
            _twoToHongbaoDis.constant = FitValue(87);
            _tenToHongbaoDis.constant = FitValue(87);
            
            _h2.constant = FitValue(47);
            _w2.constant = FitValue(47);
            _h3.constant = FitValue(47);
            _w3.constant = FitValue(47);
            
            [self layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            
        }];
        
    }else{
        
        if (_addBlock) {
            _addBlock(0);
        }

        
        _hongbaoBtn.layer.shadowOffset =  CGSizeMake(0, 4);
        _hongbaoBtn.layer.shadowOpacity = 0.8;
        _hongbaoBtn.layer.shadowColor = COLOR(0, 0, 0, 0.25).CGColor;

    
        [UIView animateWithDuration:0.1 animations:^{
            
            _twoToHongbaoDis.constant = FitValue(1);
            _tenToHongbaoDis.constant = FitValue(1);
            
            _h2.constant = FitValue(20);
            _w2.constant = FitValue(20);
            _h3.constant = FitValue(20);
            _w3.constant = FitValue(20);
         
            
            [self layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            _h2.constant = FitValue(1);
            _w2.constant = FitValue(1);
            _h3.constant = FitValue(1);
            _w3.constant = FitValue(1);
            
        }];
        
    
    
    }
    
    
    
    
    
    
    
}

#pragma mark - 点击2元
- (IBAction)TwoYuanClick:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    [self performSelector:@selector(delayClick:) withObject:sender afterDelay:1.5];
    
    if (_addBlock) {
        _addBlock(0);
    }
    
    
    if (_sendBlock) {
        
        
        _hongbaoBtn.selected = !_hongbaoBtn.selected;
        _hongbaoBtn.layer.shadowOffset =  CGSizeMake(0, 4);
        _hongbaoBtn.layer.shadowOpacity = 0.8;
        _hongbaoBtn.layer.shadowColor = COLOR(0, 0, 0, 0.25).CGColor;
        
        
        [UIView animateWithDuration:0.1 animations:^{
            
            _twoToHongbaoDis.constant = FitValue(1);
            _tenToHongbaoDis.constant = FitValue(1);
            
            _h2.constant = FitValue(20);
            _w2.constant = FitValue(20);
            _h3.constant = FitValue(20);
            _w3.constant = FitValue(20);
            
            
            [self layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            _h2.constant = FitValue(1);
            _w2.constant = FitValue(1);
            _h3.constant = FitValue(1);
            _w3.constant = FitValue(1);
            
        }];
        
#warning =============
        //2*100
        _sendBlock(2*100);
    }

    
}


#pragma mark - 点击10元
- (IBAction)tenYuanClick:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    [self performSelector:@selector(delayClick:) withObject:sender afterDelay:1.5];
    
    if (_addBlock) {
        _addBlock(0);
    }
    
    if (_sendBlock) {
        
        _hongbaoBtn.selected = !_hongbaoBtn.selected;
        _hongbaoBtn.layer.shadowOffset =  CGSizeMake(0, 4);
        _hongbaoBtn.layer.shadowOpacity = 0.8;
        _hongbaoBtn.layer.shadowColor = COLOR(0, 0, 0, 0.25).CGColor;
        
        [UIView animateWithDuration:0.1 animations:^{
            _twoToHongbaoDis.constant = FitValue(1);
            _tenToHongbaoDis.constant = FitValue(1);
            _h2.constant = FitValue(20);
            _w2.constant = FitValue(20);
            _h3.constant = FitValue(20);
            _w3.constant = FitValue(20);
            
            [self layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            _h2.constant = FitValue(1);
            _w2.constant = FitValue(1);
            _h3.constant = FitValue(1);
            _w3.constant = FitValue(1);
            
        }];
#warning ============= 10*100
        _sendBlock(10*100);
    }

}


-(void)moneyDismiss
{
    
    _hongbaoBtn.selected = 0;
    
    _hongbaoBtn.layer.shadowOffset =  CGSizeMake(0, 4);
    _hongbaoBtn.layer.shadowOpacity = 0.8;
    _hongbaoBtn.layer.shadowColor = COLOR(0, 0, 0, 0.25).CGColor;
    
    
    [UIView animateWithDuration:0.1 animations:^{
        
        _twoToHongbaoDis.constant = FitValue(1);
        _tenToHongbaoDis.constant = FitValue(1);
        
        _h2.constant = FitValue(20);
        _w2.constant = FitValue(20);
        _h3.constant = FitValue(20);
        _w3.constant = FitValue(20);
        
        
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        _h2.constant = FitValue(1);
        _w2.constant = FitValue(1);
        _h3.constant = FitValue(1);
        _w3.constant = FitValue(1);
        
    }];

    


}




-(void)delayClick:(UIButton *)btn
{
    btn.userInteractionEnabled = YES;
}







@end
