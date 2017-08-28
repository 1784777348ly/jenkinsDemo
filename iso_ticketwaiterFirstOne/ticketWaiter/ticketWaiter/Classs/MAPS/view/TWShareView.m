//
//  TWShareView.m
//  ticketWaiter
//
//  Created by LY on 17/1/17.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWShareView.h"
//#import "UMSocialWechatHandler.h"


@interface TWShareView ()
{
    BOOL _isAuto;
}


@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *shareTitle;

@property (weak, nonatomic) IBOutlet UIView *mainView;




//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l5;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h3;


//距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bomDis;




@end


@implementation TWShareView


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    if (!_isAuto) {
        _isAuto = 1;
        
        NSArray *arr = @[_l1,_l2,_l3,_l4,_l5,_t1,_t2,_h1,_h2,_h3,_w1];
        
        for (int i=0; i<arr.count; i++) {
            
            ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);

        }

        _cancelBtn.titleLabel.font = NormalFont(_cancelBtn.titleLabel.font.pointSize);
        _shareTitle.font = NormalFont(_shareTitle.font.pointSize);

    }


}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = [UIScreen mainScreen].bounds;
}


+(instancetype)shareView
{
    TWShareView *view = [[[NSBundle mainBundle] loadNibNamed:@"TWShareView" owner:self options:0] lastObject];
    return view;

}

-(void)show
{
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [UIView transitionWithView:_mainView
                      duration:0.3
                       options: UIViewAnimationOptionTransitionNone //any animation
                    animations:^ {
                        _bomDis.constant -= _h3.constant;
                        [_mainView layoutIfNeeded];
                    }
                    completion:nil];


}


-(void)dismiss
{
    
    [UIView transitionWithView:_mainView
                      duration:0.3
                       options: UIViewAnimationOptionTransitionNone //any animation
                    animations:^ {
                        _bomDis.constant = 0;
                        [_mainView layoutIfNeeded];
                    }
                    completion:^(BOOL finished) {
                        
                        [self removeFromSuperview];
                    }];

}





- (IBAction)shareclick:(UIButton *)sender {
    
    //61  ~ 65
    switch (sender.tag-60) {
        case 1:{
            //微信好友
            [self.delegate secletedNum:1];
            break;
        }
        case 2:{
            
            //朋友圈
            [self.delegate secletedNum:2];
            break;
        }
        case 3:{
            //qq好友
            [self.delegate secletedNum:3];
            break;
        }
        case 4:{
            //qq空间
            [self.delegate secletedNum:4];
            break;
        }
        case 5:{
            //新浪
            [self.delegate secletedNum:5];
            break;
        }
        default: break;
    }


    [self dismiss];
    
    
}






//点击取消
- (IBAction)cancelClick:(UIButton *)sender {
    
    [self dismiss];
}






@end
