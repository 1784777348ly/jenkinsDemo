//
//  TWMyPaybackCell.m
//  ticketWaiter
//
//  Created by LY on 16/12/30.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "TWMyPaybackCell.h"
#import "TWPaiHangModel.h"

@interface TWMyPaybackCell ()
{

    BOOL  _isAuto;
}

@property (weak, nonatomic) IBOutlet UILabel *dateLable;

@property (weak, nonatomic) IBOutlet UILabel *contentsLable;

@property (weak, nonatomic) IBOutlet UILabel *moneylable;

@property (weak, nonatomic) IBOutlet UILabel *moneysLable;

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t2;




@end


@implementation TWMyPaybackCell

- (void)awakeFromNib {
    // Initialization code
    if (!_isAuto) {
        _isAuto = 1;
        
        NSArray *arr = @[_l1,_l2,_t1,_t2,_dateLable,_contentsLable,_moneylable,_moneysLable];
        
        
        for (int i=0; i<arr.count; i++) {
            
            if (i>=4) {
                
                ((UILabel *)arr[i]).font = NormalFont(((UILabel *)arr[i]).font.pointSize);
                
            }else{
                
                ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);
            }
        }
        
        
        
        
    }
    
    
    
    
}

-(void)setModel:(TWMyPaybackModel *)model
{
    _model = model;

    _dateLable.text = [self caculateTime:model.createtime];
    _contentsLable.text = model.descriptions;
    _moneysLable.text = [NSString stringWithFormat:@"%.2f元",model.amount/100.0];
    

}


-(NSString *)caculateTime:(NSTimeInterval )timeStr
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStr/1000.0];
    
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    
    return [dateFormatter stringFromDate:date];
}






@end
