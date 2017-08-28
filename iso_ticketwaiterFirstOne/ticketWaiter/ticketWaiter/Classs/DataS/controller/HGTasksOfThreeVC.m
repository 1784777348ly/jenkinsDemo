//
//  HGTasksOfThreeVC.m
//  Hui10Game
//
//  Created by LY on 16/12/26.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "HGTasksOfThreeVC.h"
#import "TWPaiHangCell.h"
#import "TWPaiHangModel.h"
#import "TWPaiHangModelView.h"
#import "TWMyPaybackVC.h"
#import "HGPlaceholderView.h"
#import "TZImagePickerController.h"
#import "ImageUploadTool.h"

#import "TWMineViewModel.h"
#import "TWMapViewController.h"

#import "HSRefreshFooter.h"
#import "HSRefreshHeader.h"

#import "HGSaveNoticeTool.h"


@interface HGTasksOfThreeVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,TZImagePickerControllerDelegate>
{
    BOOL   _middleViewShow;
    BOOL   _rightViewShow;

}

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *lineView;


@property (weak, nonatomic) IBOutlet UILabel *titleLable;


@property (weak, nonatomic) IBOutlet UIButton *ltitle;

@property (weak, nonatomic) IBOutlet UIButton *mtitle;

@property (weak, nonatomic) IBOutlet UIButton *rtitle;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollerView;
@property (weak, nonatomic) IBOutlet UIView *conView;


//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewW;


@property(nonatomic)HGPlaceholderView *placeHolderViewL;
@property(nonatomic)HGPlaceholderView *placeHolderViewM;
@property(nonatomic)HGPlaceholderView *placeHolderViewR;


@property (strong, nonatomic) TZImagePickerController *imagePickerVc;

@property(nonatomic,assign)NSIndexPath *selIndexPath;


@property(nonatomic)NSString *picStr;





@end

@implementation HGTasksOfThreeVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
     [self setNavigationBar];
    
    //适配
    [self shiPei];

    [self.leftView registerNib:[UINib nibWithNibName:@"TWPaiHangCell" bundle:nil] forCellReuseIdentifier:@"TWPaiHangCell"];
    [self.rightView registerNib:[UINib nibWithNibName:@"TWPaiHangCell" bundle:nil] forCellReuseIdentifier:@"TWPaiHangCell"];
    [self.middleView registerNib:[UINib nibWithNibName:@"TWPaiHangCell" bundle:nil] forCellReuseIdentifier:@"TWPaiHangCell"];

    [self obtainDataFromFirstPage];
    
    //添加上拉  下拉刷新
    
    
    [self addHeaderAndFooter];


}






//传数据 刷新界面
-(void)obtainDataFromFirstPage
{

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    TWPaiHangModelView *model = [[TWPaiHangModelView alloc] init];
    __weak typeof(self)  weakSelf = self;
    
    
    //左边
    self.placeHolderViewL = [HGPlaceholderView placehoderViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    weakSelf.placeHolderViewL.hidden = YES;
    [self.leftView addSubview:_placeHolderViewL];
    _placeHolderViewL.block = ^(){
        weakSelf.placeHolderViewL.hidden = YES;
         [model obtainDataWithTableView:weakSelf.leftView andPalceHolderView:weakSelf.placeHolderViewL andDataArr:weakSelf.dataArrL andViewType:1 andRefshType:1];
    };
    
    [model obtainDataWithTableView:self.leftView andPalceHolderView:_placeHolderViewL andDataArr:self.dataArrL andViewType:1 andRefshType:1];
    
    
    //右边
    self.placeHolderViewR = [HGPlaceholderView placehoderViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    weakSelf.placeHolderViewR.hidden = YES;

    [self.rightView addSubview:_placeHolderViewR];
    _placeHolderViewR.block = ^(){
        weakSelf.placeHolderViewR.hidden = YES;
        [model obtainDataWithTableView:weakSelf.rightView andPalceHolderView:weakSelf.placeHolderViewR andDataArr:weakSelf.dataArrR andViewType:3 andRefshType:1];
    };
    
//    [model obtainDataWithTableView:weakSelf.rightView andPalceHolderView:weakSelf.placeHolderViewR andDataArr:weakSelf.dataArrR andViewType:3 andRefshType:1];
//    
    
    //中间
    self.placeHolderViewM = [HGPlaceholderView placehoderViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    weakSelf.placeHolderViewM.hidden = YES;

    [self.middleView addSubview:_placeHolderViewM];
    _placeHolderViewM.block = ^(){
        weakSelf.placeHolderViewM.hidden = YES;
        [model obtainDataWithTableView:weakSelf.middleView andPalceHolderView:weakSelf.placeHolderViewM andDataArr:weakSelf.dataArrM andViewType:2 andRefshType:1];
    };
    
    //    [model obtainDataWithTableView:weakSelf.middleView andPalceHolderView:weakSelf.placeHolderViewM andDataArr:weakSelf.dataArrM andViewType:2 andRefshType:1];
    
}

-(void)addHeaderAndFooter
{
    
    TWPaiHangModelView *model = [[TWPaiHangModelView alloc] init];
    __weak typeof(self)  weakSelf = self;

    //左边
    HSRefreshFooter *footer1 = [HSRefreshFooter footerWithRefreshingBlock:^{
        
        [model obtainDataWithTableView:weakSelf.leftView andPalceHolderView:weakSelf.placeHolderViewL andDataArr:weakSelf.dataArrL andViewType:1 andRefshType:3];
    }];
    
    self.leftView.mj_footer = footer1;
    
    HSRefreshHeader *header1 = [HSRefreshHeader headerWithRefreshingBlock:^{
        
        [model obtainDataWithTableView:weakSelf.leftView andPalceHolderView:weakSelf.placeHolderViewL andDataArr:weakSelf.dataArrL andViewType:1 andRefshType:2];
        
    }];
    
    self.leftView.mj_header = header1;

    
    //中间
    
    HSRefreshFooter *footer2 = [HSRefreshFooter footerWithRefreshingBlock:^{
        
        [model obtainDataWithTableView:weakSelf.middleView andPalceHolderView:weakSelf.placeHolderViewM andDataArr:weakSelf.dataArrM andViewType:2 andRefshType:3];
    }];
    
    self.middleView.mj_footer = footer2;
    
    HSRefreshHeader *header2 = [HSRefreshHeader headerWithRefreshingBlock:^{
        
        [model obtainDataWithTableView:weakSelf.middleView andPalceHolderView:weakSelf.placeHolderViewM andDataArr:weakSelf.dataArrM andViewType:2 andRefshType:2];
        
    }];
    
    self.middleView.mj_header = header2;
    //右边
    
    HSRefreshFooter *footer3 = [HSRefreshFooter footerWithRefreshingBlock:^{
        
        [model obtainDataWithTableView:weakSelf.rightView andPalceHolderView:weakSelf.placeHolderViewR andDataArr:weakSelf.dataArrR andViewType:3 andRefshType:3];
    }];
    
    self.rightView.mj_footer = footer3;
    
    HSRefreshHeader *header3 = [HSRefreshHeader headerWithRefreshingBlock:^{
        
        [model obtainDataWithTableView:weakSelf.rightView andPalceHolderView:weakSelf.placeHolderViewR andDataArr:weakSelf.dataArrR andViewType:3 andRefshType:2];
    }];
    
    self.rightView.mj_header = header3;


}






#pragma mark - 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger  num=0;
    
    switch (tableView.tag) {
        case 21:
        {
            num = self.dataArrL.count>=10?10:self.dataArrL.count;
            break;
        }
        case 22:
        {
            num = self.dataArrM.count>=10?10:self.dataArrM.count;
            break;
        }
        case 23:
        {
            num = self.dataArrR.count>=10?10:self.dataArrR.count;
            break;
        }
        default:{
            break;
        }
    }
    
    return num;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.01;

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 0.01;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UIView *viewx = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
//    viewx.backgroundColor = [UIColor whiteColor];
//    
//    return viewx;
    
    
    return nil;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return FitValue(93);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWPaiHangCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWPaiHangCell" forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    
    cell.block = ^(NSString *pics , NSInteger picNum){
    
        [weakSelf setUpImagePickerVCWithPics:pics andPicNum:picNum];

        weakSelf.selIndexPath = [NSIndexPath indexPathForRow:indexPath.section inSection:indexPath.row];
    };
    
    cell.pBlock = ^(NSDictionary *params){
    
        TWMapViewController *psVC = [[TWMapViewController alloc]init];
        psVC.positionStr = [params objectForKey:@"position"];
        psVC.showType = PanoShowTypeGEO;
        psVC.nameStr = [params objectForKey:@"merchantname"];
        psVC.mid = [params objectForKey:@"mid"];
        
        [weakSelf.navigationController pushViewController:psVC animated:YES];

    };

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    if (tableView.tag == 21) {
        
        cell.model = self.dataArrL[indexPath.row];
        
        return cell;
    }else if (tableView.tag == 22) {
        
        cell.model = self.dataArrM[indexPath.row];
        
        return cell;
    }else{
        
        cell.model = self.dataArrR[indexPath.row];
        
        return cell;
    }

}

#pragma mark - 选择照片
//创建图片选择器
- (void)setUpImagePickerVCWithPics:(NSString *)pics andPicNum:(NSInteger)picNum{
    
    
    if (!_picStr) {
        _picStr = [NSString stringWithString:pics];

    }else{
        _picStr = pics;
    }
    
    self.imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:4-picNum delegate:self];
    //self.imagePickerVc.sortAscendingByModificationDate = NO;
    self.imagePickerVc.autoDismiss = NO;
    self.imagePickerVc.barItemTextColor = UIColorHex(333333);
    
    
    [self presentViewController:self.imagePickerVc animated:YES completion:nil];

}

//选择照片完成
- (void)didFinishPickPhoto:(NSArray *)photos asset:(NSArray *)asset isOriginal:(BOOL)isOriginal{
    
    __weak typeof(self) weakSelf = self;
    //上传图片
    dispatch_queue_t currentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(currentQueue, ^{
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
        [SVProgressHUD showWithStatus:@"上传中..."];

        NSMutableDictionary *params = [self getUploadImagesWith:photos];
        
        NSMutableString *lastPics = [params objectForKey:@"pic"];
        
        NSString *tmpppStr = [NSString stringWithFormat:@"%@,%@",_picStr,[params objectForKey:@"pic"]];
        
        [params setObject:tmpppStr forKey:@"pic"];

        
        TWMineViewModel *viewModel = [[TWMineViewModel alloc] init];
        
        [viewModel uploadPicWithParams:params andReturnBlock:^(id result) {
            
            NSDictionary *dic = (NSDictionary *)result;
            
            if ([dic[@"success"] integerValue] == 1) {
                
                NSArray *arr = [lastPics componentsSeparatedByString:@","];
                
                NSMutableArray *arrs = [[NSMutableArray alloc] init];
                
                if(arr > 0){
                    
                    [arrs addObjectsFromArray:arr];
                
                }else{
                
                    [arrs addObject:lastPics];
                }
                
                
                //本地缓存图片
                for(int i=0;i<photos.count;i++){
                    
                    [[SDImageCache sharedImageCache] storeImage:photos[i] forKey:[NSString stringWithFormat:@"http://wwwhui10.b0.upaiyun.com/%@_200.png",arrs[i]]];

                }
//
//                if(_ltitle.selected){
//                
//                    TWPaiHangModel *model = self.dataArrL[weakSelf.selIndexPath.row];
//                    
//                    model.pic = [params objectForKey:@"pic"];
//                    
//                    [self.leftView reloadData];
//                
//                }else if (_mtitle.selected){
//                
//                    TWPaiHangModel *model = self.dataArrM[weakSelf.selIndexPath.row];
//                    
//                    model.pic = [params objectForKey:@"pic"];
//                    
//                    [self.middleView reloadData];
//
//                }else{
//                
//                    TWPaiHangModel *model = self.dataArrR[weakSelf.selIndexPath.row];
//                    
//                    model.pic = [params objectForKey:@"pic"];
//                    
//                    [self.rightView reloadData];
//
//                }

                [SVProgressHUD dismiss];
                
            }else{
                
                [SVProgressHUD showErrorWithStatus:dic[@"em"]];
                
            }
            
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            
        }];
    });
                   

}


- (NSMutableDictionary *)getUploadImagesWith:(NSArray *)images{
    
    NSString *string = @"";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < images.count; i++) { //缩略图
        NSString *md5Name = [ImageUploadTool imageMD5Name:images[i]];
        UIImage  *img     = [ImageUploadTool compressImage:images[i] targetWidth:200];
        NSString *imgUrl  = [NSString stringWithFormat:@"%@_200.png",md5Name];
        NSString *base64  = [ImageUploadTool base64Image:img];
        if ([string isEqualToString:@""]) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@",md5Name]];
        } else {
            string = [string stringByAppendingString:[NSString stringWithFormat:@",%@",md5Name]];
        }
        NSString *nameKey = [NSString stringWithFormat:@"imageurl%ld",i+1];
        NSString *fileKey = [NSString stringWithFormat:@"imagefile%ld",i+1];
        [dict setValue:imgUrl forKey:nameKey];
        [dict setValue:base64 forKey:fileKey];
    }
    for (NSInteger i = 0; i < images.count; i++) { //高清大图
        NSString *md5Name = [ImageUploadTool imageMD5Name:images[i]];
        NSString *imgUrl  = [NSString stringWithFormat:@"%@.png",md5Name];
        NSString *base64  = [ImageUploadTool base64Image:images[i]];
        NSString *nameKey = [NSString stringWithFormat:@"imageurl%ld",i+images.count+1];
        NSString *fileKey = [NSString stringWithFormat:@"imagefile%ld",i+images.count+1];
        [dict setValue:imgUrl forKey:nameKey];
        [dict setValue:base64 forKey:fileKey];
    }
    [dict setValue:string forKey:@"pic"];
    [dict setValue:LYTOKEN forKey:@"token"];
    return dict;
}



#pragma mark - 上传保存图片


#pragma mark - scroller的代理方法

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    if (![scrollView isEqual:_myScrollerView]) {
        
        return;
    }
    
     NSInteger page = scrollView.contentOffset.x/SCREEN_WIDTH;
    
    if (page == 0) {
        self.ltitle.selected = 1;
        self.ltitle.titleLabel.font  = BoldFontWithNoScale(self.ltitle.titleLabel.font.pointSize);
        self.mtitle.selected = 0;
        self.mtitle.titleLabel.font  = NormalFontWithNoScale(self.mtitle.titleLabel.font.pointSize);
        self.rtitle.selected = 0;
        self.rtitle.titleLabel.font  = NormalFontWithNoScale(self.rtitle.titleLabel.font.pointSize);
    }else if (page == 1) {
        self.ltitle.selected = 0;
        self.ltitle.titleLabel.font  = NormalFontWithNoScale(self.ltitle.titleLabel.font.pointSize);
        
        self.mtitle.selected = 1;
        self.mtitle.titleLabel.font  = BoldFontWithNoScale(self.mtitle.titleLabel.font.pointSize);
        
        self.rtitle.selected = 0;
        self.rtitle.titleLabel.font  = NormalFontWithNoScale(self.rtitle.titleLabel.font.pointSize);
        
        if (!_middleViewShow) {
            _middleViewShow = 1;
            TWPaiHangModelView *model = [[TWPaiHangModelView alloc] init];
            __weak typeof(self)  weakSelf = self;
            
            [model obtainDataWithTableView:weakSelf.middleView andPalceHolderView:weakSelf.placeHolderViewM andDataArr:weakSelf.dataArrM andViewType:2 andRefshType:1];
        }
        

    }else{
        self.ltitle.selected = 0;
        self.ltitle.titleLabel.font  = NormalFontWithNoScale(self.ltitle.titleLabel.font.pointSize);

        self.mtitle.selected = 0;
        self.mtitle.titleLabel.font  = NormalFontWithNoScale(self.mtitle.titleLabel.font.pointSize);

        self.rtitle.selected = 1;
        self.rtitle.titleLabel.font  = BoldFontWithNoScale(self.rtitle.titleLabel.font.pointSize);
        
        if (!_rightViewShow) {
            _rightViewShow = 1;
            TWPaiHangModelView *model = [[TWPaiHangModelView alloc] init];
            __weak typeof(self)  weakSelf = self;
            [model obtainDataWithTableView:weakSelf.rightView andPalceHolderView:weakSelf.placeHolderViewR andDataArr:weakSelf.dataArrR andViewType:3 andRefshType:1];
            
        }

    }
    
    
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (![scrollView isEqual:_myScrollerView]) {
        
        return;
    }

    CGFloat widths = CGRectGetMinX(self.rtitle.superview.frame) - CGRectGetMinX(self.ltitle.superview.frame);

    
    CGRect rect = self.bottomView.frame;
    
    rect.origin.x = self.ltitle.superview.frame.origin.x + scrollView.contentOffset.x/(SCREEN_WIDTH*2)*widths;

    [self.bottomView setFrame:rect];


}





#pragma mark - 点击事件
//点击切换view
- (IBAction)switchViewClick:(UIButton *)sender {
    //tag  11 12 13

    [self.myScrollerView setContentOffset:CGPointMake((sender.tag-11)*SCREEN_WIDTH, 0) animated:YES];


    
    //字变化
    sender.selected = YES;
    sender.titleLabel.font  = BoldFontWithNoScale(sender.titleLabel.font.pointSize);
    
    if (sender.tag == 11) {
        self.mtitle.selected = 0;
        self.mtitle.titleLabel.font  = NormalFontWithNoScale(self.mtitle.titleLabel.font.pointSize);
        
        self.rtitle.selected = 0;
        self.rtitle.titleLabel.font  = NormalFontWithNoScale(self.rtitle.titleLabel.font.pointSize);
        
    }else if (sender.tag == 12) {
        self.ltitle.selected = 0;
        self.ltitle.titleLabel.font  = NormalFontWithNoScale(self.ltitle.titleLabel.font.pointSize);
        self.rtitle.selected = 0;
        self.rtitle.titleLabel.font  = NormalFontWithNoScale(self.rtitle.titleLabel.font.pointSize);
        
        if (!_middleViewShow) {
             _middleViewShow = 1;
            TWPaiHangModelView *model = [[TWPaiHangModelView alloc] init];
            __weak typeof(self)  weakSelf = self;
            
            [model obtainDataWithTableView:weakSelf.middleView andPalceHolderView:weakSelf.placeHolderViewM andDataArr:weakSelf.dataArrM andViewType:2 andRefshType:1];
        }
        
    }else{
        self.ltitle.selected = 0;
        self.ltitle.titleLabel.font  = NormalFontWithNoScale(self.ltitle.titleLabel.font.pointSize);
        self.mtitle.selected = 0;
        self.mtitle.titleLabel.font  = NormalFontWithNoScale(self.mtitle.titleLabel.font.pointSize);
        
        if (!_rightViewShow) {
            _rightViewShow = 1;
            TWPaiHangModelView *model = [[TWPaiHangModelView alloc] init];
            __weak typeof(self)  weakSelf = self;
            [model obtainDataWithTableView:weakSelf.rightView andPalceHolderView:weakSelf.placeHolderViewR andDataArr:weakSelf.dataArrR andViewType:3 andRefshType:1];

        }

    }

}









#pragma mark - 适配
-(void)shiPei
{
    NSArray *arr = @[_viewH,_viewW,_ltitle,_mtitle,_rtitle];

    for (int i=0; i<arr.count; i++) {
        
        if (i<2) {
          
            ((NSLayoutConstraint *)arr[i]).constant = FitValue(((NSLayoutConstraint *)arr[i]).constant);
            
        }else{
        
            if (i==2) {
                
                 _ltitle.titleLabel.font  = BoldFont(_ltitle.titleLabel.font.pointSize);
                
            }else{
            
                ((UIButton *)arr[i]).titleLabel.font = NormalFont(((UIButton *)arr[i]).titleLabel.font.pointSize);
                
            }


        }
        
    }
    
   
    
//    _mtitle.titleLabel.font  = NormalFont(_mtitle.titleLabel.font.pointSize);
//
//    _rtitle.titleLabel.font  = NormalFont(_rtitle.titleLabel.font.pointSize);
    
    self.ltitle.selected = 1;
    
    
    //加阴影
//    self.lineView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.lineView.layer.shadowOpacity = 0.8f;
//    self.lineView.layer.shadowRadius = 4.f;
//    self.lineView.layer.shadowOffset = CGSizeMake(1,0);
    
    
    //加圆角
//    _submit1.layer.cornerRadius = _h1.constant/2.0;
//    _submit2.layer.cornerRadius = _h1.constant/2.0;
//    _submit3.layer.cornerRadius = _h1.constant/2.0;
    

}


#pragma mark - 设置导航栏
- (void)setNavigationBar{
    
    self.fd_prefersNavigationBarHidden = YES;
    
    self.titleLable.text = @"每月排行榜";
    

}


#pragma mark  - 返回
- (IBAction)backClick:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -  点击到我的奖励
- (IBAction)myRepayClick:(UIButton *)sender {
    
    TWMyPaybackVC *vc = [[TWMyPaybackVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}








#pragma mark - 懒加载
-(NSMutableArray *)dataArrL
{
    if (!_dataArrL) {
        
        _dataArrL = [[NSMutableArray alloc] init];
        
    }

    return _dataArrL;
}

-(NSMutableArray *)dataArrM
{
    if (!_dataArrM) {
        
        _dataArrM = [[NSMutableArray alloc] init];
        
    }
    
    return _dataArrM;
}
-(NSMutableArray *)dataArrR
{
    if (!_dataArrR) {
        
        _dataArrR = [[NSMutableArray alloc] init];
        
    }
    
    return _dataArrR;
}



@end
