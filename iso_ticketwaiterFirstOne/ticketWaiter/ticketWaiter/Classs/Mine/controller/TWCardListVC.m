//
//  TWCardListVC.m
//  ticketWaiter
//
//  Created by LY on 17/1/13.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWCardListVC.h"
#import "TWOpenAndPayCell.h"
#import "TWMineModel.h"
#import "TWMineViewModel.h"

#import "TWUnboundVC.h"

#import "HGPlaceholderView.h"

#import "TWUnboundView.h"
#import "HGSaveNoticeTool.h"

@interface TWCardListVC ()

@property(nonatomic,weak)TWUnboundView *unboundView;



@end

@implementation TWCardListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self setNavigationBar];
    
    TWMineViewModel *viewModel = [[TWMineViewModel alloc] init];
    
    
    [viewModel fetchCardList:self];
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"TWOpenAndPayCell" bundle:nil] forCellReuseIdentifier:@"TWOpenAndPayCell"];
    
    self.placeHolderView = [HGPlaceholderView placehoderViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.placeHolderView.hidden = YES;
    [self.myTableView addSubview:_placeHolderView];
    
    __weak typeof(self) weakSelf = self;
    
    _placeHolderView.block = ^(){
        
        [viewModel fetchCardList:weakSelf];
        weakSelf.placeHolderView.hidden = YES;


    };
    
    
    
}


#pragma mark - 代理


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArr count];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        return FitValue(91);
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

        return 1;

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return FitValue(10);
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    view.backgroundColor = HexRGB(0xcccccc);
    
    return view;
    
}





-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        
        
        TWOpenAndPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWOpenAndPayCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = ((TWOpenAccountModel *)[self.dataArr objectAtIndex:indexPath.row]);
        
        return cell;

    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (!self.unboundView) {
       
        TWUnboundView *viewss = [TWUnboundView unboundViewWithRect:CGRectMake(0, SCREEN_HEIGHT-120, SCREEN_WIDTH, FitValue(120))];
        
        self.unboundView = viewss;
        
        __weak  typeof(self) weakSelf = self;
        
        self.unboundView.block = ^(){
            
            [weakSelf unBoundcard];
        };
        
        [self.view addSubview:self.unboundView];
        
    }else{
    
        
    
    }

    
//    TWOpenAccountModel *model = [self.dataArr objectAtIndex:indexPath.row];
//    
//    TWUnboundVC *vc = [[TWUnboundVC alloc] init];
//    
//    [vc.dataArr addObject:model] ;
//    
//    [self.navigationController pushViewController:vc animated:YES];

}

- (void)unBoundcard{

    
    _myTableView.userInteractionEnabled = 0;
    [self performSelector:@selector(delayClick:) withObject:nil afterDelay:2.0];
    
    TWMineViewModel *model = [[TWMineViewModel alloc] init];
    
    NSDictionary *dic = [HGSaveNoticeTool obtainCatheDictionaryWithKey:@"getbindingquickpay"];
    
    NSDictionary *params = @{@"payid":dic[@"payid"],@"token":LYTOKEN};
    
    [model unboundCardWithParams:params andReturnBlock:^(id result) {
        
        NSDictionary *dics = (NSDictionary *)result;
        
        if ([dics[@"success"] integerValue] == 1) {
            
            [SVProgressHUD dismiss];
            
            //解绑成功   改变缓存状态  删除银行卡
            [HGSaveNoticeTool updatePersonInfodataWithKey:@"bankcard" andValue:@0];
            [HGSaveNoticeTool clearCatheWithKey:@"getbindingquickpay"];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"银行卡解绑成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alertView.tag = 21;
            
            [alertView show];
            
            
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:dics[@"em"]];
            
        }
        
        
    }];
    
    
}



-(void)delayClick:(UIButton *)sender
{
    
    sender.userInteractionEnabled = 1;
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 21) {
        
        if (buttonIndex == 0) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }
    
    
}


#pragma mark - 设置导航栏
- (void)setNavigationBar{
    
    [self setNaviBarBackgroundColor:nil andStatusBarColor:nil];
    [self setNaviBarTitle:@"我的银行卡" color:WHITECOLOR];
    [self setNaviBarLeftTitle:nil image:@"icon_bar_back"];
}

- (void)leftAction:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - 懒加载

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }

    return _dataArr;

}



@end
