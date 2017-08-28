//
//  HGPlaceholderView.m
//  Hui10Game
//
//  Created by LY on 16/12/1.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "HGPlaceholderView.h"

@interface HGPlaceholderView ()
{
    BOOL _isAuto;

}


@property (weak, nonatomic) IBOutlet UILabel *lable1;

@property (weak, nonatomic) IBOutlet UILabel *lable2;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t4;




@property(nonatomic,assign)CGRect rect;


@end


@implementation HGPlaceholderView


+(instancetype)placehoderView
{
    HGPlaceholderView *placeHolderView = [[[NSBundle mainBundle] loadNibNamed:@"HGPlaceholderView" owner:self options:0] lastObject];

    return placeHolderView;

}


+(instancetype)placehoderViewWithFrame:(CGRect)rect
{
    HGPlaceholderView *placeHolderView = [[[NSBundle mainBundle] loadNibNamed:@"HGPlaceholderView" owner:self options:0] lastObject];
    
    placeHolderView.rect = rect;
    
    return placeHolderView;

}



-(void)awakeFromNib
{
    if (!_isAuto) {
        _isAuto = 1;
        
        _w1.constant = FitValue(_w1.constant);
        _h1.constant = FitValue(_h1.constant);
        _w2.constant = FitValue(_w2.constant);
        _h2.constant = FitValue(_h2.constant);
        
        _t1.constant = FitValue(_t1.constant);
        _t2.constant = FitValue(_t2.constant);
        _t3.constant = FitValue(_t3.constant);
        _t4.constant = FitValue(_t4.constant);
        
        _lable1.font = NormalFont(_lable1.font.pointSize);
        _lable2.font = NormalFont(_lable2.font.pointSize);
        _placeholderBtn.titleLabel.font = NormalFont(_placeholderBtn.titleLabel.font.pointSize);
        _placeholderBtn.layer.cornerRadius = FitValue(4);
        _placeholderBtn.layer.masksToBounds = YES;

    }

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    if (self.rect.size.height>0) {
        
        self.frame = self.rect;
        
    }else{
    
        self.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    }
    

}

- (IBAction)clickOn:(UIButton *)sender {

    sender.userInteractionEnabled = 0;
    
    [self performSelector:@selector(lateClick:) withObject:sender afterDelay:2.0f];
    
    if (_block) {
        _block();
    }
   

}

-(void)lateClick:(UIButton *)btn
{

    btn.userInteractionEnabled = 1;

}

#pragma mark - 设置占位图类型
-(void)setPlaceHolderViewWithType:(NSInteger)typeValue
{
    if (typeValue == 1) {
        //断网
        _lable1.text = @"网络去哪里了";
        _lable2.text = @"请检查您的手机是否联网";
        
    }else if (typeValue == 2){
       //没有数据
       _lable1.text = @"没有更多数据了";
       _lable2.text = @"";
    
    }else if(typeValue == 3){
       //服务器异常
        _lable1.text = @"服务器好像跑飞了。。";
        _lable2.text = @"";
    
    }


}


-(void)setOrderSTitle:(NSString *)title
{
     _lable1.text = title;

}







@end
