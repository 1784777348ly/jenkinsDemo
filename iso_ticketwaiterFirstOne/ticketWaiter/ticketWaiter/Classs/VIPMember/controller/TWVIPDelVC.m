
//
//  TWVIPDelVC.m
//  ticketWaiter
//
//  Created by LY on 17/1/11.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import "TWVIPDelVC.h"
#import "TWVIPModel.h"
#import "TWVIPCell.h"
#import "TWVIPModelView2.h"


@interface TWVIPDelVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UIButton *delBtn;

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l2;




@end

@implementation TWVIPDelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationBar];
    
    self.myTableView.tableFooterView = [[UIView alloc] init];
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"TWVIPCell" bundle:nil] forCellReuseIdentifier:@"TWVIPCell"];
    
    
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
    return  FitValue(60);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TWVIPModel *model = self.dataArr[indexPath.row];
    
    model.isDeleteState = !model.isDeleteState;

    [tableView reloadRowAtIndexPath:indexPath withRowAnimation:(UITableViewRowAnimationNone)];
    
    [self changeBtnColor];

    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWVIPCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWVIPCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.cellType = 2;
    
    cell.model = (TWVIPModel *)self.dataArr[indexPath.row];
    
    return cell;
    
}

#pragma mark - 删除

- (IBAction)delClick:(UIButton *)sender {
    
    for (int i=0; i<self.dataArr.count; i++) {
        
        TWVIPModel *model = self.dataArr[i];
        
        if (model.isDeleteState == YES) {
            
            [self.dataArr removeObjectAtIndex:i];
            i--;
        }
        
    }
    
    [self changeBtnColor];
    
    [self.myTableView reloadData];
    
}


#pragma mark - 监控删除改变删除按钮颜色
-(void)changeBtnColor
{
    
    int i=0;
    for (;i<self.dataArr.count; i++) {
        TWVIPModel *model = self.dataArr[i];
        if (model.isDeleteState == 1) {
            break;
        }
    }
    
    if (i==self.dataArr.count) {
        
        [_delBtn setBackgroundColor:HexRGB(0xcccccc)];
        _delBtn.userInteractionEnabled = NO;
        
        
    }else{
        
        [_delBtn setBackgroundColor:HexRGB(0xef3535)];
        _delBtn.userInteractionEnabled = YES;
        
    }
    

}





#pragma mark - 设置Navigation
- (void)setNavigationBar{
    
    [self setNaviBarBackgroundColor:nil andStatusBarColor:nil];
    [self setNaviBarTitle:@"会员删除" color:WHITECOLOR];
    [self setNaviBarLeftTitle:nil image:@"icon_bar_back"];
    
    [self shiPei];
    

}

- (void)leftAction:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



#pragma mark - 懒加载
-(void)setDataArr:(NSMutableArray *)dataArr
{
    _dataArr = dataArr;
    
}

-(void)shiPei
{
    NSArray *arr = @[_h1,_h2,_l2,_l1,_delBtn];
    
    for (int i=0; i<arr.count; i++) {
        
        if (i<4) {
            
            ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);
            
            
        }else{
            
            ((UIButton *)arr[i]).titleLabel.font = NormalFont(((UIButton *)arr[i]).titleLabel.font.pointSize);
            
        }
        
    }

    _delBtn.layer.cornerRadius = FitValue(4);
    _delBtn.layer.masksToBounds = YES;
    
    [_delBtn setTitleColor:COLOR(255, 255, 255, 0.5) forState:UIControlStateHighlighted];



}






@end

