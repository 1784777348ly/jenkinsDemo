//
//  TWSearchVC.m
//  ticketWaiter
//
//  Created by LY on 17/1/11.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWSearchVC.h"

#import "TWVIPModel.h"
#import "TWVIPCell.h"
#import "TWVIPModelView2.h"

#import "TWAddMemberVC.h"
#import "TWSearchView.h"


@interface TWSearchVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property(nonatomic)UIButton *rightBtn;
@property(nonatomic)UIButton *leftBtn;

@property(nonatomic)UITextField *textField;


@property(nonatomic)NSMutableArray *tmpArr;
//适配




@end

@implementation TWSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
  
    [self setNavigationBar];
    
    self.myTableView.tableFooterView = [[UIView alloc] init];
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"TWVIPCell" bundle:nil] forCellReuseIdentifier:@"TWVIPCell"];
    
    self.tmpArr = self.dataArr.mutableCopy;
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
    vc.isSearchToAdd = 1;
    
   // NSLog(@"%@",model.phoneNum1);
    
    vc.model = model;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWVIPCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWVIPCell" forIndexPath:indexPath];
    
    cell.cellType = 3;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = (TWVIPModel *)self.dataArr[indexPath.row];
    
    
    return cell;
    
}


#pragma mark - 设置Navigation
- (void)setNavigationBar{
    
    [self setNaviBarBackgroundColor:nil andStatusBarColor:nil];
    
    [self setNaviBarTitle:@"" color:WHITECOLOR];
    
//    [self setNaviBarLeftTitle:nil image:@"icon_bar_search"];
//    
//    [self setNaviBarRightTitle:@"取消" image:nil];
    
    [self setSearchView];
    
    
    
    
    
}

#pragma mark - 点击事件

-(void)setSearchView
{
    TWSearchView * view = [TWSearchView searchView];
    
    __weak typeof(self)  weakSelf = self;
    
    //取消
    view.scBlock = ^(){
    
        [weakSelf.navigationController popViewControllerAnimated:YES];
    
    };
    
    //输入有值了的
    view.siBlock = ^(NSString *str){
    
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

-(NSMutableArray *)tmpArr
{
    if (!_tmpArr) {
        _tmpArr = [[NSMutableArray alloc] init];
    }
    
    return _tmpArr;

}




@end

