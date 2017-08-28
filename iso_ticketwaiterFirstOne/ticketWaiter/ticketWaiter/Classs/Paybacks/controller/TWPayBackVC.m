//
//  TWPayBackVC.m
//  ticketWaiter
//
//  Created by LY on 17/1/3.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWPayBackVC.h"
#import "TWPayBackModel.h"
#import "TWPaybackCell.h"

#import "TWPayBackViewModel.h"
#import "TWSelMoneyView.h"

#import "TWSendMoneyVC.h"
#import "HSRefreshFooter.h"
#import "HSRefreshHeader.h"
#import "HGPlaceholderView.h"
#import "HGSaveNoticeTool.h"

//升级正式版
#import "TWOpenAndPayVC.h"

//绑卡
#import "TWBoundCardVC.h"




@interface TWPayBackVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>


@property(nonatomic,weak)TWSelMoneyView *hongBaoView;


@property(nonatomic,assign)CGFloat hongBaoWidth;


@end

@implementation TWPayBackVC

-(void)viewWillAppear:(BOOL)animated
{
    [self.dataArr removeAllObjects];
    
    TWPayBackViewModel *viewModel = [[TWPayBackViewModel alloc] init];

    [viewModel obtainPaybackDataWithTableViewVC:self andDataArr:self.dataArr andRefshType:1];

}






- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   // self.hongBaoWidth = 60;
    
    [self setNavigationBar];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"TWPaybackCell" bundle:nil] forCellReuseIdentifier:@"TWPaybackCell"];
    
     TWPayBackViewModel *viewModel = [[TWPayBackViewModel alloc] init];
    
    //设置占位视图
    self.placeHolderView = [HGPlaceholderView placehoderView];
    [self.view addSubview:_placeHolderView];
    self.placeHolderView.hidden = YES;

    __weak typeof(self)  weakSelf = self;
    _placeHolderView.block = ^(){
        weakSelf.placeHolderView.hidden = YES;
        [viewModel obtainPaybackDataWithTableViewVC:weakSelf andDataArr:weakSelf.dataArr andRefshType:1];
    };

    
    
    HSRefreshFooter *footer = [HSRefreshFooter footerWithRefreshingBlock:^{
        
        [viewModel obtainPaybackDataWithTableViewVC:self andDataArr:self.dataArr andRefshType:3];
    }];
    
    self.myTableView.mj_footer = footer;
    
    HSRefreshHeader *header = [HSRefreshHeader headerWithRefreshingBlock:^{
        
        [viewModel obtainPaybackDataWithTableViewVC:self andDataArr:self.dataArr andRefshType:2];
        
    }];
    
    self.myTableView.mj_header = header;

    [self setHongbaoView];

    
    
}

#pragma mark - 设置红包视图
-(void)setHongbaoView
{
    
    UIView *viewBack = [[UIView alloc] initWithFrame:self.view.bounds];
    
    viewBack.userInteractionEnabled = 0;
    
    viewBack.tag = 1001;
    
    viewBack.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:viewBack];
    
    //红包
    TWSelMoneyView *view = [TWSelMoneyView selMoneyViewWithRect:CGRectMake(SCREEN_WIDTH - FitValue(30)-FitValue(150), SCREEN_HEIGHT - FitValue(150+64), FitValue(150), FitValue(150))];
    
    self.hongBaoView = view;
    
    [self.view addSubview:view];

    __weak  typeof(self) weakSelf = self;
    
    view.addBlock = ^(BOOL  isAdded){
    
        if (isAdded) {
            
             viewBack.userInteractionEnabled = 1;
           
            UIView *viewAll = [[UIView alloc] initWithFrame:weakSelf.view.bounds];
            
            viewAll.backgroundColor = [UIColor clearColor];
            
            // viewAll.userInteractionEnabled = 0;
            
            [viewBack addSubview:viewAll];
            
            UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(dismissClick:)];
            [viewAll addGestureRecognizer:tapGr];
            
        }else{
        
            viewBack.userInteractionEnabled = 0;

            [viewBack removeAllSubviews];
        
        }
        
       
    
    };
    
    
    
#pragma mark - 赠送彩金
    view.sendBlock = ^(NSInteger money){
        
#warning ----------- 判断是否是正式账号   是否绑定银行卡  能升级的时候在打开
        
        NSString *isZhenShi = [HGSaveNoticeTool obtainPersonInfoDataWithKey:@"leveltype"];
        
        NSString *isBoundCard = [HGSaveNoticeTool obtainPersonInfoDataWithKey:@"bankcard"];
        
        if ([isZhenShi isEqualToString:@"1"] || [isZhenShi isEqualToString:@"3"]) {
            //试用版账号
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请升级至正式版账号在使用" delegate:self cancelButtonTitle:@"稍后" otherButtonTitles:@"升级", nil];
            alertView.tag = 21;
            [alertView show];
            
            
            return ;
        }
        
        
        if ([isBoundCard isEqualToString:@"0"]) {
            //没有绑定银行卡
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"未绑定银行卡，不能赠送彩金" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即绑卡", nil];
            alertView.tag = 22;
            [alertView show];
            
            
            return ;
        }

        
        //赠送彩金
        TWSendMoneyVC *vc = [[TWSendMoneyVC alloc] init];
        
        vc.money = money;
        
        [weakSelf.navigationController pushViewController:vc animated:YES];

    };

}






#pragma mark - 点击消失
-(void)dismissClick:(UITapGestureRecognizer *)tapGr
{
    
    tapGr.view.superview.userInteractionEnabled = 0;

    [tapGr.view removeFromSuperview];
    
    
    [self.hongBaoView moneyDismiss];
    

}






#pragma mark - 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  FitValue(66);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
//    TWPayBackModel *model = self.dataArr[indexPath.row];
//
//    
//    [self.navigationController pushViewController:vc animated:YES];
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWPaybackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWPaybackCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = (TWPayBackModel *)self.dataArr[indexPath.row];
    
    return cell;
    
}


#pragma mark - 判断是否是正式账号   是否绑定银行卡
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 21) {
        
        if (buttonIndex == 1) {
            
#warning -------跳转至 升级账号
           //TWOpenAndPayVC
            TWOpenAndPayVC *vc = [[TWOpenAndPayVC alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }

    if (alertView.tag == 22) {
        
        if (buttonIndex == 1) {
#warning -------- 绑卡
            //TWBoundCardVC
            TWBoundCardVC *vc = [[TWBoundCardVC alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }

}








#pragma mark - 设置导航栏
- (void)setNavigationBar{
    
    [self setNaviBarBackgroundColor:nil andStatusBarColor:nil];
    [self setNaviBarTitle:@"赠送彩金记录" color:WHITECOLOR];
    [self setNaviBarLeftTitle:nil image:@"icon_bar_back"];
}

- (void)leftAction:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



#pragma mark - 懒加载
-(NSMutableArray *)dataArr
{

    if(!_dataArr){
        
        _dataArr = [[NSMutableArray alloc] init];

    }
    
    return _dataArr;

}



@end
