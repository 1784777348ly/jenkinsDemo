//
//  TWMyAccountSelCell.m
//  ticketWaiter
//
//  Created by LY on 17/1/13.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWMyAccountSelCell.h"
#import "TWMineModel.h"


@interface TWMyAccountSelCell ()
{
    BOOL  _isau;


}

@property (weak, nonatomic) IBOutlet UIButton *selBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLable;
@property (weak, nonatomic) IBOutlet UIView *bottomline;

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;




@end

@implementation TWMyAccountSelCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    if (!_isau) {
        _isau = 1;
        
        NSArray *arr = @[_l1,_l2,_l3,_h1,_h2,_w1,_titleLable,_subtitleLable,_selBtn];
        
        for (int i=0; i<arr.count; i++) {
            
            if (i<=5) {
                
                 ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);
                
            }else if (i<=7) {
                
                 ((UILabel *)arr[i]).font = NormalFont(((UILabel *)arr[i]).font.pointSize);
               
                
            }else{
                
                ((UIButton *)arr[i]).titleLabel.font = NormalFont(((UIButton *)arr[i]).titleLabel.font.pointSize);
                
            }
        }

        
    }

}

-(void)setModel:(TWMineModel *)model
{
    _model = model;
    
    _selBtn.selected = model.isSeled;
    
    _titleLable.text = model.title;
    
    _subtitleLable.text = model.details;
    
    _bottomline.hidden = !model.hideBottomLine;
    
    

}





@end
