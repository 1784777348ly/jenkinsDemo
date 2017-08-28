//
//  LYCusActionSheet.m
//  HuiShiApp
//
//  Created by LY on 16/8/25.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "LYCusActionSheet.h"
#import "LYActionCell.h"
#import "LYActionMoel.h"

@interface LYCusActionSheet ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *backView1;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic)NSMutableArray *dataArr;

@property(nonatomic)NSArray *stringArr;

@property(nonatomic)LYCusActionSheet *actionView;


//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight3;


@end


@implementation LYCusActionSheet

-(void)awakeFromNib
{
    _titleLable.font = Font(_titleLable.font.pointSize);

    if (SCREEN_HEIGHT < 667) {
        
        _topHeight1.constant *= ScaleY;
        _topHeight2.constant *= ScaleY;
        _topHeight3.constant *= ScaleY;
        _bottomViewHeight.constant *= ScaleY;
        
    }else if (SCREEN_HEIGHT > 667) {
        
        _topHeight1.constant *= ScaleY;
        _topHeight2.constant *= ScaleY;
        _topHeight3.constant *= ScaleY;
        _bottomViewHeight.constant *= ScaleY;
        
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.frame = [UIScreen mainScreen].bounds;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
      self = [[[NSBundle mainBundle] loadNibNamed:@"LYCusActionSheet" owner:self options:0] lastObject];
    
    }
    return self;
}





-(instancetype)lyActionSheetWithTitle:(NSString *)title
                    andContentStrings:(NSArray *)stringArr
                            andImages:(NSArray *)imageNames
                        andTitleColor:(UIColor *)titleColor
                      andContentColor:(UIColor *)contentColor
                       andBorderColor:(UIColor *)borderColor
                       andCancelTitle:(NSString *)cancelStr
{
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LYActionCell" bundle:nil] forCellReuseIdentifier:@"LYActionCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.titleLable.text = title;
    self.titleLable.textColor = titleColor;
    
    self.stringArr = [[NSArray alloc] initWithArray:stringArr];
    
    if (stringArr.count > 3) {
        
        _bottomViewHeight.constant += 60*ScaleY*(stringArr.count-3);
    }
    
    for (int i=0; i<stringArr.count; i++) {
        
        LYActionMoel *model = [[LYActionMoel alloc] init];
        model.titleStr = stringArr[i];
        
        if (imageNames == nil) {
        
        }else{
            model.imageName = imageNames[i];
        }
        model.contentStrColor = contentColor;
        model.borderColor = borderColor;
        model.tag = i;
        
        [self.dataArr addObject:model];
    }
    
    LYActionMoel *model = [[LYActionMoel alloc] init];
    model.titleStr = cancelStr;
    model.contentStrColor = HexRGB(0x999999);
    model.borderColor = HexRGB(0x999999);
    [self.dataArr addObject:model];
    model.tag = stringArr.count;
    [self.tableView reloadData];
    
    
    return _actionView;

}

-(void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];

    
    [UIView transitionWithView:_backView1
                      duration:0.3
                       options: UIViewAnimationOptionTransitionNone //any animation
                    animations:^ {
                                    _topHeight3.constant -= _bottomViewHeight.constant;
                                    [_backView1 layoutIfNeeded];
                                 }
                    completion:nil];
    
    

}


-(void)dismiss
{

    [UIView transitionWithView:_backView1
                      duration:0.3
                       options: UIViewAnimationOptionTransitionNone //any animation
                    animations:^ {
                                    _topHeight3.constant += _bottomViewHeight.constant;
                                    [_backView1 layoutIfNeeded];
                                 }
                    completion:^(BOOL finished) {
                        
                        [self removeFromSuperview];
                        
                    }];
    
}

#pragma mark - 代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == self.dataArr.count-1) {
        
        return 85*ScaleY;
    }else{
    
        return 60*ScaleY;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LYActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LYActionCell"];
    
    __weak typeof(self) weakSelf = self;
    
    cell.block = ^(NSInteger tag){
        
          [weakSelf dismiss];
        
        if (tag == weakSelf.dataArr.count - 1) {
           
            [weakSelf.delagete actionSheet:weakSelf andButtonIndex:0];

        }else{
        
            [weakSelf.delagete actionSheet:weakSelf andButtonIndex:tag+1];

        }
        
      

    };

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArr[indexPath.row];
    
    return cell;


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
