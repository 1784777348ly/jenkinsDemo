//
//  TWMyAccountVC.m
//  ticketWaiter
//
//  Created by LY on 16/12/29.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "TWMyAccountVC.h"
#import "TWMineModel.h"
#import "TWMyAccountCell.h"
#import "TWMyAccountSelCell.h"

#import "TWOpenAndPayVC.h"
#import "HGSaveNoticeTool.h"

#import "TWMineViewModel.h"

@interface TWMyAccountVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property(nonatomic)NSMutableArray *dataArr;

@end

@implementation TWMyAccountVC

-(void)viewWillAppear:(BOOL)animated
{
    
    if (self.dataArr.count > 0) {
        
        [self.dataArr removeAllObjects];
    }else{
        
    }
    
    [self refreshArr];
    
    [self.myTableView reloadData];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBar];
    
    self.myTableView.tableFooterView = [[UIView alloc] init];

    [self.myTableView registerNib:[UINib nibWithNibName:@"TWMyAccountSelCell" bundle:nil] forCellReuseIdentifier:@"TWMyAccountSelCell"];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"TWMyAccountCell" bundle:nil] forCellReuseIdentifier:@"TWMyAccountCell"];
    
}






#pragma mark - 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArr count];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArr[section] count];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return FitValue(60);

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    
    NSString *isZhenShi = [HGSaveNoticeTool obtainPersonInfoDataWithKey:@"leveltype"];
    if ([isZhenShi isEqualToString:@"2"]) {

        //正式版
        return 0.01;

    }else{
        //正式
        return FitValue(90);
        
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    
    if (section == 1) {
        
        return FitValue(60);
    }
    
    return FitValue(10);

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        
        UIView *viewx = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FitValue(60))];
        viewx.backgroundColor = HexRGB(0xf5f5f5);

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, FitValue(10), SCREEN_WIDTH, FitValue(50))];
        view.backgroundColor = [UIColor whiteColor];

        [viewx addSubview:view];
        
        UIView *viewss = [[UIView alloc] initWithFrame:CGRectMake(0, FitValue(49.5), SCREEN_WIDTH, FitValue(0.5))];
        viewss.backgroundColor = HexRGB(0xcccccc);
        
        [view addSubview:viewss];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(FitValue(28), FitValue(15), FitValue(200), FitValue(20))];
        
        lable.text = @"到期自动续费";
        lable.font = NormalFont(16);
        lable.textColor = HexRGB(0x282828);
        
        [view addSubview:lable];
        
        return viewx;
    }

    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{

//    if (section == 1) {
//        
//        
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
//        view.backgroundColor = [UIColor yellowColor];
//        
//        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
//        
//        lable.text = @"不自动续费情况下，帐号过期后，需重新购买正式版帐号权限";
//        
//        [view addSubview:lable];
//        
//        return view;
//
//        
//    }
    
    if ([[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"hidepay"] integerValue] == 1) {
        
        return nil;
    }
    
    
    
    NSString *isZhenShi = [HGSaveNoticeTool obtainPersonInfoDataWithKey:@"leveltype"];
    if ([isZhenShi isEqualToString:@"1"]) {
        //试用
        //试用版
        if (section == 0) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FitValue(90))];
            view.backgroundColor = MainBackgroundColor;
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(FitValue(28), 44, FitValue(319), FitValue(45))];
            btn.backgroundColor = HexRGB(0xEF3535);
            
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = FitValue(4);
            
            [btn setTitle:@"升级或开通正式版权限" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
 
            [btn setTitleColor:COLOR(255, 255, 255, 0.5) forState:UIControlStateHighlighted];
            
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_login_c"] forState:UIControlStateHighlighted];
            
            
            
            [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:btn];
            
            return view;
            
        }

    }else if ([isZhenShi isEqualToString:@"3"]){
        
        //过期版本
        if (section == 0) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FitValue(90))];
            view.backgroundColor = MainBackgroundColor;
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(FitValue(28), 44, FitValue(319), FitValue(45))];
            btn.backgroundColor = HexRGB(0xEF3535);
            
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = FitValue(4);
            
            [btn setTitle:@"去续费" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [btn setTitleColor:COLOR(255, 255, 255, 0.5) forState:UIControlStateHighlighted];
            
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_login_c"] forState:UIControlStateHighlighted];
            
            
            
            [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:btn];
            
            return view;
            
        }

    
    
    
    }

    
    return nil;


}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1) {
        
        
        if (indexPath.row == 1) {
            
            [self selXuFeiWithType:0];
            
        }else{
        
            [self selXuFeiWithType:1];

        }
        
        
       
    }

}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    if (indexPath.section == 1) {
        
        TWMyAccountSelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWMyAccountSelCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = ((TWMineModel *)[self.dataArr[indexPath.section] objectAtIndex:indexPath.row]);
        
        return cell;
        
        
        
    }else{
    
        TWMyAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWMyAccountCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = ((TWMineModel *)[self.dataArr[indexPath.section] objectAtIndex:indexPath.row]);
        
        return cell;
        
    
    }
    
    
    
//    if (indexPath.section==0&&indexPath.row==1) {
//        
//        TWMyAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWMyAccountCell" forIndexPath:indexPath];
//        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.model = ((TWMineModel *)[self.dataArr[indexPath.section] objectAtIndex:indexPath.row]);
//        
//        return cell;
//        
//        
//    }else{
//        TWMineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWMineViewCell" forIndexPath:indexPath];
//        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.model = ((TWMineModel *)[self.dataArr[indexPath.section] objectAtIndex:indexPath.row]);
//        
//        return cell;
//    
//    
//    }
    
    
    
}

-(void)selXuFeiWithType:(NSInteger)type
{
    TWMineViewModel *viewModel = [[TWMineViewModel alloc] init];
    
    TWMineModel *model = [self.dataArr[1] objectAtIndex:type];
    
    if (!model.isSeled) {
        
        return;
    }

    [viewModel autoPayWithType:type ReturnBlock:^(id result) {
        
        NSDictionary *dic = (NSDictionary *)result;
        
        if ([dic[@"success"] integerValue] == 1 ) {

            if (type == 1) {
                
                [SVProgressHUD showSuccessWithStatus:@"设置成功"];

                //自动续费
                TWMineModel *model = [self.dataArr[1] objectAtIndex:0];
                model.isSeled = 1;
                
                TWMineModel *modelx = [self.dataArr[1] objectAtIndex:1];
                modelx.isSeled = 0;
                
                [HGSaveNoticeTool updatePersonInfodataWithKey:@"autorenew" andValue:@"1"];
                

            }else{
            
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];

                TWMineModel *model = [self.dataArr[1] objectAtIndex:0];
                model.isSeled = 0;
                
                TWMineModel *modelx = [self.dataArr[1] objectAtIndex:1];
                modelx.isSeled = 1;
                
                [HGSaveNoticeTool updatePersonInfodataWithKey:@"autorenew" andValue:@"0"];


            }
            
            
            [self.myTableView reloadData];
            
        }else{
        
            [SVProgressHUD showErrorWithStatus:dic[@"em"]];
        
        }

    }];
    
    
    
  


}




#pragma mark - 点击事件 开通会员
-(void)onClick:(UIButton *)btn
{
    TWOpenAndPayVC *vc = [[TWOpenAndPayVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];

}


#pragma mark - 设置导航栏
- (void)setNavigationBar{
    
    [self setNaviBarBackgroundColor:nil andStatusBarColor:nil];
    [self setNaviBarTitle:@"我的帐号" color:WHITECOLOR];
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

-(void)refreshArr
{
    NSArray *titles = @[@"我的账号",@"帐号类型",@"自动续期",@"不自动续费"];
    
    NSString *isZhenShi = [HGSaveNoticeTool obtainPersonInfoDataWithKey:@"leveltype"];
    NSString *tttstr = @"";
    if ([isZhenShi isEqualToString:@"1"]) {
        //试用
        tttstr = @"试用账号";
    }else if ([isZhenShi isEqualToString:@"2"]){
        //正式
        tttstr = @"正式账号";
        
    }else{
        
        tttstr = @"未续费账号";
    }
    NSArray *detailTitles = @[[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"username"],
                              tttstr,
                              @"自动续费200.00元",
                              @"到期后需自动购买才能使用"];
    NSArray *detailsType = @[@"1",@"1",@"2",@"2"]; //"1"代表文字  "2"代表图片
    
    NSArray *isNotHaveArrow = @[@(1),@(1),@(1),@(1)];
    
    NSArray *bottoms = @[@(1),@(0),@(1),@(0)];
    
    NSMutableArray *seleleds = [[NSMutableArray alloc] initWithObjects:@(0),@(0),nil];
    
    
    if ([[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"autorenew"] integerValue] == 1) {
        
        [seleleds addObjectsFromArray:@[@"1",@"0"]];
        
    }else{
    
         [seleleds addObjectsFromArray:@[@"0",@"1"]];
    
    }

    NSString *timeStr = [[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"expirydate"] description];
    
    NSMutableArray *numArr = [[NSMutableArray alloc] initWithObjects:@(2),@(2), nil];
    
    
    if ([isZhenShi isEqualToString:@"1"] || [isZhenShi isEqualToString:@"3"]) {
        //试用
        [numArr removeLastObject];
    }
    
    for (int i=0; i<numArr.count; i++) {
        
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
        for (int k=0; k<[numArr[i] intValue]; k++) {
            
            TWMineModel *model = [[TWMineModel alloc] init];
            
            model.title = [titles objectAtIndex:i*2+k];
            model.details = [detailTitles objectAtIndex:i*2+k];
            model.detailsType = [detailsType objectAtIndex:i*2+k];
            model.isNotHaveArrow = [isNotHaveArrow objectAtIndex:i*2+k];
            model.hideBottomLine = [bottoms[i*2+k] boolValue];
            model.isSeled = [seleleds[i*2+k] boolValue];
            if (i*2+k==1) {
                model.subTitle = timeStr;
            }
            
            
            [tmpArr addObject:model];
        }
        
        [self.dataArr addObject:tmpArr];
        
    }
    
    if (([[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"hidepay"] integerValue] == 1)&&self.dataArr.count>1) {
        
        [self.dataArr removeObjectAtIndex:1];
        
    }
    
    
    
    

    


}






@end
