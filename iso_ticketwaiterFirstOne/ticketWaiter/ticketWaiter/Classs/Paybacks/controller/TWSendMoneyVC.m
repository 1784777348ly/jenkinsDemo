//
//  TWSendMoneyVC.m
//  ticketWaiter
//
//  Created by LY on 17/1/16.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWSendMoneyVC.h"

#import "TWSearchVC.h"
#import "TWVIPModelView2.h"

#import "TWVIPModel.h"
#import "TWVIPCell.h"

#import "TWSearchView.h"

#import "HSRefreshFooter.h"
#import "HSRefreshHeader.h"
#import "HGPlaceholderView.h"
#import "HGSaveNoticeTool.h"

#import "TWPayBackViewModel.h"

#import "TWBoundCardVC.h"


@interface TWSendMoneyVC ()<UIAlertViewDelegate>


@property(nonatomic)NSMutableArray *tmpArr;

@property(nonatomic)UIButton *rightBtn;

@property(nonatomic)NSInteger num;

@end

@implementation TWSendMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationBar];
    
    [self obtainData];
    
    self.myTableView.tableFooterView = [[UIView alloc] init];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"TWVIPCell" bundle:nil] forCellReuseIdentifier:@"TWVIPCell"];
    
    //添加占位图
    self.placeHolderView = [HGPlaceholderView placehoderView];
    [self.view addSubview:_placeHolderView];
    _placeHolderView.hidden = YES;

    __weak typeof(self)  weakSelf = self;
    _placeHolderView.block = ^(){
        weakSelf.placeHolderView.hidden = YES;
        TWVIPModelView2 *vv = [[TWVIPModelView2 alloc] init];
        [vv obtainVIPListWithTableView:weakSelf andFreshType:1];
    };

    TWVIPModelView2 *vv = [[TWVIPModelView2 alloc] init];
    HSRefreshFooter *footer = [HSRefreshFooter footerWithRefreshingBlock:^{
        
        [vv obtainVIPListWithTableView:weakSelf andFreshType:3];
    }];
    
    self.myTableView.mj_footer = footer;
    
    HSRefreshHeader *header = [HSRefreshHeader headerWithRefreshingBlock:^{
        
        [vv obtainVIPListWithTableView:weakSelf andFreshType:2];
        
    }];
    
    self.myTableView.mj_header = header;
    

}

//获得会员列表
-(void)obtainData
{
    TWVIPModelView2 *vv = [[TWVIPModelView2 alloc] init];
    
    [vv obtainVIPListWithTableView:self andFreshType:1];
    
}



#pragma mark - 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return FitValue(60);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TWVIPModel *model = self.dataArr[indexPath.row];
    
    _num = indexPath.row;
    
    NSString *arr = @"";
    
    if (model.remark.length>10) {
        
        NSMutableString *strr = [[NSMutableString alloc] initWithString:model.remark];

        arr = [strr substringToIndex:10];
    }else{
    
        arr = model.remark;
        
    }
    
    
    
    UIAlertView *alerw = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"赠送%.2f元彩金,给%@ %@",self.money/100.0,model.phone,arr] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    alerw.tag = 81;
    
    [alerw show];
    
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWVIPCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWVIPCell" forIndexPath:indexPath];
    
    cell.cellType = 3;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = (TWVIPModel *)self.dataArr[indexPath.row];
    
    
    return cell;
    
}

#pragma mark - 赠送彩金
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 81&&buttonIndex == 1) {
        
        
        if ([[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"leveltype"] integerValue] == 3) {
            
#warning ========== 账号过期  未续费
            UIAlertView *alerw = [[UIAlertView alloc] initWithTitle:nil message:@"请先续费在使用此功能" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alerw show];
            
            return;

        }
        
        
        if ([[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"bankcard"] integerValue] == 0) {
            
#warning ========== 未绑定银行卡
            UIAlertView *alerw = [[UIAlertView alloc] initWithTitle:nil message:@"请先绑定银行卡" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alerw.tag = 96;
            [alerw show];
            
            return;
            
        }

        TWPayBackViewModel *viewModel = [[TWPayBackViewModel alloc] init];
        
        TWVIPModel *model = self.dataArr[_num];
        
        [viewModel donateMoneyInfoWithMoney:_money andMemberId:model.memberid returnBack:^(id result) {
            
            NSDictionary *dic = (NSDictionary *)result;
            
            if ([dic[@"success"] integerValue] == 1) {
                
                [SVProgressHUD dismiss];
                UIAlertView *alerw = [[UIAlertView alloc] initWithTitle:nil message:@"赠送处理中。。。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alerw.tag = 92;
                [alerw show];
                
               // [SVProgressHUD showSuccessWithStatus:@"赠送成功"];

                
            }else{
                
                [SVProgressHUD showErrorWithStatus:dic[@"em"]];
            }

        }];

    }
    
    
    if (alertView.tag == 92) {
        
        [self.navigationController popViewControllerAnimated:YES];

    }
    
    
    if (alertView.tag == 96&&buttonIndex == 1) {
    
        TWBoundCardVC *vc = [[TWBoundCardVC alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }


}




#pragma mark - 设置Navigation
- (void)setNavigationBar{
    
    [self setNaviBarBackgroundColor:nil andStatusBarColor:nil];
    [self setNaviBarTitle:@"选择赠送的会员" color:WHITECOLOR];
    [self setNaviBarLeftTitle:nil image:@"icon_bar_back"];
    [self setNaviBarRightImage:@"icon_bar_search"];
    
    
}

- (void)leftAction:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)setNaviBarRightImage:(NSString *)imgName{
    
    //靠右的
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.backgroundColor = CLEARCOLOR;
    
    [self.rightBtn setImage:ImageNamed(imgName)
                   forState:UIControlStateNormal];
    self.rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.naview addSubview:self.rightBtn];

    //搜索
    [self.rightBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self.naview);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];

}


#pragma mark - 搜索
#pragma mark - 设置搜索框
-(void)searchClick:(UIButton *)btn
{
    
    //把所有会员查找出来
    NSArray *hisArr = [HGSaveNoticeTool obtainCatheArrayWithKey:@"querystationbinduserlist"];
    
    if (hisArr.count == 0) {
        
        return;
    }

    [self.dataArr removeAllObjects];
    for (int i=0; i<hisArr.count; i++) {
        
        NSMutableDictionary *dicc = [hisArr[i] mutableCopy];
        
        NSArray *dictKeysArray = [dicc allKeys];
        for (int i = 0; i<dictKeysArray.count; i++) {
            
            NSString *key = dictKeysArray[i];
            
            if ([[dicc objectForKey:key] isEqual:[NSNull null]]) {
                
                [dicc setValue:@"" forKey:key];
            }
            
        }
        
        TWVIPModel *model = [[TWVIPModel alloc] init];
        
        [model setValuesForKeysWithDictionary:dicc];
        
        [self.dataArr addObject:model];
    }

    [self.tmpArr removeAllObjects];
    
    self.tmpArr = self.dataArr.mutableCopy;

    
    TWSearchView * view = [TWSearchView searchView];
    
    __weak typeof(self)  weakSelf = self;
    
    //取消
    view.scBlock = ^(){
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    };
    
    //输入有值了的
    view.siBlock = ^(NSString *str){
        
        if (str.length>11) {
            
            [weakSelf.dataArr removeAllObjects];
            [weakSelf.myTableView reloadData];
            
        }else{
        
            NSRange range = NSMakeRange(0, str.length);
            
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            
            for (int i=0; i<weakSelf.tmpArr.count; i++) {
                
                TWVIPModel *model = weakSelf.tmpArr[i];
                
                if ([[model.phone substringWithRange:range] isEqualToString:str]) {
                    
                    //满足条件  就放在数组里面
                    
                    model.inputStrLength = str.length;
                    
                    [arr addObject:model];
                    
                }
                
            }
            
            [weakSelf.dataArr removeAllObjects];
            
            weakSelf.dataArr = [arr mutableCopy];
            
            [weakSelf.myTableView reloadData];

        }


    };

    [self.naview addSubview:view];
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
