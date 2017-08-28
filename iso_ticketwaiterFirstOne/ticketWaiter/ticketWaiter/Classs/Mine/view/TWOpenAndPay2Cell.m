//
//  TWOpenAndPay2Cell.m
//  ticketWaiter
//
//  Created by LY on 17/1/13.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWOpenAndPay2Cell.h"
#import "TWMineModel.h"

@interface TWOpenAndPay2Cell ()
{

    BOOL _isau;
}

@property (weak, nonatomic) IBOutlet UILabel *leftlable;
@property (weak, nonatomic) IBOutlet UILabel *rightLable;


//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l2;



@end

@implementation TWOpenAndPay2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (!_isau) {
        _isau = 1;
        
        _l2.constant = FitValue(_l2.constant);
        _l1.constant = FitValue(_l1.constant);
        _leftlable.font = NormalFont(_leftlable.font.pointSize);
        _rightLable.font = NormalFont(_rightLable.font.pointSize);
        
        
    }

}

-(void)setModel:(TWOpenAccountModel *)model
{

    _model = model;
    _leftlable.text = model.title;
    _rightLable.text = model.subTitle;

}




@end
