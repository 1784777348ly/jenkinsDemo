//
//  TWOrderViewController.m
//  ticketWaiter
//
//  Created by LY on 17/1/16.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWOrderViewController.h"
#import "TWOrderCell.h"
#import "TWOrderMoneyCell.h"
#import "TWOrderModel.h"
#import "TwOrderViewModel.h"

#import "TWWiFiView.h"
#import "TWOrderUpView.h"
#import "TWChartsView.h"
#import "HGSaveNoticeTool.h"
#import "HGPlaceholderView.h"
#import "HSRefreshHeader.h"
#import "HSRefreshFooter.h"

#import "NSDate+Methods.h"


@interface TWOrderViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *lineView;


@property (weak, nonatomic) IBOutlet UIButton *ltitle;

@property (weak, nonatomic) IBOutlet UIButton *mtitle;

@property (weak, nonatomic) IBOutlet UIButton *rtitle;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollerView;
@property (weak, nonatomic) IBOutlet UIView *conView;

@property (weak, nonatomic) IBOutlet UIView *wifiBackView;


@property (weak, nonatomic) IBOutlet UILabel *orderLable;

@property (weak, nonatomic) IBOutlet UIButton *upLoadBtn;

//图表视图
@property (weak, nonatomic) IBOutlet UIView *chartsBackView;


//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t1;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;
@property (weak, nonatomic) IBOutlet UIView *bottomHidView;


@property(nonatomic)TWWiFiView *wifiView;
@property(nonatomic)TWOrderUpView  *orderUpView;

@property(nonatomic,assign)NSIndexPath  *selIndexpath;

@property(nonatomic)TWChartsView *viewss;
@property(nonatomic)UILabel *allMoneyLable;

@property(nonatomic,assign)NSInteger allTouFangNumber;
@property(nonatomic,assign)NSInteger tmpAllTouFangNumber;
@property(nonatomic,assign)NSInteger successNumber;

@property(nonatomic)NSMutableDictionary *successNumDic;


@property(nonatomic)NSMutableArray  *serialNumbers;

@property(nonatomic,assign)NSInteger  chartType;

@property(nonatomic)NSTimer  *timer;



@end

@implementation TWOrderViewController

-(void)viewWillDisappear:(BOOL)animated
{
    
    [self.wifiView stopTimer];
    [super viewWillDisappear:animated];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationBar];
    
    //适配
    [self shiPei];

    [self.leftView registerNib:[UINib nibWithNibName:@"TWOrderCell" bundle:nil] forCellReuseIdentifier:@"TWOrderCell"];
    [self.rightView registerNib:[UINib nibWithNibName:@"TWOrderMoneyCell" bundle:nil] forCellReuseIdentifier:@"TWOrderMoneyCell"];
    [self.middleView registerNib:[UINib nibWithNibName:@"TWOrderCell" bundle:nil] forCellReuseIdentifier:@"TWOrderCell"];
    
    //添加下拉刷新   上拉加载 还有占位图
    [self addRefreshHeadAndFooter];

    [self obtainDataFromFirstPage];
    
    //添加小人
    if (!self.orderUpView) {
        //订单
        TWOrderUpView *vvv = [TWOrderUpView OrderUpView:CGRectMake(FitValue(270), FitValue(450), FitValue(72), FitValue(102)) ];
        self.orderUpView = vvv;
        self.orderUpView.hidden = YES;
        [self.view addSubview:self.orderUpView];
    }
    
    
    
    TWChartsView *viewss = [TWChartsView ChartsViewWithRect:CGRectMake(0, 0, SCREEN_WIDTH,_t1.constant)];
    
    _chartType = 1;
    
    self.viewss = viewss;
    
    __weak  typeof(self) weakSelf = self;
    
    viewss.chartBlock = ^(NSInteger type){
    
        TwOrderViewModel *model = [[TwOrderViewModel alloc] init];

        if (type == 1) {
            
            weakSelf.chartType = 1;
             [model obtainOrderMoneyWithTableView:weakSelf.rightView andDataArr:weakSelf.dataArrR andViewType:3 andListType:1 andAllMoneyOrderDic:weakSelf.allOrderMoneyDic andChartsDic:weakSelf.allOrderAndMoneyChartsDic andFreshType:1];

        }else{
            weakSelf.chartType = 2;
              [model obtainOrderMoneyWithTableView:weakSelf.rightView andDataArr:weakSelf.dataArrR andViewType:3 andListType:2 andAllMoneyOrderDic:weakSelf.allOrderMoneyDic andChartsDic:weakSelf.allOrderAndMoneyChartsDic andFreshType:1];
        }
        
        [self refreshChartsWithModel:model andType:type];
    
    };
    
    
   // [self chartInitViewOfDateType:1];
    
    [self.chartsBackView addSubview:viewss];
    
    
    
}


#pragma mark - 添加 上拉 下拉  占位图
-(void)addRefreshHeadAndFooter
{

    TwOrderViewModel *model = [[TwOrderViewModel alloc] init];
     __weak typeof(self)  weakSelf = self;
   
    //左边的未投订单
    //设置占位视图
    self.holderViewL = [HGPlaceholderView placehoderViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-FitValue(105))];
    self.holderViewL.placeholderBtn.hidden = YES;
    [self.leftView addSubview:_holderViewL];
    self.holderViewL.hidden = YES;
    _holderViewL.block = ^(){
        weakSelf.holderViewL.hidden = YES;
        [model obtainDataWithTableView:weakSelf.leftView andDataArr:weakSelf.dataArrL andViewType:1 andRefreshType:1 andVC:weakSelf];
    };

    HSRefreshFooter *footer = [HSRefreshFooter footerWithRefreshingBlock:^{
        
        
        [model obtainDataWithTableView:weakSelf.leftView andDataArr:weakSelf.dataArrL andViewType:1 andRefreshType:3  andVC:weakSelf];
    }];
    
    self.leftView.mj_footer = footer;
    
    HSRefreshHeader *header = [HSRefreshHeader headerWithRefreshingBlock:^{
        
        weakSelf.holderViewL.hidden = YES;
        [model obtainDataWithTableView:weakSelf.leftView andDataArr:weakSelf.dataArrL andViewType:1 andRefreshType:2  andVC:weakSelf];
        
    }];
    
    self.leftView.mj_header = header;
    
    
    //中间的已投订单
    //设置占位视图
    self.holderViewM = [HGPlaceholderView placehoderViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.middleView addSubview:_holderViewM];
    self.holderViewM.hidden = YES;
    weakSelf.middleView.bounces = YES;
    _holderViewM.block = ^(){
        weakSelf.holderViewM.hidden = YES;
        weakSelf.middleView.bounces = YES;
        [model obtainDataWithTableView:weakSelf.middleView andDataArr:weakSelf.dataArrM andViewType:2 andRefreshType:1  andVC:weakSelf];
    };
    
    HSRefreshFooter *footerM = [HSRefreshFooter footerWithRefreshingBlock:^{
        
        [model obtainDataWithTableView:weakSelf.middleView andDataArr:weakSelf.dataArrM andViewType:2 andRefreshType:3  andVC:weakSelf];
    }];
    
    self.middleView.mj_footer = footerM;
    
    HSRefreshHeader *headerM = [HSRefreshHeader headerWithRefreshingBlock:^{
        
        [model obtainDataWithTableView:weakSelf.middleView andDataArr:weakSelf.dataArrM andViewType:2 andRefreshType:2  andVC:weakSelf];
        
    }];
    
    self.middleView.mj_header = headerM;
    
    //订单按月 按
    //右侧能上拉加载
    HSRefreshFooter *footerR = [HSRefreshFooter footerWithRefreshingBlock:^{
        
        [model obtainOrderMoneyWithTableView:weakSelf.rightView andDataArr:weakSelf.dataArrR andViewType:3 andListType:weakSelf.chartType andAllMoneyOrderDic:weakSelf.allOrderMoneyDic andChartsDic:weakSelf.allOrderAndMoneyChartsDic andFreshType:3];
        
    }];
    
    self.rightView.mj_footer = footerR;

    [self refreshChartsWithModel:model andType:1];


}






//传数据 刷新界面
-(void)obtainDataFromFirstPage
{
    
    
    __weak typeof(self) weakSelf = self;
    
    TwOrderViewModel *model = [[TwOrderViewModel alloc] init];
    model.block = ^(){
        
        //刷新  动画效果
        weakSelf.orderLable.text = [NSString stringWithFormat:@"共%zd个订单",weakSelf.dataArrL.count];
        [weakSelf.orderUpView refreshOrderWithNum1:weakSelf.dataArrM.count andNum2:weakSelf.dataArrL.count+weakSelf.dataArrM.count];

    };
    
    [self refreshChartsWithModel:model andType:1];
    
    [model obtainDataWithTableView:self.leftView andDataArr:self.dataArrL andViewType:1 andRefreshType:1  andVC:self];

    [model obtainDataWithTableView:self.middleView andDataArr:self.dataArrM andViewType:2 andRefreshType:1  andVC:self];
    
    [model obtainOrderMoneyWithTableView:self.rightView andDataArr:self.dataArrR andViewType:3 andListType:1 andAllMoneyOrderDic:self.allOrderMoneyDic andChartsDic:self.allOrderAndMoneyChartsDic andFreshType:1];

    
}

-(void)refreshChartsWithModel:(TwOrderViewModel *)model andType:(NSInteger)viewTyped
{
    __weak typeof(self) weakSelf = self;


    model.chartsBlock = ^(){

        NSInteger  viewType = viewTyped;
        
        if ([[weakSelf.allOrderAndMoneyChartsDic objectForKey:@"type"] description].length > 0) {
            
            viewType = [[weakSelf.allOrderAndMoneyChartsDic objectForKey:@"type"] integerValue];
        }
        
        // 画图表
        NSArray *arr = [weakSelf.allOrderAndMoneyChartsDic objectForKey:@"items"];
        
        NSMutableArray *valueArr = [[NSMutableArray alloc] init];
        
        NSMutableArray *dateArr = [[NSMutableArray alloc] init];
        
        if(viewType == 1){
        //天
            for (int i=0; i<arr.count; i++) {
                
                NSDictionary *dic = arr[i];
                
                [dateArr addObject:[self caculateTime:[dic[@"orderdate"] description]]];
                [valueArr addObject:@[[NSNumber numberWithInteger:[dic[@"amount"] integerValue]/100]]];
            }
            
            //设置标题
           NSString *bottomStr = [NSString stringWithFormat:@"%@月",[self caculateMonthTime:[[[arr lastObject] objectForKey:@"orderdate"] description]]];
            
            NSString *topStr = [NSString stringWithFormat:@"最近%zd天",arr.count];
            
            [weakSelf.viewss setupLbaleWithStr:topStr andBottomLable:bottomStr];

        }else{
        //月
            for (int i=0; i<arr.count; i++) {
                
                NSDictionary *dic = arr[i];
                
                [dateArr addObject:[self caculateMonthTime:[dic[@"orderdate"] description]]];
                [valueArr addObject:@[[NSNumber numberWithInteger:[dic[@"amount"] integerValue]/100]]];
            }
            
            //设置标题
            NSString *bottomStr = [NSString stringWithFormat:@"%@年",[self caculateYear:[[[arr lastObject] objectForKey:@"orderdate"] description]]];
            
            NSString *topStr = [NSString stringWithFormat:@"最近%zd个月",arr.count];
            
            [weakSelf.viewss setupLbaleWithStr:topStr andBottomLable:bottomStr];
        
        }
        
        
        
        [weakSelf.viewss setChartsValue:valueArr andxShowInfoTextArr:dateArr];

        
    };


}


#pragma mark - 初始化 图表
-(void)chartInitViewOfDateType:(NSInteger)dateType
{
    NSInteger  num = 10;
    
    //值
    NSMutableArray *valueArr = [[NSMutableArray alloc] init];
    //日期
    NSMutableArray *dateArr = [[NSMutableArray alloc] init];
    
    if (dateType == 1) {
        // 天
        NSDate *dates = [NSDate date];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
        NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
        [dateFormatter setTimeZone:timeZone];
        [dateFormatter setDateFormat:@"MM月"];
        [self.viewss setupLbaleWithStr:[NSString stringWithFormat:@"最近%zd天",num] andBottomLable:[self  caculateMonthTime:[dateFormatter stringFromDate:dates]]];
        
        for (int i=0; i<num; i++) {
            [dateArr addObject:[self caculateTime:dates  andlastDays:num - i - 1]];;
            [valueArr addObject:@[[NSNumber numberWithInteger:0]]];
        }
        
    }else{
        //  月
        NSDate *dates = [NSDate date];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
        NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
        [dateFormatter setTimeZone:timeZone];
        [dateFormatter setDateFormat:@"yyyy年"];
        [self.viewss setupLbaleWithStr:[NSString stringWithFormat:@"最近%zd个月",num] andBottomLable:[self  caculateMonthTime:[dateFormatter stringFromDate:dates]]];
        
        for (int i=0; i<num; i++) {
            [dateArr addObject:[self caculateTime:dates  andlastMonth:num - i - 1]];;
            [valueArr addObject:@[[NSNumber numberWithInteger:0]]];
        }
        
    }
    
    [self.viewss setChartsValue:valueArr andxShowInfoTextArr:dateArr];



}







#pragma mark - 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger  num=0;
    
    switch (tableView.tag) {
        case 21:
        {
            num = self.dataArrL.count;
            break;
        }
        case 22:
        {
            num = self.dataArrM.count;
            break;
        }
        case 23:
        {
            
            if (self.allOrderMoneyDic.count >0) {
                
                if ([self.allOrderMoneyDic[@"items"] isEqual:[NSNull null]]) {
                    
                    num = 0;
                    
                }else{
                
                    num = [self.allOrderMoneyDic[@"items"] count];
                }
                
            }else{
            
                    num = 0;
            
            }

            break;
        }
        default:{
            break;
        }
    }
    
    return num;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 23) {
        
        return FitValue(58);
        
    }

    
    
    return 0.01;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.01;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (tableView.tag == 23) {

        
        UIView *view =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FitValue(58))];
        view.backgroundColor = MainBackgroundColor;
        
        UIView *viewx =  [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, FitValue(48))];
        viewx.backgroundColor = WHITECOLOR;
        [view addSubview:viewx];
        
        UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectZero];
        lable1.text = @"详细订单额(元)";
        lable1.font = NormalFont(14);
        lable1.textColor = HexRGB(0x282828);
        [viewx addSubview:lable1];
        [lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(viewx.mas_left).offset(FitValue(30));
            make.centerY.equalTo(viewx.mas_centerY);
            
        }];
        
        
        UILabel *allMoneyLable = [[UILabel alloc] initWithFrame:CGRectZero];
        
        self.allMoneyLable = allMoneyLable;
        
        
        if (self.allOrderMoneyDic.count >0) {
            
            if ([self.allOrderMoneyDic[@"items"] isEqual:[NSNull null]]) {
                
            }else{
                
                allMoneyLable.text = [NSString stringWithFormat:@"订单总额: %.2f",[[self.allOrderMoneyDic objectForKey:@"total"] integerValue]/100.0];

            }
            
        }else{
            
            
        }

        allMoneyLable.font = NormalFont(14);
        allMoneyLable.textColor = HexRGB(0x282828);
        [viewx addSubview:allMoneyLable];
        [allMoneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(viewx.mas_right).offset(-FitValue(30));
            make.centerY.equalTo(viewx.mas_centerY);
            
        }];

        
        UIView *viewss = [[UIView alloc] init];
        
        viewss.backgroundColor = HexRGB(0xcccccc);
        [viewx addSubview:viewss];
        
        [viewss mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.equalTo(viewx);
            make.height.mas_equalTo(1);
        }];
        
        
        return view;
        
        
    }
    
    
    return nil;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == 23) {
        
        return FitValue(36);
    }
    
    return FitValue(81);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView.tag == 21) {
        
        TWOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWOrderCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.model = self.dataArrL[indexPath.row];
        
        return cell;
    }else if (tableView.tag == 22) {
        
        TWOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWOrderCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.model = self.dataArrM[indexPath.row];
        
        return cell;
    }else{
        //TWOrderMoneyCell
        
        TWOrderMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWOrderMoneyCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell customedWithDic:[[self.allOrderMoneyDic objectForKey:@"items"] objectAtIndex:indexPath.row] andListType:[self.allOrderMoneyDic objectForKey:@"type"]];

        return cell;
    }
    
}

#pragma mark - scroller的代理方法

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (![scrollView isEqual:self.myScrollerView]){
    
        return;
    }
    
    NSInteger page =ceil(scrollView.contentOffset.x/SCREEN_WIDTH);
    
    NSLog(@"%zd",page);
    
    
    if (page == 0) {
        self.ltitle.selected = 1;
        self.ltitle.titleLabel.font  = BoldFontWithNoScale(self.ltitle.titleLabel.font.pointSize);
        self.mtitle.selected = 0;
        self.mtitle.titleLabel.font  = NormalFontWithNoScale(self.mtitle.titleLabel.font.pointSize);
        self.rtitle.selected = 0;
        self.rtitle.titleLabel.font  = NormalFontWithNoScale(self.rtitle.titleLabel.font.pointSize);
    }else if (page == 1) {
        self.ltitle.selected = 0;
        self.ltitle.titleLabel.font  = NormalFontWithNoScale(self.ltitle.titleLabel.font.pointSize);
        
        self.mtitle.selected = 1;
        self.mtitle.titleLabel.font  = BoldFontWithNoScale(self.mtitle.titleLabel.font.pointSize);
        
        self.rtitle.selected = 0;
        self.rtitle.titleLabel.font  = NormalFontWithNoScale(self.rtitle.titleLabel.font.pointSize);
        
    }else{
        self.ltitle.selected = 0;
        self.ltitle.titleLabel.font  = NormalFontWithNoScale(self.ltitle.titleLabel.font.pointSize);
        
        self.mtitle.selected = 0;
        self.mtitle.titleLabel.font  = NormalFontWithNoScale(self.mtitle.titleLabel.font.pointSize);
        
        self.rtitle.selected = 1;
        self.rtitle.titleLabel.font  = BoldFontWithNoScale(self.rtitle.titleLabel.font.pointSize);
        
    }
    
    
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if ([scrollView isEqual:self.myScrollerView]) {
        
        
        CGFloat widths = CGRectGetMinX(self.rtitle.superview.frame) - CGRectGetMinX(self.ltitle.superview.frame);
        
        
        CGRect rect = self.bottomView.frame;
        
        rect.origin.x = self.ltitle.superview.frame.origin.x + scrollView.contentOffset.x/(SCREEN_WIDTH*2)*widths;
        
        [self.bottomView setFrame:rect];
        
    }

    
}





#pragma mark - 点击事件
//点击切换view
- (IBAction)switchViewClick:(UIButton *)sender {
    //tag  11 12 13
    
    [self.myScrollerView setContentOffset:CGPointMake((sender.tag-11)*SCREEN_WIDTH, 0) animated:YES];
    
    //    CGRect rect = self.bottomView.frame;
    //
    //    UIView *view = sender.superview;
    //
    //
    //    NSLog(@"%@",NSStringFromCGRect(view.frame));
    //
    //    rect.origin.x = view.frame.origin.x;
    //
    //    [self.bottomView setFrame:rect];
    
    //字变化
    sender.selected = YES;
    sender.titleLabel.font  = BoldFontWithNoScale(sender.titleLabel.font.pointSize);
    
    if (sender.tag == 11) {
        self.mtitle.selected = 0;
        self.mtitle.titleLabel.font  = NormalFontWithNoScale(self.mtitle.titleLabel.font.pointSize);
        
        self.rtitle.selected = 0;
        self.rtitle.titleLabel.font  = NormalFontWithNoScale(self.rtitle.titleLabel.font.pointSize);
        
    }else if (sender.tag == 12) {
        self.ltitle.selected = 0;
        self.ltitle.titleLabel.font  = NormalFontWithNoScale(self.ltitle.titleLabel.font.pointSize);
        self.rtitle.selected = 0;
        self.rtitle.titleLabel.font  = NormalFontWithNoScale(self.rtitle.titleLabel.font.pointSize);
    }else{
        self.ltitle.selected = 0;
        self.ltitle.titleLabel.font  = NormalFontWithNoScale(self.ltitle.titleLabel.font.pointSize);
        self.mtitle.selected = 0;
        self.mtitle.titleLabel.font  = NormalFontWithNoScale(self.mtitle.titleLabel.font.pointSize);
    }
    
    
    
}


#pragma mark - 确定投放
- (IBAction)uploadClick:(UIButton *)sender {
    
    sender.userInteractionEnabled  = 0;
    [self performSelector:@selector(delayClick:) withObject:sender afterDelay:5];

    if (!self.wifiView.isOk) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"您未在购彩区域内" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if (!self.wifiView.isHaveMac) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"请在连接Wifi的情况下使用App" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
        
    }

    TwOrderViewModel *viewModel = [[TwOrderViewModel alloc] init];
    
    [viewModel besureToTouFangWithReturnBlock:^(id result) {
        
        NSDictionary *dic = (NSDictionary *)result;
        
        if ([dic[@"success"] integerValue] == 1) {
            
            [SVProgressHUD dismiss];

            //获得订单号码
            NSString *serilNumber = [dic[@"result"] objectForKey:@"serialnumber"];
            
            if (serilNumber.length>0) {
                [self.serialNumbers addObject:serilNumber];
            }

            //清空界面订单
            _holderViewL.hidden = NO;
            [_holderViewL setPlaceHolderViewWithType:2];
            [_holderViewL setOrderSTitle:@"订单投放中...."];
            _orderLable.text = [NSString stringWithFormat:@"共%@个订单",@"0"];

            //self.orderUpView.hidden = 0;
            
           // [self.orderUpView refreshOrderWithNum1:_successNumber andNum2:_allTouFangNumber];

        
            [self findTouFangShu];
            
            self.timer.fireDate = [NSDate distantPast];
            
//            
//            if (![self.successNumDic objectForKey:serilNumber]) {
//                [self.successNumDic setObject:@(0) forKey:serilNumber];
//            }

        }else{
            
            
            
        
            [SVProgressHUD showErrorWithStatus:dic[@"em"]];

        }
        
        
    }];
    
    
}

#pragma mark - 轮询查询投放成功数
-(void)findTouFangShu
{
    
    TwOrderViewModel *viewModel = [[TwOrderViewModel alloc] init];
    //轮询 查询投注结果
    
    NSString *str = nil;
    
    if (self.serialNumbers.count>1) {
        
        str = [self.serialNumbers componentsJoinedByString:@","];
    }else{
    
        str = self.serialNumbers[0];
    }
    
    
    [viewModel searchTouFangResultsWithSerialNumber:str withReturnBlock:^(id result) {
        
        NSDictionary *dic = (NSDictionary *)result;

        //展示小人
        self.orderUpView.hidden = 0;

        NSLog(@"订单结果++++++++++++++++++++++%@",dic);
        
        if ([dic[@"success"] integerValue] == 1) {
            
            NSDictionary *results = dic[@"result"];
            
            [SVProgressHUD dismiss];
            
            //显示

            if ([results[@"total"] integerValue] ==  [results[@"failsize"] integerValue] +[results[@"successsize"] integerValue]) {
                
                self.timer.fireDate = [NSDate distantFuture];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"投递%zd笔,成功%zd笔，失败%zd笔",[results[@"total"] integerValue],[results[@"successsize"] integerValue],[results[@"failsize"] integerValue]] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                [alertView show];
                [self performSelector:@selector(dimissAlert:) withObject:alertView afterDelay:2.0];
                
                //去掉 动画 刷新界面
                [self.orderUpView setHidden:1];
                [self.dataArrL removeAllObjects];
                _holderViewL.hidden = YES;
                
                [self.serialNumbers removeAllObjects];


                TwOrderViewModel *model = [[TwOrderViewModel alloc] init];
                [model obtainDataWithTableView:self.leftView andDataArr:self.dataArrL andViewType:1 andRefreshType:2  andVC:self];
                [model obtainDataWithTableView:self.middleView andDataArr:self.dataArrM andViewType:2 andRefreshType:2  andVC:self];
                
                
            }else{
                
                [self.orderUpView refreshOrderWithNum1:[results[@"successsize"] integerValue] andNum2:[results[@"total"] integerValue]];
                //获得订单号码
                [self findTouFangShu];

            }

        }else{
            
            //查询接口异常
            [SVProgressHUD showErrorWithStatus:dic[@"em"]];
            
            //去掉 动画 刷新界面
            [self.orderUpView setHidden:1];
            
            TwOrderViewModel *model = [[TwOrderViewModel alloc] init];
            [model obtainDataWithTableView:self.leftView andDataArr:self.dataArrL andViewType:1 andRefreshType:2  andVC:self];
            [model obtainDataWithTableView:self.middleView andDataArr:self.dataArrM andViewType:2 andRefreshType:2  andVC:self];
            
            
        }

        
        
    }];

}




#pragma mark - 刷新订单数额
-(void)refreshOrderNumberWithNum:(NSString *)orderNum
{
    _orderLable.text = [NSString stringWithFormat:@"共%@个订单",orderNum];
   // _tmpAllTouFangNumber = [orderNum integerValue];
}


#pragma mark - 轮循查询
-(void)fireCheck
{
    TwOrderViewModel *viewModel = [[TwOrderViewModel alloc] init];
    
    [viewModel findIWTOrderWithSerialNumber:[self.serialNumbers componentsJoinedByString:@","]];

}





#pragma mark - 延迟点击
-(void)delayClick:(UIButton *)btn
{
    btn.userInteractionEnabled = 1;

}




#pragma mark - 适配
-(void)shiPei
{
    NSArray *arr = @[_viewH,_viewW,_h1,_w1,_h2,_w2,_t1,_bottomHeight,_ltitle,_mtitle,_rtitle,_upLoadBtn,_orderLable];
    
    for (int i=0; i<arr.count; i++) {
        
        if (i<8) {
            
            ((NSLayoutConstraint *)arr[i]).constant = FitValue(((NSLayoutConstraint *)arr[i]).constant);
            
        }else{
            
            if (i==8) {
                
                _ltitle.titleLabel.font  = BoldFont(_ltitle.titleLabel.font.pointSize);
                
            }else{
                
                if (i<=11) {
                    
                     ((UIButton *)arr[i]).titleLabel.font = NormalFont(((UIButton *)arr[i]).titleLabel.font.pointSize);
                }else{
                    
                     ((UILabel *)arr[i]).font = NormalFont(((UILabel *)arr[i]).font.pointSize);
                
                }

            }
            
            
        }
        
    }
    
    
    
    //    _mtitle.titleLabel.font  = NormalFont(_mtitle.titleLabel.font.pointSize);
    //
    //    _rtitle.titleLabel.font  = NormalFont(_rtitle.titleLabel.font.pointSize);
    
    self.ltitle.selected = 1;
    
    _upLoadBtn.layer.cornerRadius = FitValue(4);
    _upLoadBtn.layer.masksToBounds = YES;
    
    [_upLoadBtn setTitleColor:COLOR(255, 255, 255, 0.5) forState:UIControlStateHighlighted];
    
    
    
    //加阴影
    //    self.lineView.layer.shadowColor = [UIColor blackColor].CGColor;
    //    self.lineView.layer.shadowOpacity = 0.8f;
    //    self.lineView.layer.shadowRadius = 4.f;
    //    self.lineView.layer.shadowOffset = CGSizeMake(1,0);
    
    
    //加圆角
    //    _submit1.layer.cornerRadius = _h1.constant/2.0;
    //    _submit2.layer.cornerRadius = _h1.constant/2.0;
    //    _submit3.layer.cornerRadius = _h1.constant/2.0;
    
    
}


#pragma mark - 设置导航栏
- (void)setNavigationBar{
    
    self.fd_prefersNavigationBarHidden = YES;
    
    //wifi视图
    self.wifiView = [TWWiFiView wifiView];
    
    self.wifiView.frame = CGRectMake(0, 0, FitValue(22.5), FitValue(16));
    
    [self.wifiBackView addSubview:self.wifiView];
    
    [self.wifiView addTimer];
 
}


#pragma mark - 隐藏左侧底部view
-(void)hidBottomView
{
//    _bottomHeight.constant = 45;
//    _h2.constant = 0;
    _bottomHidView.hidden = 0;
    self.leftView.bounces = 0;
    
   

}


#pragma mark - 显示左侧底部view
-(void)showBottomView
{
//    _bottomHeight.constant = FitValue(105);
//    _h2.constant = FitValue(45);
    _bottomHidView.hidden = 1;
    self.leftView.bounces = 1;


    
}


#pragma mark  - 返回
- (IBAction)backClick:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -  点击到我的奖励



-(NSString *)caculateTime:(NSString *)timeStr
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStr floatValue]/1000.0];
    
    [dateFormatter setTimeZone:timeZone];
    //[dateFormatter setDateFormat:@"MM-dd"];
    [dateFormatter setDateFormat:@"dd"];
    
    return [dateFormatter stringFromDate:date];
}

-(NSString *)caculateTime:(NSDate *)date andlastDays:(NSInteger)dates
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    
   // NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStr integerValue]/1000.0];
    
    NSDate *datex =  [date dateByMinusDays:dates];
    
    
    [dateFormatter setTimeZone:timeZone];
    //[dateFormatter setDateFormat:@"MM-dd"];
    [dateFormatter setDateFormat:@"dd"];
    
    return [dateFormatter stringFromDate:datex];


}

-(NSString *)caculateTime:(NSDate *)date andlastMonth:(NSInteger)month
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    
  //  NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStr integerValue]/1000.0];
    
    NSDate *datex =  [date dateByMinusMonths:-month];
    
    [dateFormatter setTimeZone:timeZone];
    //[dateFormatter setDateFormat:@"MM-dd"];
    [dateFormatter setDateFormat:@"MM"];
    
    
    NSLog(@"PPPPPPP%zdPPPPPPP%@PPPPPPPP%@",month,[dateFormatter stringFromDate:datex],[dateFormatter stringFromDate:date]);
    
    return [dateFormatter stringFromDate:datex];
    
    
}



-(NSString *)caculateMonthTime:(NSString *)timeStr
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStr floatValue]/1000.0];
    
    [dateFormatter setTimeZone:timeZone];
    //[dateFormatter setDateFormat:@"MM-dd"];
    [dateFormatter setDateFormat:@"MM"];
    
    return [dateFormatter stringFromDate:date];

}

-(NSString *)caculateYear:(NSString *)timeStr
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStr floatValue]/1000.0];
    
    [dateFormatter setTimeZone:timeZone];
    //[dateFormatter setDateFormat:@"MM-dd"];
    [dateFormatter setDateFormat:@"yyyy"];
    
    return [dateFormatter stringFromDate:date];
    
}




#pragma mark - 懒加载
-(NSMutableArray *)dataArrL
{
    if (!_dataArrL) {
        
        _dataArrL = [[NSMutableArray alloc] init];
        
    }
    
    return _dataArrL;
}

-(NSMutableArray *)dataArrM
{
    if (!_dataArrM) {
        
        _dataArrM = [[NSMutableArray alloc] init];
        
    }
    
    return _dataArrM;
}
-(NSMutableArray *)dataArrR
{
    if (!_dataArrR) {
        
        _dataArrR = [[NSMutableArray alloc] init];
        
    }
    
    return _dataArrR;
}

-(NSMutableDictionary *)allOrderMoneyDic
{
    if (!_allOrderMoneyDic) {
        
        _allOrderMoneyDic = [[NSMutableDictionary alloc] init];
        
    }
    
    return _allOrderMoneyDic;
}

-(NSMutableDictionary *)allOrderAndMoneyChartsDic
{
    if (!_allOrderAndMoneyChartsDic) {
        
        _allOrderAndMoneyChartsDic = [[NSMutableDictionary alloc] init];
        
    }
    
    return _allOrderAndMoneyChartsDic;

}



-(NSMutableDictionary *)successNumDic
{
    if (!_successNumDic) {
        
        _successNumDic = [[NSMutableDictionary alloc] init];
    }

    return _successNumDic;
}

-(NSMutableArray *)serialNumbers
{
    if (!_serialNumbers) {
        _serialNumbers = [[NSMutableArray alloc] init];
    }

    return _serialNumbers;

}

-(NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(fireCheck) userInfo:nil repeats:YES];
        
        _timer.fireDate = [NSDate distantFuture];
    }
    
    return _timer;

}



#pragma mark - 悬浮窗消失
- (void) dimissAlert:(UIAlertView *)alert {
    if(alert){
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}

-(void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}







@end

