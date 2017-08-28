//
//  TWPaiHangCell.m
//  ticketWaiter
//
//  Created by LY on 16/12/29.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "TWPaiHangCell.h"
#import "HGHeaderImageViewForNib.h"
#import "TWObtainImage.h"
#import "TWPaiHangModel.h"

#import "HGSaveNoticeTool.h"

@interface TWPaiHangCell ()
{

    BOOL  _isAutolayout;
}

@property (weak, nonatomic) IBOutlet HGHeaderImageViewForNib *headView;
@property (weak, nonatomic) IBOutlet UILabel *title;

//第1 2 3 名
@property (weak, nonatomic) IBOutlet UIImageView *PaiMingImage;

//其他排名
@property (weak, nonatomic) IBOutlet UIImageView *otherPaiMingImage;
@property (weak, nonatomic) IBOutlet UILabel *otherPaiMingLable;



@property (weak, nonatomic) IBOutlet UIButton *mapsBtn;


@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UIImageView *middleImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;



//适配
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h5;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l5;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *l6;


@property (weak, nonatomic) IBOutlet UIView *anViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *anViewH;




@property(nonatomic,assign)NSInteger  picNum;

@end


@implementation TWPaiHangCell

- (void)awakeFromNib {
    
    if (!_isAutolayout) {
        
        NSArray *arr = @[_h1,_h2,_h3,_h4,_h5,_w1,_w2,_w3,_w4,_w5,_l1,_l2,_l3,_l4,_l5,_l6,_anViewH,_title,_otherPaiMingLable];
        
        for (int i=0; i<arr.count; i++) {
            
            if (i>=17) {
                
                ((UILabel *)arr[i]).font = BoldFont(((UILabel *)arr[i]).font.pointSize);
                
            }else{
                
                ((NSLayoutConstraint *)arr[i]).constant = FitValue([(NSLayoutConstraint *)arr[i] constant]);
            }
        }

//        UITapGestureRecognizer *tapGure1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
//        
//        [_leftImage addGestureRecognizer:tapGure1];
//        
//        UITapGestureRecognizer *tapGure2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
//        
//        [_rightImage addGestureRecognizer:tapGure2];
//        
//        UITapGestureRecognizer *tapGure3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
//        
//        [_middleImage addGestureRecognizer:tapGure3];

    }
    
    
}


-(void)setModel:(TWPaiHangModel *)model
{
    _model = model;
    
  
    [TWObtainImage LocalHaveImageWithImageName:model.headImage andReturnBlock:^(UIImage *image) {
        
        if (image) {
            
            [_headView headerViewImage:image];
        }

    }];

    _title.text = model.merchantname;
  
    
    if (model.rank == 1) {

        _anViewHeight.hidden = YES;

    }else{
    
        _anViewHeight.hidden = NO;

    }
    
    
    if (model.rank<=3) {
        // 123 名
        _PaiMingImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_no%zd",model.rank]];
        _otherPaiMingLable.hidden = YES;
        _otherPaiMingImage.hidden = YES;
        _PaiMingImage.hidden = NO;
        
        
        
    }else{

        _otherPaiMingLable.hidden = NO;
        _otherPaiMingImage.hidden = NO;
        _PaiMingImage.hidden = YES;
        _otherPaiMingLable.text = [NSString stringWithFormat:@"%zd",model.rank];
    }


    if (model.picArr.count==0) {
        
        _leftImage.hidden = YES;
        _middleImage.hidden = YES;
        _rightImage.hidden = YES;
        
    }else{
     
        NSArray *leftViews = @[_leftImage,_middleImage,_rightImage];
        
        for (int i=0; i<leftViews.count; i++) {
            
            if (i < model.picArr.count) {
                
                
                NSString *name = model.picArr[i];
                
                NSString *nameStr = nil;
                
                if ([name containsString:@"http"]) {
                    
                    nameStr = name;
                }else{
                    
                    if ([name containsString:@"png"]||[name containsString:@"jpg"]) {
                        
                        nameStr = [NSString stringWithFormat:@"http://wwwhui10.b0.upaiyun.com/%@",name];
                        
                    }else{
                        
                        nameStr = [NSString stringWithFormat:@"http://wwwhui10.b0.upaiyun.com/%@.png",name];
                        
                    }
                    
                }

                
                [((UIImageView *)leftViews[i]) sd_setImageWithURL:[NSURL URLWithString:nameStr] placeholderImage:nil options:(SDWebImageLowPriority)];
                
                ((UIImageView *)leftViews[i]).hidden = NO;
//                
//                 [((UIImageView *)leftViews[i]) sd_setImageWithURL:[NSURL URLWithString:model.picArr[i]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                     
//                 }];

                
                //((UIImageView *)leftViews[i]).image = image;
                
//                [TWObtainImage LocalHaveImageWithImageName:model.picArr[i] andReturnBlock:^(UIImage *image) {
//                    if (image) {
//                        ((UIImageView *)leftViews[i]).image = image;
//                        ((UIImageView *)leftViews[i]).hidden = NO;
//                    }
//                }];
                
            }else{
            
                ((UIImageView *)leftViews[i]).hidden = YES;
            }
            
        }
        
       // _leftImage.hidden = NO;
    
    }
    
    
    
   
    
    if (model.position.length > 0) {
        
        [_mapsBtn setImage:[UIImage imageNamed:@"icon_view_yes"] forState:UIControlStateNormal];
        _mapsBtn.userInteractionEnabled = YES;
        
        
    }else{
    
        [_mapsBtn setImage:[UIImage imageNamed:@"icon_view_no"] forState:UIControlStateNormal];
        _mapsBtn.userInteractionEnabled = NO;


    }
    
    
    

}

//点击地图  显示全景地图
- (IBAction)mapsClick:(UIButton *)sender {
    
    if (_pBlock) {
        
        if (_model.position.length >0) {
         
            NSDictionary *dic = @{@"mid":self.model.mid,@"merchantname":self.model.merchantname,@"position":self.model.position};
            
            _pBlock(dic);
            
        }else{
        
            
        }

    }
    
    
}

-(void)photoClick:(UITapGestureRecognizer *)tapGr
{
    
    return;

//     if([_model.mid isEqualToString:[HGSaveNoticeTool obtainPersonInfoDataWithKey:@"mid"]]){
//         
//         if (_picNum == 0) {
//             
//             if (_block) {
//                 _block(_model.pic,_picNum);
//             }
//             
//         }else if (_picNum == 1){
//         
//             if (_block) {
//                 _block(_model.pic,_picNum);
//             }
//         
//         }else if (_picNum == 2){
//             
//             if ([tapGr.view isEqual:_middleImage]) {
//                 
//                 if (_block) {
//                     _block(_model.pic,_picNum);
//                 }
//             }
//
//         }else if (_picNum == 3){
//             
//             if ([tapGr.view isEqual:_rightImage]) {
//                 
//                 if (_block) {
//                     _block(_model.pic,_picNum);
//                 }
//             }
//             
//         }
//
//     }

}








@end
