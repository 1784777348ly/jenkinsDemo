//
//  HGHeaderImageViewForNib.m
//  Hui10Game
//
//  Created by LY on 16/12/2.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "HGHeaderImageViewForNib.h"

@interface HGHeaderImageViewForNib ()

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *vvView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageview;

@property(nonatomic,assign)CGRect rects;

//距离约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *b1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l1;



@end


@implementation HGHeaderImageViewForNib


-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"HGHeaderImageViewForNib" owner:self options:nil]objectAtIndex:0];
        
        view.frame = self.bounds;
    
        self.rects = self.bounds;
        
        [self addSubview:view];

    }
    return self;
}

-(void)headerViewWithBackgroundColor:(UIColor *)bColor andImageName:(NSString *)name
{
    
    if (bColor == nil) {
        
        bColor = [UIColor whiteColor];
    }
    self.vvView.backgroundColor = bColor;
    
    self.vvView.layer.cornerRadius = self.rects.size.height/2.0;
    self.vvView.layer.masksToBounds = YES;
    
    self.headImageview.image = [UIImage imageNamed:name];
    
    self.headImageview.layer.cornerRadius = (self.rects.size.height - 4)/2.0;
    self.headImageview.layer.masksToBounds = YES;
    

}

-(void)headerViewImageName:(NSString *)name
{
    //不要背景
    _b1.constant = 0;
    _t1.constant = 0;
    _h1.constant = 0;
    _l1.constant = 0;
    self.vvView.backgroundColor = [UIColor clearColor];
    
    if (name.length > 0) {
        
        self.headImageview.image = [UIImage imageNamed:name];
        
    }else{
    
        self.headImageview.image = [UIImage imageNamed:@"loading_avatar"];
    }
    
    
    self.headImageview.layer.cornerRadius = (self.rects.size.height)/2.0;
    self.headImageview.layer.masksToBounds = YES;

}

-(void)headerViewImage:(UIImage *)image
{
    //不要背景
//    _b1.constant = 0;
//    _t1.constant = 0;
//    _h1.constant = 0;
//    _l1.constant = 0;
//    self.vvView.backgroundColor = [UIColor clearColor];
  
    if (image) {
    
        self.headImageview.image = image;
    }else{
    
        self.headImageview.image = [UIImage imageNamed:@"icon_nopic-0"];
    
    }
    
//    self.headImageview.layer.cornerRadius = (self.rects.size.height)/2.0;
//    self.headImageview.layer.masksToBounds = YES;

}




-(void)normalViewWithImageName:(NSString *)name
{
    //不要背景
    _b1.constant = 0;
    _t1.constant = 0;
    _h1.constant = 0;
    _l1.constant = 0;

    self.vvView.backgroundColor = [UIColor clearColor];
    self.headImageview.image = [UIImage imageNamed:name];

}






@end
