//
//  TWBoundCardAgainVC.m
//  ticketWaiter
//
//  Created by LY on 17/1/13.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWBoundCardAgainVC.h"
#import "TWMineModel.h"
#import "TWBoundCardCell.h"
#import "TWPayResultVC.h"

#import "HGSaveNoticeTool.h"
#import "TWJudgeRulesTool.h"
#import "TWMineViewModel.h"


@interface TWBoundCardAgainVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@property(nonatomic)NSMutableArray *dataArr;

@property(nonatomic)UIButton *ensureBtn;


@end

@implementation TWBoundCardAgainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBar];
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"TWBoundCardCell" bundle:nil] forCellReuseIdentifier:@"TWBoundCardCell"];
    
}

#pragma mark - 代理方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return FitValue(55);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return FitValue(88);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return FitValue(90);

}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
    UIView *viewx = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FitValue(88))];
    viewx.backgroundColor = HexRGB(0xf5f5f5);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, FitValue(10), SCREEN_WIDTH, FitValue(78))];
    view.backgroundColor = [UIColor whiteColor];
    
    [viewx addSubview:view];
    
    UIView *viewss = [[UIView alloc] initWithFrame:CGRectMake(0, FitValue(77), SCREEN_WIDTH, FitValue(1))];
    viewss.backgroundColor = HexRGB(0xcccccc);
    
    [view addSubview:viewss];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(FitValue(32), FitValue(19), SCREEN_WIDTH, FitValue(20))];
    
    lable.text = self.cardNum;
    lable.font = BoldFont(20);
    lable.textColor = HexRGB(0x282828);
    
    [view addSubview:lable];
    
    NSArray *arr = [self.cardName componentsSeparatedByString:@"·"];

    //银行图标
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-FitValue(27.5+45), FitValue(10), FitValue(50), FitValue(50))];
    
    [view addSubview:imageview];
    
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(view.mas_right).offset(FitValue(-27.5));
        make.height.and.with.mas_equalTo(FitValue(50));
        make.centerY.equalTo(view.mas_centerY);
        
    }];
    
    
    
    UILabel *bankName = [[UILabel alloc] initWithFrame:CGRectZero];
    
    bankName.text = self.cardName;
    
    if (arr.count>0) {
//        bankName.text = arr[0];
        
        NSArray *bankNames = @[@"zxyh",@"zsyh",@"zgyzcxyh",@"zgyh",@"zgnyyh",@"zgjsyh",@"zggsyh",@"xyyh",@"sfyh",@"pfyh",@"msyh",@"jtyh",@"hxyh",@"gfyh",@"gdyh"];
        
        NSArray *keyNames = @[@"中信",@"招商",@"邮政",@"中国银行",@"农业",@"建设",@"工商",@"兴业",@"深圳发展",@"浦东发展",@"民生",@"交通",@"华夏",@"广发",@"光大"];
        
        
        for (int i=0; i<keyNames.count; i++) {
            
            if ([[arr[0] description] containsString:keyNames[i]]) {
                imageview.image = [UIImage imageNamed:bankNames[i]];
                break;
            }
        }

    }else{
        bankName.text = @"";
    }
    
    
    
    bankName.textColor = HexRGB(0x282828);
    
    bankName.font = NormalFont(13);
    
    [view addSubview:bankName];
    
    [bankName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(lable.mas_bottom).offset(5);
        make.leading.equalTo(lable.mas_leading);
        
    }];

    return viewx;


}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
   
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FitValue(90))];
        view.backgroundColor = MainBackgroundColor;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(FitValue(28), 44, FitValue(319), FitValue(45))];
    
    
        self.ensureBtn = btn;
    
    
        btn.backgroundColor = HexRGB(0xcccccc);
        
//        TWOpenAccountModel *model = [self.dataArr[0] objectAtIndex:0];
//        
//        if (!model.isAccount) {
//            
//            //点击绑定银行卡
//            btn.backgroundColor = HexRGB(0xcccccc);
//            btn.userInteractionEnabled = NO;
//            
//        }else{
//            
//            btn.backgroundColor = HexRGB(0xEF3535);
//            btn.userInteractionEnabled = YES;
//        }
//        
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = FitValue(4);
        btn.userInteractionEnabled = NO;
    
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
        [btn setTitleColor:COLOR(255, 255, 255, 0.5) forState:UIControlStateHighlighted];

        [btn setBackgroundImage:[UIImage imageNamed:@"btn_login_c"] forState:UIControlStateHighlighted];
    
    
        [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:btn];
        
        return view;
        

}






-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWBoundCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWBoundCardCell" forIndexPath:indexPath];
    
    
    __weak typeof(self)  weakSelf = self;
    
    cell.tfBlock = ^(){
        
        [weakSelf changeBtnColor];
    
    };
    

    TWCardModel *model = self.dataArr[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = model;
    
    return cell;

}

#pragma mark - 确定

-(void)onClick:(UIButton *)btn
{
    //绑卡成功页面
    
#warning ------ 判断身份证号  手机号
    
    TWCardModel *model = self.dataArr[1];
    
    if (![TWJudgeRulesTool checkIdentityCardNo:model.tfContent]) {
        
        [SVProgressHUD showErrorWithStatus:@"身份证号错误"];
        
        return;
    }

    TWCardModel *model2 = self.dataArr[2];
    
    if (![TWJudgeRulesTool judgePhoneIsOk:model2.tfContent]) {
        
        [SVProgressHUD showErrorWithStatus:@"手机号错误"];
        
        return;
    }

    TWCardModel *model3 = self.dataArr[3];
    
    if (model3.tfContent.length > 50) {
        
        [SVProgressHUD showErrorWithStatus:@"开户支行错误"];
        
        return;
    }
    
    
    TWMineViewModel *viewModel = [[TWMineViewModel alloc] init];
    
    NSDictionary *params = @{@"card":self.cardNum,
                             @"fullname":self.placeHolder,
                             @"identify":model.tfContent,
                             @"phone":model2.tfContent,
                             @"token":LYTOKEN,
                             @"bankbranch":model3.tfContent
                             };
    
    
    
    [viewModel boundCardWithParams:params andReturnBlock:^(id result) {
        
        NSDictionary *dic = (NSDictionary *)result;
        
        
        if ([dic[@"success"] integerValue] == 1) {
            
            [SVProgressHUD dismiss];
            //绑卡成功  改变绑卡状态
            [HGSaveNoticeTool updatePersonInfodataWithKey:@"bankcard" andValue:@1];
            
            TWPayResultVC *vc = [[TWPayResultVC alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
        
            [SVProgressHUD showErrorWithStatus:dic[@"em"]];
        }
        
        
    }];
    

    
    
    
    
    
//    NSInteger num = self.navigationController.viewControllers.count;
//    
//    [self.navigationController popToViewController:self.navigationController.viewControllers[num-2] animated:YES];

}


-(void)changeBtnColor
{
    int sum=0;
    
    for (int i=1; i<self.dataArr.count; i++) {
        
        int a=0;
        
        TWCardModel *model = self.dataArr[i];
        
        if (model.tfContent.length > 0) {
            
            a++;
            sum +=a;
        }
    }

    
    if (sum==self.dataArr.count-1) {
        
        //变大红色
        self.ensureBtn.backgroundColor = HexRGB(0xef3535);
        self.ensureBtn.userInteractionEnabled = YES;
        
        
    }else if (sum==0){
    
        //灰色
        self.ensureBtn.backgroundColor = HexRGB(0xcccccc);
        self.ensureBtn.userInteractionEnabled = NO;
    
    }else{
        
        //过度色
        self.ensureBtn.backgroundColor = HexRGB(0xe87071);
        self.ensureBtn.userInteractionEnabled = NO;
    
    }
    


}




#pragma mark - 设置导航栏
- (void)setNavigationBar{
    
    [self setNaviBarBackgroundColor:nil andStatusBarColor:nil];
    [self setNaviBarTitle:@"绑定银行卡" color:WHITECOLOR];
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
        
        
        NSArray *arr = @[@"持卡人姓名",@"身份证号码",@"银行预留手机",@"开户支行"];
        
        NSArray *placeHarr = @[@"持卡人姓名",@"身份证号码",@"银行预留手机",@"开户支行"];
        NSArray *editArr = @[@(0),@(1),@(1),@(1)];
        NSArray *isHaveBtns= @[@(0),@(0),@(0),@(0)];
        
        
        
        for (int i=0; i<arr.count; i++) {
            
            TWCardModel *model = [[TWCardModel alloc] init];
            
            model.lefttitle = arr[i];
            model.isEdited = [editArr[i] boolValue];
            
            model.isHaveBtn = [isHaveBtns[i] boolValue];
            model.placeHolders = placeHarr[i];
            
            if (i==0) {
                
                model.tfContent = self.placeHolder;
                
            }

            [_dataArr addObject:model];
        }

    }

    return _dataArr;

}



@end
