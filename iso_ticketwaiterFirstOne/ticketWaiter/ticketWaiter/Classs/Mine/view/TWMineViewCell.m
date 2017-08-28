//
//  TWMineViewCell.m
//  ticketWaiter
//
//  Created by LY on 16/12/28.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "TWMineViewCell.h"
#import "TWMineModel.h"

#import "TWObtainImage.h"

@interface TWMineViewCell ()
{

    BOOL _isAu;

}

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w2;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h3;





@end


@implementation TWMineViewCell

- (void)awakeFromNib {
    // Initialization code
    
    if (!_isAu) {
        
        _isAu = 1;
        
        NSArray *arr = @[_l1,_l2,_l3,_l4,_w1,_w2,_h1,_h2,_titleLable,_detailBtn];
        
        for (int i=0; i<arr.count; i++) {
            
            if (i==8) {
                
                ((UILabel *)arr[i]).font = NormalFont(((UILabel *)arr[i]).font.pointSize);
                
            }else if (i==9) {
                
                ((UIButton *)arr[i]).titleLabel.font = NormalFont(((UIButton *)arr[i]).titleLabel.font.pointSize);
                
            }else{
                
                ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);
            }
        }

        
    }
    
    
}


-(void)setModel:(TWMineModel *)model
{
    _model = model;
    
    _titleLable.text = model.title;
    
    _headImage.image = [UIImage imageNamed:model.imageName];
    
    
    
    if (!model.isNotHaveArrow) {
        
        _rightArrow.hidden = YES;
    }else{
    
        _rightArrow.hidden = NO;
    }
    
    
    if ([model.title isEqualToString:@"投注站照片"]) {
        
        NSLog(@"%@",model.details);

            _h3.constant = _w3.constant = FitValue(40);
            
            [TWObtainImage LocalHaveImageWithImageName:model.details andReturnBlock:^(UIImage *image) {
                
                [_detailBtn setImage:image forState:UIControlStateNormal];
                
            }];

    }else{
    
        [_detailBtn setTitle:model.details forState:UIControlStateNormal];

        _w3.constant = [model.details widthForFont:NormalFont(14)]+5;
        
    }

    
    if ([model.title isEqualToString:@"我的账号"]) {
    
         [_detailBtn setTitle:model.details forState:UIControlStateNormal];
        
        if([model.details isEqualToString:@"正式版"]){
        
           [_detailBtn setTitleColor:HexRGB(0xef3535) forState:UIControlStateNormal];
        
        }else{
        
           [_detailBtn setTitleColor:HexRGB(0x686868) forState:UIControlStateNormal];
            
        }
    
    
    }
    
    
    
    
    
    
    _bottomView.hidden = !model.hideBottomLine;
    
    
    //文字
//    if ([model.detailsType isEqualToString:@"1"]) {
//        
//        [_detailBtn setTitle:model.details forState:UIControlStateNormal];
//        
//    }else{
//        
//        [_detailBtn setImage:[UIImage imageNamed:model.details] forState:UIControlStateNormal];
//    
//    }
    
    

}



@end
