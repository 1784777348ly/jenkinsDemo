//
//  TWMyPaybackVC.m
//  ticketWaiter
//
//  Created by LY on 16/12/30.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "TWMyPaybackVC.h"
#import "TWMyPaybackCell.h"
#import "TWPaiHangModel.h"
#import "TWPaiHangModelView.h"

#import "HSRefreshFooter.h"
#import "HSRefreshHeader.h"

#import "HGPlaceholderView.h"



@interface TWMyPaybackVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic)NSMutableArray *dataArr;


@end

@implementation TWMyPaybackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationBar];

    [self obtainData];

    [self.myTableView registerNib:[UINib nibWithNibName:@"TWMyPaybackCell" bundle:nil] forCellReuseIdentifier:@"TWMyPaybackCell"];
    
    
    TWPaiHangModelView *bb = [[TWPaiHangModelView alloc] init];

    HSRefreshFooter *footer = [HSRefreshFooter footerWithRefreshingBlock:^{
        
        [bb obtainPaybackDataWithTableViewVC:self andDataArr:self.dataArr andRefshType:3];
    }];
    
    self.myTableView.mj_footer = footer;
    
    HSRefreshHeader *header = [HSRefreshHeader headerWithRefreshingBlock:^{
        
        [bb obtainPaybackDataWithTableViewVC:self andDataArr:self.dataArr andRefshType:2];

    }];
    
    self.myTableView.mj_header = header;

    
    
}






#pragma mark - 获取数据

-(void)obtainData
{
    //添加占位图
    self.placeHolderView = [HGPlaceholderView placehoderView];
    [self.view addSubview:_placeHolderView];
    
    self.placeHolderView.hidden = YES;
    __weak typeof(self)  weakSelf = self;
    _placeHolderView.block = ^(){
        weakSelf.placeHolderView.hidden = YES;
        TWPaiHangModelView *bb = [[TWPaiHangModelView alloc] init];
        [bb obtainPaybackDataWithTableViewVC:weakSelf andDataArr:weakSelf.dataArr andRefshType:1];
    };

    
    TWPaiHangModelView *bb = [[TWPaiHangModelView alloc] init];
    [bb obtainPaybackDataWithTableViewVC:self andDataArr:self.dataArr andRefshType:1];

}



#pragma mark - 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dataArr.count;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return FitValue(62);

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWMyPaybackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWMyPaybackCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = (TWMyPaybackModel *)self.dataArr[indexPath.row];
    
    return cell;

}



#pragma mark - 设置导航栏
- (void)setNavigationBar{
    
    [self setNaviBarBackgroundColor:nil andStatusBarColor:nil];
    [self setNaviBarTitle:@"我的奖励" color:WHITECOLOR];
    [self setNaviBarLeftTitle:nil image:@"icon_bar_back"];
}

- (void)leftAction:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - 获得网络状态
- (void)netWorkNotReachable{
    self.netRachable = NO;
    
}
- (void)netWorkReachable{
    self.netRachable = YES;
    
}




#pragma mark  - 懒加载
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }

    
    return _dataArr;
}



@end
