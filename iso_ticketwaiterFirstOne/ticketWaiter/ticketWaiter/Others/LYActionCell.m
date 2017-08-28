//
//  LYActionCell.m
//  HuiShiApp
//
//  Created by LY on 16/8/25.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "LYActionCell.h"
#import "LYActionMoel.h"

@interface LYActionCell ()
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeight;

@end

@implementation LYActionCell

- (void)awakeFromNib {
    
    _actionBtn.titleLabel.font = Font(_actionBtn.titleLabel.font.pointSize);

    if (SCREEN_HEIGHT < 667) {
        
        _btnHeight.constant *= ScaleY;
        
    }else if (SCREEN_HEIGHT < 667) {
        
        _btnHeight.constant *= ScaleY;
    }
    
}

-(void)setModel:(LYActionMoel *)model
{
    _model = model;
    
    [_actionBtn setTitle:model.titleStr forState:UIControlStateNormal];
    
    if (model.imageName) {
        [_actionBtn setImage:[UIImage imageNamed:model.imageName] forState:UIControlStateNormal];
    }
    
    if (model.contentStrColor != nil) {
        
        [_actionBtn setTitleColor:model.contentStrColor forState:UIControlStateNormal];
    }
    
    if (model.borderColor != nil) {
        
        _actionBtn.layer.borderColor = model.borderColor.CGColor;
        _actionBtn.layer.masksToBounds = YES;
        _actionBtn.layer.cornerRadius = 20;
        _actionBtn.layer.borderWidth = 1;
        
    }else{
    
        _actionBtn.layer.borderColor = [HexRGB(0x999999) CGColor];
        _actionBtn.layer.masksToBounds = YES;
        _actionBtn.layer.cornerRadius = 20;
        _actionBtn.layer.borderWidth = 1;
    
    }
    

}

- (IBAction)actionBtnclick:(UIButton *)sender {
    
        _block(_model.tag);
}



@end
