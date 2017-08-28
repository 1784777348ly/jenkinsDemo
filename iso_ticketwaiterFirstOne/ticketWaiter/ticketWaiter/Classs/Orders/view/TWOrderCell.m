//
//  TWOrderCell.m
//  ticketWaiter
//
//  Created by LY on 17/1/16.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWOrderCell.h"
#import "TWOrderModel.h"

@interface TWOrderCell ()
{
    BOOL  _isAuto;
}
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *labless;
@property (weak, nonatomic) IBOutlet UILabel *moneyLable;

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleViewHeight;






@end

@implementation TWOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (!_isAuto) {
        _isAuto = 1;
        
        NSArray *arr = @[_l1,_l2,_l3,_t1,_t2,_w1,_w2,_w3,_middleViewHeight,_phoneNum,_nickName,_orderNumber,_timeLable,_labless,_moneyLable];
        
        for (int i=0; i<arr.count; i++) {
            
            if (i<9) {
                
                ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);
                
                
            }else{
                
                ((UILabel *)arr[i]).font = NormalFont(((UILabel *)arr[i]).font.pointSize);

            }
            
        }

    }

}


-(void)setModel:(TWOrderModel *)model{

    _model = model;
    
    _phoneNum.text = model.userphone;
    _nickName.text = model.username.length >0 ?model.username : @"";
    _orderNumber.text = [NSString stringWithFormat:@"订单号:%@",model.orderno];
    _timeLable.text = [self caculateTime:model.ordertime];
    _moneyLable.text = [NSString stringWithFormat:@"%.2f元",model.amount/100.0];
    
    _w1.constant = [_moneyLable.text widthForFont:NormalFont(14)]+5;
    
    
}


-(NSString *)caculateTime:(NSString *)timeStr
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStr floatValue]/1000.0];
    
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    
    return [dateFormatter stringFromDate:date];
}





@end
