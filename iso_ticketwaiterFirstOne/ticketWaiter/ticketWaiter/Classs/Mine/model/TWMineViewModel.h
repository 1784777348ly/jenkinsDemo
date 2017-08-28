//
//  TWMineViewModel.h
//  ticketWaiter
//
//  Created by LY on 16/12/29.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TWOpenAndPayVC,TWCardListVC;

typedef void(^MineViewModelBlock)(BOOL success);

@interface TWMineViewModel : NSObject

@property(nonatomic,copy)MineViewModelBlock successBlock;

/*
 *   发起支付请求  获取tn值   可能是苹果支付2  或者是银联支付1
 */
-(void)startPayWith:(TWOpenAndPayVC *)payVc andMoney:(NSInteger)money andOrderId:(NSString *)orderId andPayType:(NSInteger)payType;

/*
 *   获得支付结果
 */
-(void)getPayResult;


/*
 *   修改登录密码
 */

-(void)mofifyloginCode:(NSString *)oldPassword andNewPassword:(NSString *)newPassword andReturnBlock:(void(^)(id result))block;



/*
 *   查询卡信息
 */
-(void)obtainCardInfoWithReturnBlock:(void(^)(id result))block;


/*
 *   绑定银行卡
 */
-(void)boundCardWithParams:(NSDictionary *)params  andReturnBlock:(void(^)(id result))block;


/*
 *  解除绑定银行卡
 */
-(void)unboundCardWithParams:(NSDictionary *)params  andReturnBlock:(void(^)(id result))block;




/*
 *   上传图片
 */
-(void)uploadPicWithParams:(NSDictionary *)params  andReturnBlock:(void(^)(id result))block;



/*
 *   退出登录
 */
-(void)logoutAndReturnBlock:(void(^)(id result))block;


/*
 *  升级为正式版
 */
-(void)becomeFormalMember;



-(void)fetchCardList:(TWCardListVC *)vc;


/*
 *   设置为自动续费 type  1 自动续费  2 取消自动续费
 */
-(void)autoPayWithType:(NSInteger)type ReturnBlock:(void(^)(id result))block;







@end
