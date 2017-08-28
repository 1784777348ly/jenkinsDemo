//
//  TWMyAccountCell.m
//  ticketWaiter
//
//  Created by LY on 16/12/29.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "TWMyAccountCell.h"
#import "TWMineModel.h"

@interface TWMyAccountCell ()
{
    BOOL  _isA;

}

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;


@property (weak, nonatomic) IBOutlet UIView *bottomView;


//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t2;




@end


@implementation TWMyAccountCell

- (void)awakeFromNib {
    // Initialization code
    if (!_isA) {
        _isA= 1;
        NSArray *arr = @[_l2,_l1,_t1,_t2,_title,_detail,_subTitle];
        
        for (int i=0; i<arr.count; i++) {
            
            if (i>=4) {
                
                ((UILabel *)arr[i]).font = NormalFont(((UILabel *)arr[i]).font.pointSize);
                
            }else{
                
                ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);
            }
        }

    }
    
    
}

-(void)setModel:(TWMineModel *)model
{
    _model = model;
    
    _title.text = model.title;
    _detail.text = model.details;
    
    if (model.subTitle.length == 0) {
        
        _subTitle.hidden = YES;
        
        _t2.constant = 0;
        
        
    }else{
        
        _t2.constant = FitValue(-10);
         _subTitle.hidden = NO;
        _subTitle.text = [NSString stringWithFormat:@"到期时间 %@",[self caculateTime:model.subTitle]];
    
    }
    _bottomView.hidden = !model.hideBottomLine;
    


}

-(NSString *)caculateTime:(NSString *)timeStr
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]/1000.0];
    
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    
    return [dateFormatter stringFromDate:date];
}






@end
