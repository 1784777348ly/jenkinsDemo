//
//  TWSaveMemView.m
//  ticketWaiter
//
//  Created by LY on 17/1/25.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWSaveMemView.h"

@interface TWSaveMemView ()
{

    BOOL  _isAuto;

}

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *showLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l1;

@property(nonatomic,assign)CGRect rect;

@end


@implementation TWSaveMemView


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    if (!_isAuto) {
        _isAuto = 1;
        
        NSArray *arr = @[_h1,_h2,_h3,_w1,_w3,_t1,_l1,_showLable,_titleLable,_closeBtn];
        
        for (int i=0; i<arr.count; i++) {
            
            if (i<=6) {
                
                ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);
                
            }else if (i<=8){
                
                ((UILabel *)arr[i]).font = NormalFont(((UILabel *)arr[i]).font.pointSize);

            }else{
            
                ((UIButton *)arr[i]).titleLabel.font = NormalFont(((UIButton *)arr[i]).titleLabel.font.pointSize);
 
            }
            
        }

        
        
        
    }
    

}


+(instancetype)saveMemberViewWithRect:(CGRect)rect
{

    TWSaveMemView *sssss = [[[NSBundle mainBundle] loadNibNamed:@"TWSaveMemView" owner:self options:0] lastObject];
    
    sssss.rect = rect;

    return sssss;
}


-(void)show
{

    [[UIApplication sharedApplication].keyWindow addSubview:self];

}

-(void)dismiss
{
    [self removeFromSuperview];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = [UIScreen mainScreen].bounds;

}







#pragma mark - 赠送彩金
- (IBAction)tapClick:(UITapGestureRecognizer *)sender {
    
    [self dismiss];
    if (_donateBlock) {
        
        _donateBlock(1);
    }
    
    
}



#pragma mark - 关闭
- (IBAction)closeClick:(UIButton *)sender {
    
    [self dismiss];
    if (_donateBlock) {
        
        _donateBlock(0);
    }

    
    
}





@end
