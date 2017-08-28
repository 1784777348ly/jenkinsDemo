//
//  TWOpenAndPayCell.m
//  ticketWaiter
//
//  Created by LY on 16/12/29.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "TWOpenAndPayCell.h"
#import "TWMineModel.h"

@interface TWOpenAndPayCell ()
{

    BOOL _isauto;

}

@property (weak, nonatomic) IBOutlet UILabel *titles;
@property (weak, nonatomic) IBOutlet UILabel *subtitles;

@property (weak, nonatomic) IBOutlet UILabel *rightLable;

@property (weak, nonatomic) IBOutlet UILabel *middleLbale;
@property (weak, nonatomic) IBOutlet UIView *coverView;



//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l4;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w3;





@end

@implementation TWOpenAndPayCell

- (void)awakeFromNib {
    
    if (!_isauto) {
        _isauto = 1;
        
        NSArray *arr = @[_h1,_h2,_h3,_w2,_w3,_l1,_l2,_l3,_l4,_titles,_subtitles,_rightLable,_middleLbale];
        
        for (int i=0; i<arr.count; i++) {
            
            if (i>=9) {
                
                ((UILabel *)arr[i]).font = NormalFont(((UILabel *)arr[i]).font.pointSize);
                
            }else{
                
                ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);
            }
        }

        
        
    }
    
}



-(void)setModel:(TWOpenAccountModel *)model
{
    _model = model;
    
    if (model.isAccount) {
        
        _coverView.hidden  = YES;
        
        _titles.text = model.title;
        
        _subtitles.text = model.subTitle;
        
    }else{
    
        _coverView.hidden  = NO;
        
        _titles.text = model.title;
        
        _subtitles.text = model.subTitle;
        
    }
    

    


}




@end
