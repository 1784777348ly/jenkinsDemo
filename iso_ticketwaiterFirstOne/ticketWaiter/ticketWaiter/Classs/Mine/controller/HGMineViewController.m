//
//  HGMineViewController.m
//  ticketWaiter
//
//  Created by LY on 16/12/28.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "HGMineViewController.h"
#import "TWMineModel.h"
#import "TWMineViewCell.h"

#import "TWMyAccountVC.h"
#import "TWModifyLoginCodeVC.h"

#import "TWCardListVC.h"
//选择器
#import "LYCusActionSheet.h"

#import "HGSaveNoticeTool.h"

#import "TWMineViewModel.h"
#import "HSNavigationController.h"
#import "TWLoginViewController.h"

#import "TWBoundCardVC.h"


//判断相册权限
#import <AssetsLibrary/AssetsLibrary.h>

//判断相机权限
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>



@interface HGMineViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,LYCusActionSheetDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w1;

@property(nonatomic)UIImage *showPic;


@property(nonatomic)NSMutableArray *dataArr;

@property(nonatomic)NSString *imageNameMD5;


@end

@implementation HGMineViewController

-(void)viewWillAppear:(BOOL)animated
{
    //注意  改变 是否绑定快捷支付  换照片
    if ([[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"bankcard"] integerValue] == 1) {
        
        TWMineModel *model = [self.dataArr[2] objectAtIndex:0];
        model.details = @"已绑定";
    }else{
    
        TWMineModel *model = [self.dataArr[2] objectAtIndex:0];
        model.details = @"未绑定";
    }
    
    
    NSString *isZhenShi = [HGSaveNoticeTool obtainPersonInfoDataWithKey:@"leveltype"];
    
    
    NSArray *shiYongimages = @[@"icon_sz_wdzh_1",@"icon_sz_xgdlmm_1",@"icon_sz_tzzzp_1",@"icon_sz_tzzmc_1",@"icon_sz_bdyhk_1"];
    
    NSArray *zShiImages = @[@"icon_sz_wdzh_2",@"icon_sz_xgdlmm_2",@"icon_sz_tzzzp_2",@"icon_sz_tzzmc_2",@"icon_sz_bdyhk_2"];
    
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    NSString *myaccountState = @"升级或开通试用版";
    
    if ([isZhenShi isEqualToString:@"1"]) {
        //试用
        [images addObjectsFromArray:shiYongimages];
        
    }else if ([isZhenShi isEqualToString:@"2"]){
        //正式
        [images addObjectsFromArray:zShiImages];
        
        myaccountState = @"正式版";
        
    }else{
        
        //过期
        [images addObjectsFromArray:shiYongimages];
        
        myaccountState = @"已过期";
        
    }
    
     TWMineModel *model = [self.dataArr[0] objectAtIndex:0];
    
     model.details = myaccountState;


    for (int  i=0; i<3; i++) {
        
        NSMutableArray *arr = self.dataArr[i];
        
        for (int j=0; j<arr.count; j++) {
            
            TWMineModel *model = arr[j];
            model.imageName = images[i*2+j];
        }
        
    }
    
    [self.myTableView reloadData];
    

}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationBar];
    
    self.myTableView.tableFooterView = [[UIView alloc] init];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"TWMineViewCell" bundle:nil] forCellReuseIdentifier:@"TWMineViewCell"];

}


#pragma mark - 推出登录
- (IBAction)logoutClick:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定要退出登录么?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    
    [alertView show];

    
}


#pragma mark - 上传保存图片
-(void)uploadPicToSaveWithparams:(NSDictionary *)params
{

    TWMineViewModel *viewModel = [[TWMineViewModel alloc] init];
    
    [viewModel uploadPicWithParams:params andReturnBlock:^(id result) {
        
        NSDictionary *dic = (NSDictionary *)result;
        
        if ([dic[@"success"] integerValue] == 1) {
            
             [[SDImageCache sharedImageCache] storeImage:_showPic forKey:[NSString stringWithFormat:@"http://wwwhui10.b0.upaiyun.com/%@.png",_imageNameMD5]];
            
            TWMineModel *model = [self.dataArr[1] objectAtIndex:0];
            
            model.details = [params objectForKey:@"head"];
            
            [self.myTableView reloadData];
            
            [SVProgressHUD dismiss];
            
        }else{
        
            [SVProgressHUD showErrorWithStatus:dic[@"em"]];

        }
        
        
    }];

}



#pragma mark - 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    if ([[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"hidepay"] integerValue] == 1) {
        
        return [self.dataArr count]-1;
        
    }else{
    
        return [self.dataArr count];

    }

    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArr[section] count];

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return FitValue(10);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 0.01;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return FitValue(52);

}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWMineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWMineViewCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = ((TWMineModel *)[self.dataArr[indexPath.section] objectAtIndex:indexPath.row]);

    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 ) {
        
        if (indexPath.row == 0) {
            
            TWMyAccountVC *vc = [[TWMyAccountVC alloc] init];

            NSString *isZhenShi = [HGSaveNoticeTool obtainPersonInfoDataWithKey:@"leveltype"];

            if ([isZhenShi isEqualToString:@"1"]) {
                //试用
                vc.accountType = 1;
            }else{
                //正式
                vc.accountType = 0;
            }

            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            TWModifyLoginCodeVC *vc = [[TWModifyLoginCodeVC alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
        
        }
        
    }else if(indexPath.section == 1){
    
        if (indexPath.row == 0) {
            
            //拍照上传
//            LYCusActionSheet *ascsc = [[LYCusActionSheet alloc] init];
//            ascsc.tag = 300000001;
//            ascsc.delagete = self;
//            [ascsc lyActionSheetWithTitle:@"更换照片" andContentStrings:@[@"从相册选择",@"拍照"] andImages:nil andTitleColor:HexRGB(0xef3535) andContentColor:HexRGB(0x0099ff)  andBorderColor:HexRGB(0xcccccc) andCancelTitle:@"取消"];
//            [ascsc show];
            
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"更换照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照", nil];
            
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            
            [actionSheet showInView:self.view];
            
            
        }else{
            
            //修改投注站名称
            
        }
    
    
    }else{
    
        //绑定快捷支付卡
        //判断有没有绑定
        if ([[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"bankcard"]integerValue]==1) {
            //绑定了的 查询银行卡列表
            TWCardListVC *vc = [[TWCardListVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            //点击绑定银行卡
            TWBoundCardVC *vc = [[TWBoundCardVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        
        }
        
        
       
        
        
    
    }




}

#pragma mark - 选择拍照还是选择照片
-(void)actionSheet:(LYCusActionSheet *)cusActionSheet andButtonIndex:(NSInteger)buttonIndex
{
    

    if (cusActionSheet.tag == 300000001) {
        
        
        if (buttonIndex == 1) {
            //相册
            [self openPicLibrary];
            
        }else if(buttonIndex == 2){
            //拍照
            [self addCarema];
        }
        
    }

}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //NSLog(@"%zd",buttonIndex);
    //判断有没有权限

    if (buttonIndex == 0) {
        
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的相册权限已关闭，请前往设置>隐私中开启" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [alertView show];
            
        }else{
        
            [self openPicLibrary];

        }

    }else if(buttonIndex == 1){
        
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的相机权限已关闭，请前往设置>隐私中开启" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [alertView show];
            
        }else{
            [self addCarema];
        }
        
    }

}

#pragma mark - 判断退出登录
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        
        //确定要退出登录么的
        TWMineViewModel *viewModel = [[TWMineViewModel alloc] init];
        
        [viewModel logoutAndReturnBlock:^(id result) {
            
            NSDictionary *dic = (NSDictionary *)result;
            if ([dic[@"success"] integerValue] == 1) {
                
                [UserDefaults removeObjectForKey:@"token"];
                [UserDefaults synchronize];
                //切换页面
                [self changeRootViewController];
                
                
            }else{
                
                [SVProgressHUD showErrorWithStatus:dic[@"em"]];
            }
            
            
        }];
        
        
    }
    
    
}





#pragma mark - 图片的处理方法
#pragma mark - 相册和拍照
//打开相机
-(void)addCarema
{
    //判断是否可以打开相机，模拟器此功能无法使用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;  //是否可编辑
        //摄像头
        //UIModalPresentationOverCurrentContext
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
        
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"取消!" otherButtonTitles:nil];
        [alert show];
    }
    
}

//拍摄完成后要执行的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    _showPic = [info objectForKey:UIImagePickerControllerEditedImage];
    
    
//    [[SDImageCache sharedImageCache] storeImage:_tmpHeadImage forKey:[NSString stringWithFormat:@"http://wwwhui10.b0.upaiyun.com/%@_200.png",model.userinfo.portraiturl]];
    
    UIImage *image200 = [self imageCompressForWidth:[info objectForKey:UIImagePickerControllerEditedImage] targetWidth:200];
    
    
//    UIImage *image600 = [self imageCompressForWidth:[info objectForKey:UIImagePickerControllerEditedImage] targetWidth:600];

        
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
        
        //200*200图片名字
    NSRange range = {8,16};
    NSMutableString *md5OfPicTmp1 = [[NSMutableString alloc] initWithString:[UIImagePNGRepresentation(image200) md5String]];
    NSString *md5OfPic1 = [md5OfPicTmp1 substringWithRange:range];
    [paraDic setValue:[NSString stringWithFormat:@"%@.png",md5OfPic1] forKey:@"imageurl1"];
    
    //200*200图片
    NSString * baseStr = [UIImageJPEGRepresentation(image200, 0.1) base64EncodedString];
    
    [paraDic setValue:baseStr forKey:@"imagefile1"];
    
    //600*600图片名字
    //                NSMutableString *md5OfPicTmp2 = [[NSMutableString alloc] initWithString:[UIImagePNGRepresentation(_tmpHeadImage) md5String]];
    // NSString *md5OfPic2 = [md5OfPicTmp2 substringWithRange:range];
//    [paraDic setValue:[NSString stringWithFormat:@"%@_600.png",md5OfPic1] forKey:@"imageurl2"];
//    
//    //600*600图片
//    NSString * baseStr1 = [UIImageJPEGRepresentation(image600, 0.1)
//                           base64EncodedString];
//    
//    [paraDic setValue:baseStr1 forKey:@"imagefile2"];
    
    
//    NSString *pics = [HGSaveNoticeTool obtainPersonInfoDataWithKey:@"head"];
//    
//    NSString *picSNames = nil;
//    
//    if ([pics containsString:@","]) {
//        
//        NSArray *arr = [pics componentsSeparatedByString:@","];
//        
//        NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithArray:arr];
//        
//        [tmpArr replaceObjectAtIndex:0 withObject:md5OfPic1];
//        
//        picSNames = [tmpArr componentsJoinedByString:@","];
//        
//    }else{
//        
//        picSNames = md5OfPic1;
//    
//    }
//    
//    if (!_imageNameMD5) {
//        _imageNameMD5 = [NSString stringWithString:md5OfPic1];
//    }else{
    
        _imageNameMD5 = md5OfPic1;
  //  }
    
    
    //用相册图片
    [paraDic setValue:[NSString stringWithFormat:@"%@.png",md5OfPic1] forKey:@"head"];
    [paraDic setValue:LYTOKEN forKey:@"token"];
    
    [self uploadPicToSaveWithparams:paraDic];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
}
//点击Cancel按钮后执行方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//关于调用系统相册
//打开相册
-(void)openPicLibrary
{
    //相册是可以用模拟器打开的
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;//是否可以编辑
        
        //打开相册选择照片
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker  animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }
    
}

#pragma mark - 压缩图片
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    UIImage* clipImage = nil;
    
    //不是等比例的图片 需要裁剪成正方形
    if (width!=height) {
        
        CGRect rect = {};
        if(width>height){
            
            rect = CGRectMake((width-height), 0, height*2, height*2);
            
        }else{
            
            rect = CGRectMake(0, (height-width), width*2, width*2);
            
        }
        
        CGImageRef imageRef = CGImageCreateWithImageInRect(sourceImage.CGImage, rect);
        
        clipImage = [UIImage imageWithCGImage:imageRef];
        
        CGImageRelease(imageRef);
        
        
    }else{
        
        clipImage = sourceImage;
        
    }
    
    //然后等比例缩成规定大小的尺寸
    CGFloat targetWidth = defineWidth;
    //     CGFloat targetHeight = (targetWidth / width) * height;
    
    CGFloat targetHeight = defineWidth;
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [clipImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 切换控制器
-(void)changeRootViewController{

    TWLoginViewController *logController = [TWLoginViewController new];
    logController.isPushed = 1;
    
    [self.navigationController pushViewController:logController animated:YES];
    
//    HSNavigationController *loginNav = [[HSNavigationController alloc] initWithRootViewController:logController];
//    [[UIApplication sharedApplication].keyWindow setRootViewController:loginNav]; //用户未登录

}




#pragma mark - 设置导航栏
- (void)setNavigationBar{
    
    [self setNaviBarBackgroundColor:nil andStatusBarColor:nil];
    [self setNaviBarTitle:@"我的设置" color:WHITECOLOR];
    [self setNaviBarLeftTitle:nil image:@"icon_bar_back"];
    
    //适配
    
    _t1.constant = FitValue(_t1.constant);
    _t2.constant = FitValue(_t2.constant);
    _w1.constant = FitValue(_w1.constant);
    _h1.constant = FitValue(_h1.constant);
    
    _logoutBtn.layer.cornerRadius = FitValue(4);
    _logoutBtn.layer.masksToBounds = YES;
    [_logoutBtn setTitleColor:COLOR(255, 255, 255, 0.5) forState:UIControlStateHighlighted];


}

- (void)leftAction:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}




#pragma mark - 懒加载
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
        
        NSArray *titles = @[@"我的账号",@"修改登录密码",@"投注站照片",@"投注站名称",@"绑定银行卡快捷支付"];
        
        
        NSString *isZhenShi = [HGSaveNoticeTool obtainPersonInfoDataWithKey:@"leveltype"];
        
        
        NSArray *shiYongimages = @[@"icon_sz_wdzh_1",@"icon_sz_xgdlmm_1",@"icon_sz_tzzzp_1",@"icon_sz_tzzmc_1",@"icon_sz_bdyhk_1"];
        
        NSArray *zShiImages = @[@"icon_sz_wdzh_2",@"icon_sz_xgdlmm_2",@"icon_sz_tzzzp_2",@"icon_sz_tzzmc_2",@"icon_sz_bdyhk_2"];

        
        NSMutableArray *images = [[NSMutableArray alloc] init];
        
        NSString *myaccountState = @"升级或开通试用版";
        
        if ([isZhenShi isEqualToString:@"1"]) {
            //试用
            [images addObjectsFromArray:shiYongimages];
            
        }else if ([isZhenShi isEqualToString:@"2"]){
            //正式
            [images addObjectsFromArray:zShiImages];
            
            myaccountState = @"正式版";

        }else{
            
            //过期
            [images addObjectsFromArray:shiYongimages];
            
            myaccountState = @"已过期";
            
        }

        //账号 密码空  投注站照片  投注站名称  是否绑定快捷支付
        NSArray *detailTitles = @[
                                  myaccountState,
                                  @"",
                                  [[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"head"]length]>0?[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"head"]:@"",
                                  [HGSaveNoticeTool obtainPersonInfoDataWithKey:@"merchantname"],
                                  [[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"bankcard"]integerValue]==1?@"已绑定":@"未绑定"
                                  ];
        
               
       // NSArray *detailsType = @[@"1",@"1",@"2",@"1",@"1"]; //"1"代表文字  "2"代表图片
        NSArray *isNotHaveArrow = @[@(1),@(1),@(1),@(0),@(1)];
        NSArray *bottomIsHave = @[@(1),@(0),@(1),@(0),@(0)];

        NSArray *numArr = @[@(2),@(2),@(1)];
        
        for (int i=0; i<3; i++) {
            
            NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
            for (int k=0; k<[numArr[i] intValue]; k++) {
                
                TWMineModel *model = [[TWMineModel alloc] init];
                
                model.imageName = [images objectAtIndex:i*2+k];
                model.title = [titles objectAtIndex:i*2+k];
                model.details = [detailTitles objectAtIndex:i*2+k];
              //  model.detailsType = [detailsType objectAtIndex:i*2+k];
                model.isNotHaveArrow = [[isNotHaveArrow objectAtIndex:i*2+k] integerValue];
                model.hideBottomLine = [[bottomIsHave objectAtIndex:i*2+k] boolValue];
                
                [tmpArr addObject:model];
            }
            
            [_dataArr addObject:tmpArr];
            
        }

    }

    return _dataArr;
}



@end
