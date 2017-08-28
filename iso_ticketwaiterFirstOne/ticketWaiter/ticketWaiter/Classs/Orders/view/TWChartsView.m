//
//  TWChartsView.m
//  ticketWaiter
//
//  Created by LY on 17/1/17.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWChartsView.h"
#import "JHColumnChart.h"


#define k_MainBoundsWidth [UIScreen mainScreen].bounds.size.width
#define k_MainBoundsHeight [UIScreen mainScreen].bounds.size.height

@interface TWChartsView ()
{

    BOOL  _isAuto;
    
    BOOL  _isCreate;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIView *selView;

@property (weak, nonatomic) IBOutlet UIButton *dayBtn;
@property (weak, nonatomic) IBOutlet UIButton *monthBtn;

@property (weak, nonatomic) IBOutlet UIView *yColumView;
@property (weak, nonatomic) IBOutlet UIView *chartsView;

@property (weak, nonatomic) IBOutlet UILabel *monthlable;



//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l3;


@property(nonatomic)JHColumnChart *column;

@property(nonatomic,assign)CGRect  rect;


@end

@implementation TWChartsView

-(void)awakeFromNib
{
    [super awakeFromNib];
    if (!_isAuto) {
        
        _isAuto = 1;
        
        NSArray *arr = @[_t1,_t2,_l3,_l1,_l2,_w1,_w2,_h1,_titleLable,_dayBtn,_monthBtn];
        
        for (int i=0; i<arr.count; i++) {
            
            if (i<8) {
                
                ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);
                
            }else if(i==8){
                
                ((UILabel *)arr[i]).font = NormalFont(((UILabel *)arr[i]).font.pointSize);
                
            }else{
            
                ((UIButton *)arr[i]).titleLabel.font = NormalFont(((UIButton *)arr[i]).titleLabel.font.pointSize);
            }
            
        }
        
        _selView.layer.cornerRadius = FitValue(12);
        _selView.layer.borderColor = HexRGB(0xcccccc).CGColor;
        _selView.layer.borderWidth = 0.5;
        
        _dayBtn.selected = 1;

    }

}

+(instancetype)ChartsViewWithRect:(CGRect)rect
{
    TWChartsView *chartView = [[[NSBundle mainBundle] loadNibNamed:@"TWChartsView" owner:self options:0] lastObject];

    chartView.rect = rect;


    return chartView;

}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = self.rect;
    
    if (!_isCreate) {
        _isCreate = 1;
        [self setUpCharts];
    }
    
    

    

}


-(void)refreshViewWithDatas:(NSDictionary *)dic
{


}


-(void)setUpCharts
{
    
    CGRect rects = self.chartsView.bounds;
    
    JHColumnChart *column = [[JHColumnChart alloc] initWithFrame:CGRectMake(0, 0, rects.size.width, rects.size.height)];
    
    NSLog(@"<<<<<<<<<<<<<<<<<<<<%@",NSStringFromCGRect(rects));
    
    self.column = column;
    self.column.originSize = CGPointMake(0, FitValue(55));
    /*    The first column of the distance from the starting point     */
   // self.column.drawFromOriginX = 0;
    self.column.typeSpace = FitValue(15);
    self.column.isShowYLine = NO;
    /*        Column width         */
    self.column.columnWidth = FitValue(15);
    /*        Column backgroundColor         */
    self.column.bgVewBackgoundColor = [UIColor clearColor];
    /*        X, Y axis font color         */
    self.column.drawTextColorForX_Y = HexRGB(0x282828);
    /*        X, Y axis line color         */
    self.column.colorForXYLine = HexRGB(0x282828);
    
    self.column.xDescTextFontSize = 10;
    
    self.column.yDescTextFontSize = 10;
    
    [self.chartsView addSubview:column];

}


-(void)setChartsValue:(NSArray *)valueArr andxShowInfoTextArr:(NSArray *)xArr
{

    if (valueArr.count<10) {
     
        self.column.typeSpace = FitValue(15*10.0/valueArr.count);
        self.column.columnWidth = FitValue(15*10.0/valueArr.count);
    }else{
    
        self.column.typeSpace = FitValue(15);
        self.column.columnWidth = FitValue(15);
        
    }

    
    self.column.valueArr = valueArr ;
    
    self.column.xShowInfoText = xArr;

    self.column.columnBGcolorsArr = @[[UIColor colorWithRed:72/256.0 green:200.0/256 blue:255.0/256 alpha:1],[UIColor greenColor],[UIColor orangeColor],[UIColor orangeColor],[UIColor orangeColor],[UIColor orangeColor],[UIColor orangeColor],[UIColor orangeColor],[UIColor orangeColor],[UIColor orangeColor],[UIColor orangeColor],[UIColor orangeColor],[UIColor orangeColor]];
    
    [self.column showAnimation];
    
    [self.yColumView.layer removeAllSublayers];
    
    [self.column setYColumnNumbers:self.yColumView andWidth:_w2.constant];


}

#pragma mark - 点击事件

- (IBAction)dayClick:(UIButton *)sender {
    
    
    if (sender.selected == 1) {
        
        
    }else{
    
        sender.selected = 1;
        _monthBtn.selected = 0;
        
//        _monthlable.text = @"12月";
//        _titleLable.text = @"最近一个月的订单额";
        
        if (_chartBlock) {
            
            _chartBlock(1);
        }
        
    }
    
    
 
    
}

- (IBAction)monthClick:(UIButton *)sender {
    
    if (sender.selected == 1) {
        
    }else{
    
        sender.selected = 1;
        _dayBtn.selected = 0;
        
//        _monthlable.text = @"2016年";
//         _titleLable.text = @"一年的订单额";
        
        if (_chartBlock) {
            
            _chartBlock(2);
        }
    }

    
}

-(void)setupLbaleWithStr:(NSString *)upStr andBottomLable:(NSString *)bottomStr
{
    
    if (upStr.length == 0) {
        
         _titleLable.text = @"";
        
    }else{
         _titleLable.text = upStr;
    }

    
    if (bottomStr.length == 0) {
        
        _monthlable.text = @"";
        
    }else{
        
        _monthlable.text = bottomStr;
    }
   
    
}











@end
