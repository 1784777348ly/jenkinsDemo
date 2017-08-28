//
//  TWOrderMoneyCell.m
//  ticketWaiter
//
//  Created by LY on 17/1/17.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWOrderMoneyCell.h"

@interface TWOrderMoneyCell ()
{
    BOOL _isAuto;

}

@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *moneyLable;

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l2;



@end


@implementation TWOrderMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (!_isAuto) {
        _isAuto = 1;
        
        _l1.constant = FitValue(_l1.constant);
        _l2.constant = FitValue(_l2.constant);
        _timeLable.font = NormalFont(_timeLable.font.pointSize);
        _moneyLable.font = NormalFont(_moneyLable.font.pointSize);
        
    }

}

-(void)customedWithDic:(NSDictionary *)dic andListType:(NSString *)ListType
{

    _timeLable.text = [self caculateTime:[dic[@"orderdate"] description] andListType:ListType ];

    _moneyLable.text = [NSString stringWithFormat:@"%.2f",[dic[@"amount"]  integerValue]/100.0];

}

-(NSString *)caculateTime:(NSString *)timeStr andListType:(NSString *)ListType
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStr floatValue]/1000.0];
    
    [dateFormatter setTimeZone:timeZone];
    
    if ([ListType integerValue] == 1) {
        //日表
        [dateFormatter setDateFormat:@"MM月dd日"];
    }else{
    
        [dateFormatter setDateFormat:@"yyyy年MM月"];
    }
    
    //[dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    return [dateFormatter stringFromDate:date];
}




@end
