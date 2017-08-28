//
//  TWUnboundVC.m
//  ticketWaiter
//
//  Created by LY on 17/1/14.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWUnboundVC.h"
#import "TWOpenAndPayCell.h"
#import "TWMineModel.h"

#import "TWMineViewModel.h"
#import "HGSaveNoticeTool.h"


@interface TWUnboundVC ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;


//适配
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t3;


@end

@implementation TWUnboundVC






- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationBar];
    [self shiPei];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"TWOpenAndPayCell" bundle:nil] forCellReuseIdentifier:@"TWOpenAndPayCell"];
    
    
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
    // TWOpenAccountModel *model = [self.dataArr objectAtIndex:0];
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 21) {
        
        if (buttonIndex == 0) {
            
            [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
            
        }
        
    }


}



#pragma mark - 点击事件
//解除绑定
- (IBAction)unBoundcardClick:(UIButton *)sender {

    sender.userInteractionEnabled = 0;
    [self performSelector:@selector(delayClick) withObject:sender afterDelay:2.0];

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

//取消
- (IBAction)cancelClick:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)delayClick
{

    _myTableView.userInteractionEnabled = 1;

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

-(void)shiPei
{
    _btn1.titleLabel.font = NormalFont(_btn1.titleLabel.font.pointSize);
    _btn2.titleLabel.font = NormalFont(_btn2.titleLabel.font.pointSize);
    
    _h1.constant = FitValue(_h1.constant);
    _h2.constant = FitValue(_h2.constant);
    _t1.constant = FitValue(_t1.constant);
    _t2.constant = FitValue(_t2.constant);
    _t3.constant = FitValue(_t3.constant);
    
    
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
