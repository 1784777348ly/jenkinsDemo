//
//  TWUnboundView.m
//  ticketWaiter
//
//  Created by LY on 17/2/21.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWUnboundView.h"

@interface TWUnboundView ()
{

    BOOL  _isAuto;

}

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t3;


@property(nonatomic,assign)CGRect  rects;

@end



@implementation TWUnboundView

+(instancetype)unboundViewWithRect:(CGRect )rect
{
    
    TWUnboundView *viewss = [[[NSBundle mainBundle] loadNibNamed:@"TWUnboundView" owner:self options:0] lastObject];
    
    [viewss setViewRect:rect];

    return viewss;

}


-(void)setViewRect:(CGRect)rect
{
    self.rects = rect;
}


-(void)dismiss
{
    [self removeFromSuperview];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = self.rects;

}

-(void)awakeFromNib
{
    if (!_isAuto) {
        _isAuto = 1;
        _h1.constant = FitValue(_h1.constant);
        _h2.constant = FitValue(_h2.constant);
        _t1.constant = FitValue(_t1.constant);
        
        _btn1.titleLabel.font = NormalFont(_btn1.titleLabel.font.pointSize);
        _btn2.titleLabel.font = NormalFont(_btn2.titleLabel.font.pointSize);
        
    }



}


#pragma mark - 取消
- (IBAction)cancelClick:(UIButton *)sender {
    
    [self dismiss];

}


#pragma mark - 解除绑定
- (IBAction)unBoundCard:(UIButton *)sender {
    
    if (_block) {
        _block();
    }
    
}










@end
