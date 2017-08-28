//
//  TWMineModel.h
//  ticketWaiter
//
//  Created by LY on 16/12/28.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWMineModel : NSObject

@property(nonatomic)NSString *title;
@property(nonatomic)NSString *details;
@property(nonatomic)NSString *imageName;

@property(nonatomic)BOOL  hideBottomLine;


//"1"代表文字  "2"代表图片
@property(nonatomic)NSString *detailsType;
@property(nonatomic)BOOL isNotHaveArrow;

//副标题
@property(nonatomic)NSString *subTitle;

//回传的图片
@property(nonatomic)UIImage *locImage;

@property(nonatomic)BOOL  isSeled;


@end


@interface TWOpenAccountModel : NSObject

@property(nonatomic)NSString *title;
@property(nonatomic)NSString *subTitle;
@property(nonatomic)NSString *details;

@property(nonatomic)BOOL  isAccount;

@property(nonatomic)NSString *bindid;
@property(nonatomic)NSString *mid;
@property(nonatomic)NSString *payid;


@end

@interface TWCardModel : NSObject

@property(nonatomic)NSString *lefttitle;
@property(nonatomic)NSString *tfContent;


@property(nonatomic)BOOL isEdited;

@property(nonatomic)NSString *placeHolders;


@property(nonatomic)BOOL  isHaveBtn;

@end





