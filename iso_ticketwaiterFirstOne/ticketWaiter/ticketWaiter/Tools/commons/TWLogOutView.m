//
//  TWLogOutView.m
//  ticketWaiter
//
//  Created by LY on 17/2/7.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWLogOutView.h"

@interface TWLogOutView ()
{
    BOOL _isAuto;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLable;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIView *allView;

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l2;



@end

@implementation TWLogOutView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    if (!_isAuto) {
        _isAuto = 1;
        
        NSArray *arr = @[_h1,_h2,_w1,_t1,_t2,_l1,_l2,_subTitleLable,_titleLable,_cancelBtn];
        
        for (int i=0; i<arr.count; i++) {
            
            if (i<=6) {
                
                ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);
                
            }else if (i<=8){
                
                ((UILabel *)arr[i]).font = NormalFont(((UILabel *)arr[i]).font.pointSize);
                
            }else{
                
                ((UIButton *)arr[i]).titleLabel.font = NormalFont(((UIButton *)arr[i]).titleLabel.font.pointSize);
                
            }
            
        }
        
        _allView.layer.cornerRadius = 5;
        _allView.layer.masksToBounds = YES;

        
    }


}

+(instancetype)logoutView
{
    
    TWLogOutView *sssss = [[[NSBundle mainBundle] loadNibNamed:@"TWLogOutView" owner:self options:0] lastObject];
    
    
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


#pragma mark - 退出登录
- (IBAction)logoutClick:(UIButton *)sender {
    
    [self dismiss];
    if (_logoutBlock) {
        _logoutBlock();
    }
    
}











@end
