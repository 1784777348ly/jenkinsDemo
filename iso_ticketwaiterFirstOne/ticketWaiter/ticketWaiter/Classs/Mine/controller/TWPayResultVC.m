//
//  TWPayResultVC.m
//  ticketWaiter
//
//  Created by LY on 16/12/29.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "TWPayResultVC.h"

@interface TWPayResultVC ()

@property (weak, nonatomic) IBOutlet UILabel *lable;

@property (weak, nonatomic) IBOutlet UIButton *btn;


//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w2;







@end

@implementation TWPayResultVC




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self shiPei];
    
    [self setNavigationBar];
    
}


- (IBAction)backClick:(UIButton *)sender {
    
    //返回银行卡列表页面
    
    if (self.navigationController.viewControllers.count>6) {
        
        
        [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 4] animated:YES];

        
    }else{
    
    
        [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 4] animated:YES];
    
    }
    
    
    
}







#pragma mark - 设置导航栏
- (void)setNavigationBar{
    
    [self setNaviBarBackgroundColor:nil andStatusBarColor:nil];
    [self setNaviBarTitle:@"绑定银行卡" color:WHITECOLOR];
    [self setNaviBarLeftTitle:nil image:@"icon_bar_back"];
}

- (void)leftAction:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)shiPei
{
    NSArray *arr = @[_t1,_t2,_t3,_h1,_h2,_w1,_w2,_lable,_btn];
    
    for (int i=0; i<arr.count; i++) {
        
        if (i==7) {
            
            ((UILabel *)arr[i]).font = NormalFont(((UILabel *)arr[i]).font.pointSize);
            
        }else if (i==8) {
            
            ((UIButton *)arr[i]).titleLabel.font = NormalFont(((UIButton *)arr[i]).titleLabel.font.pointSize);
            
        }else{
            
            ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);
        }
    }
    
    _btn.layer.cornerRadius = FitValue(4);
    _btn.layer.masksToBounds = YES;
    
    [_btn setTitleColor:COLOR(255, 255, 255, 0.5) forState:UIControlStateHighlighted];

    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
