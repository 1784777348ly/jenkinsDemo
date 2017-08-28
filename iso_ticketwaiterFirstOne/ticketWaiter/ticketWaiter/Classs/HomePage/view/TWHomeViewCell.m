//
//  TWHomeViewCell.m
//  ticketWaiter
//
//  Created by LY on 16/12/22.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "TWHomeViewCell.h"
#import "TWHomeViewModel.h"

@interface TWHomeViewCell ()
{

    BOOL _isAuto;
    
}

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w1;





@end

@implementation TWHomeViewCell

- (void)awakeFromNib {
    // Initialization code
    if (!_isAuto) {
        _isAuto = 1;
        
        NSArray *arr = @[_t1,_t2,_t3,_h1,_w1,_titleLable,_subtitle];
        
        for (int i=0; i<arr.count; i++) {
            
            if (i>=5) {
                
                ((UILabel *)arr[i]).font = NormalFont(((UILabel *)arr[i]).font.pointSize);
                
            }else{
                
                ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);
                
            }
            
        }

        
        
    }
    
    
    
}

-(void)setModel:(TWHomeViewModel *)model
{
    _model = model;
    _titleLable.text = model.title;
    
    _titleImage.image = [UIImage imageNamed:model.imageName];
    
    if (model.subTitle.length == 0) {
        
        _subtitle.hidden = YES;
    }else{
    
        _subtitle.hidden = NO;
        _subtitle.text = model.subTitle;
    }
    
    
    [self customedTitle];
    
}

-(void)customedTitle
{
    if ([self.model.title isEqualToString:@"彩票订单"] ) {
        
        
    }else if ([self.model.title isEqualToString:@"我的设置"]){
    
        _subtitle.textColor = HexRGB(0xef3535);
        _subtitle.backgroundColor = WHITECOLOR;


    }else if ([self.model.title isEqualToString:@"检查版本"]){
        
        _subtitle.textColor = WHITECOLOR;
        _subtitle.backgroundColor = HexRGB(0xef3535);
        _subtitle.layer.cornerRadius = 3;
        _subtitle.layer.masksToBounds = YES;
    }

}









//subtitle








@end
