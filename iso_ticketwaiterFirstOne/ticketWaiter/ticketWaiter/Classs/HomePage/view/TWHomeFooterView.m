//
//  TWHomeFooterView.m
//  ticketWaiter
//
//  Created by LY on 16/12/22.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "TWHomeFooterView.h"

@interface TWHomeFooterView ()
{
    BOOL  _isAutolayout;
    
}

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UIView *backView;

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w2;


@end

@implementation TWHomeFooterView

- (void)awakeFromNib {
    // Initialization code
    
    if (!_isAutolayout) {
        
        _isAutolayout = 1;
        
        
        NSArray *arr = @[_l1,_l2,_h1,_w1,_w2,_titleLable];
        
        for (int i=0; i<arr.count; i++) {
            
            if (i==5) {
                
                ((UILabel *)arr[i]).font = NormalFont(((UILabel *)arr[i]).font.pointSize);
                
            }else{
            
                ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);

            }

        }
     
        UITapGestureRecognizer *gg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick:)];
     
        [self.backView addGestureRecognizer:gg];
        
        
        
    }
    
    
    
}


-(void)onClick:(UITapGestureRecognizer *)tapGR
{
    tapGR.view.userInteractionEnabled = 0;
    
    [self performSelector:@selector(delayClick:) withObject:tapGR.view afterDelay:2.0];
    
    
    if (_mapBlock) {
        
        _mapBlock();
    }

}

-(void)delayClick:(UIView *)views
{
    views.userInteractionEnabled = 1;
}





@end
