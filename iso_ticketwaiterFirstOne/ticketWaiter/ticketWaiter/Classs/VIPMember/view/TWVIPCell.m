//
//  TWVIPCell.m
//  ticketWaiter
//
//  Created by LY on 16/12/30.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "TWVIPCell.h"
#import "TWVIPModel.h"

@interface TWVIPCell ()
{

    BOOL  _isAutolayout;

}

@property (weak, nonatomic) IBOutlet UILabel *phoneLable;

@property (weak, nonatomic) IBOutlet UILabel *nicknameLable;

@property (weak, nonatomic) IBOutlet UIButton *clickBtn;


//适配

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w3;






@end


@implementation TWVIPCell

- (void)awakeFromNib {
    // Initialization code
    
    if (!_isAutolayout) {
        
        _isAutolayout = 1;
        
        NSArray *arr = @[_h1,_w1,_l1,_l2,_l3,_w3,_phoneLable,_nicknameLable,_clickBtn];
        
        for (int i=0; i<arr.count; i++) {
            
            if (i<6) {
                
                ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);

                
            }else if(i<=7){
                
                ((UILabel *)arr[i]).font = NormalFont(((UILabel *)arr[i]).font.pointSize);
                
            }else{
                
                ((UIButton *)arr[i]).titleLabel.font = NormalFont(((UIButton *)arr[i]).titleLabel.font.pointSize);

            }
            
        }
        
        
        
        //w1 l2  l3
//        _w1.constant = 0;
//        _l2.constant = 0;
//        _l3.constant = FitValue(24);

    }
    
}


-(void)setModel:(TWVIPModel *)model
{
    
    _model = model;
    _phoneLable.text = model.phone;
    
    if (model.remark.description.length>0) {
        
        _nicknameLable.text = model.remark;
        _nicknameLable.textColor = HexRGB(0x282828);
        
        _w2.constant = [@"88888888888" widthForFont:NormalFontWithNoScale(16)]+FitValue(5);
        
    }else{
        
        _nicknameLable.textColor = HexRGB(0xcccccc);
        _nicknameLable.text = @"未备注";
        //_w2.constant = [@"未备注" widthForFont:NormalFontWithNoScale(16)]+FitValue(5);
        _w2.constant = [@"88888888888" widthForFont:NormalFontWithNoScale(16)]+FitValue(5);

    }
    
    //1的情况下 正常情况下
    if (_cellType == 1) {
        
        _w1.constant = 0;
        _l2.constant = 0;
        _l3.constant = FitValue(24);
        
    }else if (_cellType == 2) {
       //删除的情况下
        
        _w1.constant = FitValue(44);
        _l2.constant = FitValue(-6);
        _l3.constant = FitValue(30);
        
        self.clickBtn.selected = model.isDeleteState;
        
    }else{
      // 选择的情况下
    
        _w1.constant = 0;
        _l2.constant = FitValue(-9);
        _l3.constant = FitValue(28);
        
        _phoneLable.attributedText = [self changeColorWithAStr:model.phone andRect:model.inputStrLength];
    
    }

    
}

#pragma mark  - 点击事件

- (IBAction)clickOn:(UIButton *)sender {
    
   // sender.selected = !sender.selected;
    
    //改变模型属性
    
    
}


- (NSMutableAttributedString *)changeColorWithAStr:(NSString *)str andRect:(NSUInteger)length
{
    NSMutableAttributedString *tmpStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:HexRGB(0xef3535), NSForegroundColorAttributeName, nil];
    NSDictionary *bDic = [NSDictionary dictionaryWithObjectsAndKeys:HexRGB(0x282828), NSForegroundColorAttributeName, nil];
    
    [tmpStr addAttributes:aDic range:NSMakeRange(0, length)];
    [tmpStr addAttributes:bDic range:NSMakeRange(length, str.length-length)];

    return tmpStr;
}





@end
