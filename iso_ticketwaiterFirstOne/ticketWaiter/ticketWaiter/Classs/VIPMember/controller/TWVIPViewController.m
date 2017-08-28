//
//  TWVIPViewController.m
//  ticketWaiter
//
//  Created by LY on 16/12/30.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "TWVIPViewController.h"
#import "TWVIPModel.h"
#import "TWVIPCell.h"
#import "TWVIPModelView2.h"

#import "TWAddMemberVC.h"
#import "TWVIPDelVC.h"
#import "TWSearchVC.h"

#import "HSRefreshFooter.h"
#import "HSRefreshHeader.h"
#import "HGPlaceholderView.h"
#import "HGSaveNoticeTool.h"


@interface TWVIPViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UIButton *addPerBtn;

@property(nonatomic)UIButton *rightBtn;
@property(nonatomic)UIButton *leftBtn;


//适配

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l1;


@end

@implementation TWVIPViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self obtainData];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSArray *arr = @[_h1,_w1,_t1,_l1];
    
    for (int i=0; i<arr.count; i++) {

    ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);
        
    }

    [self setNavigationBar];
    
    // [self obtainData];
    
    self.myTableView.tableFooterView = [[UIView alloc] init];

    [self.myTableView registerNib:[UINib nibWithNibName:@"TWVIPCell" bundle:nil] forCellReuseIdentifier:@"TWVIPCell"];
    
    
    //添加占位图
    self.placeHolderView = [HGPlaceholderView placehoderView];
    [self.view addSubview:_placeHolderView];
    _placeHolderView.hidden = YES;
    
    [self.view bringSubviewToFront:self.addPerBtn];
    
    
    
    __weak typeof(self)  weakSelf = self;
    _placeHolderView.block = ^(){
        weakSelf.placeHolderView.hidden = YES;
        TWVIPModelView2 *vv = [[TWVIPModelView2 alloc] init];
        [vv obtainPaybackDataWithTableView:weakSelf andFreshType:1];
    };
    
    
    
    TWVIPModelView2 *vv = [[TWVIPModelView2 alloc] init];

    HSRefreshFooter *footer = [HSRefreshFooter footerWithRefreshingBlock:^{
        
        [vv obtainPaybackDataWithTableView:self andFreshType:3];
    }];
    
    self.myTableView.mj_footer = footer;
    
    HSRefreshHeader *header = [HSRefreshHeader headerWithRefreshingBlock:^{
        
        [vv obtainPaybackDataWithTableView:self andFreshType:2];
        
    }];
    
    self.myTableView.mj_header = header;
    
    
    
    
}

-(void)obtainData
{
  
    TWVIPModelView2 *vv = [[TWVIPModelView2 alloc] init];
    
    [vv obtainPaybackDataWithTableView:self andFreshType:1];

    _placeHolderView.hidden = YES;
}




-(void)backClick
{

    [self.navigationController popToRootViewControllerAnimated:YES];

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
    
    TWAddMemberVC *vc = [[TWAddMemberVC alloc] init];
    vc.vcType = 2;
    
    
   // NSLog(@"%@",model.phoneNum1);
    
    vc.model = model;
    
    [self.navigationController pushViewController:vc animated:YES];
    

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWVIPCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWVIPCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellType = 1;
    
    cell.model = (TWVIPModel *)self.dataArr[indexPath.row];
    
    
    return cell;
    
}

#pragma mark - 点击事件

//点击添加会员
- (IBAction)addMemberClick:(UIButton *)sender {
    
    
    if ([[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"leveltype"] integerValue] == 3) {
        
        UIAlertView *alerw = [[UIAlertView alloc] initWithTitle:nil message:@"请先续费在使用此功能" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alerw show];
        
        return;
        
    }
    
    
    TWAddMemberVC *vc = [[TWAddMemberVC alloc] init];
    
    vc.vcType = 1;
    
    vc.dataArr = [self.dataArr mutableCopy];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 设置Navigation
- (void)setNavigationBar{
    
    [self setNaviBarBackgroundColor:nil andStatusBarColor:nil];
    [self setNaviBarTitle:@"会员管理" color:WHITECOLOR];
    [self setNaviBarLeftTitle:nil image:@"icon_bar_back"];
    
    [self setNaviBarRightImage:@[@"icon_bar_del",@"icon_bar_search"]];
    
    
}

- (void)leftAction:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)setNaviBarRightImage:(NSArray *)imgNames{
    
     //靠右的
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.backgroundColor = CLEARCOLOR;
   
    [self.rightBtn setImage:ImageNamed(imgNames[1])
                forState:UIControlStateNormal];
    self.rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    //靠左的
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.backgroundColor = CLEARCOLOR;
    [self.leftBtn setImage:ImageNamed(imgNames[0])
                   forState:UIControlStateNormal];
    
    self.leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    [self.naview addSubview:self.rightBtn];
    [self.naview addSubview:self.leftBtn];
    self.leftBtn.hidden = YES;
    
    //搜索
    [self.rightBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self.naview);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(44);
    }];
    
    
    //删除
    [self.leftBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightBtn.mas_left).offset(-5);
        make.centerY.equalTo(self.naview);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(44);
    }];

}


#pragma mark - 搜索
-(void)searchClick:(UIButton *)btn
{

    NSArray *hisArr = [HGSaveNoticeTool obtainCatheArrayWithKey:@"querystationbinduserlist"];

    if (hisArr.count == 0) {
        
        return;
    }
    
    TWSearchVC *vb = [[TWSearchVC alloc ] init];

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
        
        [vb.dataArr addObject:model];

        
    }

    [self.navigationController pushViewController:vb animated:YES];
    

}

#pragma matk - 删除
-(void)deleteAction:(UIButton *)btn
{
   
    TWVIPDelVC *vc = [[TWVIPDelVC alloc] init];
    
    vc.dataArr = [self.dataArr mutableCopy];
    
    [self.navigationController pushViewController:vc animated:YES];

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
