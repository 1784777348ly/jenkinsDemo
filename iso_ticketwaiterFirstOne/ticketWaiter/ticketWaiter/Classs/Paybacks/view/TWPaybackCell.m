//
//  TWPaybackCell.m
//  ticketWaiter
//
//  Created by LY on 17/1/3.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWPaybackCell.h"
#import "TWPayBackModel.h"

@interface TWPaybackCell ()
{

    BOOL _isAuto;

}


@property (weak, nonatomic) IBOutlet UILabel *namelable;
@property (weak, nonatomic) IBOutlet UILabel *phonelable;
@property (weak, nonatomic) IBOutlet UILabel *moneylable;
@property (weak, nonatomic) IBOutlet UILabel *reasonLable;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (weak, nonatomic) IBOutlet UILabel *leftIcon;
@property (weak, nonatomic) IBOutlet UIImageView *bottomIcon;




//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t1;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lx1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lx2;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ww1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ww2;



@property (weak, nonatomic) IBOutlet UILabel *shibaiLable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wwww1;



@end

@implementation TWPaybackCell




- (void)awakeFromNib {
    // Initialization code
    
    if (!_isAuto) {
        
        _isAuto = 1;
        
        NSArray *arr = @[_h1,_l1,_l2,_l3,_t1,_ww1,_ww2,_wwww1,_namelable,_phonelable,_moneylable,_reasonLable,_timeLable,_leftIcon];
        
        for (int i=0; i<arr.count; i++) {
            
            if (i>=8) {
                
                ((UILabel *)arr[i]).font = NormalFont(((UILabel *)arr[i]).font.pointSize);
                
            }else{
                
                ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);
            }
        }

        
    }

}


-(void)setModel:(TWPayBackModel *)model
{
    _model = model;
    
    _namelable.text = model.name;
    _phonelable.text = model.phone;
    _moneylable.text = [NSString stringWithFormat:@"%.2f元",[model.amount floatValue]/100.0];
    _reasonLable.text = @"赠送金额";
    _timeLable.text = [self caculateTime:model.updatetime];
    
    if (model.status == 2  || model.status == 4) {
        //失败
        
        _shibaiLable.hidden = 0;
        
        _shibaiLable.layer.cornerRadius = 3;
        _shibaiLable.layer.masksToBounds = 1;
        
        
//        _w2.constant = FitValue(30);
//        _lx1.constant = FitValue(15);
//        
        _lx2.constant = FitValue(0);
        _w3.constant = FitValue(0);
        _timeLable.textColor = HexRGB(0x686868);
//
//        _leftIcon.layer.cornerRadius = 3;
//        _leftIcon.layer.masksToBounds = YES;

    }else if (model.status == 3){
        //成功
        _lx2.constant = FitValue(0);
        _w3.constant = FitValue(0);
        _timeLable.textColor = HexRGB(0x686868);
        
//        _w2.constant = FitValue(0);
//        _lx1.constant = FitValue(0);
        
        _shibaiLable.hidden = 1;
        
        
    }else{
        //处理中..
        _lx2.constant = FitValue(9);
        _w3.constant = FitValue(12);
        _timeLable.text = @"红包赠送中....";
        _timeLable.textColor = HexRGB(0xef3535);
        
//        _w2.constant = FitValue(0);
//        _lx1.constant = FitValue(0);
        
        
        _shibaiLable.hidden = 1;

    }
    
    
    
}

-(NSString *)caculateTime:(NSTimeInterval )timeStr
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStr/1000.0];
    
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    
    return [dateFormatter stringFromDate:date];
}





@end
