//
//  TWOrderUpView.m
//  ticketWaiter
//
//  Created by LY on 17/1/16.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWOrderUpView.h"

@interface TWOrderUpView ()
{
    BOOL _isAuto;
}

//gif动画
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
//订单号
@property (weak, nonatomic) IBOutlet UILabel *orderLable;
//进度条
@property (weak, nonatomic) IBOutlet UIImageView *progressView;

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressDis;

@property(nonatomic,assign)CGRect frames;


@end

@implementation TWOrderUpView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    if (!_isAuto) {
        _isAuto = 1;
        NSArray *arr = @[_h1,_h2,_w1,_t1];
        
        for (int i=0; i<arr.count; i++) {

                ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);

            }
        
        [self setGifAnimation];
        
        
    }

}


-(void)ruleFrame:(CGRect)rect
{
    self.frames = rect;

}



+(instancetype)OrderUpView:(CGRect)frame
{
    
    TWOrderUpView *hh = [[[NSBundle mainBundle] loadNibNamed:@"TWOrderUpView" owner:self options:0] lastObject];
    
    [hh ruleFrame:frame];

    return hh;

}




-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = self.frames;


}




-(void)setGifAnimation{

    //得到图片的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"floatAnimation" ofType:@"gif"];
    //将图片转为NSData
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    //创建一个webView，添加到界面
        //自动调整尺寸
    //禁止滚动
    _myWebView.scrollView.scrollEnabled = NO;
    _myWebView.scrollView.backgroundColor = [UIColor clearColor];
    
    //设置透明效果
    _myWebView.backgroundColor = [UIColor clearColor];
    _myWebView.opaque = 0;
    //加载数据
    [_myWebView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];

}


//num1 已经完成  num2 总共的订单
-(void)refreshOrderWithNum1:(NSInteger)num1 andNum2:(NSInteger)num2
{
    
    CGRect rect = self.frames;
    
    self.orderLable.attributedText = [self changeColorWithAStr:[NSString stringWithFormat:@"%zd/%zd",num1,num2] andRect:[[NSString stringWithFormat:@"%zd",num1] length]];
    
    _progressDis.constant = (1-num1*1.0/num2)*rect.size.width;

    
    NSLog(@"}}}}}}}}}}}}}}}}}}}}}}}}}}}}}{{{{{{{{{{{{{{{{{{{{{{%zd  %zd",num1,num2);
    
    
}


- (NSMutableAttributedString *)changeColorWithAStr:(NSString *)str andRect:(NSUInteger)length
{
    NSMutableAttributedString *tmpStr = [[NSMutableAttributedString alloc] initWithString:str];
    
   
     NSDictionary *aDic = [NSDictionary dictionaryWithObjects:@[HexRGB(0xffffff),BoldFont(14)] forKeys:@[NSForegroundColorAttributeName,NSFontAttributeName]];
    
    
     NSDictionary *bDic = [NSDictionary dictionaryWithObjects:@[HexRGB(0xcecece),BoldFont(14)] forKeys:@[NSForegroundColorAttributeName,NSFontAttributeName]];
    
    
    [tmpStr addAttributes:aDic range:NSMakeRange(0, length)];
    [tmpStr addAttributes:bDic range:NSMakeRange(length, str.length-length)];
    
    return tmpStr;
}

-(void)dismiss
{
    [self removeFromSuperview];
}






@end
